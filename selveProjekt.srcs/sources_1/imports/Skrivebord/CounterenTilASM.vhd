-- Listing 4.11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity CounterenTilASM is
   generic(
      --N: integer := 4;     -- number of bits
    --  M: integer := 9     -- mod-M
      N: integer := 8;     -- number of bits
      M: integer := 60     -- mod-M
  );
   port(
      clk, reset  : in std_logic;
      max_tick    : out std_logic;
      q           : out std_logic_vector(N-1 downto 0)
   );
end CounterenTilASM;

architecture arch of CounterenTilASM is
   signal r_reg   : unsigned(N-1 downto 0);
   signal r_next  : unsigned(N-1 downto 0);
begin
 -- register
  process(clk,reset)
  begin
     if (reset='1') then r_reg <= "00001010"; -- If reset then set r_reg to 10(decimal) ("A" in hex)
     --if (reset='1') then r_reg <= "0001";
     
     elsif (clk'event and clk='1') then 
     r_reg <= r_next; end if;
     
  end process;
  -- next-state logic
  
  r_next <= "00001010" when r_reg=(M) else r_reg + 1;
  --r_next <= "0001" when r_reg=(M) else r_reg + 1; --set lower bound to 10(decimal) ("A" in hex)
            
  -- output logic
  q <= std_logic_vector(r_reg);
  max_tick <= '1' when r_reg=(M-1) else '0';
end arch;