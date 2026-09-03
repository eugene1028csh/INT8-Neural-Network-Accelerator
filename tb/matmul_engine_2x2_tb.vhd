library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matmul_engine_2x2_tb is
end entity;

architecture sim of matmul_engine_2x2_tb is
  signal clk    : std_logic := '0';
  signal reset  : std_logic := '0';
  signal start : std_logic := '0';

  signal a00, a01, a10, a11 : signed(7 downto 0) := (others => '0');
  signal b00, b01, b10, b11 : signed(7 downto 0) := (others => '0');

  signal c00, c01, c10, c11 : signed(31 downto 0) := (others => '0');

  signal done : std_logic;

begin
  clk <= not clk after 5 ns;

  dut : entity work.matmul_engine_2x2
    port map
    (
      clk   => clk,
      reset => reset,
      start => start,

      a00 => a00,
      a01 => a01,
      a10 => a10,
      a11 => a11,

      b00 => b00,
      b01 => b01,
      b10 => b10,
      b11 => b11,

      c00 => c00,
      c01 => c01,
      c10 => c10,
      c11 => c11,

      done => done
    );

  stimulus : process
  begin

    reset <= '1';

    wait until rising_edge(clk);
    wait for 1 ns;
    
    reset <= '0';

    a00 <= to_signed(1, 8);
    a01 <= to_signed(2, 8);
    a10 <= to_signed(3, 8);
    a11 <= to_signed(4, 8);

    b00 <= to_signed(5,8);
    b01 <= to_signed(6,8);
    b10 <= to_signed(7,8);
    b11 <= to_signed(8,8);

    start <= '1';

    wait until rising_edge(clk);
    wait for 1 ns;
    --captures A/B into a and b registers
    --move from S_IDLE to S_CLEAR

    start <= '0';

    assert c00 = to_signed(19, 32)
        report "c00 incorrect"
        severity error;
    
    assert c01 = to_signed(22, 32)
        report "c01 incorrect"
        severity error;

    assert c10 = to_signed(43, 32)
        report "c10 incorrect"
        severity error;

    assert c11 = to_signed(50, 32)
        report "c11 incorrect"
        severity error;

    report "MatMul Engine Passed"
        severity note;
    
    wait;

  end process;

end architecture;