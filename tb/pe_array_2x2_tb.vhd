library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_array_2x2_tb is
end entity pe_array_2x2_tb;

architecture sim of pe_array_2x2_tb is
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
      clk       => clk,
      reset     => reset,
      enable    => enable,
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

  stimulus : process
  begin
    --reset test
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
    
    reset <= '0';
    enable <= '1';

    --Cycle 1 and Asserts
    a_row0_in <= to_signed(2, 8);
    a_row1_in <= to_signed(7, 8);

    b_col0_in <= to_signed(3, 8);
    b_col1_in <= to_signed(11, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(6,32)
        report "PE00 Cycle 1 failed"
        severity error;
    
    assert result01 = to_signed(0, 32)
        report "PE01 calculated too early"
        severity error;
    
    assert result10 = to_signed(0, 32)
        report "PE10 calculated too early"
        severity error;
    
    assert result11 = to_signed(0,32)
        report "PE11 calculated too early"
        severity error;

    --Cycle 2
    a_row0_in <= to_signed(0, 8);
    a_row1_in <= to_signed(4, 8);

    b_col0_in <= to_signed(0, 8);
    b_col1_in <= to_signed(5, 8);

    wait until rising_edge(clk);
    wait for 1 ns;

    assert result00 = to_signed(6, 32)
        report "PE00 final result failed"
        severity error;

    assert result01 = to_signed(10, 32)
        report "PE01 final result failed"
        severity error;
    
    assert result10 = to_signed(12, 32)
        report "PE10 final result failed"
        severity error;
    
    assert result11 = to_signed(77, 32)
        report "PE11 final result failed"
        severity error;
    
    assert a_row0_out = to_signed(2, 8)
        report "Row 0 A propagation failed"
        severity error;
    
    assert a_row1_out = to_signed(7, 8)
        report "Row 1 A propagation failed"
        severity error;
    
    assert b_col0_out = to_signed(3, 8)
        report "Col 0 B propagation failed"
        severity error;

    assert b_col1_out = to_signed(11, 8)
        report "Col 1 B propagation failed"
        severity error;
    
    
    end process;
  end architecture;