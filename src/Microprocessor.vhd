library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Microprocessor is
    port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end entity;

architecture Behavioral of Microprocessor is

    -- ============================================================
    -- DÉCLARATION DES COMPOSANTS
    -- ============================================================

    component control_unit1 is
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
    end component;

    component memory_async is
        port (
            RnW    : in  std_logic; 
            addr   : in  std_logic_vector(11 downto 0);
            data_s : in  std_logic_vector(15 downto 0);
            data   : out std_logic_vector(15 downto 0)
        );
    end component;

    component acc is
        port (
            acc_ld   : in  std_logic;
            acc_in   : in  std_logic_vector(15 downto 0);
            acc_out  : out std_logic_vector(15 downto 0);
            accZ     : out std_logic;
            acc15    : out std_logic
        );
    end component;

    component IR is
        port (
            data_in  : in  std_logic_vector(15 downto 0);
            ir_ld    : in  std_logic;
            data_out : out std_logic_vector(11 downto 0);
            opcode   : out std_logic_vector(3 downto 0)
        );
    end component;

    component pc is
        port (
            data_in  : in  std_logic_vector(15 downto 0);
            pc_ld    : in  std_logic;
            data_out : out std_logic_vector(11 downto 0)
        );
    end component;

    component alu is
        port (
            alufs : in  std_logic_vector(3 downto 0);
            A     : in  std_logic_vector(15 downto 0);
            B     : in  std_logic_vector(15 downto 0);
            S     : out std_logic_vector(15 downto 0)
        );
    end component;

    component muxb is
        port (
            selB     : in std_logic;
            mem_data : in std_logic_vector(15 downto 0);
            const1   : in std_logic_vector(15 downto 0);
            outB     : out std_logic_vector(15 downto 0)
        );
    end component;

    component muxa is
        port (
            selA  : in std_logic;
            acc   : in std_logic_vector(11 downto 0);
            other : in std_logic_vector(11 downto 0);
            outA  : out std_logic_vector(11 downto 0)
        );
    end component;

    component OE is
        port (
            data_in  : in std_logic_vector(15 downto 0);
            acc_oe   : in std_logic;
            data_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -- ============================================================
    -- SIGNAUX INTERNES
    -- ============================================================

    -- Signaux de données
    signal opcode_s      : std_logic_vector(3 downto 0) := (others => '0');
    signal acc_out_s     : std_logic_vector(15 downto 0) := (others => '0');
    signal acc_in_s      : std_logic_vector(15 downto 0) := (others => '0');
    signal pc_out        : std_logic_vector(11 downto 0) := (others => '0');
    signal pc_in         : std_logic_vector(15 downto 0) := (others => '0');
    signal ir_out        : std_logic_vector(11 downto 0) := (others => '0');
    signal bus_add       : std_logic_vector(11 downto 0) := (others => '0');
    signal addr_full     : std_logic_vector(15 downto 0) := (others => '0');
    signal alu_inB       : std_logic_vector(15 downto 0) := (others => '0');

    -- Bus de données
    signal bus_data_in   : std_logic_vector(15 downto 0) := (others => 'Z');
    signal bus_data_out  : std_logic_vector(15 downto 0) := (others => 'Z');
    signal bus_data      : std_logic_vector(15 downto 0);

    -- Signaux de contrôle
    signal acc_ld_s, pc_ld_s, ir_ld_s, acc_oe_s : std_logic := '0';
    signal selA_s, selB_s, RnW_s : std_logic := '1';
    signal alufs_s : std_logic_vector(3 downto 0) := (others => '0');
    signal accZ_s, acc15_s : std_logic := '0';

begin

    -- ============================================================
    -- CONNEXIONS CRITIQUES
    -- ============================================================

    -- ? CONNEXION CRITIQUE : PC reçoit la sortie de l'ALU
    -- Cette ligne permet au PC de s'incrémenter correctement
    pc_in <= acc_in_s;

    -- Construction de l'adresse complète (instruction sur 16 bits)
    addr_full <= opcode_s & bus_add;

    -- Gestion du bus de données bidirectionnel
    -- Lecture : mémoire ? CPU
    -- Écriture : CPU ? mémoire
    bus_data <= bus_data_out when RnW_s = '1' else bus_data_in;

    -- ============================================================
    -- INSTANCIATION DE LA MÉMOIRE
    -- ============================================================

    MEM: memory_async
        port map (
            RnW    => RnW_s,
            addr   => bus_add,
            data_s => bus_data_in,   -- Données à écrire (CPU ? mémoire)
            data   => bus_data_out   -- Données lues (mémoire ? CPU)
        );

    -- ============================================================
    -- INSTANCIATION DE L'UNITÉ DE CONTRÔLE (MACHINE D'ÉTAT)
    -- ============================================================

    CU: control_unit1
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => opcode_s,
            acc_z   => accZ_s,
            acc_15  => acc15_s,
            pc_id   => pc_ld_s,
            ir_id   => ir_ld_s,
            acc_id  => acc_ld_s,
            acc_oe  => acc_oe_s,
            SelA    => selA_s,
            SelB    => selB_s,
            alufs   => alufs_s,
            RnW     => RnW_s
        );

    -- ============================================================
    -- INSTANCIATION DES REGISTRES
    -- ============================================================

    -- Accumulateur (registre de travail)
    ACCU: acc
        port map (
            acc_ld  => acc_ld_s,
            acc_in  => acc_in_s,     -- Sortie de l'ALU
            acc_out => acc_out_s,
            accZ    => accZ_s,       -- Flag Zero
            acc15   => acc15_s       -- Bit de signe
        );

    -- Registre d'instruction
    IR_reg: IR
        port map (
            data_in  => bus_data,
            ir_ld    => ir_ld_s,
            data_out => ir_out,      -- 12 bits d'adresse
            opcode   => opcode_s     -- 4 bits d'opcode
        );

    -- Compteur de programme
    PC_reg: pc
        port map (
            data_in  => pc_in,       -- ? Connecté à la sortie ALU
            pc_ld    => pc_ld_s,
            data_out => pc_out
        );

    -- ============================================================
    -- INSTANCIATION DES MULTIPLEXEURS
    -- ============================================================

    -- MUX_B : Sélectionne l'entrée B de l'ALU
    -- selB = '0' : données de la mémoire (bus_data)
    -- selB = '1' : adresse complète (addr_full)
    MUX_B: muxb
        port map (
            selB     => selB_s,
            mem_data => bus_data,
            const1   => addr_full,
            outB     => alu_inB
        );

    -- MUX_A : Sélectionne le bus d'adresses
    -- selA = '0' : PC (pour fetch et incrément)
    -- selA = '1' : IR (pour accéder aux données)
    MUX_A: muxa
        port map (
            selA  => selA_s,
            acc   => pc_out,
            other => ir_out,
            outA  => bus_add
        );

    -- ============================================================
    -- INSTANCIATION DE L'ALU
    -- ============================================================

    UAL: alu
        port map (
            alufs => alufs_s,
            A     => acc_out_s,      -- Entrée A = Accumulateur
            B     => alu_inB,        -- Entrée B = Sortie MUX_B
            S     => acc_in_s        -- Sortie ? ACC et PC
        );

    -- ============================================================
    -- BUFFER TRI-STATE (OUTPUT ENABLE)
    -- ============================================================

    -- Permet à l'accumulateur d'écrire sur le bus de données
    OE_reg: OE
        port map (
            data_in  => acc_out_s,
            acc_oe   => acc_oe_s,
            data_out => bus_data_in
        );

end Behavioral;
