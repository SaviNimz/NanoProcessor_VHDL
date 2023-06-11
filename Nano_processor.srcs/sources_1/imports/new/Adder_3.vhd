

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_3 is
Port (  I_A : in STD_LOGIC_VECTOR (2 downto 0);
        O_S_Out : out STD_LOGIC_VECTOR (2 downto 0));
end Adder_3;
architecture Behavioral of Adder_3 is

component FA
port (
    A: in std_logic;
    B: in std_logic;
    C_in: in std_logic;
    S: out std_logic;
    C_out: out std_logic);
end component;

SIGNAL FA0_C,FA1_C,FA2_C,FA3_C : std_logic;
SIGNAL b0 : std_logic := '1';
SIGNAL b1 : std_logic := '0';
SIGNAL C_in : std_logic := '0';
begin
 FA_0 : FA 
 port map ( 
     A => I_A(0), 
     B => b0, 
     C_in => C_in, 
     S => O_S_Out(0), 
     C_out => FA0_C
 );
 
 FA_1 : FA 
 port map ( 
     A => I_A(1), 
     B => b1, 
     C_in => FA0_C, 
     S => O_S_Out(1), 
     C_out => FA1_C
 ); 
 
 FA_2 : FA 
 port map ( 
     A => I_A(2), 
     B => b1, 
     C_in => FA1_C, 
     S => O_S_Out(2), 
     C_out => FA2_C
 );
 
end Behavioral;
