-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: drawLine_tb.vhd
--File Purpose: Test Bench File for drawLine_tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY drawLineTB IS
END ENTITY;

ARCHITECTURE rtl OF drawLineTB IS
  COMPONENT drawLine IS PORT (
   x0_in, x1_in: IN STD_LOGIC_VECTOR (7 downto 0);
y0_in, y1_in: IN STD_LOGIC_VECTOR (6 downto 0);
load_coord, err_sel, clock, plot_sel, reset: IN STD_LOGIC;
x_out: OUT STD_LOGIC_VECTOR (7 downto 0);
y_out: OUT STD_LOGIC_VECTOR (6 downto 0);
done, plot: OUT STD_LOGIC);
END COMPONENT;
  
  SIGNAL x0, x1, x_out: STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL y0, y1, y_out: STD_LOGIC_VECTOR (6 downto 0);
  SIGNAL load, err_sel, plot_sel, done, plot_out, reset: STD_LOGIC;
  SIGNAL clock :STD_LOGIC := '0';
  CONSTANT HALF_CLK :TIME := 5 ns;
BEGIN
DUT: drawLine PORT MAP (
  x0_in => x0, y0_in => y0, x1_in => x1, y1_in => y1,
  load_coord => load, err_sel => err_sel, clock => clock, 
  plot_sel => plot_sel, reset => reset, x_out => x_out, y_out => y_out, done => done,
  plot => plot_out);

  x0 <= "01100000";
  y0 <= "0111100";
  x1 <= "00000000";
  y1 <= "0000000";
  
  CLK: PROCESS
    BEGIN
      WAIT FOR HALF_CLK;
      clock <= NOT clock;
    END PROCESS;
  
  TEST: PROCESS
    BEGIN
      --First cycle, load
      WAIT FOR HALF_CLK;
      
      load <= '1'; 
      err_sel <= '0';
      plot_sel <= '0';
      WAIT FOR 2*HALF_CLK;
      
      load <= '0';
      err_sel <= '1';
      plot_sel <= '1';
      WAIT FOR 2*HALF_CLK;
      
      load <= '0';
      err_sel <= '0';
      CASE done IS
      WHEN '1' => plot_sel <= '0';
      WHEN OTHERS => plot_sel <= '1';
      END CASE;
      WAIT;
      
    END PROCESS;
  
END ARCHITECTURE;