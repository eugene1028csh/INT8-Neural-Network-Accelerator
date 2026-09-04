library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity requantize_2 is
  port (
    data0, data1 : in signed(31 downto 0);
    out0, out1   : out signed(7 downto 0)
  );
end entity;

architecture rtl of requantize_2 is
begin
  process (all)
    variable scaled0 : signed(31 downto 0);
    variable scaled1 : signed(31 downto 0);
  begin

    scaled0 := SHIFT_RIGHT(data0, 2);
    scaled1 := SHIFT_RIGHT(data1, 2);

    if scaled0 > to_signed(127, 32) then
        out0 <= to_signed(127, 8);
    elsif scaled0 < to_signed(-128,32) then
        out0 <= to_signed(-128,8);
    else
        out0 <= resize(scaled0,8);
    end if;


    if scaled1 > to_signed(127, 32) then
        out1 <= to_signed(127, 8);
    elsif scaled1 < to_signed(-128,32) then
        out1 <= to_signed(-128,8);
    else
        out1 <= resize(scaled1,8);
    end if;

    end process;

  end architecture;