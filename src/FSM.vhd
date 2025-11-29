library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_machine_etat is
end entity;

architecture sim of tb_machine_etat is
    -- Signaux d?entrée
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal opcode  : std_logic_vector(3 downto 0) := (others => '0');
    signal accZ    : std_logic := '0';
    signal acc15   : std_logic := '0';

    -- Signaux de sortie
    signal RnW     : std_logic;
    signal selA    : std_logic;
    signal selB    : std_logic;
    signal pc_ld   : std_logic;
    signal ir_ld   : std_logic;
    signal acc_ld  : std_logic;
    signal acc_oe  : std_logic;
    signal alufs   : std_logic_vector(3 downto 0);
begin
    -- Instanciation du DUT
    uut: entity work.machine_etat
        port map (
            clk    => clk,
            reset  => reset,
            opcode => opcode,
            accZ   => accZ,
            acc15  => acc15,
            RnW    => RnW,
            selA   => selA,
            selB   => selB,
            pc_ld  => pc_ld,
            ir_ld  => ir_ld,
            acc_ld => acc_ld,
            acc_oe => acc_oe,
            alufs  => alufs
        );

    -- Génération d?horloge (20 ns)
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    -- Stimulus
    stim_proc : process
    begin
        -- Reset
        reset <= '1';
        wait for 25 ns;
        reset <= '0';

        -- Séquence d?instructions
        opcode <= "0000";  -- LDA
        wait for 60 ns;

        opcode <= "0001";  -- STO
        wait for 60 ns;

        opcode <= "0010";  -- ADD
        wait for 60 ns;

        opcode <= "0011";  -- SUB
        wait for 60 ns;

        opcode <= "0100";  -- JMP
        wait for 60 ns;

        opcode <= "0101"; acc15 <= '1'; -- JGE
        wait for 60 ns;

        opcode <= "0110"; accZ <= '0';  -- JNE
        wait for 60 ns;

        opcode <= "0111";  -- STP
        wait for 60 ns;

        wait; -- stop simulation
    end process;
end architecture;

