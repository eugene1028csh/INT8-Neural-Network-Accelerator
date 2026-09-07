library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity requantize_2_configurable_tb is
end entity;

architecture sim of requantize_2_configurable_tb is
  signal data0, data1 : signed(31 downto 0)  := (others => '0');
  signal multiplier   : signed(15 downto 0)  := (others => '0');
  signal shift_amount : unsigned(5 downto 0) := (others => '0');
  signal out0, out1   : signed(7 downto 0)   := (others => '0');
begin
  dut : entity work.requantize_2_configurable
    port map
    (
      data0        => data0,
      data1        => data1,
      multiplier   => multiplier,
      shift_amount => shift_amount,
      out0         => out0,
      out1         => out1
    );

  stimulus : process
  begin
    data0        <= to_signed(400, 32);
    data1        <= to_signed(1000, 32);
    multiplier   <= to_signed(414, 16);
    shift_amount <= to_unsigned(16, 6);

    wait for 1 ns;

    assert out0 = to_signed(3, 8)
    report "out0 incorrect"
      severity error;
    
    assert out1 = to_signed(6, 8)
    report "out0 incorrect"
      severity error;

    data0        <= to_signed(0, 32);
    data1        <= to_signed(9981, 32);
    multiplier   <= to_signed(414, 16);
    shift_amount <= to_unsigned(16, 6);

    wait for 1 ns;

    assert out0 = to_signed(0, 8)
    report "out0 incorrect"
      severity error;
    
    assert out1 = to_signed(63, 8)
    report "out0 incorrect"
      severity error;

    data0        <= to_signed(16129, 32);
    data1        <= to_signed(20141, 32);
    multiplier   <= to_signed(414, 16);
    shift_amount <= to_unsigned(16, 6);

    wait for 1 ns;

    assert out0 = to_signed(102, 8)
    report "out0 incorrect"
      severity error;
    
    assert out1 = to_signed(127, 8)
    report "out0 incorrect"
      severity error;
    
    data0        <= to_signed(0, 32);
    data1        <= to_signed(10108, 32);
    multiplier   <= to_signed(414, 16);
    shift_amount <= to_unsigned(16, 6);

    wait for 1 ns;

    assert out0 = to_signed(0, 8)
    report "out0 incorrect"
      severity error;
    
    assert out1 = to_signed(64, 8)
    report "out0 incorrect"
      severity error;

    data0        <= to_signed(20, 32);
    data1        <= to_signed(21, 32);
    multiplier   <= to_signed(1, 16);
    shift_amount <= to_unsigned(1, 6);

    wait for 1 ns;

    assert out0 = to_signed(10, 8)
    report "Config test out0 failed"
    severity error;

    assert out1 = to_signed(11, 8)
    report "Config test out1 failed"
    severity error;
        
    report "Configurable requantizer legacy-scale tests passed"
        severity note;

    wait;
  end process;

end architecture;