LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY servomoteur_top IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        GPIO_0 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCT OF servomoteur_top IS
BEGIN

    LEDR <= SW;

    servomoteur_0 : ENTITY work.servomoteur
        PORT MAP(
            clk => CLOCK_50,
            rst_n => KEY(0),
            position => SW,
            commande => GPIO_0(5)
        );

END ARCHITECTURE;