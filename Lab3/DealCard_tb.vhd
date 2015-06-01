-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: DealCard_tb.vhd
--File Purpose: Testbench of DealCard.vhd
-- Generate enable rising edge on the 1st to 26th clock cycle. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DealCard_tb IS
END ENTITY;

ARCHITECTURE rtl OF DealCard_tb IS
  CONSTANT TEST_QUANTITY: INTEGER := 32;
  CONSTANT HALF_PERIOD: time := 1 ns;
  CONSTANT OFFSET: time := 100 ps;
  SIGNAL clk: STD_LOGIC := '0';
  SIGNAL count_out: UNSIGNED(3 downto 0);
  SIGNAL reset_in: STD_LOGIC;
  SIGNAL enable_in: STD_LOGIC;
  
  COMPONENT DealCard IS
    PORT(
      clock : IN STD_LOGIC;
      enable: IN STD_LOGIC;
      reset: IN STD_LOGIC;
      countSample: OUT UNSIGNED (3 downto 0)      
    );
    END COMPONENT;
BEGIN
  
  DUT: DealCard PORT MAP 
    (clock => clk, enable => enable_in, reset => reset_in, 
     countSample => count_out
    );
    
  CLK_GEN: PROCESS
  BEGIN
    WAIT FOR HALF_PERIOD; 
    clk <= NOT clk;
  END PROCESS;
  
  EN_GEN: PROCESS
  BEGIN
      WAIT FOR 2*HALF_PERIOD-OFFSET;
    FOR i IN 1 TO TEST_QUANTITY LOOP
      -- reset the counter at the beginning of every loop
      reset_in <= '0';
      enable_in <= '0';
      WAIT FOR HALF_PERIOD;
      --- Set the enalbe signal
      reset_in <= '1';
      WAIT FOR HALF_PERIOD;
      reset_in <='0';
      WAIT FOR  HALF_PERIOD*(i*2-1);
      enable_in <= '1';
      WAIT FOR HALF_PERIOD;
    END LOOP;
    WAIT;
  END PROCESS;
  
END ARCHITECTURE;