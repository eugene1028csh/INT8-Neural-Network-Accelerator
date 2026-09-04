library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tiny_nn_2x2_tb is
end entity;

architecture sim of tiny_nn_2x2_tb is
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';
  signal done  : std_logic := '0';

  --input
  signal x0 : signed(7 downto 0) := (others => '0');
  signal x1 : signed(7 downto 0) := (others => '0');

  --layer 1
  signal w1_00 : signed(7 downto 0)  := (others => '0');
  signal w1_01 : signed(7 downto 0)  := (others => '0');
  signal w1_10 : signed(7 downto 0)  := (others => '0');
  signal w1_11 : signed(7 downto 0)  := (others => '0');
  signal b1_0  : signed(31 downto 0) := (others => '0');
  signal b1_1  : signed(31 downto 0) := (others => '0');

  --layer 2
  signal w2_00 : signed(7 downto 0)  := (others => '0');
  signal w2_01 : signed(7 downto 0)  := (others => '0');
  signal w2_10 : signed(7 downto 0)  := (others => '0');
  signal w2_11 : signed(7 downto 0)  := (others => '0');
  signal b2_0  : signed(31 downto 0) := (others => '0');
  signal b2_1  : signed(31 downto 0) := (others => '0');

  --output
  signal y0 : signed(31 downto 0) := (others => '0');
  signal y1 : signed(31 downto 0) := (others => '0');

begin

  clk <= not clk after 5 ns;

  dut : entity work.tiny_nn_2x2
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,
      done  => done,
      x0    => x0,
      x1    => x1,
      w1_00 => w1_00,
      w1_01 => w1_01,
      w1_10 => w1_10,
      w1_11 => w1_11,
      b1_0  => b1_0,
      b1_1  => b1_1,
      w2_00 => w2_00,
      w2_01 => w2_01,
      w2_10 => w2_10,
      w2_11 => w2_11,
      b2_0  => b2_0,
      b2_1  => b2_1,
      y0    => y0,
      y1    => y1
    );

  stimulus : process
  begin
    --reset
    reset <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    reset <= '0';

    x0    <= to_signed(4, 8);
    x1    <= to_signed(4, 8);
    w1_00 <= to_signed(2, 8);
    w1_01 <= to_signed(2, 8);
    w1_10 <= to_signed(1, 8);
    w1_11 <= to_signed(3, 8);
    b1_0  <= to_signed(0, 32);
    b1_1  <= to_signed(0, 32);
    w2_00 <= to_signed(2, 8);
    w2_01 <= to_signed(1, 8);
    w2_10 <= to_signed(1, 8);
    w2_11 <= to_signed(2, 8);
    b2_0  <= to_signed(1, 32);
    b2_1  <= to_signed(-20, 32);

    --start
    start <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    start <= '0';

    wait until done = '1';
    wait for 1 ns;

    report "VHDL_OUTPUT y0=" & integer'image(to_integer(y0)) &
    -- integer'image(to_integer(y0)) converts the signed matrix output values, 
    -- into an integer and to a string in the report window, so python can verify from thr
      " y1 =" & integer'image(to_integer(y1))
      severity note;

    assert y0 = to_signed(13, 32)
    report "y0 incorrect"
      severity error;

    assert y1 = to_signed(0, 32)
    report "y1 incorrect"
      severity error;

    report " tiny nn 2x2 tb pass"
      severity note;

    wait;
  end process;
end architecture;
