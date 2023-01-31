LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY telemetre_servomoteur_top IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        GPIO_0 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCT OF telemetre_servomoteur_top IS

    signal dist_cm : STD_LOGIC_VECTOR (9 DOWNTO 0);

BEGIN

    LEDR <= dist_cm;

    telemetre_0 : ENTITY work.telemetre_us
        PORT MAP(
            clk => CLOCK_50,
            rst_n => KEY(0),
            echo => GPIO_0(3),
            trig => GPIO_0(1),
            dist_cm => dist_cm
        );

    servomoteur_0 : ENTITY work.servomoteur
        PORT MAP(
            clk => CLOCK_50,
            rst_n => KEY(0),
            position => dist_cm(7 downto 0) & "00",
            commande => GPIO_0(5)
        );

END ARCHITECTURE;