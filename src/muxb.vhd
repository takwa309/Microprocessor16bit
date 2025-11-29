library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUXB is
    Port (
        selB : in STD_LOGIC;
        mem_data : in STD_LOGIC_VECTOR(15 downto 0);
        const1   : in STD_LOGIC_VECTOR(15 downto 0);
        outB     : out STD_LOGIC_VECTOR(15 downto 0)
    );
end MUXB;

architecture Behavioral of MUXB is
begin
    process(selB, mem_data, const1)
    begin
        if selB = '0' then
            outB <= mem_data;
        else
            outB <= const1;
        end if;
    end process;
end Behavioral;

