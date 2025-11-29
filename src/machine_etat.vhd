library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit1 is
    port (
        rslt     : in std_logic; 
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
    type state_type is (A, A1, B, B1, C, C1, C2, D, E, E1, F, F1, G, G1, STOP);
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

    
    process(state, opcode, acc_z, acc_15)
    begin
        next_state <= A; 

        case state is
            when A =>
                   next_state <= A1;
               

            when A1 =>
                 case opcode is
                    when "0101" =>
                       if acc_z = '1' and acc_15 = '1' then
                           next_state <= F;
                       else
                            next_state <= B;
                       end if;

                     when "0110" =>
                         if acc_z = '0' and acc_15 = '0' then
                              next_state <= G;
                         else
                              next_state <= B;
                         end if;
                     when "0111" =>
                       next_state <= A;

                     when others =>
                                next_state <= B;
                    end case;


            when B =>
                next_state <= B1;

            when B1 =>
                case opcode is
                    when "0010" | "0011" | "0000" => next_state <= C;
                    when "0001" => next_state <= E;
                    when others => next_state <= A;
                end case;

            when C =>
                case opcode is
                    when "0010" => next_state <= C1; -- LDA
                    when "0011" => next_state <= C2; -- STA
                    when "0000" => next_state <= D;  -- ADD
                    when others => next_state <= A;
                end case;

            when D | E1 | F1 | G1 | C1 | C2 =>
                next_state <= A;

            when E =>
                next_state <= E1;

            when F =>
                if acc_15 = '0' then
                    next_state <= F1;
                else
                    next_state <= A;
                end if;

            when G =>
                if acc_z = '0' then
                    next_state <= G1;
                else
                    next_state <= A;
                end if;

            when others =>
                next_state <= A;
        end case;
    end process;

    
    process(state)
    begin
        
        SelA   <= '0';
        SelB   <= '0';
        RnW    <= '0';
        pc_id  <= '0';
        ir_id  <= '0';
        acc_id <= '0';
        acc_oe <= '0';
        alufs  <= "0000";

        case state is
            when A =>
                RnW    <= '1';
                SelA   <= '0';
                SelB   <= '0';
                pc_id  <= '0';
                ir_id  <= '0';

            when A1 =>
                RnW    <= '1';
                SelA   <= '0';
                SelB   <= '0';
                ir_id  <= '1';

            when B =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '0';
                alufs  <= "0011";

            when B1 =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '0';
                pc_id  <= '1';
                alufs  <= "0011";

            when C =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '1';
                pc_id  <= '0';

            when C1 => 
                RnW    <= '0';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';
                alufs  <= "0010";

            when C2 =>  
                RnW    <= '0';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';
                alufs  <= "0001";

            when D =>  
                RnW    <= '0';
                SelA   <= '1';
                SelB   <= '1';
                acc_id <= '1';

            when E =>
                RnW    <= '0';
                SelA   <= '1';
                SelB   <= '0';
                acc_oe <= '1';

            when E1 =>
                RnW    <= '1';
                SelA   <= '1';
                SelB   <= '0';
                acc_oe <= '1';

            when F =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '1';
                pc_id  <= '0';

            when F1 =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '1';
                pc_id  <= '1';

            when G =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '1';
                pc_id  <= '0';

            when G1 =>
                RnW    <= '0';
                SelA   <= '0';
                SelB   <= '1';
                pc_id  <= '1';

            when others =>
                null;
        end case;
    end process;

end fsm;



