library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Ins_Dec is
 Port ( I : in STD_LOGIC_VECTOR (11 downto 0); -- this is the instruction input
        Reg_en : out STD_LOGIC_VECTOR (2 downto 0); -- this sends the enable singals for the register
        Load_sel : out STD_LOGIC; -- this selects the load of the multiplexer
        Val : out STD_LOGIC_VECTOR (3 downto 0); -- this is the immediate value fed to the multiplexer
        -- following two busses selects the registers
        Reg_sel_1 : out STD_LOGIC_VECTOR (2 downto 0);
        Reg_sel_2 : out STD_LOGIC_VECTOR (2 downto 0);
        
        Add_sub_sel : out STD_LOGIC; -- this will select the addition or substracton
        
        Chek_jump : in STD_LOGIC_VECTOR (3 downto 0); -- input from the 8_4 MUX is fed to here
        
        Jump_flag :  out STD_LOGIC; -- this will give the jump flag
        Jump_add : out STD_LOGIC_VECTOR (2 downto 0)); -- this is the address to jump
        
end Ins_Dec;

architecture Behavioral of Ins_Dec is

begin
   process (I) begin
     -- MOVE INSTRUCTION
        if (I(11 downto 10) = "10") then
            Reg_en <= I(9 downto 7);
            Val <= I(3 downto 0);
            Load_sel <= '1';
            Jump_flag <= '0';
       -- ADD INSTRUCTION
        elsif (I(11 downto 10) = "00") then
            Add_sub_sel <= '0';
            Load_sel <= '0';
            Reg_en <= I(9 downto 7);
            Reg_sel_1 <= I(9 downto 7);
            Reg_sel_2 <= I(6 downto 4);
            Jump_flag <= '0';
            
    -- NEG INSTRUCTION

       elsif (I(11 downto 10) = "01") then
           Add_sub_sel <= '1';
           Load_sel <= '0';
           Reg_en <= I(9 downto 7);
           Reg_sel_1 <= "000";
           Reg_sel_2 <= I(9 downto 7);
           Jump_flag <= '0';
           
    -- JUMP INSTRUCTON
      elsif (I(11 downto 10) = "11") then
            Reg_en <= "110";
            Reg_sel_1 <= I(9 downto 7);
            -- we are doing a change
            if I(9 downto 7) = "000" then
                Jump_flag <= '1';
                Jump_add <= I(2 downto 0);
            
            else if Chek_jump = "0000" then
                Jump_flag <= '1';
                Jump_add <= I(2 downto 0);
            end if; 
          end if;
        end if;      
    end process; 
     
    
end Behavioral;
