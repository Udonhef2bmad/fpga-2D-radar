LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY top_servomoteur IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        GPIO_0 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCT OF top_servomoteur IS
BEGIN

    LEDR <= SW;

    servomotor : ENTITY work.servomoteur
        PORT MAP(
            clk => CLOCK_50,
            Reset_n => KEY(0),
            position => SW,
            commande => GPIO_0(5)
        );

END ARCHITECTURE;