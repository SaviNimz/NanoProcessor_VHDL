library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_4 is
    port (
        A : in  std_logic_vector(3 downto 0);
        B : in  std_logic_vector(3 downto 0);
        S : in  std_logic;
        Y : out std_logic_vector(3 downto 0)
    );
end Mux_2_4;

architecture behavioral of Mux_2_4 is
begin
    process(A, B, S)
    begin
        if S = '0' then
            Y <= A;
        else
            Y <= B;
        end if;
    end process;
end behavioral;