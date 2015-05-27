-- Lab2 Testbench.  A test bench is a file that describes the commands that should
-- be used when simulating the design.  The test bench does not describe any hardware,
-- but is only used during simulation.  In Lab 2, you can use this test bench directly,
-- and do *not need to modify it* (in later labs, you will have to write test benches).
-- Therefore, you do not need to worry about the details in this file (but you might find
-- it interesting to look through anyway).

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbenches don't have input and output ports.  We'll talk about that in class
-- later in the course.

entity fsm_tb is
end fsm_tb;


architecture stimulus of fsm_tb is

	--Declare the device under test (DUT)
	component lab2_FSM is

	  port (clk, reset, dir: in std_logic;
             lcd_rs: out std_logic;
             data: out std_logic_vector(7 downto 0);
             state_out: out std_logic_vector(7 downto 0));
  end component;
	--Signals that connect to the ports of the DUT. The inputs would be 
	--driven inside the testbench according to different test cases, and
	--the output would be monitored in the waveform viewer.

       signal clk_t: std_logic := '0';
	     signal resetb_t : std_logic := '1';
        signal dir_t : std_logic := '0';
        signal out_lcd_data_t: std_logic_vector(7 downto 0);
        signal state_t: std_logic_vector(7 downto 0);
        	

	--Declare a constant of type 'time'. This would be used to cause delay
       -- between clock edges

	constant HALF_PERIOD : time := 3ns;

begin
	
	DUT: lab2_FSM port map (clk => clk_t,
	                    reset=> resetb_t,
	                    dir=> dir_t,
	                    data => out_lcd_data_t,
	                    state_out=> state_t);
    
        -- set the clock to toggle

        clk_t <= not clk_t after HALF_PERIOD;
 
        -- pulse reset for a little while

        resetb_t <= '0' after HALF_PERIOD*10, '1' after HALF_PERIOD*20;

        -- put in a pattern for DIR.  You can make this more complicated if you like
        -- to increase the effectiveness of your simulation tests.

        dir_t <= '0', 
               '1' after HALF_PERIOD*20,
               '0' after HALF_PERIOD*40;

end stimulus;
