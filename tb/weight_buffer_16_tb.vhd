library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity weight_buffer_16_tb is
end entity;

architecture sim of weight_buffer_16_tb is
  signal clk                : std_logic            := '0';
  signal reset              : std_logic            := '0';
  signal write_en           : std_logic            := '0';
  signal write_addr         : unsigned(3 downto 0) := (others => '0');
  signal write_data         : signed(7 downto 0)   := (others => '0');
  signal w00, w11, w22, w33 : signed(7 downto 0);

begin
  clk <= not clk after 5 ns;
  dut : entity work.weight_buffer_16
    port map
    (
      clk        => clk,
      reset      => reset,
      write_en   => write_en,
      write_addr => write_addr,
      write_data => write_data,
      w00        => w00,
      w11        => w11,
      w22        => w22,
      w33        => w33,
      w01 => open,
      w02 => open,
      w03 => open,
      w10 => open,
      w12 => open,
      w13 => open,
      w20 => open,
      w21 => open,
      w23 => open,
      w30 => open,
      w31 => open,
      w32 => open
    );
  stimulus : process
  begin
    --reset
    reset <= '1';
    wait until rising_edge(clk);
    reset <= '0';

    -- write 12 to w00
    write_en   <= '1';
    write_addr <= "0000"; --store 12 into buffer location 0
    write_data <= to_signed(12, 8);
    wait until rising_edge(clk);

    -- write -7 to w11
    write_addr <= "0101"; --store -7 into buffer location 5
    write_data <= to_signed(-7, 8);
    wait until rising_edge(clk);

    -- write 25 to w22
    write_addr <= "1010"; --store 25 into buffer location 10
    write_data <= to_signed(25, 8);
    wait until rising_edge(clk);

    -- write 3 to w33
    write_addr <= "1111"; --store 3 into buffer location 15
    write_data <= to_signed(3, 8);
    wait until rising_edge(clk);

    write_en <= '0';
    wait for 1 ns;

    assert w00 = to_signed(12,8) severity error;
    assert w11 = to_signed(-7,8) severity error;
    assert w22 = to_signed(25,8) severity error;
    assert w33 = to_signed(3,8) severity error;

    report "weight buffer tb passed" severity note;

    wait;

  end process;

end architecture;