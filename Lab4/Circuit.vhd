-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: Circuit.vhd
--File Purpose: The driver circuit of the VGA core for Lab 4. 
-- Requires specification of modes for running.
-- MODE:
-- FILLCOLOUR: Fill the screen with colourful lines
-- FILLBLACK
-- LINECENTER
-- LINECONT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Circuit IS PORT (
 x_in: IN STD_LOGIC_VECTOR (7 downto 0);
 y_in: IN STD_LOGIC_VECTOR (6 downto 0);
 colour_in: IN STD_LOGIC_VECTOR (2 downto 0);
 clock, reset, move: IN STD_LOGIC;
 x_out: OUT STD_LOGIC_VECTOR (7 downto 0);
 y_out: OUT STD_LOGIC_VECTOR (6 downto 0);
 plot: OUT STD_LOGIC;
 colour: OUT STD_LOGIC_VECTOR (2 downto 0)
);
END ENTITY;

ARCHITECTURE struct OF Circuit IS
  TYPE MODE IS (FILLCOLOUR, LINECENTER, LINECONT);
  TYPE STATE IS (R0, F0, F1, F2, F3, L0, L1, L2, L3); --Change me as progress is made!
  TYPE BUTTON_STATE IS (IDLE, PRESSED, DEBOUNCE);
  
  SIGNAL S: STATE; --State Variable of the FSM
  SIGNAL MS: BUTTON_STATE; --State variable for the Next State button.
  SIGNAL fill_y_count: INTEGER; --Fill Screen ONLY. Register counting the y position
  SIGNAL fill_colour_count: UNSIGNED (2 downto 0); --FILLCOLOUR ONLY. Colour control for the FILLCOLOUR mode.
  SIGNAL fill_y_done: STD_LOGIC; --Fill Screen ONLY. Activates when the last horizontal line is painted during the fill screen session.
  SIGNAL fill_y_init: STD_LOGIC; --Fill Screen ONLY. Initialize signal for fill_y_counter.
  SIGNAL fill_y_update_en: STD_LOGIC; --Fill Screen ONLY. Signal to increment the fill_y_counter.
  SIGNAL line_done: STD_LOGIC; --Signal from drawLine, telling the main FSM that the most recent line drawing has been finished.
  SIGNAL colour_sel: INTEGER; --Datapath selection. Which colour to use?
  SIGNAL coord_sel: INTEGER; --Datapath selection. Which initiale and end coordinates to choose? 
									  --Set to 0 during fill screen, 1 during line from center, 2 during line from previous end point.
  SIGNAL move_edge: STD_LOGIC; --Signal represents that the next state button has just been pressed.
  SIGNAL load_previous_coord: STD_LOGIC; --Task 3 ONLY. Enable signal for the previous_coord registers.
  --Registers for the previous coordinates. 
  SIGNAL x_in_previous: STD_LOGIC_VECTOR (7 downto 0); 
  SIGNAL y_in_previous: STD_LOGIC_VECTOR (6 downto 0);
  
  --Internal wiring
  SIGNAL x0_int, x1_int: STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL y0_int, y1_int: STD_LOGIC_VECTOR (6 downto 0); 
  
  --Datapath control for drawLine
  SIGNAL line_load, line_err_sel, plot_sel: STD_LOGIC;
  
  CONSTANT Y_LIM: INTEGER := 120;
  CONSTANT M: MODE := LINECONT;

  COMPONENT drawLine IS PORT (
    x0_in, x1_in: IN STD_LOGIC_VECTOR (7 downto 0);
    y0_in, y1_in: IN STD_LOGIC_VECTOR (6 downto 0);
    load_coord, err_sel, clock, plot_sel, reset: IN STD_LOGIC;
    x_out: OUT STD_LOGIC_VECTOR (7 downto 0);
    y_out: OUT STD_LOGIC_VECTOR (6 downto 0);
    done, plot: OUT STD_LOGIC);
  END COMPONENT;
  
BEGIN 
BUTTON_STATE_TRANSITION: PROCESS(clock)
BEGIN
	IF (rising_edge(clock)) THEN
		CASE MS IS
			WHEN IDLE =>
				IF (move = '1') THEN
					MS <= PRESSED;
				END IF;
			WHEN PRESSED =>
				MS <= DEBOUNCE;
			WHEN DEBOUNCE =>
				IF (move = '0') THEN	
					MS <= IDLE;
				END IF;
			END CASE;
	END IF;
END PROCESS;

BUTTON_STATE_OUTPUT: PROCESS(MS)
BEGIN
	CASE MS IS
		WHEN PRESSED =>
			move_edge <= '1';
		WHEN OTHERS =>
			move_edge <= '0';
	END CASE;
END PROCESS;

FSM_STATE_TRANSITION: PROCESS (clock, reset) --Change this as the progress is made!
BEGIN
    IF (reset ='1') THEN
        S <= R0;
    
    ELSIF rising_edge (clock) THEN
          CASE S IS 
            WHEN  R0 => 
                S <= F0;
            WHEN  F0 =>
                S <= F1;
            WHEN  F1 =>
                IF line_done = '0'THEN
                    S <= F1;
                ELSIF line_done ='1' and fill_y_done = '0' THEN
                    S <= F2;
                ELSE
						    IF M = FILLCOLOUR THEN
                     S <= F3;
						    ELSE
						          S <= L0;
						    END IF;
                END IF;
            WHEN  F2 =>
                S <= F0;
            WHEN F3 =>
                S <= S;
            WHEN L0 =>
                IF (move_edge = '1') THEN
						S <= L1;
					 END IF;
				WHEN L1 =>
					S <= L2;
				WHEN L2 =>
					IF line_done = '1' THEN
						CASE M IS
							WHEN LINECENTER => S <= L0;
							WHEN OTHERS => S <= L3;
						END CASE;
					END IF;
				WHEN L3 =>
					IF (move_edge = '1') THEN
						S <= L1;
					END IF;
          END CASE;
    END IF;
END PROCESS;

FSM_STATE_OUTPUT: PROCESS (S)
BEGIN
  CASE S IS
    WHEN R0 =>
      line_load <= '1';
      line_err_sel <= '0';
      plot_sel <= '0';
      fill_y_update_en <= '1';
      fill_y_init <= '1';
      coord_sel <= 0;
      colour_sel <= 0;
      load_previous_coord <= '0';
    WHEN F0 =>
      line_load <= '0';
      line_err_sel <= '1';
      plot_sel <= '1';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 0;
      colour_sel <= 0;
      load_previous_coord <= '0';
    WHEN F1 =>
      line_load <= '0';
      line_err_sel <= '0';
      plot_sel <= '1';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 0;
      colour_sel <= 0;
      load_previous_coord <= '0';
    WHEN F2 =>
      line_load <= '1';
      line_err_sel <= '0';
      plot_sel <= '0';
      fill_y_update_en <= '1';
      fill_y_init <= '0';
      coord_sel <= 0;
      colour_sel <= 0;
      load_previous_coord <= '0';
    WHEN F3 =>
      line_load <= '0';
      line_err_sel <= '0';
      plot_sel <= '0';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 0;
      colour_sel <= 0;
      load_previous_coord <= '0';
	 WHEN L0 =>
      line_load <= '1';
      line_err_sel <= '0';
      plot_sel <= '0';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 1;
      colour_sel <= 1;
      load_previous_coord <= '0';
	WHEN L1 =>
      line_load <= '0';
      line_err_sel <= '1';
      plot_sel <= '1';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 1;
      colour_sel <= 1;
      load_previous_coord <= '1';
	WHEN L2 =>
      line_load <= '0';
      line_err_sel <= '0';
      plot_sel <= '1';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 1;
      colour_sel <= 1;
      load_previous_coord <= '0';
	WHEN L3 =>
      line_load <= '1';
      line_err_sel <= '0';
      plot_sel <= '0';
      fill_y_update_en <= '0';
      fill_y_init <= '0';
      coord_sel <= 2;
      colour_sel <= 1;
      load_previous_coord <= '0';
  END CASE;
END PROCESS;

DRAW_LINE: drawLine PORT MAP (
    x0_in => x0_int, x1_in => x1_int,
    y0_in => y0_int, y1_in => y1_int,
    load_coord => line_load, err_sel => line_err_sel, clock => clock, plot_sel => plot_sel, reset => reset,
    x_out => x_out,
    y_out => y_out,
    done => line_done, plot => plot
);


COMBINATION_XYIN_CONNECT: PROCESS (coord_sel, x_in, y_in, fill_y_count, x_in_previous, y_in_previous)
BEGIN
  CASE coord_sel IS
  WHEN 0 =>
      x0_int <= x"00";
      x1_int <= x"9F";
      y0_int <= STD_LOGIC_VECTOR(TO_UNSIGNED(fill_y_count, y0_int'length));
      y1_int <= STD_LOGIC_VECTOR(TO_UNSIGNED(fill_y_count, y1_int'length));
  WHEN 1 =>
      x0_int <= STD_LOGIC_VECTOR(TO_UNSIGNED(80, x0_int'length));
      x1_int <= x_in;
      y0_int <= STD_LOGIC_VECTOR(TO_UNSIGNED(60, y0_int'length));
      y1_int <= y_in;
  WHEN OTHERS =>  --Change this for the challenge task!
      x0_int <= x_in_previous;
      x1_int <= x_in;
      y0_int <= y_in_previous;
      y1_int <= y_in;
  END CASE;     
END PROCESS;

AUX_xyPrevious_REGISTERS: PROCESS (clock, reset)
BEGIN
  IF (reset = '1') THEN
    x_in_previous <= "01010000";
    y_in_previous <= "0111100";
  ELSIF rising_edge(clock) and load_previous_coord = '1' THEN
    x_in_previous <= x_in;
    y_in_previous <= y_in;
  END IF;
END PROCESS;

AUX_FILLCOUNT_REGISTER: PROCESS (clock, reset)
BEGIN
  IF reset ='1' THEN
	 fill_y_count <= 0;
    fill_colour_count <= "000";
  ELSIF (rising_edge(clock)) THEN
    IF fill_y_update_en = '1' THEN
      IF fill_y_init = '1' THEN
        fill_y_count <= 0;
        fill_colour_count <= "000";
      ELSE
        fill_y_count <= fill_y_count + 1;
        fill_colour_count <= fill_colour_count + "001";
      END IF;
    END IF;
  END IF;
END PROCESS; 

AUX_FILLCOUNT_OUTPUT: PROCESS (fill_y_count)
BEGIN
  IF fill_y_count > Y_LIM THEN
    fill_y_done <= '1';
  ELSE
    fill_y_done <= '0';
  END IF;
END PROCESS;

AUX_COLOUR_OUTPUT: PROCESS (colour_in, fill_colour_count, colour_sel)
BEGIN
    IF colour_sel = 0 and M = FILLCOLOUR THEN
      colour <= STD_LOGIC_VECTOR(fill_colour_count);
    ELSIF colour_sel = 0 THEN
      colour <= "000";
    ELSE
      colour <= colour_in;
    END IF;
END PROCESS;

END ARCHITECTURE;