LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.math_real.ALL;

ENTITY test_tb IS
END ENTITY;

ARCHITECTURE RTL OF test_tb IS

    -- 50MHz Clock period definition (do not modify)
    -- CONSTANT clock_period : TIME := 1 / (50 * 10**6);
    CONSTANT clock_period : TIME := 20 ns;

    -- simulation signals (do not modify)
    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC; 

    -- Test signals
    
    signal a_i, b_i : std_logic := '0';
    signal combinatorial_o, clocked_o : std_logic;

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.test
    port map (
        clk_i => CLK,
        a_i => a_i,
        b_i => b_i,
        combinatorial_o => combinatorial_o,
        clocked_o => clocked_o
    );


    -- test process
    test_proc : PROCESS
    BEGIN
        -- simulation init (do not modify)
        RST <= '1';
        ENDSIM <= '0';
        WAIT FOR 0.02 us;
        RST <= '0';

        -- test here

        -- set initial values
        a_i <= '0';
        b_i <= '0';
        
        -- wait for 2 clock cycles
        wait for 20 ns;
        
        -- change input values and wait for 2 more clock cycles
        a_i <= '1';
        b_i <= '1';
        wait for 20 ns;


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