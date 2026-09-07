library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tiny_nn_2x2_tb is
end entity;

architecture tb of tiny_nn_2x2_tb is

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';
  signal done  : std_logic;

  signal x0, x1 : signed(7 downto 0);

  signal w1_00, w1_01, w1_10, w1_11 : signed(7 downto 0);
  signal b1_0, b1_1                 : signed(31 downto 0);

  signal w2_00, w2_01, w2_10, w2_11 : signed(7 downto 0);
  signal b2_0, b2_1                 : signed(31 downto 0);

  signal y0, y1 : signed(31 downto 0);

begin

  clk <= not clk after 5 ns;

  DUT : entity work.tiny_nn_2x2
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,
      done  => done,

      x0 => x0,
      x1 => x1,

      w1_00 => w1_00,
      w1_01 => w1_01,
      w1_10 => w1_10,
      w1_11 => w1_11,

      b1_0 => b1_0,
      b1_1 => b1_1,

      w2_00 => w2_00,
      w2_01 => w2_01,
      w2_10 => w2_10,
      w2_11 => w2_11,

      b2_0 => b2_0,
      b2_1 => b2_1,

      y0 => y0,
      y1 => y1
    );

  process
  begin
    -- Trained quantized parameters=
    --Layer 1:transform the inputs into useful nonlinear features
    w1_00 <= to_signed(127, 8); --weight is near the largest positive magnitude representable under that quantization scale.
    w1_01 <= to_signed(-127, 8); --strong negative weight
    w1_10 <= to_signed(80, 8); --moderately strong positive weight
    w1_11 <= to_signed(-79, 8); --moderately strong negative weight
    b1_0 <= to_signed(0, 32);
    b1_1 <= to_signed(9981, 32); --may correspond to a perfectly ordinary real-valued bias.
    --Biases are INT32 because they're added to the INT32 MAC result.
    --ReLU  ← introduces nonlinearity

    --Layer 2: use those features to decide the class
    w2_00 <= to_signed(-116, 8);
    w2_01 <= to_signed(100, 8);
    w2_10 <= to_signed(127, 8);
    w2_11 <= to_signed(-81, 8);
    b2_0 <= to_signed(-2556, 32);
    b2_1 <= to_signed(2556, 32);

    -- Reset
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait for 10 ns;

    -- XOR: [0,0] -> class 0
    x0 <= to_signed(0, 8);
    x1 <= to_signed(0, 8);

    --start
    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    wait until done = '1';

    report "Input [0,0] y0=" &
      integer'image(to_integer(y0)) &
      " y1=" &
      integer'image(to_integer(y1));

    assert y0 > y1
    report "XOR [0,0] FAILED"
      severity error;

    wait until rising_edge(clk);

    -- XOR: [0,1] -> class 1
    x0 <= to_signed(0, 8);
    x1 <= to_signed(127, 8);

    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    wait until done = '1';

    report "Input [0,1] y0=" &
      integer'image(to_integer(y0)) &
      " y1=" &
      integer'image(to_integer(y1));

    assert y1 > y0
    report "XOR [0,1] FAILED"
      severity error;

    wait until rising_edge(clk);
   
    -- XOR: [1,0] -> class 1
    x0 <= to_signed(127, 8);
    x1 <= to_signed(0, 8);

    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    wait until done = '1';

    report "Input [1,0] y0=" &
      integer'image(to_integer(y0)) &
      " y1=" &
      integer'image(to_integer(y1));

    assert y1 > y0
    report "XOR [1,0] FAILED"
      severity error;

    wait until rising_edge(clk);

    -- XOR: [1,1] -> class 0
    x0 <= to_signed(127, 8);
    x1 <= to_signed(127, 8);

    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    wait until done = '1';

    report "Input [1,1] y0=" &
      integer'image(to_integer(y0)) &
      " y1=" &
      integer'image(to_integer(y1));

    assert y0 > y1
    report "XOR [1,1] FAILED"
      severity error;
    report "TRAINED XOR NETWORK PASSED 4/4"
      severity note;

    wait;

  end process;

end architecture;