-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- File Name: Card7Seg_DE2.vhd
-- Purpose: DE2 Testbench of Card7Seg.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Card7Seg_DE2 IS
  PORT (
    HEX0: out STD_LOGIC_VECTOR (6 downto 0 );
    SW: in STD_LOGIC_VECTOR (3 downto 0)
  );
END ENTITY;

ARCHITECTURE behave of Card7Seg_DE2 IS
  COMPONENT Card7Seg IS
  PORT (
    hex: OUT STD_LOGIC_VECTOR(6 downto 0);
    input: IN UNSIGNED (3 downto 0)
  );
  END COMPONENT;
  SIGNAL input_conv : UNSIGNED (3 downto 0);
BEGIN
  input_conv <= UNSIGNED(SW);
  DUT: Card7Seg PORT MAP (hex => HEX0 , input => input_conv);
END ARCHITECTURE;