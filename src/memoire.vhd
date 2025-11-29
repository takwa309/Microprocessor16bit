library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_async is
    port (
        RnW   : in  std_logic; 
        addr  : in  std_logic_vector(11 downto 0);
        data_s : in  std_logic_vector(15 downto 0);
        data  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture arch of memory_async is
    type mem_type is array (0 to 4095) of std_logic_vector(15 downto 0);
    signal mem : mem_type := (
        0  => "0000100000000000", 1 => "0011100000000001", 2 => "0101000000001000",
        3  => "0100000000001101", 8 => "0001100000000000", 9 => "0000100000000010",
        10 => "0010100000000011", 11 => "0001100000000010", 12 => "0100000000000000",
        13 => "0111000000000000", 2048 => std_logic_vector(to_unsigned(10,16)),
        2049 => std_logic_vector(to_unsigned(3,16)), 2050 => (others => '0'),
        2051 => std_logic_vector(to_unsigned(1,16)), others => (others => '0')
    );
begin

    -- Lecture asynchrone : data_out est toujours le contenu de mem[addr]
    data <= mem(to_integer(unsigned(addr))) when RnW = '1' else (others => 'Z');

    -- Écriture asynchrone : met à jour la mémoire si RnW='0'
    mem(to_integer(unsigned(addr))) <= data_s when RnW = '0';

end architecture;

