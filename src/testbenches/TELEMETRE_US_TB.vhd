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
        RST <= '1'; -- reset is active low (aka device works when rst=1)

        -- test here


        -- set initial values
        echo <= '0';
        --trig <= '0';
        WAIT FOR 10 us; -- HC SR04 takes 10 us to react

        -- HC SR04 sends out ultrasound

        --echo returns
        wait for 8 ms; -- wait 8ms or 8*50 000 000 ticks
        echo <= '1'; -- HC SR04 signals returning echo

        WAIT FOR 16 ms;
        echo <= '0'; -- HC SR04 signals echo end


        WAIT FOR 16 ms;
        --check distance value


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