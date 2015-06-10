-- Your Names:  Linqiao (James) Liu; Henry Hao Yan
-- Your Student Numbers: 39140116; 59057159
-- Your Lab Section:  L1B

--File Name: drawLine.vhd
--File Purpose: Data path for drawing one line between two arbitrary points.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY drawLine IS PORT (
x0_in, y0_in, x1_in, y1_in: IN STD_LOGIC_VECTOR (7 downto 0);
load_coord, err_sel, clock, plot_sel: IN STD_LOGIC;
x_out, y_out: OUT STD_LOGIC_VECTOR (7 downto 0);
done, plot: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behave OF drawLine IS
  -- Internal siganls
  -- Conv vales need to 8 downto 0, to take care of the sign bit
  SIGNAL x0_conv, y0_conv, x1_conv, y1_conv: UNSIGNED (8 downto 0);
  SIGNAL x0_int, y0_int, x1_int, y1_int: INTEGER;
  SIGNAL error, e2: INTEGER;
  SIGNAL sx, sy, x_int, y_int, dx, dy: INTEGER;
  SIGNAL correctX, correctY: BOOLEAN; 
  
  --Upper limit of x and y signal
  CONSTANT X_ULIM: UNSIGNED (7 downto 0) := x"9F"; --159
  CONSTANT y_ULIM: UNSIGNED (7 downto 0) := x"77"; --119
BEGIN
  --0. Keep the input coordinates inside bound
  BOUND: PROCESS(x0_in, y0_in, x1_in, y1_in)
  BEGIN
    IF (UNSIGNED(x0_in) < x"00") THEN x0_conv <= '0' & x"00";
      ELSIF (UNSIGNED(x0_in) > X_ULIM) THEN  x0_conv <= '0' & X_ULIM;
      ELSE x0_conv <= '0' & unsigned(x0_in);
    END IF;
    
    IF (UNSIGNED(x1_in) < x"00") THEN x1_conv <= '0' & x"00";
      ELSIF (UNSIGNED(x1_in) > X_ULIM) THEN  x1_conv <= '0' & X_ULIM;
      ELSE x1_conv <= '0' & unsigned(x1_in);
    END IF;
    
    IF (UNSIGNED(y0_in) < x"00") THEN y0_conv <= '0' & x"00";
      ELSIF (UNSIGNED(y0_in) > Y_ULIM) THEN  y0_conv <= '0' & Y_ULIM;
      ELSE y0_conv <= '0' & unsigned(y0_in);
    END IF;
    
    IF (UNSIGNED(y1_in) < x"00") THEN y1_conv <= '0' & x"00";
      ELSIF (UNSIGNED(y1_in) > Y_ULIM) THEN  y1_conv <= '0' & Y_ULIM;
      ELSE y1_conv <= '0' & unsigned(y1_in);
    END IF;
  END PROCESS;
  
  --1. Step 1 of line drawing loading in new coordinates and cacluated 
  --   necessary paramteres. Please activate load_coord signal.
  LOAD: PROCESS (clock)
  BEGIN
    IF rising_edge(clock) AND load_coord = '1' THEN
      x0_int <= to_integer(x0_conv);
      x1_int <= to_integer(x1_conv);
      y0_int <= to_integer(y0_conv);
      y1_int <= to_integer(y1_conv);
      -- Compute dx and sx
      CASE x1_conv > x0_conv IS
        WHEN TRUE => 
          dx <= to_integer(x1_conv) - to_integer(x0_conv);
          sx <= 1;
        WHEN OTHERS => 
          dx <= to_integer(x0_conv) - to_integer(x1_conv);
          sx <= -1;
      END CASE; 
       -- Compute dy
      CASE y1_conv > y0_conv IS
        WHEN TRUE => 
          dy <= to_integer(y1_conv) - to_integer(y0_conv);
          sy <= 1;
        WHEN OTHERS => 
          dy <= to_integer(y0_conv) - to_integer(y1_conv);
          sy <= -1;
      END CASE;
    END IF;
  END PROCESS;
  
  
  
-- Compute e2
  E_2: e2 <= error*2;
-- Compute correctX and correctY
  correctX <= -dy < e2;
  correctY <= dx > e2;
   
-- Compute error, x_int, and y_int. 
-- Proceeds on rising edge and plot_sel = ''1'
COMP_ERROR: PROCESS (clock)
VARIABLE err_int: INTEGER;
BEGIN
  IF rising_edge(clock) and plot_sel = '1' THEN
    IF (err_sel = '1') THEN
      error <= dx-dy;
      x_int <= x0_int;
      y_int <= y0_int;
    ELSE
      CASE correctX IS --e2 > -dy?
        WHEN TRUE => 
          err_int := error - dy;
          x_int <= x_int + sx;
        WHEN OTHERS => 
          err_int := error;
          x_int <= x_int;
      END CASE;
      
      CASE correctY IS  --e2 < dx?
        WHEN TRUE => 
          error <= err_int + dx;
          y_int <= y_int + sy;
        WHEN OTHERS => 
          error <= err_int;
          y_int <= y_int;
      END CASE;
    END IF;
  END IF;
END PROCESS;

-- Output signals
 plot <= plot_sel;
 PROCESS (x_int, y_int, x1_int, y1_int)
 BEGIN
   IF x_int >= x1_int AND y_int >= y1_int THEN
     done <= '1';
    ELSE
      done <= '0';
    END IF;
 END PROCESS;

 x_out <= std_logic_vector(to_unsigned(x_int, x_out'length));
 y_out <= std_logic_vector(to_unsigned(y_int, y_out'length));

END ARCHITECTURE;
