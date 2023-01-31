LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY telemetre_us IS
    GENERIC (
        clock_freq : NATURAL := 50 * 10 ** 6; -- 50MHz = 20 us/tick
        propagation_speed : NATURAL := 34300 -- sound propagation speed in cm/s
    );
    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        trig : OUT STD_LOGIC;
        dist_cm : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END telemetre_us;

ARCHITECTURE RTL OF telemetre_us IS

    TYPE StateType IS (E0, E1, E2, E3, E4, E5);
    SIGNAL State : StateType;
    signal echo_r, echo_rr : std_logic;
    SIGNAL counter1 : INTEGER;
    SIGNAL counter2 : INTEGER;

    CONSTANT trigger_duration_ticks : NATURAL := 5 * 10 ** 2;-- trigger pin high duration in ms (10us = 500ticks@50MHz)
    CONSTANT module_cooldown_ticks : NATURAL := 5 * 10 ** 6;-- minimal delay before module can be triggered again (100ms = 5000000ticks@50MHz)


BEGIN

    PROCESS (clk, rst_n)
    BEGIN
        IF rst_n = '0' THEN
            State <= E0;
            counter1 <= 0;
            counter2 <= 0;

        ELSIF Rising_edge(clk) THEN
		  
				echo_r <= echo; 
				echo_rr <= echo_r; 

            CASE State IS
                WHEN E0 =>
                    counter2 <= 0; --reset counter 2
                    State <= E1;

                WHEN E1 =>
                    trig <= '1'; -- start sending trigger signal
                    counter1 <= counter1 + 1; -- count trigger duration

                    IF counter1 > trigger_duration_ticks THEN --delay reached
                        State <= E2;
                    END IF;

                WHEN E2 =>
                    trig <= '0'; -- stop sending trigger signal

                    IF echo_rr = '1' THEN -- wait for echo high
                        counter2 <= 0;
                        State <= E3;
                    END IF;

                WHEN E3 =>
                    counter2 <= counter2 + 1; -- count echo duration
                    IF echo_rr = '0' THEN -- wait for echo low
                        State <= E4;
                    END IF;

                WHEN E4 =>
                    -- calculate distance based on counter value
                    --dist_cm <= STD_LOGIC_VECTOR(to_unsigned(counter2 * propagation_speed / (2*clock_freq), dist_cm'length));
                    dist_cm <= STD_LOGIC_VECTOR(to_unsigned(counter2 * 343 / 1000000, dist_cm'length));

                    State <= E5;

                WHEN E5 =>
                    -- wait before triggering again
                    counter1 <= 0; --reset counter 1
                    counter2 <= counter2 + 1; -- count up to min cooldown

                    IF counter2 > module_cooldown_ticks THEN --cooldown elapsed, ready for another reading
                        State <= E0;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE;