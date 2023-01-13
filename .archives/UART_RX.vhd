LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- for unsigned to integer conversion

ENTITY UART_RX IS
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        RX : IN STD_LOGIC;
        DATA_RX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ERROR_RX : OUT STD_LOGIC;
        END_RX : OUT STD_LOGIC;
        BPS_MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PARITY_MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE RTL OF UART_RX IS

    SIGNAL TICK_HALF_BIT_MODES : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL TICK_HALF_BIT : STD_LOGIC;

    SIGNAL RST_i : STD_LOGIC;
    SIGNAL CLEAR_FDIV_i : STD_LOGIC;

BEGIN

    TICK_HALF_BIT <= TICK_HALF_BIT_MODES(to_integer(unsigned(BPS_MODE))); --select bit mode

    RST_i <= RST OR CLEAR_FDIV_i; --combine external and internal reset
    FDIV_1 : ENTITY work.FDIV
        GENERIC MAP(FCLOCK => 50E6) -- set system clock speed
        PORT MAP(
            CLK => CLK,
            RST => RST_i,
            HALF_TICK_115200 => TICK_HALF_BIT_MODES(3),
            HALF_TICK_57600 => TICK_HALF_BIT_MODES(2),
            HALF_TICK_19200 => TICK_HALF_BIT_MODES(1),
            HALF_TICK_9600 => TICK_HALF_BIT_MODES(0),

            TICK_115200 => OPEN,
            TICK_57600 => OPEN,
            TICK_19200 => OPEN,
            TICK_9600 => OPEN
        );

    UART_FSM_RX_1 : ENTITY work.UART_FSM_RX
        GENERIC MAP(PSIZE => 8) --packet size
        PORT MAP(
            CLK => CLK,
            RST => RST,
            TICK_HALF_BIT => TICK_HALF_BIT,
            CLEAR_FDIV => CLEAR_FDIV_i,
            RX => RX,
            DATA_RX => DATA_RX,
            ERROR_RX => ERROR_RX,
            END_RX => END_RX,
            PARITY_MODE => PARITY_MODE
        );

END ARCHITECTURE;