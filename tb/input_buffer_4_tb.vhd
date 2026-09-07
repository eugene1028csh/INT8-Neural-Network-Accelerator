library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer_4_tb is
end entity;

architecture sim of input_buffer_4_tb is

  signal clk        : std_logic            := '0';
  signal reset      : std_logic            := '0';
  signal write_en   : std_logic            := '0';
  signal write_addr : unsigned(1 downto 0) := (others => '0');
  signal write_data : signed(7 downto 0)   := (others => '0');

  signal x0, x1, x2, x3 : signed(7 downto 0);

begin

  clk <= not clk after 5 ns;

  dut : entity work.input_buffer_4
    port map
    (
      clk        => clk,
      reset      => reset,
      write_en   => write_en,
      write_addr => write_addr,
      write_data => write_data,
      x0         => x0,
      x1         => x1,
      x2         => x2,
      x3         => x3
    );

  stimulus : process
  begin
    --reset
    reset <= '1';
    wait until rising_edge(clk);
    reset <= '0';

    --write 12 into x0
    write_en   <= '1';
    write_addr <= "00";
    write_data <= to_signed(12, 8);
    wait until rising_edge(clk);

    --write -7 into x1
    write_en   <= '1';
    write_addr <= "01";
    write_data <= to_signed(-7, 8);
    wait until rising_edge(clk);

    -- write 25 into x2
    write_addr <= "10";
    write_data <= to_signed(25, 8);
    wait until rising_edge(clk);

    -- write 3 into x3
    write_addr <= "11";
    write_data <= to_signed(3, 8);
    wait until rising_edge(clk);

    write_en <= '0';
    wait for 1 ns;

    assert x0 = to_signed(12, 8) severity error;
    assert x1 = to_signed(-7, 8) severity error;
    assert x2 = to_signed(25, 8) severity error;
    assert x3 = to_signed(3, 8) severity error;

    report "input buffer test passed" severity note;

    wait;
  end process;
end architecture;