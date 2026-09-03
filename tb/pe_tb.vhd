library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_tb is
end entity pe_tb;

architecture sim of pe_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal enable : std_logic := '0';

  signal a_in : signed(7 downto 0) := (others => '0');
  signal b_in : signed(7 downto 0) := (others => '0');

  signal a_out : signed(7 downto 0);
  signal b_out : signed(7 downto 0);

  signal result : signed(31 downto 0);

begin
  clk <= not clk after 5 ns;

  dut : entity work.pe
    port map
    (
      clk => clk,
      reset => reset,
      enable => enable,
      a_in => a_in,
      b_in => b_in,
      a_out => a_out,
      b_out => b_out,
      result => result
    );

  stimulus : process
  begin
    --reset and asserts for failure report
    reset <= '1';
    enable <= '0';
    wait for 10 ns;
    reset <= '0';

    assert a_out = to_signed(0, 8)
    report "Reset failed: a_out"
      severity error;

    assert b_out = to_signed(0, 8)
    report "Reset failed: b_out"
      severity error;

    assert result = to_signed(0, 32)
    report "Reset failed: Result"
      severity error;

    --first PE test and asserts for failure report
    enable <= '1';
    a_in <= to_signed(3, 8);
    b_in <= to_signed(4, 8);
    wait for 10 ns;

    assert result = to_signed(12, 32)
    report "PE MAC test 1 failed"
      severity error;

    assert a_out = to_signed(3, 8)
    report "PE a forwarding failed"
      severity error;

    assert b_out = to_signed(4, 8)
    report "PE b forwarding failed"
      severity error;

    --signed values test
    a_in <= to_signed(3, 8);
    b_in <= to_signed(-5, 8);
    wait for 10 ns;

    assert result = to_signed(-3, 32)
    report "PE signed MAC test failed"
      severity error;

    assert a_out = to_signed(3, 8)
    report "PE signed a forwarding failed"
      severity error;

    assert b_out = to_signed(-5, 8)
    report "PE b forwarding test failed"
      severity error;

    --enable test and assert for failure reporting
    enable <= '0';
    a_in <= to_signed(100, 8);
    b_in <= to_signed(100, 8);
    wait for 10 ns;

    assert result = to_signed(-3, 32)
    report "PE result changed while disabled"
      severity error;

    assert a_out = to_signed(3, 8)
    report "PE a_out changed while disabled"
      severity error;

    assert b_out = to_signed(-5, 8)
    report "PE b_out changed while disabled"
      severity error;
    wait;
  end process;
end architecture;