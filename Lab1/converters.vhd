-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B


-- Lab 1 Multiple Display Design (Task 3.3) 

-- The following lines instantiates 4 converters

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity CONVERTERS is
  port (
    SW: in std_logic_vector (11 downto 0);
    HEX0: out std_logic_vector (6 downto 0);
    HEX1: out std_logic_vector (6 downto 0);
    HEX2: out std_logic_vector (6 downto 0);
    HEX3: out std_logic_vector (6 downto 0)
    );
end entity;

architecture BEHAVIOURAL of CONVERTERS is
    component CONVERTER
      port (-- slide switches	
		    SW : in std_logic_vector(2 downto 0);  

		    -- 7-segment display
		    HEX0 : out std_logic_vector(6 downto 0)
		    );
    end component;
    
  begin
    CONV0: CONVERTER port map(HEX0 => HEX0, 
    SW => SW (2 downto 0) );
    CONV1: CONVERTER port map(HEX0 => HEX1, 
    SW => SW (5 downto 3) );
    CONV2: CONVERTER port map(HEX0 => HEX2, 
    SW => SW (8 downto 6) );
    CONV3: CONVERTER port map(HEX0 => HEX3, 
    SW => SW (11 downto 9) );
    
end architecture;  