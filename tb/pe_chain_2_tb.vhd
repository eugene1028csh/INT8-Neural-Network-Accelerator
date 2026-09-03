library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_chain_2_tb is
end entity pe_chain_2_tb;

architecture sim of pe_chain_2_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal a_in : signed(7 downto 0) := (others => '0');
    signal b_in : signed(7 downto 0) := (others => '0');
    signal a_out : signed(7 downto 0);
    signal b_out : signed(7 downto 0);
    signal result0 : signed(31 downto 0);
    signal result1 : signed(31 downto 0);
    begin
        clk <= not clk after 5 ns;

        dut : entity work.pe_chain_2
        port map(
            clk => clk,
            reset => reset,
            enable => enable,
            a_in => a_in,
            b_in => b_in,
            a_out => a_out,
            b_out => b_out,
            result0 => result0,
            result1 => result1
        );

        stimulus : process
        begin
            reset <= '1';
            enable <= '0'; 

            wait until rising_edge(clk);
            wait for 1 ns;

            assert result0 = to_signed(0, 32)
                report "PE0 reset failed"
                severity error;
            
            assert result1 = to_signed(0, 32)
                report "PE1 reset failed"
                severity error;

            assert a_out = to_signed(0, 8)
                report "a_out reset failed"
                severity error;

            assert b_out = to_signed(0,8)
                report "b_out reset failed"
                severity error;
            
            reset <= '0';
            enable <= '1';

            --inject 3x4
            a_in <= to_signed(3, 8);
            b_in <= to_signed(4, 8);

            wait until rising_edge(clk);
            wait for 1 ns;

            assert result0 = to_signed(12,32)
                report "PE0 first MAC failed"
                severity error;

            assert result1 = to_signed(0,32)
                report "PE1 first MAC failed: probably calculated too early"
                severity error;

            assert a_out = to_signed(0, 8)
                report "a reached PE1 output too early"
                severity error;

            assert b_out = to_signed(0, 8)
                report "b reached PE1 output too early"
                severity error;
            
            --inject 0s
            a_in <= to_signed(0,8);
            b_in <= to_signed(0,8);

            wait until rising_edge(clk);
            wait for 1 ns;

            assert result0 = to_signed(12,32)
                report "PE0 result incorrect after bubble"
                severity error;

            assert result1 = to_signed(12, 32)
                report "PE1 did not receive MAC operation"
                severity error;

            assert a_out = to_signed(3,8)
                report "a did not propagate through PE chain"
                severity error;

            assert b_out = to_signed(4,8)
                report "b did not propagate through PE chain"
                severity error;
            
            --one more clock to check forwarding inputs
            wait until rising_edge(clk);
            wait for 1 ns;

            assert result0 = to_signed(12, 32)
                report "PE0 accumulator changed unexpectedly"
                severity error;

            assert result1 = to_signed(12, 32)
                report "PE1 accumulator changed unexpectedly"
                severity error;

            assert a_out = to_signed(0, 8)
                report "a_out bubble failed"
                severity error;

            assert b_out = to_signed(0, 8)
                report "b_out bubble failed"
                severity error;
            wait;

        end process;

    end architecture sim;