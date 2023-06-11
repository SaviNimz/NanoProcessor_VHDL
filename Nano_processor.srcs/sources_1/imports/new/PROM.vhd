library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity PROM is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0));
end PROM;

architecture Behavioral of PROM is

type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
 
 signal Program_Rom : rom_type := (
   --stored instructions (indexing from 0 - 7)
    "100010000001",  --MOVI R1,1   10 001 000 0001     881
    "100100000010",  --MOVI R2,2   10 010 000 0010     901  
    "100110000011",  --MOVI R3,3   10 011 000 0011     0a0
    "000010100000",  --ADD R1,R2    00 001 010 0000     0a0
    "000010110000",  --ADD R1,R3    00 001 011 0000     0a0
    "110000000111",  --JZR R0, 7 ; If R0 = 0 jump to line 7  11 000 0000 111    c00
    "000000000000",
    "000000000000"
    
    -- second set of instructions
    
       --signal Program_Rom : rom_type := (
       --stored instructions (indexing from 0 - 7)
        --"101110000001",  --MOVI R7,1   10 111 000 0001     881
        --"100100000010",  --MOVI R2,2   10 010 000 0010     901  
        --"100110000011",  --MOVI R3,3   10 011 000 0011     0a0
        --"001110100000",  --ADD R7,R2    00 111 010 0000     0a0
        --"001110110000",  --ADD R7,R3    00 111 011 0000     0a0
        --"110000000111",  --JZR R0, 7 ; If R0 = 0 jump to line 7  11 000 0000 111    c00
        --"000000000000",
        --"000000000000"
    --);
);

begin

data <= Program_Rom(to_integer(unsigned(address)));

end Behavioral;
