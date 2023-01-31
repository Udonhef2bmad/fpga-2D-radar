LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY servomoteur_avalon IS
    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        chipselect : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

        commande : OUT STD_LOGIC
    );
END servomoteur_avalon;
ARCHITECTURE RTL OF servomoteur_avalon IS

    SIGNAL i_position : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

    PROCESS (clk, rst_n)
    BEGIN
        IF rst_n = '0' THEN
            i_position <= (OTHERS => '0');
        ELSIF Rising_edge(clk) THEN
            IF chipselect = '1' AND write_n = '0' THEN
                i_position <= writedata(i_position'length - 1 DOWNTO 0);
            END IF;
        END IF;
END PROCESS;

servomoteur : ENTITY work.servomoteur
    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        position => i_position,
        commande => commande
    );

END ARCHITECTURE;