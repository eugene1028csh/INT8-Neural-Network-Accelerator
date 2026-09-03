library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matvec_engine_2x2 is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    start : in std_logic;

    --weights
    w00 : in signed(7 downto 0);
    w01 : in signed(7 downto 0);
    w10 : in signed(7 downto 0);
    w11 : in signed(7 downto 0);

    --input vector
    x0 : in signed(7 downto 0);
    x1 : in signed(7 downto 0);

    --output vector
    y0 : out signed(31 downto 0);
    y1 : out signed(31 downto 0);

    --status
    done : out std_logic

  );
end entity matvec_engine_2x2;

architecture rtl of matvec_engine_2x2 is
  signal w00_reg : signed(7 downto 0) := (others => '0');
  signal w01_reg : signed(7 downto 0) := (others => '0');
  signal w10_reg : signed(7 downto 0) := (others => '0');
  signal w11_reg : signed(7 downto 0) := (others => '0');
  signal x0_reg  : signed(7 downto 0) := (others => '0');
  signal x1_reg  : signed(7 downto 0) := (others => '0');

  --scheduler signals
  signal array_a_row0 : signed(7 downto 0) := (others => '0');
  signal array_a_row1 : signed(7 downto 0) := (others => '0');
  signal array_b_col0 : signed(7 downto 0) := (others => '0');
  signal array_b_col1 : signed(7 downto 0) := (others => '0');

  signal array_enable : std_logic := '0';
  signal array_reset : std_logic := '0';

  signal array_result00 : signed(31 downto 0);
  signal array_result10 : signed(31 downto 0);

begin
  matvec_units : entity work.pe_array_2x2
    port map
    (
    clk => clk,
    reset => array_reset,
    enable => array_enable,

    a_row0_in => array_a_row0,
    a_row1_in => array_a_row1,

    b_col0_in => array_b_col0,
    b_col1_in => array_b_col1,

    a_row0_out => open,
    a_row1_out => open,
    b_col0_out => open,
    b_col1_out => open,

    result00 => array_result00,
    result01 => open,
    result10 => array_result10,
    result11 => open
    );

end architecture;