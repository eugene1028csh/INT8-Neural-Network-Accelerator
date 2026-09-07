library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matmul_engine_4x4_tb is
end entity;

architecture sim of matmul_engine_4x4_tb is

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';
  signal done  : std_logic;

  type row8_t is array (0 to 3) of signed(7 downto 0);
  type matrix8_t is array (0 to 3) of row8_t;

  type row32_t is array (0 to 3) of signed(31 downto 0);
  type matrix32_t is array (0 to 3) of row32_t;

  signal a : matrix8_t;
  signal b : matrix8_t;
  signal c : matrix32_t;

  type int_row_t is array (0 to 3) of integer;
  type int_matrix_t is array (0 to 3) of int_row_t;

  constant expected_c : int_matrix_t := (
  0 => (90, 100, 110, 120),
  1 => (202, 228, 254, 280),
  2 => (314, 356, 398, 440),
  3 => (426, 484, 542, 600)
  );

begin

  clk <= not clk after 5 ns;

  dut : entity work.matmul_engine_4x4
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,

      a00 => a(0)(0),
      a01 => a(0)(1),
      a02 => a(0)(2),
      a03 => a(0)(3),

      a10 => a(1)(0),
      a11 => a(1)(1),
      a12 => a(1)(2),
      a13 => a(1)(3),

      a20 => a(2)(0),
      a21 => a(2)(1),
      a22 => a(2)(2),
      a23 => a(2)(3),

      a30 => a(3)(0),
      a31 => a(3)(1),
      a32 => a(3)(2),
      a33 => a(3)(3),

      b00 => b(0)(0),
      b01 => b(0)(1),
      b02 => b(0)(2),
      b03 => b(0)(3),

      b10 => b(1)(0),
      b11 => b(1)(1),
      b12 => b(1)(2),
      b13 => b(1)(3),

      b20 => b(2)(0),
      b21 => b(2)(1),
      b22 => b(2)(2),
      b23 => b(2)(3),

      b30 => b(3)(0),
      b31 => b(3)(1),
      b32 => b(3)(2),
      b33 => b(3)(3),

      c00 => c(0)(0),
      c01 => c(0)(1),
      c02 => c(0)(2),
      c03 => c(0)(3),

      c10 => c(1)(0),
      c11 => c(1)(1),
      c12 => c(1)(2),
      c13 => c(1)(3),

      c20 => c(2)(0),
      c21 => c(2)(1),
      c22 => c(2)(2),
      c23 => c(2)(3),

      c30 => c(3)(0),
      c31 => c(3)(1),
      c32 => c(3)(2),
      c33 => c(3)(3),

      done => done
    );

  stimulus : process
  begin
    -- Reset
    reset <= '1';
    start <= '0';

    wait until rising_edge(clk);
    wait until rising_edge(clk);

    reset <= '0';

    -- Load Matrix A
    a <= (
      0 => (to_signed(1, 8), to_signed(2, 8), to_signed(3, 8), to_signed(4, 8)),
      1 => (to_signed(5, 8), to_signed(6, 8), to_signed(7, 8), to_signed(8, 8)),
      2 => (to_signed(9, 8), to_signed(10, 8), to_signed(11, 8), to_signed(12, 8)),
      3 => (to_signed(13, 8), to_signed(14, 8), to_signed(15, 8), to_signed(16, 8))
      );

    -- Same Matrix for B
    b <= (
      0 => (to_signed(1, 8), to_signed(2, 8), to_signed(3, 8), to_signed(4, 8)),
      1 => (to_signed(5, 8), to_signed(6, 8), to_signed(7, 8), to_signed(8, 8)),
      2 => (to_signed(9, 8), to_signed(10, 8), to_signed(11, 8), to_signed(12, 8)),
      3 => (to_signed(13, 8), to_signed(14, 8), to_signed(15, 8), to_signed(16, 8))
      );

    -- Give inputs time to settle
    wait until rising_edge(clk);

    -- Pulse start for one clock
    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    -- Engine now runs by itself
    wait until done = '1';
    wait for 1 ns;

    report "4x4 automatic MatMul finished" severity note;


    for row in 0 to 3 loop
      for col in 0 to 3 loop

        assert c(row)(col) = to_signed(expected_c(row)(col), 32)
        report "Wrong result at row " &
          integer'image(row) &
          ", col " &
          integer'image(col) &
          ". Got " &
          integer'image(to_integer(c(row)(col))) &
          ", expected " &
          integer'image(expected_c(row)(col))
          severity error;

      end loop;
    end loop;

    report "4x4 automatic MatMul test passed" severity note;

  end process;
end architecture;