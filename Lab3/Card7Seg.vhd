-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- File Name: Card7Seg.vhd
-- Purpose: Display the value of one card:
-- "0" is nothing, "1" is A, "2" to "10" are 1 are 2 to 0. "J" is J, Q is q, K is H

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Card7Seg IS
  PORT (
    hex: OUT STD_LOGIC_VECTOR(6 downto 0);
    input: IN UNSIGNED (3 downto 0)
  );
END ENTITY;

ARCHITECTURE behave OF Card7Seg IS
BEGIN
  PROCESS (input)
  BEGIN
    CASE input IS
      WHEN x"0" => hex <= "1111111";
      WHEN x"1" => hex <= "0001000";
      WHEN x"2" => hex <= "0100100";
      WHEN x"3" => hex <= "0110000";
      WHEN x"4" => hex <= "0011001";
      WHEN x"5" => hex <= "0010010";
      WHEN x"6" => hex <= "0000010";
      WHEN x"7" => hex <= "1111000";
      WHEN x"8" => hex <= "0000000";
      WHEN x"9" => hex <= "0010000";
      WHEN x"A" => hex <= "1000000";
      WHEN x"B" => hex <= "1110000";  
      WHEN x"C" => hex <= "0011000";
      WHEN OTHERS => hex <= "0001001"; 
    END CASE; 
  END PROCESS;
END ARCHITECTURE;