
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NanoProcessor is
Port (  Clk : in STD_LOGIC;
        Res : in STD_LOGIC;
        Overflow_led : out STD_LOGIC;
        Zero_led : out STD_LOGIC;
        Reg_7 : out std_logic_vector(3 downto 0)
        );
end NanoProcessor;

architecture Behavioral of NanoProcessor is

-- now we have to add the necessary components to the nano processor

-- adding the instruction decoder
component Ins_Dec

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
        Jump_add : out STD_LOGIC_VECTOR (2 downto 0)
        ); -- this is the address to jump
end component;

signal Reg_en_I : STD_logic_vector(2 downto 0); -- mapped to the 3-8 decorder of the register bank
signal Load_Sel_I : STD_logic; -- mapped to the Sel pin of the 2-4 MUX
signal Val_I : STD_logic_vector(3 downto 0); -- mapped to the input B of MUX_2_4

signal Reg_Sel_1_I : STD_logic_vector(2 downto 0); -- intermdeiate signals for selecting the registers from the MUX_8_4
signal Reg_Sel_2_I : STD_logic_vector(2 downto 0);

signal Add_Sub_Sel_I : STD_logic; -- this signal will be the add sub selction signal of Add Sub unit

--signal Chek_Jump_I : STD_logic_vector(3 downto 0); -- used when a jump instruction is exectued
signal Jump_flag_I : STD_logic; -- this activates when jump instructon occurs

signal Jump_Add_I : STD_logic_vector(2 downto 0); -- this will send the address to jump

-- adding the register bank

component Reg_bank
    
     Port ( I : in STD_LOGIC_VECTOR (3 downto 0); -- this bus will be connected to the three flip flops of the register
            Clk : in STD_LOGIC; -- this is the common clock for the registers
            Reg_en : in STD_LOGIC_VECTOR (2 downto 0); -- enable pins of the decoder (this will select the respective register)
            -- following are the input lines for the registers
            Reset_bank : in STD_LOGIC;
            RO0 : out STD_LOGIC_VECTOR (3 downto 0);
            RO1 : out STD_LOGIC_VECTOR (3 downto 0);
            RO2 : out STD_LOGIC_VECTOR (3 downto 0);
            RO3 : out STD_LOGIC_VECTOR (3 downto 0);
            RO4 : out STD_LOGIC_VECTOR (3 downto 0);
            RO5 : out STD_LOGIC_VECTOR (3 downto 0);
            RO6 : out STD_LOGIC_VECTOR (3 downto 0);
            RO7 : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal Reg_bank_in_I : STD_logic_vector(3 downto 0); -- this signal will be mapped to all the registers in the register bank

-- followng intermediate signals will indicate outputs of the rigister bank
-- they will be mapped to the 8_4_mux (to both)
signal RO0_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO1_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO2_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO3_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO4_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO5_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO6_I : STD_LOGIC_VECTOR(3 downto 0);
signal RO7_I : STD_LOGIC_VECTOR(3 downto 0);


-- adding the necessary multiplexers
component MUX_8_4
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
    Data_Out : out std_logic_vector(3 downto 0));
end component;


-- adding the add sub unit component
component Add_Sub_4
    Port (  I_A : in STD_LOGIC_VECTOR (3 downto 0);
            I_B : in STD_LOGIC_VECTOR (3 downto 0);
            I_Add_Sub_Sel : in STD_LOGIC;
            O_S_Out : out STD_LOGIC_VECTOR (3 downto 0);
            O_Overflow : out STD_LOGIC;
            O_Zero : out STD_LOGIC);
end component;
-- A,B maaru karala thiyenne

-- these will be the inputs to the add sub unit 
signal A_I : STD_LOGIC_VECTOR(3 downto 0); -- first input from MUX 1
signal B_I : STD_LOGIC_VECTOR(3 downto 0); -- second input from MUX 0
signal S_Out_I : STD_LOGIC_VECTOR(3 downto 0); -- output from the add sub unit (this will be mapped to MUX_2_4 pin A)

component MUX_3_2
    port (
    A : in  std_logic_vector(2 downto 0);
    B : in  std_logic_vector(2 downto 0);
    S : in  std_logic;
    Y : out std_logic_vector(2 downto 0));
end component;


component MUX_2_4
    port (
    A : in  std_logic_vector(3 downto 0);
    B : in  std_logic_vector(3 downto 0);
    S : in  std_logic;
    Y : out std_logic_vector(3 downto 0)
);
end component;


-- adding the program counter
component ProgramCounter
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        pc_in : in std_logic_vector(2 downto 0);
        pc_out    : out std_logic_vector( 2 downto 0));
end component;

signal pc_out_I : STD_logic_vector(2 downto 0);-- intermediate value of the output of the program counter 
signal pc_in_I : STD_logic_vector(2 downto 0); -- intermediate value of the inpur signal  to the program counter

-- adding the three bit adder for the program counter
component Adder_3
    Port (I_A : in STD_LOGIC_VECTOR (2 downto 0);
          O_S_Out : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal O_S_Out_I : STD_logic_vector(2 downto 0); 

-- adding the prom
component PROM
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0)
           );
end component;

signal data_I : STD_logic_vector(11 downto 0); -- itermediate value of the output from the PROM(mapped to the instruction decoder)

-- adding the slow clock to reduce the clock frequency
component Slow_Clk
    Port ( Clk_in : in STD_LOGIC;
           Clk_out : out STD_LOGIC);
end component;

begin

-- instance for program counter
ProgramCounter0 : ProgramCounter
    port map(
        clk => Clk,
        reset => Res,
        pc_in => pc_in_I,
        pc_out => pc_out_I
        );

-- instance for Program ROM
PROM0 : PROM
    port map(
        address => pc_out_I,
        data => data_I
        );
        
--instance for instruction decoder
Ins_Dec0 : Ins_Dec
    port map(
      I => data_I, 
      Reg_en => Reg_en_I, 
      Load_sel => Load_Sel_I,
      Val => Val_I,
      Reg_sel_1=> Reg_sel_1_I,
      ------------------------
      Reg_sel_2 => Reg_sel_2_I,
      Add_sub_sel => Add_sub_sel_I,
      ------------------------------------------
      Chek_jump => B_I,
      Jump_flag => Jump_flag_I,
      Jump_add => Jump_add_I
      );
--instance for 3 bit adder
Adder_3_0 : Adder_3
    port map (
            I_A => pc_out_I,
            O_S_Out => O_S_Out_I
            );
           
 -- instance for MUX_3_2 (used for the program counter)          
MUX_3_2_0 : MUX_3_2
    port map (
        A => O_S_Out_I,
        B => Jump_add_I,
        S => Jump_flag_I,
        Y => pc_in_I
        );

-- we need to create two instances of 8 way 4 bit MUX
MUX_8_4_0 : MUX_8_4
    port map(
        Data_In0 => RO0_I,
        Data_In1 => RO1_I,
        Data_In2 => RO2_I,
        Data_In3 => RO3_I,
        Data_In4 => RO4_I,
        Data_In5 => RO5_I,
        Data_In6 => RO6_I,
        Data_In7 => RO7_I,
        Sel => Reg_Sel_1_I,
        ---------------------
        Data_Out => B_I
        );
 MUX_8_4_1 : MUX_8_4
     port map(
         Data_In0 => RO0_I,
         Data_In1 => RO1_I,
         Data_In2 => RO2_I,
         Data_In3 => RO3_I,
         Data_In4 => RO4_I,
         Data_In5 => RO5_I,
         Data_In6 => RO6_I,
         Data_In7 => RO7_I,
         Sel => Reg_Sel_2_I,  
         --------------------
         Data_Out => A_I
    );
    
-- creating an instance for MUX_2_4
MUX_2_4_0 : MUX_2_4
    port map(
            A => S_Out_I,
            B => Val_I,
            S => Load_Sel_I,
            Y => Reg_bank_in_I
    );

-- creating an instance for register bank

Reg_bank_0 : Reg_bank
    port map(
       I => Reg_bank_in_I,
       Clk => Clk, 
       Reg_en => Reg_en_I,  -- enable pins of the decoder (this will select the respective register)
       -- following are the input lines for the registers
       Reset_bank => Res, -- mapped to the reset button of the whole processor
       -- outputs from all the registers
       RO0 => RO0_I,
       RO1 => RO1_I,
       RO2 => RO2_I,
       RO3 => RO3_I,
       RO4 => RO4_I,
       RO5 => RO5_I,
       RO6 => RO6_I,
       RO7 => RO7_I
    );
    
Add_Sub_4_0 : Add_Sub_4
    port map(
       I_A => A_I,
       I_B => B_I,
       I_Add_Sub_Sel => Add_Sub_Sel_I , 
       O_S_Out => S_Out_I,
       O_Overflow =>Overflow_led,
       O_Zero => Zero_led 
    );


end Behavioral;
