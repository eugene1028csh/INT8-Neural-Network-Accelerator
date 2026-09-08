library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplvl_tb is
end entity;

architecture sim of toplvl_tb is
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';

  signal input_write_en   : std_logic            := '0';
  signal input_write_addr : unsigned(1 downto 0) := (others => '0');
  signal input_write_data : signed(7 downto 0)   := (others => '0');

  signal weight_write_en   : std_logic            := '0';
  signal weight_write_addr : unsigned(3 downto 0) := (others => '0');
  signal weight_write_data : signed(7 downto 0)   := (others => '0');

  signal bias_write_en   : std_logic            := '0';
  signal bias_write_addr : unsigned(1 downto 0) := (others => '0');
  signal bias_write_data : signed(31 downto 0)  := (others => '0');

  signal start : std_logic := '0';
  signal done  : std_logic;

  signal out0, out1, out2, out3 : signed(31 downto 0);

begin

  clk <= not clk after 5 ns;

  dut : entity work.toplvl
    port map
    (
      clk   => clk,
      reset => reset,

      input_write_en   => input_write_en,
      input_write_addr => input_write_addr,
      input_write_data => input_write_data,

      weight_write_en   => weight_write_en,
      weight_write_addr => weight_write_addr,
      weight_write_data => weight_write_data,

      bias_write_en   => bias_write_en,
      bias_write_addr => bias_write_addr,
      bias_write_data => bias_write_data,

      start => start,
      done  => done,

      out0 => out0,
      out1 => out1,
      out2 => out2,
      out3 => out3
    );

  stimulus : process
  begin

    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    reset <= '0';

    input_write_en <= '1';

    for i in 0 to 3 loop
      input_write_addr <= to_unsigned(i, 2);
      input_write_data <= to_signed(i + 1, 8);
      wait until rising_edge(clk);
    end loop;

    input_write_en <= '0';

    weight_write_en <= '1';

    for i in 0 to 15 loop
      weight_write_addr <= to_unsigned(i, 4);
      weight_write_data <= to_signed(i + 1, 8);
      wait until rising_edge(clk);
    end loop;

    weight_write_en <= '0';

    bias_write_en <= '1';

    bias_write_addr <= "00";
    bias_write_data <= to_signed(-40, 32);
    wait until rising_edge(clk);

    bias_write_addr <= "01";
    bias_write_data <= to_signed(-60, 32);
    wait until rising_edge(clk);

    bias_write_addr <= "10";
    bias_write_data <= to_signed(5, 32);
    wait until rising_edge(clk);

    bias_write_addr <= "11";
    bias_write_data <= to_signed(-200, 32);
    wait until rising_edge(clk);

    bias_write_en <= '0';

    -- run accelerator
    start <= '1';
    wait until rising_edge(clk);
    start <= '0';
    wait until done = '1';
    wait for 1 ns;

    assert out0 = to_signed(0, 32)
    report "out0 incorrect" severity error;

    assert out1 = to_signed(10, 32)
    report "out1 incorrect" severity error;

    assert out2 = to_signed(115, 32)
    report "out2 incorrect" severity error;

    assert out3 = to_signed(0, 32)
    report "out3 incorrect" severity error;

    report "FULL 4x4 NN accelerator test passed" severity note;

    wait;

  end process;

end architecture;