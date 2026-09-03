library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matvec_engine_2x2_tb is
end entity;

architecture sim of matvec_engine_2x2_tb is

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';

  signal w00, w01, w10, w11 : signed(7 downto 0) := (others => '0');
  signal x0, x1             : signed(7 downto 0) := (others => '0');

  signal y0, y1 : signed(31 downto 0);
  signal done   : std_logic;

begin

  clk <= not clk after 5 ns;

  dut : entity work.matvec_engine_2x2
  port map(
    clk => clk,
    reset => reset,
    start => start,

    w00 => w00,
    w01 => w01,
    w10 => w10,
    w11 => w11,

    x0 => x0,
    x1 => x1,

    y0 => y0,
    y1 => y1,

    done => done
  );

end architecture;
    

