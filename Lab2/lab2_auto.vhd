-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- Task 3 circuit for Lab 2
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2_auto is
	port(key : in std_logic_vector(3 downto 0);  -- pushbutton switches
	     clock_50: in std_logic;
            sw : in std_logic_vector(8 downto 0);  -- slide switches
            ledg : out std_logic_vector(7 downto 0);
            ledr: out std_logic_vector (0 downto 0);
            lcd_rw : out std_logic;
            lcd_en : out std_logic;
            lcd_rs : out std_logic;
            lcd_on : out std_logic;
            lcd_blon : out std_logic;
            lcd_data : out std_logic_vector(7 downto 0);
            hex0 : out std_logic_vector(6 downto 0));  -- one of the 7-segment diplays
end lab2_auto ;


architecture behavioural of lab2_auto is
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
    signal reset_b, clk_b: std_logic;
         
begin            
      
      FSM: lab2_FSM port map
        (clk => clk_b, reset => reset_b, dir => sw(0),
         lcd_rs => lcd_rs, state_out=>ledg,  data=>lcd_data);
      
      TIMER: FreqDivider port map
        (clk_in => clock_50, clk_out => clk_b);
      
      ledr(0) <= clk_b;      
      
      reset_b <= not key(3);

        -- These will not change
        lcd_blon <= '1';
        lcd_on <= '1';
        lcd_en <= not clk_b;
        lcd_rw <= '0';

      -- Your code goes here
      -- Hint: for task 2, I did it as a single process structured as
      -- a Moore state machine.  See Slide Set 2 for some inspiration. 

end behavioural;

