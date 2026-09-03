library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matmul_2x2_tb is
end entity;

architecture sim of matmul_2x2_tb is

  signal clk    : std_logic := '0';
  signal reset  : std_logic := '0';
  signal enable : std_logic := '0';

  signal a_row0_in : signed(7 downto 0) := (others => '0');
  signal a_row1_in : signed(7 downto 0) := (others => '0');

  signal b_col0_in : signed(7 downto 0) := (others => '0');
  signal b_col1_in : signed(7 downto 0) := (others => '0');

  signal a_row0_out : signed(7 downto 0);
  signal a_row1_out : signed(7 downto 0);

  signal b_col0_out : signed(7 downto 0);
  signal b_col1_out : signed(7 downto 0);

  signal result00 : signed(31 downto 0);
  signal result01 : signed(31 downto 0);
  signal result10 : signed(31 downto 0);
  signal result11 : signed(31 downto 0);

begin

  clk <= not clk after 5 ns;
  dut : entity work.pe_array_2x2
    port map
    (
      clk    => clk,
      reset  => reset,
      enable => enable,

      a_row0_in => a_row0_in,
      a_row1_in => a_row1_in,

      b_col0_in => b_col0_in,
      b_col1_in => b_col1_in,

      a_row0_out => a_row0_out,
      a_row1_out => a_row1_out,

      b_col0_out => b_col0_out,
      b_col1_out => b_col1_out,

      result00 => result00,
      result01 => result01,
      result10 => result10,
      result11 => result11
    );

  stimulus : process (all)
  begin
    reset  <= '1';
    enable <= '0';

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(0, 32)
    report "PE00 reset failed"
      severity error;

    assert result01 = to_signed(0, 32)
    report "PE01 reset failed"
      severity error;

    assert result10 = to_signed(0, 32)
    report "PE10 reset failed"
      severity error;

    assert result11 = to_signed(0, 32)
    report "PE11 reset failed"
      severity error;

    reset  <= '0';
    enable <= '1';

    --MatMul Clock 1
    a_row0_in <= to_signed(1, 8);
    a_row1_in <= to_signed(0, 8);
    b_col0_in <= to_signed(5, 8);
    b_col1_in <= to_signed(0, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(5, 32)
    report "Clock 1: PE00 incorrect"
      severity error;

    assert result01 = to_signed(0, 32)
    report "Clock 1: PE01 incorrect"
      severity error;

    assert result10 = to_signed(0, 32)
    report "Clock 1: PE10 incorrect"
      severity error;

    assert result11 = to_signed(0, 32)
    report "Clock 1: PE11 incorrect"
      severity error;

    --MatMul Clock 2
    a_row0_in <= to_signed(2, 8);
    a_row1_in <= to_signed(3, 8);
    b_col0_in <= to_signed(7, 8);
    b_col1_in <= to_signed(6, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(19, 32)
    report "Clock2: PE00 Incorrect"
      severity error;

    assert result01 = to_signed(6, 32)
    report "Clock2: PE01 Incorrect"
      severity error;

    assert result10 = to_signed(15, 32)
    report "Clock2: PE10 Incorrect"
      severity error;

    assert result11 = to_signed(0, 32)
    report "Clock2: PE11 Incorrect"
      severity error;

    --MatMul Clock 3
    a_row0_in <= to_signed(0, 8);
    a_row1_in <= to_signed(4, 8);
    b_col0_in <= to_signed(0, 8);
    b_col1_in <= to_signed(8, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(19, 32)
    report "Clock3: PE00 Incorrect"
      severity error;

    assert result01 = to_signed(22, 32)
    report "Clock3: PE01 Incorrect"
      severity error;

    assert result10 = to_signed(43, 32)
    report "Clock3: PE10 Incorrect"
      severity error;

    assert result11 = to_signed(18, 32)
    report "Clock3: PE11 Incorrect"
      severity error;

    --MatMul Clock 4
    a_row0_in <= to_signed(0, 8);
    a_row1_in <= to_signed(0, 8);

    b_col0_in <= to_signed(0, 8);
    b_col1_in <= to_signed(0, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(19, 32)
    report "Clock 4: PE00 incorrect"
      severity error;

    assert result01 = to_signed(22, 32)
    report "Clock 4: PE01 incorrect"
      severity error;

    assert result10 = to_signed(43, 32)
    report "Clock 4: PE10 incorrect"
      severity error;

    assert result11 = to_signed(50, 32)
    report "Clock 4: PE11 incorrect"
      severity error;

    report "2x2 matrix multiplication PASSED"
      severity note;

    wait;
  end process;
end architecture;