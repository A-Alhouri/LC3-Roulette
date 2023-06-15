library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lc3_computer is
   port (
	  --System clock
      clk              : in  std_logic; 

      --Virtual I/O
      led              : out std_logic_vector(7 downto 0);
      btn              : in  std_logic_vector(4 downto 0);
      sw               : in  std_logic_vector(7 downto 0);
      hex              : out std_logic_vector(15 downto 0); --16 bit hexadecimal value (shown on 7-seg sisplay)

      --Physical I/0 (IO on the Zybo FPGA)
      pbtn				  : in  std_logic_vector(3 downto 0);
      psw				  : in  std_logic_vector(3 downto 0);
	  pled				  : out  std_logic_vector(2 downto 0);

	  --VIO serial
	  rx_data          : in  std_logic_vector(7 downto 0);
      rx_rd            : out std_logic;
      rx_empty         : in  std_logic;
      tx_data          : out std_logic_vector(7 downto 0);
      tx_wr            : out std_logic;
      tx_full          : in  std_logic;
      sink             : out std_logic;
      ------------------Added Serial_UART----------------
      rx               : in std_logic;
      tx               : out std_logic;
      
      --Debug
      address_dbg      : out std_logic_vector(15 downto 0);
      data_dbg         : out std_logic_vector(15 downto 0);
      RE_dbg           : out std_logic;
      WE_dbg           : out std_logic;
		
	  --LC3 CPU inputs
      cpu_clk_enable   : in  std_logic;
      sys_reset        : in  std_logic;
      sys_program      : in  std_logic
      
   );
   
end lc3_computer;

architecture Behavioral of lc3_computer is
    --Creating user friently names for the buttons
    alias btn_u : std_logic is btn(0); --Button UP
    alias btn_l : std_logic is btn(1); --Button LEFT
    alias btn_d : std_logic is btn(2); --Button DOWN
    alias btn_r : std_logic is btn(3); --Button RIGHT
    alias btn_s : std_logic is btn(4); --Button SELECT (center button)
    alias btn_c : std_logic is btn(4); --Button CENTER
   
    signal sink_sw : std_logic;
    signal sink_psw : std_logic;
    signal sink_btn : std_logic;
    signal sink_pbtn : std_logic;
    signal sink_uart : std_logic;
   
   
	-- Memory interface signals
	signal address           : std_logic_vector(15 downto 0);
	signal data_in           : std_logic_vector(15 downto 0); -- data inputs
    signal data_out          : std_logic_vector(15 downto 0); -- data inputs
	signal data              : std_logic_vector(15 downto 0); -- data inputs
	signal RE                : std_logic;
	signal WE                : std_logic;

	-- I/O constants for addr from 0xFE00 to 0xFFFF:
    constant STDIN_S         : std_logic_vector(15 downto 0) := X"FE00";  -- Serial IN (terminal keyboard)
    constant STDIN_D         : std_logic_vector(15 downto 0) := X"FE02";
    constant STDOUT_S        : std_logic_vector(15 downto 0) := X"FE04";  -- Serial OUT (terminal  display)
    constant STDOUT_D        : std_logic_vector(15 downto 0) := X"FE06";

    constant IO_SW           : std_logic_vector(15 downto 0) := X"FE0A";  -- Switches
    constant IO_PSW          : std_logic_vector(15 downto 0) := X"FE0B";  -- Physical Switches	
	constant IO_BTN          : std_logic_vector(15 downto 0) := X"FE0e";  -- Buttons
 	constant IO_PBTN         : std_logic_vector(15 downto 0) := X"FE0F";  -- Physical Buttons	
	constant IO_SSEG         : std_logic_vector(15 downto 0) := X"FE12";  -- 7 segment
	constant IO_LED          : std_logic_vector(15 downto 0) := X"FE16";  -- Leds
	constant IO_PLED         : std_logic_vector(15 downto 0) := X"FE17";  -- Physical Leds
   
    -----------------------------------------UART STDIN/OUT-------------------------------
    constant STDIN_S_UART    : std_logic_vector(15 downto 0) := X"FF00";  -- Serial IN (terminal keyboard)
    constant STDIN_D_UART    : std_logic_vector(15 downto 0) := X"FF02";
    constant STDOUT_S_UART   : std_logic_vector(15 downto 0) := X"FF04";  -- Serial OUT (terminal  display)
    constant STDOUT_D_UART   : std_logic_vector(15 downto 0) := X"FF06";
    
    -----------------Signal for Random Number---------------------------------------
     constant Random    : std_logic_vector(15 downto 0) := X"FF08";
    
    -----------------Signals for Register for IO_SSEG-------------------------------
    signal StoreHex         : std_logic_vector (15 downto 0);
    signal SSEG_EN          : std_logic;
    signal mem_EN           : std_logic;
      
    -----------------Signals for Register for IO_LED-----------------
    signal LED_EN           : std_logic;
    signal StoreLED         : std_logic_vector (7 downto 0);
      
    -----------------Signals for Register for IO_PLED(Physical Leds)-----------------
    signal PLED_EN          : std_logic;
    signal StorePLED        : std_logic_vector (2 downto 0);
       
    -----------------Signal for Mux Select-----------------
    signal MuxSelect        : std_logic_vector(3 downto 0);
      
    -----------------Signal for ram-----------------
    signal mem_ram          : std_logic_vector(15 downto 0);
      
    -----------------Added Serial-----------------
    signal rx_data_UART   :  std_logic_vector(7 downto 0);
    signal rx_rd_UART     : std_logic;
    signal rx_empty_UART  :  std_logic;
    signal tx_data_UART   : std_logic_vector(7 downto 0);
    signal tx_wr_UART     : std_logic;
    signal tx_full_UART   :  std_logic;
    
    
    --------------------Store counter----------------
    signal RandomNumber     : std_logic_vector(7 downto 0);
    signal StoreNumber     : std_logic_vector (7 downto 0);
    

    
begin
	-- <<< LC3 CPU using multiplexers for the data bus>>>	
	lc3_m: entity work.lc3_wrapper_multiplexers
	   port map (
		     clk        => clk,
		     clk_enable => cpu_clk_enable,
		     reset      => sys_reset,
		     program    => sys_program,
		     addr       => address,
		     data_in    => data_in,
		     data_out   => data_out,
		     WE         => WE,
		     RE         => RE 
		     );
   data_dbg <= data_in when RE='1' else data_out;
	-- <<< LC3 CPU using multiplexers end of instantiation>>>	
	
	--Information that is sent to the debugging module
   address_dbg <= address;
   RE_dbg <= RE;
   WE_dbg <= WE;
   
	-------------------------------------------------------------------------------
	-- <<< Write your VHDL code starting from here >>>
	-------------------------------------------------------------------------------
   -----------------------LC3_Ram--------------------------
   lc3_RAM: entity work.xilinx_one_port_ram_sync
        port map (
            clk     => clk,
            addr    => address,
            din     => data_out,
            dout    => mem_ram,
            WE      => mem_en
            );
               
    ---------------------LC3_UART--------------------------           
    LC3_UART: entity work.uart
        port map (
            clk      => clk,
            reset    => '0',
                
            tx       => tx,
            tx_full  => tx_full_uart,
            wr_uart  => tx_wr_uart,
            w_data   => tx_data_uart,
                     
            rx       => rx,  
            rd_uart  => rx_rd_uart,
            r_data   => rx_data_uart,
            rx_empty => rx_empty_uart
            );
     -----------------------Mod-m dims------------------------
     Counter: entity work.CounterenTilASM
         port map(
            clk => clk,
            reset => pbtn(0),
            max_tick => sink,
            q => RandomNumber
            );
            
            
-----------mod_m Counter Register------------------
process (clk, RandomNumber)
    begin 
        if (clk'event and clk = '1') then 
            if (pbtn(1) = '1') then 
                StoreNumber <= RandomNumber;
            end if;
        end if ;
        
end process; 
--Ellers:
    hex <= "00000000" & StoreNumber;
    
    
-------------IO_SSEG Register------------------
process (clk, SSEG_EN) 
    begin 
        if (clk'event and clk = '1') then 
            if (SSEG_EN = '1') then 
                StoreHex <= data_out; 
            end if;
        end if ;
end process; 
--Ellers:
     --hex <= StoreHex;
     
-------------IO_LED Register------------------
process (clk, LED_EN) 
    begin 
        if (clk'event and clk = '1') then 
            if (LED_EN = '1') then 
                StoreLED <= data_out(7 downto 0); 
            end if;
        end if ;
end process; 
--Ellers:
    LED <= StoreLED;
     
-------------IO_PLED Register------------------
process (clk, PLED_EN) 
    begin
        if (clk'event and clk = '1') then 
            if (PLED_EN = '1') then 
                StorePLED <= data_out(2 downto 0); 
            end if;
        end if ;
end process; 
--Ellers:
    PLED <= StorePLED;
    
    
   --tx_data_UART <= (data_out(7 downto 0) and "01111111");
   --tx_data <= (data_out(7 downto 0) and "01111111");
   
   tx_data_UART <= data_out(7 downto 0);
   tx_data <= data_out(7 downto 0);
    
  -- Address Control Logic
        Address_Control_Logic : process(address)
        begin
    rx_rd <= '0';      --if rx_rd = '1' it removes the first element in the buffer
    tx_wr <= '0';      --if tx_wr <= '1'; inducates that ascii form fifo has been transfered move pointer (next character )
    rx_rd_UART <= '0'; --if rx_rd = '1' it removes the first element in the buffer
    tx_wr_UART <= '0'; --if tx_wr <= '1'; inducates that ascii form fifo has been transfered move pointer (next character )
    SSEG_EN <= '0';
    LED_EN <= '0';
    PLED_EN <= '0';
              case address is
              
                  when IO_SSEG => if WE = '1' then SSEG_EN <= '1'; end if;
                  when IO_SW =>   MuxSelect <= "0001"; -- Select switch
                  when IO_PSW =>  MuxSelect <= "0010"; -- Select physical switches
                  when IO_BTN =>  MuxSelect <= "0011"; -- Select button
                  when IO_PBTN => MuxSelect <= "0100"; -- Select physical buttons
                  when IO_LED => if WE = '1' then LED_EN <= '1'; end if;     -- Select LED
                  when IO_PLED => if WE = '1' then PLED_EN <= '1'; end if;  -- Select physical LED
                  
                  ----------------------------------STDIN/OUT_VIO-----------------------------------------------------------------
                  when STDIN_S => MuxSelect <= "0101";                                           --not(rx_empty) & "000000000000000";  
                  when STDIN_D => if (RE = '1') then  MuxSelect <= "0110"; rx_rd <= '1'; end if; --"00000000" & rx_data;
                  when STDOUT_S => MuxSelect <= "0111";                                          --not(tx_full) & "000000000000000";
                  when STDOUT_D => if (WE = '1') then tx_wr <= '1'; end if;
                  
                  ----------------------------------STDIN/OUT_UART-----------------------------------------------------------------
                  when STDIN_D_UART => if (RE = '1') then rx_rd_UART <= '1'; MuxSelect <= "1001"; end if;                  
                  when STDIN_S_UART => MuxSelect <= "1010";
                  when STDOUT_S_UART =>  MuxSelect <= "1011";
                  when STDOUT_D_UART => if (WE = '1') then tx_wr_UART <= '1'; end if;
                  when others => MuxSelect <= "0000"; 
              end case;  
      end process;
      
        --------INMUX-------------
        INMUX : process (mem_EN, mem_ram, sw, psw, btn, pbtn, rx_empty, rx_data, tx_full, rx_data_UART, rx_empty_uart, tx_full_uart)
        begin
            case MuxSelect is
                  --------------------- Basic I/O-----------------------------------------------
                  when "0000" => if (WE='1') then mem_EN <='1'; else mem_EN <= '0'; data_in <= mem_ram; end if;
                  when "0001" => data_in <= "00000000" & sw;                        --VIO Switch
                  when "0010" => data_in <= "000000000000" & psw;                   --Physical Switch
                  when "0011" => data_in <= "00000000000" & btn;                    --VIO Button
                  when "0100" => data_in <= "000000000000" & pbtn;                  --Physical Button 
                  ------------------------STDIN/OUT VIO I/O-------------------------------------
                  when "0101" => data_in <=  not(rx_empty) & "000000000000000";     --STDIN_S
                  when "0110" => data_in <= "00000000" & rx_data;                   --STDIN_D      
                  when "0111" => data_in <= not(tx_full) & "000000000000000";       --STDOUT_S 
                  ------------------------STDIN/OUT UART I/O------------------------------------
                  when "1001" =>  data_in <= "00000000" & rx_data_UART;             --STDIN_D_UART
                  when "1010" => data_in <=  not(rx_empty_uart) & "000000000000000";--STDIN_S_UART
                  when "1011" => data_in <= not(tx_full_uart) & "000000000000000";  --STDOUT_S_UART
                  when others =>
            end case;
        end process;
end Behavioral;