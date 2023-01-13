LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY TELEMETRE_US IS
    GENERIC (
        clock_freq : Natural := 1 / 50 * 10 ** 6; -- 50MHz = 20 us/tick
        -- v = d / t
        -- d = v * t
        signal_speed : Natural := 333120 -- signal speed in m/s
    );
    PORT (
        clk : IN STD_LOGIC;
        Reset_n : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        trig : OUT STD_LOGIC;
        Dist_cm : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END TELEMETRE_US;

ARCHITECTURE RTL OF TELEMETRE_US IS

    TYPE StateType IS (E0, E1, E2, E3, E4, E5);
    SIGNAL State : StateType;

    SIGNAL counter1 : INTEGER;
    SIGNAL counter2 : INTEGER;


    CONSTANT dist_per_tick : Natural := clock_freq * signal_speed / 2;
    CONSTANT trigger_delay : Natural := 500; 
    CONSTANT cooldown_delay : Natural := 0; 

BEGIN
    PROCESS (clk, Reset_n)

    BEGIN
        IF Reset_n = '0' THEN
            State <= E0;
            counter1 <= 0;
            counter2 <= 0;

        ELSIF Rising_edge(clk) THEN

            CASE State IS
                WHEN E0 =>
                    -- start sending trigger signal
                    trig <= '1';
                    counter2 <= 0; --reset counter 2
                    State <= E1;

                WHEN E1 =>
                    -- send trigger signal for a certain time
                    counter1 <= counter1 + 1; -- reset counter 1
                    IF counter1 > 500 THEN
                        --delay reached
                        trig <= '0'; -- stop sending trigger signal
                        State <= E2;
                    END IF;

                WHEN E2 =>
                    -- wait for echo 
                    IF echo = '1' THEN
                        -- echo signal received
                        counter2 <= 0;
                        State <= E3;
                    END IF;
                WHEN E3 =>
                    -- count until echo returns to low state
                    counter2 <= counter2 + 1;
                    IF echo = '0' THEN
                        -- echo returned to low state, distance is known
                        State <= E4;
                    END IF;

                    --IF counter2 > 50*10**6 THEN
                    --    -- echo returned to low state, distance is known
                    --    State <= E4;
                    --END IF;

                WHEN E4 =>
                    -- calculate distance
                    Dist_cm <= STD_LOGIC_VECTOR(to_unsigned(counter2 * dist_per_tick, Dist_cm'length));
                    State <= E5;
                WHEN E5 =>
                    -- wait before triggering again

                    -- reset counter1
                    State <= E0;
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE;