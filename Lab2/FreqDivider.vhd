-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- The 1 Hz pulse generator derived from the DE2 50 MHz Clock
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FreqDivider is 
  port (clk_in: in std_logic;
        clk_out: out std_logic);
end entity;

architecture behav of FreqDivider is
  
  signal counter: unsigned(25 downto 0);
begin
  process (clk_in)
    begin
      if (rising_edge(clk_in)) then
        counter <= counter + 1;
      end if;
  end process;
  
  clk_out <= counter(counter'left);
end architecture;

      