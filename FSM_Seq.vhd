library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FSM_Seq is
    port (
        clk     : in std_logic;
        reset_n : in std_logic; -- Active low reset
        w       : in std_logic; -- Input signal
        z       : out std_logic; -- Output for detected sequence
        state   : out std_logic_vector(8 downto 0) -- Current state outputs
    );
end entity;

architecture Behavioral of FSM_Seq is
    signal current_state : std_logic_vector(8 downto 0) := "000000001"; -- Start in state A
    signal next_state    : std_logic_vector(8 downto 0);
    signal led           : std_logic; -- Intermediate signal for output z

begin

    -- State transition process
    process(clk, reset_n) 
    begin 
        if reset_n = '1' then
            current_state <= "000000001"; -- Reset to state A
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(current_state,w) 
    begin
        case current_state is
            when "000000001" => -- State A
					 led <= '0';
                if w = '0' then
                    next_state <= "000000010"; -- State B
                elsif w = '1' then
                    next_state <= "000100000"; -- State F
                end if;

            when "000000010" => -- State B
					 led <='0';
                if w = '0' then
                    next_state <= "000000100"; -- State C
                elsif w = '1' then
                    next_state <= "000100000"; -- State F
                end if;

            when "000000100" => -- State C
                if w = '0' then
                    next_state <= "000001000"; -- State D
                elsif w = '1' then
                    next_state <= "000100000"; -- State F
                end if;

            when "000001000" => -- State D
                if w = '0' then
                    next_state <= "000010000"; -- State E
                    led <= '0'; -- Signal detected
                elsif w = '1' then
                    next_state <= "000100000"; -- State F
                end if;

            when "000010000" => -- State E
                if w = '0' then
                    next_state <= "000010000"; -- Stay in E
						  led<='1';
                elsif w = '1' then
                    next_state <= "000100000"; -- State F
                end if;

            when "000100000" => -- State F
					 led <='0';
                if w = '1' then
                    next_state <= "001000000"; -- State G
                elsif w = '0' then
                    next_state <= "000000010"; -- Back to B
                end if;

            when "001000000" => -- State G
					 led <= '0';
                if w = '1' then
                    next_state <= "010000000"; -- State H
                elsif w = '0' then
                    next_state <= "000000010"; -- Back to B
                end if;

            when "010000000" => -- State H
                if w = '1' then
                    next_state <= "100000000"; -- State I
                    led <= '0'; -- Signal detected
                elsif w = '0' then
                    next_state <= "000000010"; -- Back to B
                end if;

            when "100000000" => -- State I
                if w = '1' then
                    next_state <= "100000000"; -- Stay in I
						  led <='1';
                elsif w = '0' then
                    next_state <= "000000010"; -- Back to B
                end if;

            when others => 
                next_state <= "000000001"; -- Default to A
        end case;
    end process;

    -- State output assignments
    state <= current_state;
    z <= led; -- Assign the led signal to output z

end architecture;
