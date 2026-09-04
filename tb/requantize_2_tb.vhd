library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity requantize_2_tb is
end entity;

architecture sim of requantize_2_tb is
  signal data0 : signed(31 downto 0) := (others => '0');
  signal data1 : signed(31 downto 0) := (others => '0');
  signal out0  : signed(7 downto 0)  := (others => '0');
  signal out1  : signed(7 downto 0)  := (others => '0');
begin
  dut : entity work.requantize_2
    port map
    (
      data0 => data0,
      data1 => data1,
      out0  => out0,
      out1  => out1
    );

  stimulus : process
  begin

    data0 <= to_signed(400, 32);
    data1 <= to_signed(1000, 32);

    wait for 1 ns;

    assert out0 = to_signed(100, 8)
    report "out0 incorrect"
      severity error;

    assert out1 = to_signed(127, 8)
    report "out1 incorrect"
      severity error;

    data0 <= to_signed(-800, 32);

    wait for 1 ns;
    --propagation delay because its combinational
    assert out0 = to_signed(-128, 8)
    report "out0 low incorrect"
      severity error;

    report "requantize_2 tb pass"
      severity note;

    wait;
  end process;
end architecture;