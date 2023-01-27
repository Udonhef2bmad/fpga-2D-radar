LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY avalon_pwm_interface IS
    PORT (
        clk : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        chipselect : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        address : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
END avalon_pwm_interface;

ARCHITECTURE RTL OF avalon_pwm_interface IS

    SIGNAL div : unsigned (31 DOWNTO 0);
    SIGNAL duty : unsigned (31 DOWNTO 0);
    SIGNAL counter : unsigned (31 DOWNTO 0);
    SIGNAL pwm_on : STD_LOGIC;

BEGIN

    pwm_inst : ENTITY work.avalon_pwm
        PORT MAP(
            clk => clk,
            writedata => writedata,
            chipselect => chipselect,
            write_n => write_n,
            address => address,
            reset_n => reset_n,
            readdata => readdata,
            out_port => out_port
        );

END RTL;