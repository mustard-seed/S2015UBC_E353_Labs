-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: DealCard.vhd
--File Purpose: Generate Pseudo-random card values from 0 to 13. Samples and outputs
--the value upon "rising edge" in enable signal
--Pseudo random value driven by fast clock. Entire circuit driven by fast clock.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DealCard IS
    PORT(
      clock : IN STD_LOGIC;
      enable: IN STD_LOGIC;
      reset: IN STD_LOGIC;
      countSample: OUT UNSIGNED (3 downto 0)      
    );
END ENTITY;

ARCHITECTURE behave OF DealCard IS
  --SIGNAL enableSignal: STD_LOGIC;
BEGIN 
    --enableSignal <= enable;
  PROCESS (clock)
   --The fast counter 
    VARIABLE count: UNSIGNED (3 downto 0) := "0000";
   -- VARIABLE enableVar: STD_LOGIC;
   -- VARIABLE enableVar_prev: STD_LOGIC := enableVar;
  BEGIN
    IF rising_edge(clock) THEN
      --enableVar := enable;
      --count := count+1;
      
      --If count goes beyone 13, wrap back to 0;
      IF count = "1110"  THEN
          count := "0000";
      END IF;
      --Sync. Reset
      IF reset = '1' THEN
          countSample <= "0000";
      --Update output
      ELSIF ((enable /= enable'last_value) AND (enable = '1')) THEN
      --ELSIF ((enableVar /= enableVar_prev) AND (enableVar = '1')) THEN
          countSample <= count;
      END IF;
      --enableVar_prev = enableVar;
    END IF;
  END PROCESS;
  
END ARCHITECTURE;