LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY avalon_pwm_generic IS
    PORT (
        clk : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        chipselect : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);  -- Address is now 3 bits wide
        reset_n : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_port_0 : OUT STD_LOGIC;  -- Output ports are now separate signals
        out_port_1 : OUT STD_LOGIC;
        out_port_2 : OUT STD_LOGIC;
        out_port_3 : OUT STD_LOGIC
    );
END avalon_pwm_generic;


ARCHITECTURE RTL OF avalon_pwm_generic IS

    CONSTANT NUM_CHANNELS : NATURAL := 4;

    TYPE div_array_type IS ARRAY (0 TO NUM_CHANNELS-1) OF unsigned (31 DOWNTO 0);
    TYPE duty_array_type IS ARRAY (0 TO NUM_CHANNELS-1) OF unsigned (31 DOWNTO 0);
    TYPE counter_array_type IS ARRAY (0 TO NUM_CHANNELS-1) OF unsigned (31 DOWNTO 0);
    TYPE pwm_on_array_type IS ARRAY (0 TO NUM_CHANNELS-1) OF STD_LOGIC;

    SIGNAL div : div_array_type;
    SIGNAL duty : duty_array_type;
    SIGNAL counter : counter_array_type;
    SIGNAL pwm_on : pwm_on_array_type;

BEGIN

    readdata <= (OTHERS => '0');  -- Initialize readdata to all 0s
    FOR i IN 0 TO NUM_CHANNELS-1 LOOP
        readdata(i*8+7 DOWNTO i*8) <= STD_LOGIC_VECTOR(div(i)) WHEN address(2 DOWNTO 1) = conv_std_logic_vector(i*2, 2) ELSE
                                    STD_LOGIC_VECTOR(duty(i));
    END LOOP;

    registers : PROCESS (clk, reset_n)
    BEGIN
        FOR i IN 0 TO NUM_CHANNELS-1 LOOP
            IF reset_n = '0' THEN
                div(i) <= (OTHERS => '0');
                duty(i) <= (OTHERS => '0');
            ELSIF clk'event AND clk = '1' THEN
                IF chipselect = '1' AND write_n = '0' THEN
                    IF address(2 DOWNTO 1) = conv_std_logic_vector(i*2, 2) THEN
                        div(i) <= unsigned(writedata(i*8+7 DOWNTO i*8));
                    ELSIF address(2 DOWNTO 1) = conv_std_logic_vector(i*2+1, 2) THEN
                        duty(i) <= unsigned(writedata(i*8+7 DOWNTO i*8));
                    END IF;
                END IF;
            END IF;
        END LOOP;
    END PROCESS;

    divider : PROCESS (clk, reset_n)
    BEGIN
        FOR i IN 0 TO NUM_CHANNELS-1 LOOP
            IF reset_n = '0' THEN
                counter(i) <= (OTHERS => '0');
            ELSIF clk'event AND clk = '1' THEN
                IF counter(i) >= div(i) THEN
                    counter(i) <= (OTHERS => '0');
                ELSE
                    counter(i) <= counter(i) + 1;
                END IF;
            END IF;
        END LOOP;
    END PROCESS;

    duty_cycle : PROCESS (clk, reset_n)
    BEGIN
        FOR i IN 0 TO NUM_CHANN