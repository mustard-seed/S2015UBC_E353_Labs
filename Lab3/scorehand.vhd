-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: scorehand.vdh
--File Purpose: Compute the score of a hand of 4 cards for the Black Jack Game.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ScoreHand IS
    PORT(
      card1: IN UNSIGNED (3 downto 0);
      card2: IN UNSIGNED (3 downto 0);
      card3: IN UNSIGNED (3 downto 0);
      card4: IN UNSIGNED (3 downto 0);
      score: OUT UNSIGNED (4 downto 0)
    );
END ENTITY;   

ARCHITECTURE behave OF ScoreHand IS
  SIGNAL outScore: UNSIGNED (5 downto 0);
  SIGNAL tempCard1, tempCard2, tempCard3, tempCard4: UNSIGNED (3 downto 0);
BEGIN
  Card_Conversion: PROCESS (card1, card2, card3, card4)
  BEGIN
    IF card1 = x"0" THEN
      tempCard1 <= x"0";
    ELSIF card1 = x"1" THEN
      tempCard1 <= x"B";
    ELSIF card1 >= x"2" AND card1 <= x"A" THEN
      tempCard1 <= card1;
    ELSE  
      tempCard1 <= x"A";
    END IF; 
    
    IF card2 = x"0" THEN
      tempCard2 <= x"0";
    ELSIF card2 = x"1" THEN
      tempCard2 <= x"B";
    ELSIF card2 >= x"2" AND card2 <= x"A" THEN
      tempCard2 <= card2;
    ELSE  
      tempCard2 <= x"A";
    END IF; 
    
    IF card3 = x"0" THEN
      tempCard3 <= x"0";
    ELSIF card3 = x"1" THEN
      tempCard3 <= x"B";
    ELSIF card3 >= x"2" AND card3 <= x"A" THEN
      tempCard3 <= card3;
    ELSE  
      tempCard3 <= x"A";
    END IF; 
    
    IF card4 = x"0" THEN
      tempCard4 <= x"0";
    ELSIF card4 = x"1" THEN
      tempCard4 <= x"B";
    ELSIF card4 >= x"2" AND card4 <= x"A" THEN
      tempCard4 <= card4;
    ELSE  
      tempCard4 <= x"A";
    END IF; 
  END PROCESS; 
   
  Score_Calculation: PROCESS (tempCard1, tempCard2, tempCard3, tempCard4)
    VARIABLE tempScore: UNSIGNED (5 downto 0);
    BEGIN
      tempScore := ("00" & tempCard1) + ("00" & tempCard2) + ("00" & tempCard3) + ("00" & tempCard4);
      IF (tempScore > x"15" AND tempCard1 = x"B") THEN  
          tempScore := tempScore - x"A";
      END IF;
      IF (tempScore > x"15" AND tempCard2 = x"B") THEN  
          tempScore := tempScore - x"A";
      END IF;
      IF (tempScore > x"15" AND tempCard3 = x"B") THEN  
          tempScore := tempScore - x"A";
      END IF;
      IF (tempScore > x"15" AND tempCard4 = x"B") THEN  
          tempScore := tempScore - x"A";
      END IF; 
      IF (tempScore > x"15") THEN
          tempScore := "011111";
      END IF;
      score <= tempScore(4 downto 0);
    END PROCESS;
END ARCHITECTURE;