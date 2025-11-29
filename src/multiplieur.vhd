library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Multiplieur de deux nombres de 2 bits : a(1 downto 0) × b(1 downto 0) = p(3 downto 0)
entity multiplier_2bits is
    port (
        a : in  std_logic_vector(1 downto 0);  -- Premier opérande (a1a0)
        b : in  std_logic_vector(1 downto 0);  -- Deuxième opérande (b1b0)
        p : out std_logic_vector(3 downto 0)   -- Résultat (p3p2p1p0)
    );
end multiplier_2bits;

architecture dataflow of multiplier_2bits is
    -- Produits partiels
    signal pp00, pp01, pp10, pp11 : std_logic;
    
    -- Signaux intermédiaires pour les additions
    signal c1, c2 : std_logic;  -- Retenues
    
begin
    -- Génération des produits partiels (ET logique)
    pp00 <= a(0) and b(0);  -- a0 × b0
    pp01 <= a(0) and b(1);  -- a0 × b1
    pp10 <= a(1) and b(0);  -- a1 × b0
    pp11 <= a(1) and b(1);  -- a1 × b1
    
    -- Bit de poids faible p0
    p(0) <= pp00;
    
    -- Calcul bit p1 (demi-additionneur)
    p(1) <= pp01 xor pp10;
    c1 <= pp01 and pp10;
    
    -- Calcul bit p2 (demi-additionneur)
    p(2) <= pp11 xor c1;
    c2 <= pp11 and c1;
    
    -- Bit de poids fort p3
    p(3) <= c2;
    
end dataflow;
