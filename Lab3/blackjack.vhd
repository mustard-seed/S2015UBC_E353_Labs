LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY BlackJack IS
        -- Do not modify this port list! 
	PORT(
		CLOCK_50 : in std_logic; -- A 50MHz clock
		SW   : in  std_logic_vector(0 downto 0);  -- SW(0) = player stands
		KEY  : in  std_logic_vector(3 downto 0);  -- KEY(3) reset, KEY(0) advance
		LEDR : out std_logic_vector(17 downto 0); -- red LEDs: dealer wins
		LEDG : out std_logic_vector(8 downto 0);  -- green LEDs: player wins

		HEX7 : out std_logic_vector(6 downto 0);  -- dealer, fourth card
		HEX6 : out std_logic_vector(6 downto 0);  -- dealer, third card
		HEX5 : out std_logic_vector(6 downto 0);  -- dealer, second card
		HEX4 : out std_logic_vector(6 downto 0);  -- dealer, first card

		HEX3 : out std_logic_vector(6 downto 0);  -- player, fourth card
		HEX2 : out std_logic_vector(6 downto 0);  -- player, third card
		HEX1 : out std_logic_vector(6 downto 0);  -- player, second card
		HEX0 : out std_logic_vector(6 downto 0)   -- player, first card
	);
END;

ARCHITECTURE Behavioural OF BlackJack IS

	COMPONENT Card7Seg IS
	PORT(
	   	hex: OUT STD_LOGIC_VECTOR(6 downto 0);
      input: IN UNSIGNED (3 downto 0)
	);
	END COMPONENT;

	COMPONENT DataPath IS
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
	END COMPONENT;

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

  SIGNAL pCards, dCards: STD_LOGIC_VECTOR (15 downto 0);
  SIGNAL tempNext, tempRST: STD_LOGIC;
  SIGNAL intDeal, intDealTo, intDStands, intPWins, intDWins, intPBust, intDBust, intPStands: STD_LOGIC;
  SIGNAL intDealToCardSlot: STD_LOGIC_VECTOR (1 downto 0);
BEGIN
   --Player Card Display
  HEXC3: Card7Seg PORT MAP(hex => HEX3, input => UNSIGNED(pCards(15 downto 12)) );
  HEXC2: Card7Seg PORT MAP(hex => HEX2, input => UNSIGNED(pCards(11 downto 8)) );
  HEXC1: Card7Seg PORT MAP(hex => HEX1, input => UNSIGNED(pCards(7 downto 4)) );
  HEXC0: Card7Seg PORT MAP(hex => HEX0, input => UNSIGNED(pCards(3 downto 0)) );
  
   --Dealer Card Display
  HEXC7: Card7Seg PORT MAP(hex => HEX7, input => UNSIGNED(dCards(15 downto 12)) );
  HEXC6: Card7Seg PORT MAP(hex => HEX6, input => UNSIGNED(dCards(11 downto 8)) );
  HEXC5: Card7Seg PORT MAP(hex => HEX5, input => UNSIGNED(dCards(7 downto 4)) );
  HEXC4: Card7Seg PORT MAP(hex => HEX4, input => UNSIGNED(dCards(3 downto 0)) );
  
  DATA_PATH: DataPath 
	PORT MAP(
		clock => clock_50, reset => tempRST, 
		deal => intDeal, dealTo => intDealTo, dealToCardSlot => intDealToCardSlot,
		playerCards => pCards,	dealerCards => dCards,
		dealerStands => intDStands,
		playerWins => intPWins,
		dealerWins => intDWins,
		playerBust => intPBust,
		dealerBust => intDBust
	);
	
	tempNext <= not KEY(0);
	tempRST <= not KEY(3);
	
	intPStands <= SW(0);
	LEDG(8) <= not KEY(0);
	
	FSM_COMP: FSM 
	PORT MAP(
		clock => clock_50, reset => tempRST,
		nextStep  => tempNext,
		playerStands => intPStands,
		dealerStands => intDStands,
		playerWins => intPWins,
		dealerWins => intDWins,
		playerBust => intPBust,
		dealerBust => intDBust,
    deal => intDeal,                                       
		dealTo => intDealTo,
		dealToCardSlot => intDealToCardSlot,
		redLEDs => LEDR,
		greenLEDs => LEDG(7 downto 0));
	
END Behavioural;

