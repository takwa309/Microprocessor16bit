
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUXA is
    Port (
        selA : in STD_LOGIC;  
        acc : in STD_LOGIC_VECTOR(11 downto 0);
        other : in STD_LOGIC_VECTOR(11 downto 0);
        outA : out STD_LOGIC_VECTOR(11 downto 0)
    );
end MUXA;

architecture Behavioral of MUXA is
begin
    process(selA, acc, other)
    begin
        if selA = '0' then
            outA <= acc;
        else
            outA <= other;
        end if;
    end process;
end Behavioral;
