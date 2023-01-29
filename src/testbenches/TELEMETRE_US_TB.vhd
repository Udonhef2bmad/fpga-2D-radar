LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.math_real.ALL;

ENTITY TELEMETRE_US_TB IS
END ENTITY;

ARCHITECTURE RTL OF TELEMETRE_US_TB IS

    -- 50MHz Clock period definition (do not modify)
    -- CONSTANT clock_period : TIME := 1 / (50 * 10**6);
    SIGNAL clock_period : TIME := 20 * ns;

    -- simulation signals (do not modify)
    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC; 

    -- Test signals
    signal echo : std_logic;
    signal trig : std_logic;
    signal Dist_cm : std_logic_vector(9 downto 0);

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.TELEMETRE_US
    port map (
        clk => CLK,
        Reset_n => RST,
        echo => echo,
        Dist_cm => Dist_cm,
        trig => trig
    );


    -- test process
    test_proc : PROCESS
    BEGIN
        -- simulation init (do not modify)
        RST <= '0';
        ENDSIM <= '0';
        WAIT FOR 0.02 us;
        RST <= '1'; -- reset is active low (device works when rst=1)

        -- test here

        echo <= '0'; --echo pin default state

        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 1 ms; -- wait 1ms or 50 000 000 ticks; sound wave should cover 34.3cm round trip(roughly 17cm total distance)
        echo <= '0'; -- HC SR04 signals echo end
        --WAIT FOR 200 ms; --cooldown


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 2 ms; -- wait 2ms
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 4 ms; -- wait 4ms 
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 8 ms; -- wait 8ms
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 16 ms; 
        echo <= '0'; -- HC SR04 signals echo end

        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 32 ms; 
        echo <= '0'; -- HC SR04 signals echo end

        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 64 ms; 
        echo <= '0'; -- HC SR04 signals echo end

        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 128 ms; 
        echo <= '0'; -- HC SR04 signals echo end

        wait until trig = '1'; -- HC SR04 waits for trigger
        echo <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 256 ms; 
        echo <= '0'; -- HC SR04 signals echo end

        



        WAIT FOR 10 ms; 



        -- simulation end (do not modify)
        ENDSIM <= '1';
        WAIT;
    END PROCESS;

        -- clock generator (do not modify)
        clk_gen  : PROCESS
        BEGIN
            IF (ENDSIM = '1') THEN
                WAIT;
            ELSE
                CLK <= '0';
                WAIT FOR clock_period/2;
                CLK <= '1';
                WAIT FOR clock_period/2;
            END IF;
        END PROCESS;
    
END ARCHITECTURE;