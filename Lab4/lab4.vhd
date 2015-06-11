library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4 is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic);
end lab4;

architecture rtl of lab4 is

 --Component from the Verilog file: vga_adapter.v

  component vga_adapter
    generic(RESOLUTION : string);
    port (resetn                                       : in  std_logic;
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  end component;

  COMPONENT Circuit IS PORT (
    x_in: IN STD_LOGIC_VECTOR (7 downto 0);
    y_in: IN STD_LOGIC_VECTOR (6 downto 0);
    colour_in: IN STD_LOGIC_VECTOR (2 downto 0);
    clock, reset, move: IN STD_LOGIC;
    x_out: OUT STD_LOGIC_VECTOR (7 downto 0);
    y_out: OUT STD_LOGIC_VECTOR (6 downto 0);
    plot: OUT STD_LOGIC;
    colour: OUT STD_LOGIC_VECTOR (2 downto 0) );
  END COMPONENT;

  signal x      : std_logic_vector(7 downto 0);
  signal y      : std_logic_vector(6 downto 0);
  signal colour : std_logic_vector(2 downto 0);
  signal plot   : std_logic;
  signal reset_int, move_int: std_logic;
  

begin

  -- includes the vga adapter, which should be in your project 

  reset_int <= not key(3);
  move_int <= not key(0);
  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour,
             x         => x,
             y         => y,
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);
  -- rest of your code goes here, as well as possibly additional files

 circ: CIRCUIT PORT MAP (
    x_in => SW(17 downto 10),
    y_in => SW(9 downto 3),
    colour_in => SW(2 downto 0),
    clock => CLOCK_50, reset => reset_int, move => move_int,
    x_out => x, y_out => y,
    plot => plot,
    colour => colour
 );
end RTL;


