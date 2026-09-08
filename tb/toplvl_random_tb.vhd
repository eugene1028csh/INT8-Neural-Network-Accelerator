library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all; --imported uniform() from here, used in random number generation
entity toplvl_random_tb is
end entity;

architecture sim of toplvl_random_tb is
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

  type int_vec4_t is array (0 to 3) of integer;
  type int_mat4_t is array (0 to 3) of int_vec4_t;

  type out_vec_t is array (0 to 3) of signed(31 downto 0);
  signal outputs : out_vec_t;

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

      out0 => outputs(0),
      out1 => outputs(1),
      out2 => outputs(2),
      out3 => outputs(3)
    );

  stimulus : process
    variable seed1 : positive := 1; --starting values for the pseudorandom generator
    variable seed2 : positive := 2; --starting values for the pseudorandom generator
    --positive is a VHDL integer subtype that only allows values greater than 0, which is what uniform() expects for its seeds.
    --seed1 and seed2 are the generator's internal starting stats
    variable rand      : real; --stores the random decimal number from uniform()
    variable rand_w    : int_mat4_t; --rand_w(row)(col) => holds the randomly generated 4×4 weight matrix
    variable rand_x    : int_vec4_t; --rand_x(i)  =>  holds the 4 random inputs
    variable rand_bias : int_vec4_t; --rand_bias(i)  => holds the 4 random biases
    variable expected  : int_vec4_t; --will hold the mathematically expected accelerator outputs
  begin
    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    reset <= '0';

    for test_num in 1 to 100 loop

      --random generator for weights
      for row in 0 to 3 loop
        for col in 0 to 3 loop
          uniform(seed1, seed2, rand);
          --use seed1 and seed2 to generate the next pseudorandom real number, 
          --store it in rand, and update the seeds for the next call.
          rand_w(row)(col) :=
          integer(floor(rand * 17.0)) - 8;
        end loop;
      end loop;

      --random g for inputs
      for i in 0 to 3 loop
        uniform(seed1, seed2, rand);
        rand_x(i) :=
        integer(floor(rand * 17.0)) - 8;
      end loop;

      --random g for bias
      for i in 0 to 3 loop
        uniform(seed1, seed2, rand);
        rand_bias(i) :=
        integer(floor(rand * 101.0)) - 50;
      end loop;

      for row in 0 to 3 loop
        expected(row) := rand_bias(row);
        for col in 0 to 3 loop
          expected(row) :=
          expected(row) + rand_w(row)(col) * rand_x(col);
        end loop;
        --RelU
        if expected(row) < 0 then
          expected(row) := 0;
        end if;
      end loop;

      input_write_en <= '1';
      for i in 0 to 3 loop
        input_write_addr <= to_unsigned(i, 2);
        input_write_data <= to_signed(rand_x(i), 8);
        wait until rising_edge(clk);
      end loop;
      input_write_en <= '0';

      weight_write_en <= '1';
      for row in 0 to 3 loop
        for col in 0 to 3 loop
          weight_write_addr <= to_unsigned(row * 4 + col, 4);
          weight_write_data <= to_signed(rand_w(row)(col), 8);
          wait until rising_edge(clk);
        end loop;
      end loop;
      weight_write_en <= '0';

      bias_write_en <= '1';
      for i in 0 to 3 loop
        bias_write_addr <= to_unsigned(i, 2);
        bias_write_data <= to_signed(rand_bias(i), 32);
        wait until rising_edge(clk);
      end loop;
      bias_write_en <= '0';

      --start
      start <= '1';
      wait until rising_edge(clk);
      start <= '0';

      wait until done = '1';
      wait for 1 ns;

      --checking responses
      for i in 0 to 3 loop
        assert outputs(i) = to_signed(expected(i), 32) --Is hardware output i equal to expected output i?
        report "Random test " &
          integer'image(test_num) &
          " failed at output " &
          integer'image(i) & --print which output failed
          ". Got " &
          integer'image(to_integer(outputs(i))) & --print actual value
          ", expected " &
          integer'image(expected(i)) --print expected value
          -- eg. Random test failed at output 2. Got 113, expected 115
          severity failure;
      end loop;
    end loop;

    report "100 randomized accelerator tests passed"
      severity note;

    wait;
  end process;
end architecture;