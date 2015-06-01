-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: ScoreHand_DE2.vhd
--File Purpose: DE2 testingbench of entity ScoreHand.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ScoreHand_DE2 IS
  PORT (
    LEDR: out STD_LOGIC_VECTOR (4 downto 0);
    SW: in STD_LOGIC_VECTOR (15 downto 0)
  );
END ENTITY;

ARCHITECTURE behave OF ScoreHand_DE2 IS
  COMPONENT ScoreHand IS
    PORT(
      card1: IN UNSIGNED (3 downto 0);
      card2: IN UNSIGNED (3 downto 0);
      card3: IN UNSIGNED (3 downto 0);
      card4: IN UNSIGNED (3 downto 0);
      score: OUT UNSIGNED (4 downto 0)
    );
  END COMPONENT; 
  SIGNAL card1_t, card2_t, card3_t, card4_t : UNSIGNED (3 downto 0);
  SIGNAL score_t : UNSIGNED (4 downto 0);
BEGIN
  DUT: ScoreHand PORT MAP(card1=> card1_t,
  card2 => card2_t, card3 => card3_t, card4 => card4_t, score => score_t);
  
  card1_t <= UNSIGNED(SW(15 downto 12));
  card2_t <= UNSIGNED(SW(11 downto 8));
  card3_t <= UNSIGNED(SW(7 downto 4));
  card4_t <= UNSIGNED(SW(3 downto 0));
  LEDR <= STD_LOGIC_VECTOR(score_t);
END ARCHITECTURE;