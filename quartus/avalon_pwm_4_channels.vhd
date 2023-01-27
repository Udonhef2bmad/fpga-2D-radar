LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY avalon_pwm_4_channels IS
    PORT (
        clk : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        chipselect : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Address is now 3 bits wide
        reset_n : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_port_0 : OUT STD_LOGIC; -- Output ports are now separate signals
        out_port_1 : OUT STD_LOGIC;
        out_port_2 : OUT STD_LOGIC;
        out_port_3 : OUT STD_LOGIC
    );
END avalon_pwm_4_channels;



ARCHITECTURE RTL OF avalon_pwm_4_channels IS

    TYPE div_array_type IS ARRAY (0 TO 3) OF unsigned (31 DOWNTO 0);
    TYPE duty_array_type IS ARRAY (0 TO 3) OF unsigned (31 DOWNTO 0);
    TYPE counter_array_type IS ARRAY (0 TO 3) OF unsigned (31 DOWNTO 0);
    TYPE pwm_on_array_type IS ARRAY (0 TO 3) OF STD_LOGIC;

    SIGNAL div : div_array_type;
    SIGNAL duty : duty_array_type;
    SIGNAL counter : counter_array_type;
    SIGNAL pwm_on : pwm_on_array_type;

    
    BEGIN
    FOR i IN 0 TO 3 GENERATE
        pwm_inst : pwm
            PORT MAP (
                clk => pwm_clk,
                writedata => pwm_writedata,
                chipselect => pwm_chipselect,
                write_n => pwm_write_n,
                address => pwm_address,
                reset_n => pwm_reset_n,
                readdata => pwm_readdata,
                out_port => pwm_out_port(i)
            );
    END GENERATE;

    out_port <= pwm_out_port;
END RTL;