library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_tb is
end entity mac_tb;

architecture sim of mac_tb is
  signal clk    : std_logic := '0';
  signal reset  : std_logic := '0';
  signal enable : std_logic := '0';

  signal a : signed(7 downto 0) := (others => '0');
  signal b : signed(7 downto 0) := (others => '0');

  signal result : signed(31 downto 0);

begin
  clk <= not clk after 5 ns;
  --instantiation
  -- clk => clk
  -- means MAC's clk port connect to tb clk signal
  dut : entity work.mac
    port map
    (
      clk    => clk,
      reset  => reset,
      enable => enable,
      a      => a,
      b      => b,
      result => result
    );

  --tests go here
  stimulus : process
  begin
    --reset
    reset  <= '1';
    enable <= '0';
      wait for 10 ns;
    -- because reset only happens when reset '1' and rising edge clk, so we need to levae reset '1' long enough

    reset  <= '0';
    enable <= '1';

    --expected result = 0

    --first stimulus
    a <= to_signed(3, 8);
    -- convert integer 3 to 8-bit signed VHDL value
    b <= to_signed(4, 8);
    --convert integer 4 to 8-bit signed VHDL value
    wait for 10 ns;
    assert result = to_signed(12,32)
        report "MAC test 1 failed"
        severity error;
    --expected result = 12

    --second stimulus
    a <= to_signed(2, 8);
    b <= to_signed(5, 8);
    wait for 10 ns;
    assert result = to_signed(22,32)
        report "MAC test 2 failed"
        severity error;
    --expected result = 22

    --negative stimulus test
    a <= to_signed(-5, 8);
    b <= to_signed(3, 8);
    wait for 10 ns;
    assert result = to_signed(7, 32)
        report "Signed MAC test failed"
        severity error;
    --expected result = 7

    --disable MAC
    enable <= '0';
    wait for 10 ns;
    assert result = to_signed(7, 32)
        report "MAC enable hold test failed"
        severity error;

    --expected result = 7
    wait;
  end process;
end architecture;