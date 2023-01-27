LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY servomoteur_TB IS
END ENTITY;

ARCHITECTURE RTL OF servomoteur_TB IS

    -- 50MHz Clock period definition (do not modify)
    -- CONSTANT clock_period : TIME := 1 / (50 * 10**6);
    SIGNAL clock_period : TIME := 20 * ns;

    -- simulation signals (do not modify)
    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC;

    -- Test signals
    SIGNAL position : STD_LOGIC;
    SIGNAL cmd : STD_LOGIC;

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.servomoteur
        PORT MAP(
            clk => CLK,
            Reset_n => RST,
            position => position,
            cmd => cmd
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
        position <= '0';
        WAIT FOR 100 ms;
        position <= '1';
        WAIT FOR 200 ms;
        position <= '0';

        position <= '1';
        WAIT FOR 200 ms;
        position <= '0';

        -- simulation end (do not modify)
        ENDSIM <= '1';
        WAIT;
    END PROCESS;

    -- clock generator (do not modify)
    clk_gen : PROCESS
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