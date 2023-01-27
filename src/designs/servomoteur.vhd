LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY servomoteur IS
    GENERIC (
        clockSpeed : NATURAL := 50 * 10 ** 6; -- 50MHz = 20 us/tick
        Period : NATURAL := 20; -- Period of PWM signal in milliseconds
        PulseWidthMin_ms : NATURAL := 1; -- Minimum pulse width in milliseconds
        PulseWidthMax_ms : NATURAL := 2 -- Maximum pulse width in milliseconds
    );
    PORT (
        clk : IN STD_LOGIC;
        Reset_n : IN STD_LOGIC;
        position : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        cmd : OUT STD_LOGIC
    );
END servomoteur;


ARCHITECTURE RTL OF SERVOMOTEUR IS
    TYPE StateType IS (E0, E1, E2);
    SIGNAL State : StateType;

    SIGNAL PulseWidthMin_ticks : Natural := PulseWidthMin_ms / 1000 * clockSpeed;
    SIGNAL PulseWidthMax_ticks : Natural := PulseWidthMax_ms / 1000 * clockSpeed;

    SIGNAL counter : Natural;

BEGIN
    PROCESS (clk, Reset_n)

        VARIABLE cnt : NATURAL RANGE 0 TO 500;
    BEGIN
        IF Reset_n = '0' THEN
            cmd <= '0';
            counter <= 0;
            State <= E0;

        ELSIF Rising_edge(clk) THEN

            CASE State IS
                WHEN E0 =>
                    counter <= 0;
                    State <= E1;

                WHEN E1 =>
                    -- high phase, should last at least PulseWidthMin
                    cmd <= '1';
                    counter <= counter + 1;
                    
                    IF counter > PulseWidthMin_ticks THEN
                        State <= E2;
                    END IF;

                WHEN E2 =>
                    -- low phase, 
                    cmd <= '0';
                    counter <= counter + 1;

                    IF cnt >= 1000000 THEN
                        cnt <= 0;
                        State <= E3;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE;