library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IR is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        ir_ld    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(11 downto 0);
        opcode   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end IR;

architecture Behavioral_IR of IR is
    signal ir_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); 
begin
    
    -- ? Process sensible au FRONT MONTANT de ir_ld
    process(ir_ld)
    begin
        if rising_edge(ir_ld) then
            ir_reg <= data_in;
        end if;
    end process;
    
    opcode   <= ir_reg(15 downto 12);
    data_out <= ir_reg(11 downto 0);
    
end Behavioral_IR;
