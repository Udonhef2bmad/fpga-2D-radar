LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY avalon_pwm_1_channel IS
    PORT (
        clk : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        chipselect : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        address : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_port : OUT STD_LOGIC
    );
END avalon_pwm_1_channel;

ARCHITECTURE RTL OF avalon_pwm_1_channel IS

    SIGNAL div : unsigned (31 DOWNTO 0);
    SIGNAL duty : unsigned (31 DOWNTO 0);
    SIGNAL counter : unsigned (31 DOWNTO 0);
    SIGNAL pwm_on : STD_LOGIC;

BEGIN

    readdata <= STD_LOGIC_VECTOR(div) WHEN address = '0' ELSE
        STD_LOGIC_VECTOR(duty);

    registers : PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            div <= (OTHERS => '0');
            duty <= (OTHERS => '0');
        ELSIF clk'event AND clk = '1' THEN
            IF chipselect = '1' AND write_n = '0' THEN
                IF address = '0' THEN
                    div <= unsigned(writedata);
                ELSE
                    duty <= unsigned(writedata);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    divider : PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            counter <= (OTHERS => '0');
        ELSIF clk'event AND clk = '1' THEN
            IF counter >= div THEN
                counter <= (OTHERS => '0');
            ELSE
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;

    duty_cyle : PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            pwm_on <= '1';
        ELSIF clk'event AND clk = '1' THEN
            IF counter >= duty THEN
                pwm_on <= '0';
            ELSIF counter = 0 THEN
                pwm_on <= '1';
            END IF;
        END IF;
    END PROCESS;

    out_port <= pwm_on;

END RTL;