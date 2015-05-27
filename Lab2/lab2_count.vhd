-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- Challenge Task of Lab 2
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2_count is
	port(key : in std_logic_vector(3 downto 0);  -- pushbutton switches
	     clock_50: in std_logic;
            sw : in std_logic_vector(8 downto 0);  -- slide switches
            ledg : out std_logic_vector(7 downto 0);
            ledr: out std_logic_vector (17 downto 0);
            lcd_rw : out std_logic;
            lcd_en : out std_logic;
            lcd_rs : out std_logic;
            lcd_on : out std_logic;
            lcd_blon : out std_logic;
            lcd_data : out std_logic_vector(7 downto 0);
            hex0 : out std_logic_vector(6 downto 0));  -- one of the 7-segment diplays
end lab2_count ;


architecture behavioural of lab2_count is
     -- The Finite State Machine
     component lab2_FSM is
       port (clk, reset, dir: in std_logic;
             lcd_rs: out std_logic;
             data: out std_logic_vector(7 downto 0);
             state_out: out std_logic_vector(7 downto 0));
     end component;
     
     component FreqDivider is 
        port (clk_in: in std_logic;
        clk_out: out std_logic);
   end component;
     
    
    signal current_state: std_logic_vector (7 downto 0);
    signal reset_b, clk_b, clk_mux, rs_mux, reset_count, mux_sel: std_logic;
    signal data_mux: std_logic_vector(7 downto 0);
    signal count: unsigned(4 downto 0);
begin            
      
      FSM: lab2_FSM port map
        (clk => clk_b, reset => reset_b, dir => sw(0),
         lcd_rs => rs_mux, state_out=>ledg,  data=>data_mux);
      
      TIMER: FreqDivider port map
        (clk_in => clock_50, clk_out => clk_mux);
      
      ledr(0) <= clk_mux;      
      
      reset_b <= not key(3);
      
      COUNTER: process (reset_b, clk_mux)
        begin
          if (reset_b = '1') then
           count <= "00000";
          elsif (rising_edge(clk_mux)) then
			 count <= count + 1;
				if (reset_count = '1') then
					count <= '0' & x"6";
				end if;
          end if;
			end process;
		   
		COMPARE: process (count)
		begin
			if (count = x"16") then
				reset_count <= '1';
				mux_sel <= '1';
			else
				reset_count <= '0';
				mux_sel <= '0';
			end if;
		end process;
		
		DATA_SEL: process(data_mux, mux_sel)
		begin
			if (mux_sel = '1') then
				lcd_data <= x"01"; --Clear screen
			else
				lcd_data <= data_mux;
			end if;
		end process;
		
		RS_SEL: process(rs_mux, mux_sel)
		begin
			if (mux_sel = '1') then
				lcd_rs <= '0';
			else
				lcd_rs <= rs_mux;
			end if;
		end process;
		
		CLK_SEL: process(clk_mux, mux_sel)
		begin
			if (mux_sel = '1') then
				clk_b <= '0';
			else
				clk_b <= clk_mux;
			end if;
		end process;
		

        -- These will not change
        lcd_blon <= '1';
        lcd_on <= '1';
        lcd_en <= clk_mux;
        lcd_rw <= '0';
		  ledr(5 downto 1) <= std_logic_vector(count);
		  ledr(17) <= mux_sel;

      -- Your code goes here
      -- Hint: for task 2, I did it as a single process structured as
      -- a Moore state machine.  See Slide Set 2 for some inspiration. 

end behavioural;

