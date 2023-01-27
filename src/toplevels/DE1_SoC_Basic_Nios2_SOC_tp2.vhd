LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DE1_SoC_Basic_Nios2_SOC IS
    PORT (
        -- Inputs
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        ----- ADC -------
        ADC_CONVST : OUT STD_LOGIC;
        ADC_DIN : OUT STD_LOGIC;
        ADC_DOUT : IN STD_LOGIC;
        ADC_SCLK : OUT STD_LOGIC;
        -- Outputs
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
        HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

    );
END ENTITY;
ARCHITECTURE struct OF DE1_SoC_Basic_Nios2_SOC IS
    COMPONENT DE1_SoC_QSYS IS
        PORT (
            adc_ltc2308_conduit_end_CONVST : OUT STD_LOGIC; -- CONVST
            adc_ltc2308_conduit_end_SCK : OUT STD_LOGIC; -- SCK
            adc_ltc2308_conduit_end_SDI : OUT STD_LOGIC; -- SDI
            adc_ltc2308_conduit_end_SDO : IN STD_LOGIC := 'X'; -- SDO
            clk_clk : IN STD_LOGIC := 'X'; -- clk
            key_external_connection_export : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => 'X'); -- export
            pll_sys_locked_export : OUT STD_LOGIC; -- export
            pll_sys_outclk2_clk : OUT STD_LOGIC; -- clk
            reset_reset_n : IN STD_LOGIC := 'X'; -- reset_n
            sw_external_connection_export : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => 'X'); -- export
            avalon_pwm_output_writedata : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- writedata

            sevenseg_hex0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- hex0
            sevenseg_hex1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- hex1
            sevenseg_hex2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- hex2
            sevenseg_hex3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- hex3
            sevenseg_hex4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- hex4
            sevenseg_hex5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT DE1_SoC_QSYS;
BEGIN
    u0 : COMPONENT DE1_SoC_QSYS
        PORT MAP(
            clk_clk => CLOCK_50,
            reset_reset_n => KEY(0),
            adc_ltc2308_conduit_end_CONVST => ADC_CONVST,
            adc_ltc2308_conduit_end_SCK => ADC_SCLK,
            adc_ltc2308_conduit_end_SDI => ADC_DIN,
            adc_ltc2308_conduit_end_SDO => ADC_DOUT,
            sw_external_connection_export => SW,
            key_external_connection_export => KEY,
            avalon_pwm_output_writedata => LEDR, --new leds
            sevenseg_hex0 => HEX0,
            sevenseg_hex1 => HEX1,
            sevenseg_hex2 => HEX2,
            sevenseg_hex3 => HEX3,
            sevenseg_hex4 => HEX4,
            sevenseg_hex5 => HEX5
        );

    END ARCHITECTURE;