-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B


-- Lab 1 Multiple Display Design Testbench(Task 3.3) 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity CONVERTERS_TEST is
end entity;

architecture RTL of CONVERTERS_TEST is
  component CONVERTERS
  port (
    SW: in std_logic_vector (11 downto 0);
    HEX0: out std_logic_vector (6 downto 0);
    HEX1: out std_logic_vector (6 downto 0);
    HEX2: out std_logic_vector (6 downto 0);
    HEX3: out std_logic_vector (6 downto 0)
    );
end component;
     
  signal output0: std_logic_vector (6 downto 0);
  signal output1: std_logic_vector (6 downto 0);
  signal output2: std_logic_vector (6 downto 0);
  signal output3: std_logic_vector (6 downto 0);
  signal input: std_logic_vector (11 downto 0);
  
  constant PERIOD: time := 5ns;
  
  begin
    
    dut: CONVERTERS port map(SW=>input, HEX0=>output0, 
      HEX1=>output1, HEX2=>output2, HEX3=>output3);
    
    process 
      begin
        --Test Case 1: All "A"s
        input <= "000000000000";
        wait for PERIOD;
        
        --Test Case 2: All "b"s
        input <= "001001001001";
        wait for PERIOD;
        
        --Test Case 3: All "C"s
        input <= "010010010010";
        wait for PERIOD;
        
        --Test Case 4: All "d"s
        input <= "011011011011";
        wait for PERIOD;
        
        --Test Case 5: All "E"s
        input <= "100100100100";
        wait for PERIOD;
        
        --Test Case 6: All "F"s
        input <= "101101101101";
        wait for PERIOD;
        
        --Test Case 6: All "g"s
        input <= "110110110110";
        wait for PERIOD;
        
        --Test Case 6: All "H"s
        input <= "111111111111";
        wait for PERIOD;
        
        wait;
        
      
    end process;
  end architecture;
        
        