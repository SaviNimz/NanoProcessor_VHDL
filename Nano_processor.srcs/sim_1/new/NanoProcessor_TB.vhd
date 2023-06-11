library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NanoProcessor_TB is
end NanoProcessor_TB;

architecture Behavioral of NanoProcessor_TB is
    -- Component declaration
    component NanoProcessor
    Port (  
        Clk : in STD_LOGIC;
        Res : in STD_LOGIC;
        Overflow_led : out STD_LOGIC;
        Zero_led : out STD_LOGIC;
        Reg_7 : out std_logic_vector(3 downto 0)
    );
    end component;

    -- Signal declarations
    signal Clk_tb: STD_LOGIC := '0';
    signal Res_tb: STD_LOGIC := '0';
    signal Overflow_led_tb: STD_LOGIC;
    signal Zero_led_tb: STD_LOGIC;
    signal Reg_7_tb: std_logic_vector(3 downto 0);

begin
    -- Instantiate the DUT (Device Under Test)
    DUT: NanoProcessor
    Port Map (
        Clk => Clk_tb,
        Res => Res_tb,
        Overflow_led => Overflow_led_tb,
        Zero_led => Zero_led_tb,
        Reg_7 => Reg_7_tb
    );

    -- Clock process
    Clk_process: process
    begin
        while now < 1000 ns loop
            Clk_tb <= '0';
            wait for 8 ns;
            Clk_tb <= '1';
            wait for 8 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    Stimulus_process: process
    begin
        -- Initialize inputs
        Res_tb <= '1';
        -- Add more input assignments her
        -- Wait for simulation to finish
        wait for 15 ns;
        
        Res_tb <= '0';
        
        wait;
    end process;

end Behavioral;