library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bias_buffer_4_tb is
end entity;

architecture sim of bias_buffer_4_tb is
  signal clk                        : std_logic            := '0';
  signal reset                      : std_logic            := '0';
  signal write_en                   : std_logic            := '0';
  signal write_addr                 : unsigned(1 downto 0) := (others => '0');
  signal write_data                 : signed(31 downto 0)  := (others => '0');
  signal bias0, bias1, bias2, bias3 : signed(31 downto 0);
begin
  clk <= not clk after 5 ns;
  dut : entity work.bias_buffer_4
    port map
    (
      clk        => clk,
      reset      => reset,
      write_en   => write_en,
      write_addr => write_addr,
      write_data => write_data,
      bias0      => bias0,
      bias1      => bias1,
      bias2      => bias2,
      bias3      => bias3
    );
  stimulus : process
  begin
    --reset
    reset <= '1';
    wait until rising_edge(clk);
    reset    <= '0';
    write_en <= '1';

    --write 1000 to bias0
    write_addr <= "00";
    write_data <= to_signed(1000, 32);
    wait until rising_edge(clk);

    --write -250 to bias1
    write_addr <= "01";
    write_data <= to_signed(-250, 32);
    wait until rising_edge(clk);

    --write 10 to bias2
    write_addr <= "10";
    write_data <= to_signed(10, 32);
    wait until rising_edge(clk);

    --write -12456 to bias3
    write_addr <= "11";
    write_data <= to_signed(-12456, 32);
    wait until rising_edge(clk);

    write_en <= '0';
    wait for 1 ns;

    assert bias0 = to_signed(1000, 32) severity error;
    assert bias1 = to_signed(-250, 32) severity error;
    assert bias2 = to_signed(10, 32) severity error;
    assert bias3 = to_signed(-12456, 32) severity error;

    report "bias buffer tb passed" severity note;

    wait;

  end process;
end architecture;