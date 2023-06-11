library ieee;
use ieee.std_logic_1164.all;

entity ProgramCounter is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        pc_in : in std_logic_vector(2 downto 0);
        pc_out    : out std_logic_vector( 2 downto 0));
end ProgramCounter;

architecture Behavioral of ProgramCounter is
--signal rising_edge_count : integer range 0 to 2 := 0;
begin
process(clk)
begin
    if (rising_edge(clk)) then
        if reset = '1' then
            --rising_edge_count <= 0;  -- Reset the counter
            pc_out <= "000";
        else
            --rising_edge_count <= rising_edge_count + 1;  -- Increment the counter

            --if rising_edge_count = 2 then
                pc_out <= pc_in;  -- Update the output after two rising edges
                --rising_edge_count <= 0;
            end if;
        end if;
    --end if;
end process;
end architecture behavioral;