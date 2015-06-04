-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- File Name: FSM_James.vhd
-- Purpose: FSM of the Black Jack game.

-- Recommended FSM Design. The FSM should have the following states:
-- 1) Deal to A.I. 1 (Reset State)
-- 2) Deal to Player 1
-- 3) Deal to Player 2.
---4) Deal to Player 3
-- 5) Deal to Player 4
-- 6) Deal to A.I. 2
-- 7) Deal to A.I. 3
-- 8) Deal to A.I. 4
-- 9) Display Winner
-- 10) End Game (Everything off)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FSM IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		nextStep     : IN STD_LOGIC; -- when true, it advances game to next step
		playerStands : IN STD_LOGIC; -- true if player wants to stand
		dealerStands : IN STD_LOGIC; -- true if dealerScore >= 17
		playerWins   : IN STD_LOGIC; -- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins   : IN STD_LOGIC; -- true if dealerScore >= playerScore AND dealerScore <= 21
		playerBust   : IN STD_LOGIC; -- true if playerScore > 21
		dealerBust   : IN STD_LOGIC; -- true if dealerScore > 21

		deal          : OUT STD_LOGIC; -- when true, deal a card
                                               -- dealTo and dealToCardSlot are don’t care when deal is false
		dealTo        : OUT STD_LOGIC; -- when true, deal a card to player, otherwise, deal to dealer
		dealToCardSlot: OUT STD_LOGIC_VECTOR(1 downto 0); -- Card slot in the hand to deal to
		
		redLEDs   : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		greenLEDs : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE defn OF FSM IS
  TYPE state IS (DEALA_1, DEALA_2, DEALA_3, DEALA_4, DEALP_1, DEALP_2, DEALP_3, DEALP_4, WIN, OVER, RESET_S);
  SIGNAL state_curr: state;
BEGIN
  STATE_TRANSITION: PROCESS (clock)
  VARIABLE nextStep_prev: STD_LOGIC := '0';
  BEGIN
    IF (rising_edge (clock)) THEN
      IF (reset = '1')  THEN--Sync. Reset
        state_curr <= RESET_S;
      ELSE
        IF state_curr = RESET_S THEN
          state_curr <= DEALP_1;  --Automatically transit from prep state "RESET_S" to DEALP_1
        END IF;
        
        IF state_curr = DEALP_1 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            state_curr <= DEALA_1;
          END IF;
        END IF;
        
        IF state_curr = DEALP_2 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            IF (playerStands = '1') THEN
              state_curr <= DEALA_2;
            ELSE
              state_curr <= DEALP_3;
            END IF;
          END IF;
        END IF;
        
        IF state_curr = DEALP_3 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            IF (playerBust = '1' OR playerStands = '1') THEN
              state_curr <= DEALA_2;
            ELSE
              state_curr <= DEALP_4;
            END IF;
          END IF;
        END IF;
        
        IF state_curr = DEALP_4 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            state_curr <= DEALA_2;
          END IF;
        END IF;
		  
		  IF state_curr = DEALA_1 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
              state_curr <= DEALP_2;
          END IF;
        END IF;
        
        IF state_curr = DEALA_2 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            IF (dealerStands = '1') THEN
              state_curr <= WIN;
            ELSE
              state_curr <= DEALA_3;
            END IF;
          END IF;
        END IF;
        
        IF state_curr = DEALA_3 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            IF (dealerStands = '1' or dealerBust ='1') THEN
              state_curr <= WIN;
            ELSE
              state_curr <= DEALA_4;
            END IF;
          END IF;
        END IF;
        
        IF state_curr = DEALA_4 THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            state_curr <= WIN;
          END IF;
        END IF;    
		
		 IF state_curr = WIN THEN
          IF nextStep_prev = '0' AND nextStep = '1' THEN
            state_curr <= OVER;
          END IF;
        END IF;    
     END IF; 
      nextStep_prev := nextStep;
    END IF;    
  END PROCESS;
  
OUTPUT_LOGIC: PROCESS (state_curr) 
BEGIN
  CASE state_curr IS
    WHEN RESET_S =>
      deal <='0';
      dealTo <='0';
      dealToCardSlot <= (others => '0');
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALA_1 =>
      deal <='1';
      dealTo <='0';
      dealToCardSlot <= (others => '0');
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALA_2 =>
      deal <='1';
      dealTo <='0';
      dealToCardSlot <= "01";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
      
    WHEN DEALA_3 =>
      deal <='1';
      dealTo <='0';
      dealToCardSlot <= "10";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALA_4 =>
      deal <='1';
      dealTo <='0';
      dealToCardSlot <= "11";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALP_1 =>
      deal <='1';
      dealTo <='1';
      dealToCardSlot <= (others => '0');
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALP_2 =>
      deal <='1';
      dealTo <='1';
      dealToCardSlot <= "01";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
      
    WHEN DEALP_3 =>
      deal <='1';
      dealTo <='1';
      dealToCardSlot <= "10";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN DEALP_4 =>
      deal <='1';
      dealTo <='1';
      dealToCardSlot <= "11";
      redLEDs <= (others => '0');
      greenLEDs <= (others => '0');
    
    WHEN WIN =>
      IF (playerWins = '1' and dealerWins = '0') THEN
        deal <='0';
        dealTo <='1';
        dealToCardSlot <= "00";
        redLEDs <= (others => '0');
        greenLEDs <= (others => '1');
      ELSIF (playerWins = '0' and dealerWins = '1') THEN
        deal <='0';
        dealTo <='1';
        dealToCardSlot <= "00";
        redLEDs <= (others => '1');
        greenLEDs <= (others => '0');
      ELSE
        deal <='0';
        dealTo <='0';
        dealToCardSlot <= "00";
        redLEDs <= (others => '0');
        greenLEDs <= (others => '0');
      END IF;
    
    WHEN OTHERS =>
        deal <='0';
        dealTo <='0';
        dealToCardSlot <= "00";
        redLEDs <= (others => '0');
        greenLEDs <= (others => '0');
    END CASE;
END PROCESS;
END ARCHITECTURE;
