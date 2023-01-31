LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY telemetre_us_tb IS
END ENTITY;

ARCHITECTURE RTL OF telemetre_us_tb IS

    -- 50MHz Clock period definition (do not modify)
    SIGNAL clock_period : TIME := 20 * ns;

    -- simulation signals (do not modify)
    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC; 

    -- Test signals
    signal echo : std_logic;
    signal trig : std_logic;
    signal dist_cm : std_logic_vector(9 downto 0);

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.telemetre_us
    port map (
        clk => CLK,
        rst_n => RST,
        echo => echo,
        dist_cm => dist_cm,
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
        WAIT FOR 0 ms; -- wait 0ms or (roughly 0cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 1 ms; -- wait 1ms or (roughly 17cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 2 ms; -- wait 2ms (roughly 34cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 4 ms; -- wait 4ms (roughly 68cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 8 ms; -- wait 8ms (roughly 137cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 16 ms; -- wait 16ms (roughly 274cm distance)
        echo <= '0'; -- HC SR04 signals echo end

        -- NOTICE -- 
        -- HC-SR04 cannot reach beyond 400cm distance
        -- module will simply set echo to HIGH if that is the case

        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 32 ms; -- wait 32ms (roughly 548cm distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 64 ms; -- wait 64ms (roughly 1096cm distance) -- note the distance is stored on 10 bits, so the distance will be truncated here
        echo <= '0'; -- HC SR04 signals echo end

        WAIT FOR 64 ms; 

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