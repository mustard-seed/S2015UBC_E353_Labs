-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Finite State Machine with Asynchornous Reset
entity lab2_FSM_count is
       port (clk, reset, dir: in std_logic;
             lcd_rs: out std_logic;
             data: out std_logic_vector(7 downto 0);
             state_out: out std_logic_vector(7 downto 0));
end lab2_FSM_count;

architecture behave of lab2_FSM_count is
  -- Enumerate the state variables
  type STATE is (R0, R1, R2, R3, R4, R5, S0, S1, S2, S3, S4);
  -- Define the characters
  constant L0: std_logic_vector(7 downto 0):= "01001010";
  constant L1: std_logic_vector(7 downto 0):= "01100001";
  constant L2: std_logic_vector(7 downto 0):= "01101101";
  constant L3: std_logic_vector(7 downto 0):= "01100101";
  constant L4: std_logic_vector(7 downto 0):= "01110011";
  
  signal current_state: STATE;
  
begin

--Next State Logic
--Asynchornous reset, so clk and reset both enter the sensititivty list)
NEXT_LOGIC: process(clk, reset) 
variable count: integer := 0;
begin
  if reset = '1' then
    current_state <= R0;
elsif rising_edge(clk) then
    case current_state is
      when R0 =>
        current_state <= R1;
      when R1 =>
        current_state <= R2;
      when R2 =>
        current_state <= R3;
      when R3 =>
        current_state <= R4;
      when R4 =>
        current_state <= R5;
      when R5 =>
        current_state <= S0;
      when S0 =>
        if dir = '0' then
          current_state <= S1;
        else 
          current_state <= S4;
        end if;
      when S1 =>
        if dir = '0' then
          current_state <= S2;
        else 
          current_state <= S0;
        end if;
      when S2 =>
        if dir = '0' then
          current_state <= S3;
        else 
          current_state <= S1;
        end if;
      when S3 =>
        if dir = '0' then
          current_state <= S4;
        else 
          current_state <= S2;
        end if;
      when others =>
        if dir = '0' then
          current_state <= S0;
        else 
          current_state <= S3;
        end if;
    end case;
    end if;
end process;
    
-- Output Logic
-- combinational process
OUT_LOGIC: process (current_state)
begin
  case current_state is 
    when R0 => 
      data <= x"38";
      lcd_rs <= '0';
      state_out <=  x"01";
    when R1 =>
      data <= x"38";
      lcd_rs <= '0';
      state_out <=  x"02";
    when R2 =>
      data <= x"0C";
      lcd_rs <= '0';
      state_out <=  x"03";
    when R3 =>
      data <= x"01";
      lcd_rs <= '0';
      state_out <=  x"04";
    when R4 =>
      data <= x"06";
      lcd_rs <= '0';
      state_out <=  x"05";
    when R5 =>
      data <= x"80";
      lcd_rs <= '0';
      state_out <=  x"06";
    when S0 =>
      data <= L0;
      lcd_rs <= '1';
      state_out <=  x"07";
    when S1 =>
      data <= L1;
      lcd_rs <= '1';
      state_out <=  x"08";
    when S2 =>
      data <= L2;
      lcd_rs <= '1';
      state_out <=  x"09";
    when S3 =>
      data <= L3;
      lcd_rs <= '1';
      state_out <=  x"0A";
    when others =>
      data <= L4;
      lcd_rs <= '1';
      state_out <=  x"0B";
      end case;
 end process;
end behave;