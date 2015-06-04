-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

-- File Name: FSM_DE2.vhd
-- Purpose: FSM DE2 testbench

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

ENTITY fsm_de2 IS
  PORT (
    LEDR: out STD_LOGIC_VECTOR (1 downto 0);
    LEDG: out STD_LOGIC_VECTOR (3 downto 0);
    SW: in STD_LOGIC_VECTOR (6 downto 0);
    KEY: in STD_LOGIC_VECTOR (3 downto 0);
    CLOCK_50: in STD_LOGIC
  );
END ENTITY;

ARCHITECTURE defn OF fsm_de2 IS
  SIGNAL tempRST, tempNext: STD_LOGIC;
  SIGNAL dealerW: STD_LOGIC_VECTOR (17 downto 0);
  SIGNAL playerW: STD_LOGIC_VECTOR (7 downto 0);
  
  COMPONENT FSM IS
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
  END COMPONENT;
BEGIN
  tempRST <= not KEY(3);
  tempNext <= not KEY(0);
  DUT: FSM PORT MAP(clock => clock_50, reset => tempRST, 
      nextStep => tempNext, playerStands => SW(5), dealerStands => SW(4),
      playerWins => SW(3), dealerWins => SW(2), playerBust => SW(1), dealerBust => SW(0),
      deal => LEDG(3), dealTo => LEDG(2), dealToCardSlot => LEDG(1 downto 0), 
      redLEDs => dealerW, greenLEDs => playerW);
  
  PROCESS (dealerW)
  BEGIN
    IF (dealerW = (dealerW'range => '1')) THEN
      LEDR(1) <= '1';
    ELSE
      LEDR(1) <= '0';
    END IF;
  END PROCESS;
  
  PROCESS (playerW)
  BEGIN
    IF (playerW = (playerW'range => '1')) THEN
      LEDR(0) <= '1';
    ELSE
      LEDR(0) <= '0';
    END IF;
  END PROCESS;
  
END ARCHITECTURE;
   