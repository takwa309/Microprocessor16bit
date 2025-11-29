library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity OE is
    Port (
        data_in  :  in  std_logic_vector(15 downto 0);
        acc_oe   : in  std_logic;                    
        data_out : out std_logic_vector(15 downto 0) 

    );
end OE;
architecture Behavioral of OE is
begin
    process(data_in, acc_oe)

    begin
        if acc_oe = '1' then
            data_out <= data_in; 
        else
            data_out <= (others => 'Z'); 
        end if;
    end process;
end Behavioral; 
