library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_array_4x4_tb is
end entity pe_array_4x4_tb;

architecture sim of pe_array_4x4_tb is
  signal clk       : std_logic          := '0';
  signal reset     : std_logic          := '0';
  signal enable    : std_logic          := '0';
  signal a_row0_in : signed(7 downto 0) := (others => '0');
  signal a_row1_in : signed(7 downto 0) := (others => '0');
  signal a_row2_in : signed(7 downto 0) := (others => '0');
  signal a_row3_in : signed(7 downto 0) := (others => '0');

  signal b_col0_in : signed(7 downto 0) := (others => '0');
  signal b_col1_in : signed(7 downto 0) := (others => '0');
  signal b_col2_in : signed(7 downto 0) := (others => '0');
  signal b_col3_in : signed(7 downto 0) := (others => '0');

  signal a_row0_out : signed(7 downto 0);
  signal a_row1_out : signed(7 downto 0);
  signal a_row2_out : signed(7 downto 0);
  signal a_row3_out : signed(7 downto 0);

  signal b_col0_out : signed(7 downto 0);
  signal b_col1_out : signed(7 downto 0);
  signal b_col2_out : signed(7 downto 0);
  signal b_col3_out : signed(7 downto 0);

  type result_array_t is array (0 to 15) of signed(31 downto 0);
  signal results : result_array_t; --used in   for i in results'range loop

  type integer_array_t is array (0 to 15) of integer;

  constant expected_results : integer_array_t := (
  90, 100, 110, 120,
  202, 228, 254, 280,
  314, 356, 398, 440,
  426, 484, 542, 600
  );

begin
  clk <= not clk after 5 ns;
  dut : entity work.pe_array_4x4
    port map
    (
      clk    => clk,
      reset  => reset,
      enable => enable,

      a_row0_in => a_row0_in,
      a_row1_in => a_row1_in,
      a_row2_in => a_row2_in,
      a_row3_in => a_row3_in,

      b_col0_in => b_col0_in,
      b_col1_in => b_col1_in,
      b_col2_in => b_col2_in,
      b_col3_in => b_col3_in,

      a_row0_out => a_row0_out,
      a_row1_out => a_row1_out,
      a_row2_out => a_row2_out,
      a_row3_out => a_row3_out,

      b_col0_out => b_col0_out,
      b_col1_out => b_col1_out,
      b_col2_out => b_col2_out,
      b_col3_out => b_col3_out,

      result00 => results(0),
      result01 => results(1),
      result02 => results(2),
      result03 => results(3),

      result10 => results(4),
      result11 => results(5),
      result12 => results(6),
      result13 => results(7),

      result20 => results(8),
      result21 => results(9),
      result22 => results(10),
      result23 => results(11),

      result30 => results(12),
      result31 => results(13),
      result32 => results(14),
      result33 => results(15)
    );

  stimulus : process
    procedure drive_inputs(
      a0, a1, a2, a3 : integer;
      b0, b1, b2, b3 : integer
    ) is
    begin
      a_row0_in <= to_signed(a0, 8);
      a_row1_in <= to_signed(a1, 8);
      a_row2_in <= to_signed(a2, 8);
      a_row3_in <= to_signed(a3, 8);

      b_col0_in <= to_signed(b0, 8);
      b_col1_in <= to_signed(b1, 8);
      b_col2_in <= to_signed(b2, 8);
      b_col3_in <= to_signed(b3, 8);
    end procedure;
  begin
    --reset test
    reset  <= '1';
    enable <= '0';

    wait until rising_edge(clk);
    wait for 1 ns;

    wait until rising_edge(clk);
    wait for 1 ns;

    for i in results'range loop
      assert results(i) = to_signed(0, 32)
      report "PE reset failed at result index" & integer'image(i)
        severity error;
    end loop;

    report "reset test passed"
      severity note;

    --release reset n run matrix multiplication
    reset  <= '0';
    enable <= '1';

    -- Cycle 1
    drive_inputs(
    1, 0, 0, 0,
    1, 0, 0, 0
    );
    wait until rising_edge(clk);

    -- Cycle 2
    drive_inputs(
    2, 5, 0, 0,
    5, 2, 0, 0
    );
    wait until rising_edge(clk);

    -- Cycle 3
    drive_inputs(3, 6, 9, 0,
    9, 6, 3, 0);
    wait until rising_edge(clk);

    -- Cycle 4
    drive_inputs(4, 7, 10, 13,
    13, 10, 7, 4);
    wait until rising_edge(clk);

    -- Cycle 5
    drive_inputs(0, 8, 11, 14,
    0, 14, 11, 8);
    wait until rising_edge(clk);

    -- Cycle 6
    drive_inputs(0, 0, 12, 15,
    0, 0, 15, 12);
    wait until rising_edge(clk);

    -- Cycle 7
    drive_inputs(0, 0, 0, 16,
    0, 0, 0, 16);
    wait until rising_edge(clk);

    -- Cycle 8: drain
    drive_inputs(0, 0, 0, 0,
    0, 0, 0, 0);
    wait until rising_edge(clk);

    -- Cycle 9: drain
    drive_inputs(0, 0, 0, 0,
    0, 0, 0, 0);
    wait until rising_edge(clk);

    -- Cycle 10: drain
    drive_inputs(0, 0, 0, 0,
    0, 0, 0, 0);
    wait until rising_edge(clk);

    wait for 1 ns;

    for i in results'range loop
      assert results(i) = to_signed(expected_results(i), 32)
      report "Matrix multiplication failed at result index " &
        integer'image(i) &
        ". Got " & integer'image(to_integer(results(i))) &
        ", expected " & integer'image(expected_results(i))
        severity error;
    end loop;

    report "4x4 matrix multiplication test passed" severity note;

    wait;

    wait;

  end process;
end architecture;