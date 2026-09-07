library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matvec_engine_4x4_tb is
end entity;

architecture sim of matvec_engine_4x4_tb is

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';
  signal done  : std_logic;

  type row8_t is array (0 to 3) of signed(7 downto 0);
  type matrix8_t is array (0 to 3) of row8_t;

  signal w : matrix8_t;
  signal x : row8_t;

  type row32_t is array (0 to 3) of signed(31 downto 0);
  signal y : row32_t;

begin

  clk <= not clk after 5 ns;

  dut : entity work.matvec_engine_4x4
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,

      w00 => w(0)(0), w01 => w(0)(1), w02 => w(0)(2), w03 => w(0)(3),
      w10 => w(1)(0), w11 => w(1)(1), w12 => w(1)(2), w13 => w(1)(3),
      w20 => w(2)(0), w21 => w(2)(1), w22 => w(2)(2), w23 => w(2)(3),
      w30 => w(3)(0), w31 => w(3)(1), w32 => w(3)(2), w33 => w(3)(3),

      x0 => x(0),
      x1 => x(1),
      x2 => x(2),
      x3 => x(3),

      y0 => y(0),
      y1 => y(1),
      y2 => y(2),
      y3 => y(3),

      done => done
    );

  stimulus : process
  begin
    reset <= '1';
    start <= '0';

    wait until rising_edge(clk);
    wait until rising_edge(clk);

    reset <= '0';

    w <= (
      0 => (to_signed(1, 8), to_signed(2, 8), to_signed(3, 8), to_signed(4, 8)),
      1 => (to_signed(5, 8), to_signed(6, 8), to_signed(7, 8), to_signed(8, 8)),
      2 => (to_signed(9, 8), to_signed(10, 8), to_signed(11, 8), to_signed(12, 8)),
      3 => (to_signed(13, 8), to_signed(14, 8), to_signed(15, 8), to_signed(16, 8))
      );

    x <= (
      to_signed(1, 8),
      to_signed(2, 8),
      to_signed(3, 8),
      to_signed(4, 8)
      );

    wait until rising_edge(clk);

    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    wait until done = '1';
    wait for 1 ns;

    assert y(0) = to_signed(30, 32) severity error;
    assert y(1) = to_signed(70, 32) severity error;
    assert y(2) = to_signed(110, 32) severity error;
    assert y(3) = to_signed(150, 32) severity error;

    report "4x4 MatVec test passed" severity note;

    wait;
  end process;

end architecture;