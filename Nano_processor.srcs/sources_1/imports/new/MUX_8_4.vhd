
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_8_4 is
  Port (
  Data_In0 : in  std_logic_vector(3 downto 0);
  Data_In1 : in  std_logic_vector(3 downto 0);
  Data_In2 : in  std_logic_vector(3 downto 0);
  Data_In3 : in  std_logic_vector(3 downto 0);
  Data_In4 : in  std_logic_vector(3 downto 0);
  Data_In5 : in  std_logic_vector(3 downto 0);
  Data_In6 : in  std_logic_vector(3 downto 0);
  Data_In7 : in  std_logic_vector(3 downto 0);
  Sel   : in  std_logic_vector(2 downto 0);
  Data_Out : out std_logic_vector(3 downto 0)
);
end MUX_8_4;

architecture Behavioral of MUX_8_4 is
begin
  Data_Out <= Data_In0 when Sel = "000" else
              Data_In1 when Sel = "001" else
              Data_In2 when Sel = "010" else
              Data_In3 when Sel = "011" else
              Data_In4 when Sel = "100" else
              Data_In5 when Sel = "101" else
              Data_In6 when Sel = "110" else
              Data_In7 when Sel = "111";
end Behavioral;
