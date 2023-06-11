

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_3_2 is
    port (
        A : in  std_logic_vector(2 downto 0);
        B : in  std_logic_vector(2 downto 0);
        S : in  std_logic;
        Y : out std_logic_vector(2 downto 0)
    );
end Mux_3_2;

architecture behavioral of Mux_3_2 is
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