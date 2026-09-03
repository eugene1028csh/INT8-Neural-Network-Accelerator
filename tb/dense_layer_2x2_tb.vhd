library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dense_layer_2x2_tb is
end entity;

architecture sim of dense_layer_2x2_tb is
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';

  signal w00, w01 : signed(7 downto 0) := (others => '0');
  signal w10, w11 : signed(7 downto 0) := (others => '0');

  signal x0, x1 : signed(7 downto 0) := (others => '0');

  signal bias0, bias1 : signed(31 downto 0) := (others => '0');

  signal y0, y1 : signed(31 downto 0);

  signal done : std_logic;

begin

clk  <= not clk after 5 ns;

  dut : entity work.dense_layer_2x2
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,
      w00   => w00,
      w01   => w01,
      w10   => w10,
      w11   => w11,
      x0    => x0,
      x1    => x1,
      bias0 => bias0,
      bias1 => bias1,
      y0    => y0,
      y1    => y1,
      done  => done
    );

  stimulus : process

  begin
    --reset
    reset <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    reset <= '0';

    --inputs
    w00   <= to_signed(1, 8);
    w01   <= to_signed(2, 8);
    w10   <= to_signed(3, 8);
    w11   <= to_signed(4, 8);
    x0    <= to_signed(5, 8);
    x1    <= to_signed(6, 8);
    bias0 <= to_signed(-20, 32);
    bias1 <= to_signed(3, 32);

    -- Start operation
    start <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    start <= '0';
    
    --wait for dense layer to finish
    wait until done = '1';
    wait for 1 ns;

    assert y0 = to_signed(0, 32)
    report "y0 incorrect"
      severity error;

    assert y1 = to_signed(42, 32)
    report "y1 incorrect"
      severity error;

    report "dense_layer_2x2 tb pass"
      severity note;

    wait;
  end process;
end architecture;
