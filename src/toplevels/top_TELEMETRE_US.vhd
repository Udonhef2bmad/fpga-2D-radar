LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY top_TELEMETRE_US IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        GPIO_0 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCT OF top_TELEMETRE_US IS
BEGIN

    telemeter : ENTITY work.TELEMETRE_US
        PORT MAP(
            clk => CLOCK_50,
            Reset_n => KEY(0),
            echo => GPIO_0(3),
            trig => GPIO_0(1),
            Dist_cm => LEDR
        );

END ARCHITECTURE;