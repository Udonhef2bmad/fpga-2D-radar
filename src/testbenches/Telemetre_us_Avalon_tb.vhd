LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.math_real.ALL;

ENTITY Telemetre_us_Avalon_tb IS
END ENTITY;

ARCHITECTURE RTL OF Telemetre_us_Avalon_tb IS

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
    signal dist_cm : std_logic_vector(9 downto 0);
    signal chipselect : STD_LOGIC;
    signal readdata : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal Read_n : STD_LOGIC;

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.Telemetre_us_Avalon
    port map (
        clk => CLK,
        reset_n => RST,
        chipselect => chipselect,
        readdata => readdata,
        Read_n => Read_n,
        dist_cm => dist_cm,
        trig => trig,
        echo => echo
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
        read_n <= '1'; --read data when low
        chipselect <= '0'; -- select chip when high

        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 1 ms; -- wait 1ms or 50 000 000 ticks; sound wave should cover 34.3cm round trip(roughly 17cm total distance)
        echo <= '0'; -- HC SR04 signals echo end
        --WAIT FOR 200 ms; --cooldown

        --user reads readddata
        WAIT FOR 10 us; -- wait some time
        chipselect <= '1'; --select chip
        read_n <= '0'; -- read data
        WAIT FOR 10 us; -- wait some time
        chipselect <= '0'; ---deselect chip
        read_n <= '1'; -- don't read data


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 2 ms; -- wait 2ms or 100 000 000 ticks; sound wave should cover 68.6cm round trip(roughly 34cm total distance)
        echo <= '0'; -- HC SR04 signals echo end


        wait until trig = '1'; -- HC SR04 waits for trigger
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react
        echo <= '1'; -- HC SR04
        WAIT FOR 4 ms; -- wait 4ms or 200 000 000 ticks; sound wave should cover 137.2cm round trip(roughly 68cm total distance)
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