library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        pc_ld    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(11 downto 0)
    );
end PC;

architecture Behavioral_PC of PC is
    signal pc_reg : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
begin
    
    -- ? Process sensible au FRONT MONTANT de pc_ld
    process(pc_ld)
    begin
        if rising_edge(pc_ld) then
            pc_reg <= data_in(11 downto 0);  -- Prendre les 12 LSB
        end if;
    end process;
    
    data_out <= pc_reg;
    
end Behavioral_PC;
