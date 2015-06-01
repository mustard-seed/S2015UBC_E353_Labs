-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DataPath IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		deal          : IN STD_LOGIC;
		dealTo        : IN STD_LOGIC;
		dealToCardSlot: IN STD_LOGIC_VECTOR(1 downto 0);

		playerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- player’s hand
		dealerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- dealer’s hand

		dealerStands : OUT STD_LOGIC; -- true if dealerScore >= 17

		playerWins : OUT STD_LOGIC; -- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins : OUT STD_LOGIC; -- true if dealerScore >= playerScore AND dealerScore <= 21

		playerBust : OUT STD_LOGIC; -- true if playerScore > 21
		dealerBust : OUT STD_LOGIC  -- true if dealerScore > 21
	);
END ENTITY;
	
ARCHITECTURE Behavioural OF DataPath IS
  --Declare signals, type, etc here.
  
  -- Data wire for the cards in player and dealer. Possible card ranges from 0 to 13.
  TYPE Hand IS ARRAY (0 to 3) OF UNSIGNED (3 downto 0);
  SIGNAL playerHands, dealerHands: Hand;
  --SIGNAL playerCards_temp, dealerCards_temp: STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  -- Scores of dealer and player
  SIGNAL dealerScore, playerScore: unsigned (4 downto 0);
  
  -- AI configuration
  -- Dealer stands when its score >= 17;
  CONSTANT dealerStandTresh: unsigned(4 downto 0) := "10001";
  
  -- Bust Treshold. Participant goes bust if his score >= 22; Score forced to 31
  CONSTANT bustTresh: unsigned(4 downto 0) := "10110";
  
  
  -- Define the enable values for the DealCard instances
  TYPE DealEnableValue IS ARRAY(0 to 7) OF UNSIGNED (2 downto 0);
    
  CONSTANT dealEnableTresh: DealEnableValue:=
  (
   -- values to Deal to dealers 1 to 4:
    "000",
    "001",
    "010",
    "011",
    -- values to Deal to players 1 to 4:
    "100",
    "101",
    "110",
    "111"  );
    
  TYPE DealEnableMonitor IS ARRAY(0 to 7) OF STD_LOGIC;
  SIGNAL dealEnable: DealEnableMonitor;
    
  -- Define Components
 
  
  COMPONENT DealCard IS
    PORT(
      clock : IN STD_LOGIC;
      enable: IN STD_LOGIC;
      reset: IN STD_LOGIC;
      countSample: OUT UNSIGNED (3 downto 0)      
    );
  END COMPONENT;
  
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
  -- Instantiate DealCards for Dealer
  GEN_P_DEAL: FOR i IN dealerHands'RANGE GENERATE
    P_DEAL_X: DealCard port map
      (clock=>clock, enable=>dealEnable(i), 
      reset=>reset, countSample=>dealerHands(i)
    );
  END GENERATE GEN_P_DEAL;
  
  -- Instantiate DealCards for Player
  GEN_D_DEAL: FOR i IN playerHands'RANGE GENERATE
    D_DEAL_X: DealCard port map
      (clock=>clock, enable=>dealEnable(i+playerHands'LENGTH), 
      reset=>reset, countSample=>playerHands(i)
    );
  END GENERATE GEN_D_DEAL;
  
  -- Evalue the enable values for the Card Dealer
  EVAL_DEAL_ENABLE: PROCESS (dealTo, dealToCardSlot, deal)
  BEGIN
    FOR i IN dealEnable'RANGE LOOP
      -- Check for equality
      -- Cannot assign a BOOLEAN, directly to dealEnable(i), a STD_LOGIC. 
      -- Hence must use the following IF...THEN...ELSE statement
      IF UNSIGNED ((dealTo & dealToCardSlot) = DealEnableTresh(i) AND deal = '1') THEN
         dealEnable(i) <= '1';
      ELSE
        dealEnable(i) <='0';
      END IF;
    END LOOP;
  END PROCESS;
  
  --- Linkup the Hands to the ScoreHands
  COMP_D_SCORE: ScoreHand port map
    (card1 => dealerHands(0), card2 => dealerHands(1),
     card3 => dealerHands(2), card4 => dealerHands(3),
     score => dealerScore);
  
  COMP_P_SCORE: ScoreHand port map
    (card1 => playerHands(0), card2 => playerHands(1),
     card3 => playerHands(2), card4 => playerHands(3),
     score => playerScore);
  
  --From the outputs
  --Output: Cards  
  playerCards <= STD_LOGIC_VECTOR(playerHands(3)) & 
                  STD_LOGIC_VECTOR(playerHands(2)) & 
                  STD_LOGIC_VECTOR(playerHands(1)) & 
                  STD_LOGIC_VECTOR(playerHands (0)); 
  
  dealerCards <= STD_LOGIC_VECTOR(dealerHands(3)) & 
                  STD_LOGIC_VECTOR(dealerHands(2)) & 
                  STD_LOGIC_VECTOR(dealerHands(1)) & 
                  STD_LOGIC_VECTOR(dealerHands (0)); 
  
  --Decide winnner and bust
  PROCESS (dealerScore, playerScore)
  BEGIN
    IF dealerScore = bustTresh THEN
      -- Both go bust
      IF playerScore = bustTresh THEN
        dealerWins <= '0';
        playerWins <= '0';
        dealerBust <= '1';
        playerBust <= '1';
      -- Dealer goes bust, but Player doesn't
      ELSE
        dealerWins <= '0';
        playerWins <= '1';
        dealerBust <= '1';
        playerBust <= '0';
      END IF;
    ELSE 
      -- Player goes bust, but Dealer Doesn't
      IF playerScore = bustTresh THEN
        dealerWins <= '1';
        playerWins <= '0';
        dealerBust <= '0';
        playerBust <= '1';
      ELSE
          -- Nobody goes bust. Dealer wins
          IF dealerScore >= playerScore  THEN
            dealerWins <= '1';
            playerWins <= '0';
            dealerBust <= '0';
            playerBust <= '0';
          -- Nobody goes bust, Player wins
          ELSE  
            dealerWins <= '0';
            playerWins <= '1';
            dealerBust <= '0';
            playerBust <= '0';
          END IF;
      END IF;
    END IF;
  END PROCESS;
  
  -- A.I. STAND
    PROCESS  (dealerScore)
    BEGIN
        IF dealerScore >= dealerStandTresh THEN
            dealerStands <= '1';
        ELSE
            dealerStands <= '0';
        END IF;
    END PROCESS;
       
END ARCHITECTURE;