LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Telemetre_us_Avalon IS
    PORT (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        chipselect : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        read_n : IN STD_LOGIC;
        dist_cm : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
        trig : OUT STD_LOGIC;
        echo : IN STD_LOGIC
    );
END Telemetre_us_Avalon;

ARCHITECTURE RTL OF Telemetre_us_Avalon IS

    signal i_dist_cm : STD_LOGIC_VECTOR (9 DOWNTO 0);

BEGIN

    readdata <= (31 downto i_dist_cm'length => '0') & i_dist_cm;

    dist_cm <= i_dist_cm;

    telemeter : ENTITY work.TELEMETRE_US
        PORT MAP(
            clk => clk,
            Reset_n => reset_n,
            echo => echo,
            trig => trig,
            Dist_cm => i_dist_cm
        );

END RTL;