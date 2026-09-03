library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bias_add_2_tb is
end entity;

architecture sim of bias_add_2_tb is
  signal data0 : signed(31 downto 0) := (others => '0');
  signal data1 : signed(31 downto 0) := (others => '0');
  signal bias0 : signed(31 downto 0) := (others => '0');
  signal bias1 : signed(31 downto 0) := (others => '0');
  signal out0  : signed(31 downto 0) := (others => '0');
  signal out1  : signed(31 downto 0) := (others => '0');

begin
  dut : entity work.bias_add_2
    port map
    (
      data0 => data0,
      data1 => data1,
      bias0 => bias0,
      bias1 => bias1,
      out0  => out0,
      out1  => out1
    );

  stimulus : process
  begin
    data0 <= to_signed(17, 32);
    data1 <= to_signed(39, 32);
    bias0 <= to_signed(-7, 32);
    bias1 <= to_signed(3, 32);

    wait for 1 ns;

    assert out0 = to_signed(10, 32)
    report "out0 incorrect"
      severity error;

    assert out1 = to_signed(42, 32)
    report "out1 incorrect"
      severity error;

    report "tb for bias_add_2 pass"
      severity note;

    wait;

  end process;
end architecture;