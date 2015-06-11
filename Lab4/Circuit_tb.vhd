-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: Circuit_tb.vhd
--File Purpose: Test Bench File for drawLine_tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY circuitTB IS
END ENTITY;

ARCHITECTURE rtl OF circuitTB IS
COMPONENT Circuit IS PORT (
 x_in: IN STD_LOGIC_VECTOR (7 downto 0);
 y_in: IN STD_LOGIC_VECTOR (6 downto 0);
 colour_in: IN STD_LOGIC_VECTOR (2 downto 0);
 clock, reset, move: IN STD_LOGIC;
 x_out: OUT STD_LOGIC_VECTOR (7 downto 0);
 y_out: OUT STD_LOGIC_VECTOR (6 downto 0);
 plot: OUT STD_LOGIC;
 colour: OUT STD_LOGIC_VECTOR (2 downto 0)
);
END COMPONENT;
  
  SIGNAL x_in, x_out: STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL y_in, y_out: STD_LOGIC_VECTOR (6 downto 0);
  SIGNAL colour_in, colour_out: STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL reset, move, plot_out: STD_LOGIC;
  SIGNAL clock :STD_LOGIC := '0';
  CONSTANT HALF_CLK :TIME := 5 ns;
BEGIN
DUT: Circuit PORT MAP (
  x_in => x_in, y_in => y_in, colour_in => colour_in,
   clock => clock, 
  reset => reset, move => move, x_out => x_out, y_out => y_out, plot => plot_out, colour=> colour_out);
  
  CLK: PROCESS
    BEGIN
      WAIT FOR HALF_CLK;
      clock <= NOT clock;
    END PROCESS;
    
  TEST: PROCESS
    BEGIN
      reset <= '1';
      move <= '0';
      colour_in <= "111";
      WAIT FOR 2*HALF_CLK;
      reset <= '0';
      WAIT FOR 2*HALF_CLK*200*200;
      
      x_in <= "00000000";
      y_in <= "0000000";
      move <='1';
      WAIT FOR 2*HALF_CLK;
      move <= '0';
      WAIT FOR 2*HALF_CLK*300;
      
      x_in <= "00000000";
      y_in <= "1111111";
      move <='1';
      WAIT FOR 2*HALF_CLK;
      move <= '0';
      WAIT FOR 2*HALF_CLK*300;
      
      WAIT;
    END PROCESS;
  
END ARCHITECTURE;