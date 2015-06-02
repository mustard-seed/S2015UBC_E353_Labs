-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: dataPath_tb.vdh
--File Purpose: DE2 testbench of dataPath.vhd.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

ENTITY dataPath_tb IS
  PORT (
  HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR (6 downto 0); --Display card values
  clock_50: IN STD_LOGIC;
  key: IN STD_LOGIC_VECTOR (3 downto 0); --reset button
  SW: IN STD_LOGIC_VECTOR (3 downto 0); --deal, dealTo, and dealToCardSlot
  LEDG: OUT STD_LOGIC_VECTOR (3 downto 0); --Player wins, dealer wins, player bust, dealer bust
  LEDR: OUT STD_LOGIC_VECTOR (0 downto 0)  --Dealer stand
);
END ENTITY;

ARCHITECTURE rtl OF dataPath_tb IS
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
  
  COMPONENT Card7Seg IS
  PORT (
    hex: OUT STD_LOGIC_VECTOR(6 downto 0);
    input: IN UNSIGNED (3 downto 0)
  );
  END COMPONENT;
  
  SIGNAL reset_temp: STD_LOGIC;
  SIGNAL player: STD_LOGIC_VECTOR (15 downto 0);
  SIGNAL dealer: STD_LOGIC_VECTOR (15 downto 0);
BEGIN
  DUT: dataPath PORT MAP (clock => clock_50, reset => reset_temp, deal => SW(3), dealTo => SW(2), 
  dealToCardSlot => SW(1 downto 0), playerCards => player, dealerCards => dealer, 
  dealerStands => LEDR(0), playerWins => LEDG(3), dealerWins => LEDG(2), playerBust => LEDG(1), dealerBust => LEDG(0));
  
  --Player Card Display
  HEXC3: Card7Seg PORT MAP(hex => HEX3, input => UNSIGNED(player(15 downto 12)) );
  HEXC2: Card7Seg PORT MAP(hex => HEX2, input => UNSIGNED(player(11 downto 8)) );
  HEXC1: Card7Seg PORT MAP(hex => HEX1, input => UNSIGNED(player(7 downto 4)) );
  HEXC0: Card7Seg PORT MAP(hex => HEX0, input => UNSIGNED(player(3 downto 0)) );
  
   --Dealer Card Display
  HEXC7: Card7Seg PORT MAP(hex => HEX7, input => UNSIGNED(dealer(15 downto 12)) );
  HEXC6: Card7Seg PORT MAP(hex => HEX6, input => UNSIGNED(dealer(11 downto 8)) );
  HEXC5: Card7Seg PORT MAP(hex => HEX5, input => UNSIGNED(dealer(7 downto 4)) );
  HEXC4: Card7Seg PORT MAP(hex => HEX4, input => UNSIGNED(dealer(3 downto 0)) );
  
  reset_temp <= NOT key(3);
  
END ARCHITECTURE;

