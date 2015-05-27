-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- Lab 1 Challenge Task Test Bench
-- You should add your code to this file below. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity COUNTER_TB is
end entity;
    
architecture RTL of COUNTER_TB is
  component COUNTER is
    port (
    --KEY[1] is reset, KEY[0] is the "clock"
    KEY: in std_logic_vector (1 downto 0);
    --The output 7-segments LED display
    HEX0: out std_logic_vector (6 downto 0));
  end component;
  
  signal reset: std_logic := '0';
  signal clk: std_logic := '0';
  signal output: std_logic_vector (6 downto 0);
  signal f_sw: std_logic_vector (1 downto 0); 
  
  constant PERIOD : time := 5ns;
  
  begin
    f_sw <= not reset & not clk;
    DUT: counter
    port map (KEY => f_sw, HEX0=>output);
      
    process begin
      --Test part 1, count everything once;
      --A
      wait for PERIOD;
      --B
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --C
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --D
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --E
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --F
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --G
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --H
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --A
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --B
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      --Test part 2: Reset
      reset <= '1';
      clk <='1';
      --A
      wait for PERIOD;
    
      --B
      clk <= '1';
      wait for PERIOD;
      clk <= '0';
      wait for PERIOD;
      
      reset <= '1';
      --B
      wait for PERIOD;
    
      wait;
    end process;
    
  end architecture;      