;R0=Spillerens indsats, R1= Spiller bet, R2=Computer RNG, R3-R5=Registre til beregninger, R6=Spillerens chips, R7 røres ikke og R0
.ORIG x3000;

Indsatser .fill #100
.fill #200
.fill #300
.fill #400

Guesses .fill #53
.fill #41
.fill #41
.fill #41

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

; LOW 1-18
AND R3, R3, #0;
ADD R3, R3, #-10; -44
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-14;
ADD R3, R1, R3;
BRz	LOW;


;HIGH 19-36
AND R3, R3, #0;
ADD R3, R3, #-10; -45
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-15;
ADD R3, R1, R3;
BRz	HIGH;

;Dozen1 1-12
AND R3, R3, #0;
ADD R3, R3, #-10; -46
ADD R3, R3, #-10;
ADD R3, R3, #-10;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	DOZEN1;

;Dozen2 13-24
AND R3, R3, #0;
ADD R3, R3, #-10; -47
ADD R3, R3, #-10;
ADD R3, R3, #-11;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	DOZEN2;

;Dozen3 25-36
AND R3, R3, #0;
ADD R3, R3, #-10; -48
ADD R3, R3, #-10;
ADD R3, R3, #-12;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	DOZEN3;

;Column1
AND R3, R3, #0;
ADD R3, R3, #-10; -49
ADD R3, R3, #-10;
ADD R3, R3, #-13;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	COLUMN1;

;Column2
AND R3, R3, #0;
ADD R3, R3, #-10; -50
ADD R3, R3, #-10;
ADD R3, R3, #-14;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	COLUMN2;

;Column3
AND R3, R3, #0;
ADD R3, R3, #-10; -51
ADD R3, R3, #-10;
ADD R3, R3, #-15;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	COLUMN3;

;Street
AND R3, R3, #0;
ADD R3, R3, #-10; -52
ADD R3, R3, #-10;
ADD R3, R3, #-16;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	STREET;

;Line
AND R3, R3, #0;
ADD R3, R3, #-10; -53
ADD R3, R3, #-11;
ADD R3, R3, #-16;
ADD R3, R3, #-16;
ADD R3, R1, R3;
BRz	LINE;

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


NextBet 
JSR RowReset;
LD R4, NumOfBets;
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


LOW
LEA R4, Row1;
AND R6, R6, #0;
ADD R6, R6, #1;
AND R7, R7, #0; Reset R7
LEA R3, Row7; Load adresse af Row7 ind i R3
ST R3, EndRow; Store adresse i R3 i EndRow
LDI R3, EndRow; Load værdi af Row7 i R3
ST R3, EndRowVal;
STI R7, EndRow; Store 0 i Row7
BR Checker;


HIGH
LEA R4, Row7;
AND R6, R6, #0;
ADD R6, R6, #1;
BR Checker;

DOZEN1
LEA R4, Row1;
AND R6, R6, #0;
ADD R6, R6, #2;
AND R7, R7, #0; Reset R7
LEA R3, Row5; Load adresse af Row7 ind i R3
ST R3, EndRow; Store adresse i R3 i EndRow
LDI R3, EndRow; Load værdi af Row7 i R3
ST R3, EndRowVal;
STI R7, EndRow; Store 0 i Row7
BR Checker;

DOZEN2
LEA R4, Row5;
AND R6, R6, #0;
ADD R6, R6, #2;
AND R7, R7, #0; Reset R7
LEA R3, Row9; Load adresse af Row7 ind i R3
ST R3, EndRow; Store adresse i R3 i EndRow
LDI R3, EndRow; Load værdi af Row7 i R3
ST R3, EndRowVal;
STI R7, EndRow; Store 0 i Row7
BR Checker;

DOZEN3
LEA R4, Row9;
AND R6, R6, #0;
ADD R6, R6, #2;
BR Checker;

COLUMN1
AND R6, R6, #0;
ADD R6, R6, #2;
AND R7, R7, #0;
AND R3, R3, #0;
AND R5, R5, #0;
ADD R5, R5, #-16;
ADD R5, R5, #-16;
ADD R5, R5, #-4;
LEA R7, ColumnList;

LOOP1
LEA R4, Row1;
ADD R4, R4, R3;
LDR R4, R4, #0;
STR R4, R7, #0;
ADD R7, R7, #1;
ADD R3, R3, #3;
ADD R4, R3, R5;
BRnp LOOP1;

LEA R4, Row1;
ADD R4, R4, R3;
STR R7, R4, #0;
LEA R4, ColumnList;
BR Checker;

COLUMN2
AND R6, R6, #0;
ADD R6, R6, #2;
AND R7, R7, #0;
AND R3, R3, #0;
ADD R3, R3, #1;
AND R5, R5, #0;
ADD R5, R5, #-16;
ADD R5, R5, #-16;
ADD R5, R5, #-5;
LEA R7, ColumnList;

LOOP2
LEA R4, Row1;
ADD R4, R4, R3;
LDR R4, R4, #0;
STR R4, R7, #0;
ADD R7, R7, #1;
ADD R3, R3, #3;
ADD R4, R3, R5;
BRnp LOOP2;

LEA R4, Row1;
ADD R4, R4, R3;
STR R7, R4, #0;
LEA R4, ColumnList;
BR Checker;

COLUMN3
AND R6, R6, #0;
ADD R6, R6, #2;
AND R7, R7, #0;
AND R3, R3, #0;
ADD R3, R3, #2;
AND R5, R5, #0;
ADD R5, R5, #-16;
ADD R5, R5, #-16;
ADD R5, R5, #-6;
LEA R7, ColumnList;

LOOP3
LEA R4, Row1;
ADD R4, R4, R3;
LDR R4, R4, #0;
STR R4, R7, #0;
ADD R7, R7, #1;
ADD R3, R3, #3;
ADD R4, R3, R5;
BRnp LOOP3;

LEA R4, Row1;
ADD R4, R4, R3;
STR R7, R4, #0;
LEA R4, ColumnList;
BR Checker;

STREET
AND R6, R6, #0;
ADD R6, R6, #11;
LEA R4, Row1;
LD R3, ARG2;
LOOP4
ADD R4, R4, #3;
ADD R3, R3, #-1;
BRnp LOOP4;

ST R4, EndRow;
LDI R4, EndRow;
ST R4, EndRowVal;
STI R3, EndRow;
LD R4, EndRow;
ADD R4, R4, #-3;
BR Checker;

LINE
AND R6, R6, #0;
ADD R6, R6, #5;
LEA R4, Row1;
LD R3, ARG2;
LOOP5
ADD R4, R4, #3;
ADD R3, R3, #-1;
BRnp LOOP5;

ADD R4, R4, #3;
ST R4, EndRow;
LDI R4, EndRow;
ST R4, EndRowVal;
STI R3, EndRow;
LD R4, EndRow;
ADD R4, R4, #-6;
BR Checker;


RowReset
LD R3, EndRowVal;
STI R3, EndRow;
RET;

;Varibel - lister

Player1Chips .FILL	#0

NumOfBets .fill #4

BetNumber .fill #0

EndRow .BLKW	1

EndRowVal .BLKW	1

ColumnList .BLKW	13

ARG2 .fill 4
; ARG2 .blkw 1

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

Row1 .fill 1
.fill 2
.fill 3
Row2 .fill 4
.fill 5
.fill 6
Row3 .fill 7
.fill 8
.fill 9
Row4 .fill 10
.fill 11
.fill 12
Row5 .fill 13
.fill 14
.fill 15
Row6 .fill 16
.fill 17
.fill 18
Row7 .fill 19
.fill 20
.fill 21
Row8 .fill 22
.fill 23
.fill 24
Row9 .fill 25
.fill 26
.fill 27
Row10 .fill 28
.fill 29
.fill 30
Row11 .fill 31
.fill 32
.fill 33
Row12 .fill 34
.fill 35
.fill 36
.fill 0

.END;