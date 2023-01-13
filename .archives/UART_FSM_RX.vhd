

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- for unsigned to integer conversion

ENTITY UART_FSM_RX IS
    GENERIC (PSIZE : NATURAL := 8); --packet size
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        TICK_HALF_BIT : IN STD_LOGIC;
        CLEAR_FDIV : OUT STD_LOGIC; --/!\ inout?
        RX : IN STD_LOGIC;
        DATA_RX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ERROR_RX : OUT STD_LOGIC;
        END_RX : OUT STD_LOGIC;
        PARITY_MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE RTL OF UART_FSM_RX IS

    TYPE STATE_TYPE IS (
        ERR,
        E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11,
        READ_STATE,
        P_ODD,
        P_EVEN,
        P_STOP,
        P_WAIT
    ); -- Define the states
    SIGNAL STATE : STATE_TYPE := E1;

    SIGNAL DATA_RX_i : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL PARITY : STD_LOGIC; --track parity

BEGIN

    --DATA_RX <= DATA_RX_i;--update DATA_RX [moved at end of packet]

    PROCESS (RST, CLK)

        VARIABLE COUNT : NATURAL RANGE 0 TO PSIZE;
        --VARIABLE PARITY : NATURAL RANGE 0 TO PSIZE;--counts parity

    BEGIN

        IF (RST = '1') THEN
            STATE <= E1;
            CLEAR_FDIV <= '1';
            COUNT := 0;

        ELSIF rising_edge(CLK) THEN

            CASE STATE IS
                WHEN ERR => --error state
                    ERROR_RX <= '1';
                    STATE <= E1;
                    PARITY <= '0';

                WHEN E1 => --idle state
                    COUNT := 0;
                    END_RX <= '0';
                    ERROR_RX <= '0';
                    PARITY <= '0';
                    IF (RX = '0') THEN --receiving packet  
                        STATE <= E2;
                    END IF;

                WHEN E2 => --start state
                    CLEAR_FDIV <= '1';
                    STATE <= E3;

                WHEN E3 => --sync state
                    CLEAR_FDIV <= '0';
                    IF (TICK_HALF_BIT = '1') THEN
                        STATE <= E4;
                    END IF;

                WHEN E4 => --start bit check
                    IF (RX = '0') THEN
                        STATE <= E5;
                    ELSE --error
                        STATE <= ERR;
                    END IF;

                WHEN E5 => --Half tick delay (go to start bit end)
                    IF (TICK_HALF_BIT = '1') THEN
                        STATE <= E6;
                    END IF;

                WHEN E6 => --Half tick delay (go to data bit middle)
                    IF (TICK_HALF_BIT = '1') THEN --wait 1 tick
                        STATE <= READ_STATE;
                    END IF;

                    --TODO : merge state with E6
                WHEN READ_STATE => --read RX, update parity and increment counter
                    DATA_RX_i(COUNT) <= RX; --read data
                    IF (RX = '1') THEN --update parity
                        PARITY <= NOT PARITY;
                    END IF;
                    COUNT := COUNT + 1;
                    STATE <= E7;

                WHEN E7 => --loop state (go to data bit end)
                    IF (TICK_HALF_BIT = '1') THEN
                        IF (COUNT >= PSIZE) THEN --exit when done
                            STATE <= E8;
                        ELSE --loop if data remains
                            STATE <= E6;
                        END IF;
                    END IF;

                WHEN E8 => --Half tick delay (go to stop bit middle)
                    IF (TICK_HALF_BIT = '1') THEN
                        --PARITY CHECK MODE SELECT
                        CASE PARITY_MODE IS
                            WHEN "00" => STATE <= E10; --skip to stop bit
                            WHEN "01" => STATE <= P_ODD;
                            WHEN "10" => STATE <= P_EVEN;
                            WHEN OTHERS => STATE <= P_STOP; --avoid latch/default behavior
                        END CASE;
                        --STATE <= E9;
                    END IF;

                WHEN P_ODD => --odd parity bit
                    IF (PARITY /= RX) THEN
                        STATE <= P_WAIT; --parity check success
                    ELSE --error
                        STATE <= ERR; --parity check failure
                    END IF;

                WHEN P_EVEN => --even parity bit
                    IF (PARITY = RX) THEN
                        STATE <= P_WAIT; --parity check success
                    ELSE --error
                        STATE <= ERR; --parity check failure
                    END IF;

                WHEN P_STOP => --stop parity bit
                    IF (RX = '1') THEN
                        STATE <= P_WAIT; --parity check success
                    ELSE --error
                        STATE <= ERR; --parity check failure
                    END IF;

                WHEN P_WAIT => --wait 1 tick (go to stop bit start)
                    IF (TICK_HALF_BIT = '1') THEN
                        STATE <= E9;
                    END IF;

                WHEN E9 => --wait 1 tick (go to stop bit middle)
                    IF (TICK_HALF_BIT = '1') THEN
                        STATE <= E10;
                    END IF;

                WHEN E10 => --read stop bit
                    IF (RX = '1') THEN
                        STATE <= E11;
                    ELSE --error
                        STATE <= ERR;
                    END IF;

                WHEN E11 =>
                    DATA_RX <= DATA_RX_i;--update DATA_RX
                    END_RX <= '1'; --send end of packet signal
                    STATE <= E1; --reset state machine
            END CASE;

        END IF;
    END PROCESS;

END ARCHITECTURE;