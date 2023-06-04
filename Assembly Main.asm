;R0=Spillerens indsats, R1= Spiller bet, R2=Computer RNG, R3-R5=Registre til beregninger, R6=Spillerens chips, R7 røres ikke og R0
.ORIG x3000;

INDSATS LD R0, Indsatser;

GUESS LD R1, Guesses;

; Randomly generated number
AND R2, R2, #0; Vores mål er at gange R2 med 23. Derfor ganger vi op til 32 og trækker så 8 og 1 fra 32
ADD R2, R2, #15;
ADD R3, R2, #0; I R3 gemmes 1 * R2
ADD R2, R2, R2;
ADD R2, R2, R2;
ADD R2, R2, R2;
ADD R4, R2, #0; I R4 gemmes 8 * R2
ADD R2, R2, R2;
ADD R2, R2, R2; I R2 er der gemt 32 * original R2

NOT R3, R3; 1*R2 gøres negativ for at trække fra.
ADD R3, R3, #1;
ADD R2, R2, R3; 

NOT R4, R4; 8*R2 gøres negativ for at trække fra.
ADD R4, R4, #1;
ADD R2, R2, R4;

AND R3, R3, #0;
ADD R3, R3, #-10; -37
ADD R3, R3, #-11;
ADD R3, R3, #-16;

Mod ADD R2, R2, R3;
BRp	Mod;

ADD R2, R2, #10; 37
ADD R2, R2, #12;
ADD R2, R2, #15;
NOT R2, R2;
ADD R2, R2, #1;

; List selection/condition tjek

; Rød
RUN AND R3, R3, #0;
ADD R3, R3, #-10; -40
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R1, R3;
BRz	Roed;

; Sort
AND R3, R3, #0;
ADD R3, R3, #-10; -41
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-11;
ADD R3, R1, R3;
BRz	Sort;

AND R3, R3, #0;
ADD R3, R3, #-10; -42
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-12;
ADD R3, R1, R3;
BRz	Even;

; Sort
AND R3, R3, #0;
ADD R3, R3, #-10; -43
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-13;
ADD R3, R1, R3;
BRz	Odd;

;Hvis personen kun har bettet på et tal, tjek om tallet-RNG=0. hvis ja; Sejr. 
AND R6, R6, #0;
ADD R6, R6, #10;
ADD R6, R6, #10;
ADD R6, R6, #15;
ADD R1, R1, R2;
BRz Udbetaling
BRnp NextBet

;Løbe lister igennem //Kode fra her til ---- er taget fra forelæsning 2 af 3-ugers (modificeret).
;R4=pointer, R5=indhold af pointer 
Checker LDR R5,R4,#0 ; load character using pointer (R1)
BRz NextBet ; if null character, end of string
ADD R5, R5, R2;
BRz	Udbetaling
ADD R4,R4,#1 ; move ptr to next char in string
BR Checker
;TABT AND R1, R1, #0;
;LD	R1,	Player1Chips;
;NOT R0, R0;
;ADD R0, R0, #1;
;ADD R1, R1, R0;
;ST	R1,	Player1Chips
;TRAP x25 ; Hvis intet resultat matches, så har spilleren tabt (for det bet) :c
; ----- 

Udbetaling;
AND R3, R3, #0;
ADD R3, R3, R0; 
Multiplier
ADD R0, R0, R3;
ADD R6, R6, #-1;
BRp	Multiplier
AND R1, R1, #0;
LD	R1,	Player1Chips;
ADD R1, R1, R0;
ST	R1,	Player1Chips;


NextBet LD R4, NumOfBets;
ADD R4, R4, #-1;
ST R4, NumOfBets;
BRnz DONE

LD R4, BetNumber;
ADD R4, R4, #1;
ST R4, BetNumber;

LEA R3, Indsatser;
ADD R3, R3, R4;
LDR R0, R3, #0;

LEA R3, Guesses;
ADD R3, R3, R4;
LDR R1, R3, #0;

BRnzp RUN;

DONE TRAP	x25; udbetalt og her fra skal udvidelsen tilføjelse

Roed
LEA	R4,	RoedListe; Adressen af listen gemmes i R4
AND R6, R6, #0;
ADD R6, R6, #1;
BR Checker;

Sort 
LEA	R4,	SortListe; Adressen af listen gemmes i R4
AND R6, R6, #0;
ADD R6, R6, #1;
BR Checker;

Even
LEA	R4,	EvenListe; Adressen af listen gemmes i R4
AND R6, R6, #0;
ADD R6, R6, #1;
BR Checker;

Odd
LEA	R4,	OddListe; Adressen af listen gemmes i R4
AND R6, R6, #0;
ADD R6, R6, #1;
BR Checker;


;Varibel lister
RoedListe .fill #1
.fill #3
.fill #5
.fill #7
.fill #9
.fill #12
.fill #14
.fill #16
.fill #18
.fill #19
.fill #21
.fill #23
.fill #25
.fill #27
.fill #30
.fill #32
.fill #34
.fill #36
.fill 0

SortListe .fill #2
.fill #4
.fill #6
.fill #8
.fill #10
.fill #11
.fill #13
.fill #15
.fill #17
.fill #20
.fill #22
.fill #24
.fill #26
.fill #28
.fill #29
.fill #31
.fill #33
.fill #35
.fill 0

EvenListe .fill #2
.fill #4
.fill #6
.fill #8
.fill #10
.fill #12
.fill #14
.fill #16
.fill #18
.fill #20
.fill #22
.fill #24
.fill #26
.fill #28
.fill #30
.fill #32
.fill #34
.fill #36
.fill 0

OddListe .fill #1
.fill #3
.fill #5
.fill #7
.fill #9
.fill #11
.fill #13
.fill #15
.fill #17
.fill #19
.fill #21
.fill #23
.fill #25
.fill #27
.fill #29
.fill #31
.fill #33
.fill #35
.fill 0

Player1Chips .FILL	#0

Indsatser .fill #100
.fill #200
.fill #300
.fill #400

Guesses .fill #10
.fill #40
.fill #41
.fill #42

NumOfBets .fill #4

BetNumber .fill #0

.END;