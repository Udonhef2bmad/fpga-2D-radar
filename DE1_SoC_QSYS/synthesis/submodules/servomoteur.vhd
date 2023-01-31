LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY servomoteur IS
    GENERIC (
        clockSpeed : NATURAL := 50 * 10 ** 6; -- 50MHz = 20 us/tick
        Period_ms : NATURAL := 20; -- Period of PWM signal in milliseconds
        PulseWidthMin_ms : NATURAL := 1; -- Minimum pulse width in milliseconds
        PulseWidthMax_ms : NATURAL := 2 -- Maximum pulse width in milliseconds
    );
    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        position : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        commande : OUT STD_LOGIC
    );
END servomoteur;


ARCHITECTURE RTL OF servomoteur IS
    TYPE StateType IS (E0, E1, E2);
    SIGNAL State : StateType;

    -- TODO change to constants
    SIGNAL PulseWidthMin_ticks : NATURAL := PulseWidthMin_ms * clockSpeed  / 1000;
    SIGNAL PulseWidthMax_ticks : NATURAL := PulseWidthMax_ms * clockSpeed  / 1000;
    SIGNAL Period_ticks : NATURAL := Period_ms * clockSpeed / 1000;

    SIGNAL Active_ticks : NATURAL ;

    SIGNAL counter : NATURAL;

BEGIN
    PROCESS (clk, rst_n)

        VARIABLE cnt : NATURAL RANGE 0 TO 500;
    BEGIN
        IF rst_n = '0' THEN
            commande <= '0';
            counter <= 0;
            State <= E0;

        ELSIF Rising_edge(clk) THEN

            CASE State IS
                WHEN E0 =>
                    counter <= 0;
                    State <= E1;

                WHEN E1 =>
                    -- high phase
                    commande <= '1';
                    counter <= counter + 1;

                    --Active_ticks <= to_integer(unsigned(position) * (PulseWidthMax_ticks - PulseWidthMin_ticks));
                    --Active_ticks <= PulseWidthMin_ticks + (to_integer(unsigned(position)) * PulseWidthMin_ticks) / 180;
                    Active_ticks <= PulseWidthMin_ticks + (to_integer(unsigned(position)) * (PulseWidthMax_ticks - PulseWidthMin_ticks) / (2**position'length)) ;


                    IF counter > Active_ticks  THEN
                        State <= E2;
                    END IF;

                WHEN E2 =>
                    -- low phase, 
                    commande <= '0';
                    counter <= counter + 1;

                    IF counter > Period_ticks THEN
                    State <= E0;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE;