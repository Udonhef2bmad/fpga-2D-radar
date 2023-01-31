LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY telemetre_us_avalon IS
    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        chipselect : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        read_n : IN STD_LOGIC;
        dist_cm : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
        trig : OUT STD_LOGIC;
        echo : IN STD_LOGIC
    );
END telemetre_us_avalon;

ARCHITECTURE RTL OF telemetre_us_avalon IS

    SIGNAL i_dist_cm : STD_LOGIC_VECTOR (9 DOWNTO 0);

BEGIN

    PROCESS (chipselect, read_n)
    BEGIN
        IF chipselect = '1' and read_n = '0' then
            -- readdata(i_dist_cm'length-1 DOWNTO 0) <= i_dist_cm;
            readdata <= (31 DOWNTO i_dist_cm'length => '0') & i_dist_cm;
        END IF;
    END PROCESS;

    dist_cm <= i_dist_cm;

    telemeter : ENTITY work.telemetre_us
        PORT MAP(
            clk => clk,
            rst_n => rst_n,
            echo => echo,
            trig => trig,
            Dist_cm => i_dist_cm
        );

END RTL;