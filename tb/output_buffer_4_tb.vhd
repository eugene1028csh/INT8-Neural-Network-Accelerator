library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_buffer_4_tb is
end entity;

architecture sim of output_buffer_4_tb is
  signal clk                        : std_logic := '0';
  signal reset                      : std_logic := '0';
  signal capture_en                 : std_logic := '0';
  signal data0, data1, data2, data3 : signed(31 downto 0);
  signal out0, out1, out2, out3     : signed(31 downto 0);
begin
  clk <= not clk after 5 ns;
  dut : entity work.output_buffer_4
    port map
    (
      clk        => clk,
      reset      => reset,
      capture_en   => capture_en,
      data0      => data0,
      data1      => data1,
      data2      => data2,
      data3      => data3,
      out0 => out0,
      out1 => out1,
      out2 => out2,
      out3 => out3
    );
    stimulus : process 
    begin
    -- reset
    reset <= '1';
    wait until rising_edge(clk);
    reset <= '0';

    data0 <= to_signed(17,32);
    data1 <= to_signed(-200,32);
    data2 <= to_signed(6767,32);
    data3 <= to_signed(-7676,32);

    capture_en <= '1';
    wait until rising_edge(clk);
    capture_en <= '0';
    wait for 1 ns;

    assert out0 = to_signed(17,32) severity error;
    assert out1 = to_signed(-200,32) severity error;
    assert out2 = to_signed(6767,32) severity error;
    assert out3 = to_signed(-7676,32) severity error;

    report "output buffer tb passed" severity note;

    wait;

    end process;
end architecture;