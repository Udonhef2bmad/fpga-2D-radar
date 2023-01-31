LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY servomoteur_avalon_tb IS
END ENTITY;

ARCHITECTURE RTL OF servomoteur_avalon_tb IS

    -- 50MHz Clock period definition (do not modify)
    SIGNAL clock_period : TIME := 20 * ns;

    -- simulation signals (do not modify)
    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC;

    -- Test signals
    SIGNAL commande : STD_LOGIC;
    SIGNAL chipselect : STD_LOGIC;
    SIGNAL writedata : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL write_n : STD_LOGIC;

    SIGNAL position : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

    -- instantiate DUT
    test_inst : ENTITY work.servomoteur_avalon
        PORT MAP(
            clk => CLK,
            rst_n => RST,
            chipselect => chipselect,
            write_n => write_n,
            writedata => writedata,
            commande => commande
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

        --enable writing to the module
        writedata <= (OTHERS => '0');

        chipselect <= '0'; --deselect chip
        write_n <= '1'; -- don't write data

        writedata(9 DOWNTO 0) <= "0000000000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0000000001";
        WAIT FOR 20 ms;

        chipselect <= '1'; --select chip
        write_n <= '1'; -- don't write data

        writedata(9 DOWNTO 0) <= "0000000010";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0000000100";
        WAIT FOR 20 ms;

        chipselect <= '1'; --select chip
        write_n <= '0'; -- write data

        writedata(9 DOWNTO 0) <= "0000001000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0000010000";
        WAIT FOR 20 ms;

        chipselect <= '1'; --select chip
        write_n <= '1'; -- don't write data

        writedata(9 DOWNTO 0) <= "0000100000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0010000000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0100000000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "1000000000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "1111111111";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "0000000000";
        WAIT FOR 20 ms;

        writedata(9 DOWNTO 0) <= "1111111111";
        WAIT FOR 20 ms;

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