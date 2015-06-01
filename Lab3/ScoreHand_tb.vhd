-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: Test
--File Purpose:
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ScoreHand_tb IS
END ENTITY;

ARCHITECTURE rtl OF ScoreHand_tb IS
  CONSTANT PERIOD: TIME := 1 ns;
  SIGNAL hand1, hand2, hand3, hand4: UNSIGNED (3 downto 0) := x"0"; 
  SIGNAL scoreout: UNSIGNED (4 downto 0) := "0" & x"0";
  TYPE holder is ARRAY (0 to 13) OF UNSIGNED (3 downto 0);
  CONSTANT list: holder :=
  (
    x"0",
    x"1",
    x"2",
    x"3",
    x"4",
    x"5",
    x"6",
    x"7",
    x"8",
    x"9",
    x"A",
    x"B",
    x"C",
    x"D"
  );
  
  COMPONENT ScoreHand IS
    PORT(
      card1: IN UNSIGNED (3 downto 0);
      card2: IN UNSIGNED (3 downto 0);
      card3: IN UNSIGNED (3 downto 0);
      card4: IN UNSIGNED (3 downto 0);
      score: OUT UNSIGNED (4 downto 0)
    );
  END COMPONENT;   
BEGIN
  DUT: ScoreHand PORT MAP (
    card1 => hand1, card2 => hand2, card3 => hand3, card4 => hand4, score => scoreout
    );
  
  PROCESS
    VARIABLE testScore : UNSIGNED (5 downto 0) := "000000";
  BEGIN
    FOR i1 IN 0 to 13 LOOP
      hand1 <= list(i1);
      FOR i2 IN 0 to 13 LOOP
        hand2 <= list(i2);
        FOR i3 IN 0 to 13 LOOP
          hand3 <= list (i3);
          FOR i4 IN 0 to 13 LOOP
            hand4 <= list (i4);
            testScore := ("00" & list(i1)) + ("00" & list(i2)) + ("00" & list (i3)) + ("00" & list (i4));
            WAIT FOR  PERIOD;
          END LOOP;
        END LOOP; 
      END LOOP;
    END LOOP; 
  END PROCESS;
END ARCHITECTURE;