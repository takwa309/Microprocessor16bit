library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit1 is
    port (
        clk      : in std_logic; 
        reset    : in std_logic;
        opcode   : in std_logic_vector(3 downto 0); 
        acc_z    : in std_logic;                       
        acc_15   : in std_logic;
        acc_id   : out std_logic; 
        pc_id    : out std_logic;
        ir_id    : out std_logic;
        acc_oe   : out std_logic; 
        alufs    : out std_logic_vector(3 downto 0);
        SelA     : out std_logic;
        SelB     : out std_logic; 
        RnW      : out std_logic
    );
end control_unit1;

architecture fsm of control_unit1 is
    type state_type is (A, A1, B, C, C1, C2, D, D1, J, J1, J2, W, W1);
    signal state, next_state : state_type;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= A;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Next state combinatorial
    process(state, opcode, acc_z, acc_15)
    begin
        next_state <= A; -- défaut

        case state is
            when A =>
                next_state <= A1;

            when A1 =>
                -- Correction : opcode "0100" ne doit pas être testé deux fois contradictoirement.
                if (opcode = "0110" and acc_z = '1') or (opcode = "0100") or (opcode = "0101" and acc_15 = '1') then
                    next_state <= B;
                elsif (opcode = "0110" and acc_z = '0') or (opcode = "0101" and acc_15 = '0') then
                    next_state <= C;
                elsif (opcode = "0111") then
                    next_state <= A;
                elsif (opcode = "0010" or opcode = "0000" or opcode = "0011" or opcode = "0001") then
                    next_state <= B;
                end if;

            when B =>
                if opcode = "0010" or opcode = "0011" or opcode = "0000" or opcode = "0001" then
                    next_state <= C;
                elsif (opcode = "0110" and acc_z = '1') or (opcode = "0100") or (opcode = "0101" and acc_15 = '1') or (opcode = "0111") then
                    -- Remplacé "01110" par "0111"
                    next_state <= A;
                end if;

            when C =>
                if (opcode = "0110" and acc_z = '0') or (opcode = "0101" and acc_15 = '0') or (opcode = "0000") then
                    next_state <= C1;
                elsif opcode = "0010" then
                    next_state <= W;
                elsif opcode = "0011" then
                    next_state <= D;
                elsif opcode = "0001" then
                    next_state <= J;
                end if;

            when C1 =>
                if (opcode = "0110" and acc_z = '0') or (opcode = "0101" and acc_15 = '0') or (opcode = "0000") then
                    next_state <= C2;
                end if;

            when C2 =>
                next_state <= A;

            when D =>
                if opcode = "0011" then
                    next_state <= D1;
                end if;

            when D1 =>
                next_state <= A;

            when W =>
                if opcode = "0010" then
                    next_state <= W1;
                end if;

            when W1 =>
                next_state <= A;

            when J =>
                if opcode = "0001" then
                    next_state <= J1;
                end if;

            when J1 =>
                if opcode = "0001" then
                    next_state <= J2;
                end if;

            when J2 =>
                next_state <= A;

            when others =>
                next_state <= A;
        end case;
    end process;

    -- Outputs: tous les signaux reçoivent d'abord une valeur par défaut
    process(state)
    begin
        -- valeurs par défaut (empêche l'inférence de latch)
        RnW    <= '1';
        SelA   <= '0';
        SelB   <= '0';
        acc_id <= '0';
        pc_id  <= '0';
        ir_id  <= '0';
        acc_oe <= '0';
        alufs  <= "0000";

        case state is
            when A =>
                -- valeurs par défaut déjà correctes pour A

            when A1 =>
                RnW    <= '1';
                SelA   <= '0';
                SelB   <= '0';
                ir_id  <= '1';
                acc_oe <= '0';
                pc_id  <= '1';

            when B =>
                RnW    <= '1';
                pc_id  <= '0';
                acc_oe <= '0';
                alufs  <= "0011";

            when C =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_oe <= '0';

            when C1 =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '0';
                acc_oe <= '0';
                alufs  <= "0000";

            when C2 => 
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';
                acc_oe <= '0';
                alufs  <= "0000";

            when D =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '0';
                acc_oe <= '0';
                alufs  <= "0001";

            when D1 =>  
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';
                acc_oe <= '0';
                alufs  <= "0001";

            when J =>
                RnW    <= '0';
                SelA   <= '1';
                acc_oe <= '0';

            when J1 =>
                RnW    <= '0';
                SelA   <= '1';
                acc_oe <= '1';

            when J2 =>
                RnW    <= '0';
                SelA   <= '1';
                acc_oe <= '0';

            when W =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '0';
                acc_oe <= '0';
                alufs  <= "0010";

            when W1 =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';
                acc_oe <= '0';
                alufs  <= "0010";

            when others =>
                null;
        end case;
    end process;

end fsm;

