library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE1_SoC_Basic_Nios2_SOC is
port (
	-- Inputs
	CLOCK_50             : in std_logic;
	KEY                  : in std_logic_vector (3 downto 0);
	SW                   : in std_logic_vector (9 downto 0);
	----- ADC -------
	ADC_CONVST          : out std_logic;
	ADC_DIN             : out std_logic;
	ADC_DOUT            : in std_logic;
	ADC_SCLK            : out std_logic;
	
	
	-- Outputs
	LEDR            : out std_logic_vector (9 downto 0);
   HEX0            : out std_logic_vector (6 downto 0);
	HEX1            : out std_logic_vector (6 downto 0);
	HEX2            : out std_logic_vector (6 downto 0);
	HEX3            : out std_logic_vector (6 downto 0);
	HEX4            : out std_logic_vector (6 downto 0);
	HEX5            : out std_logic_vector (6 downto 0)
	
	);
end entity;


architecture struct of DE1_SoC_Basic_Nios2_SOC is
	 component DE1_SoC_QSYS is
        port (
            adc_ltc2308_conduit_end_CONVST  : out std_logic;                                       -- CONVST
            adc_ltc2308_conduit_end_SCK     : out std_logic;                                       -- SCK
            adc_ltc2308_conduit_end_SDI     : out std_logic;                                       -- SDI
            adc_ltc2308_conduit_end_SDO     : in  std_logic                    := 'X';             -- SDO
            clk_clk                         : in  std_logic                    := 'X';             -- clk
            key_external_connection_export  : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
            pll_sys_locked_export           : out std_logic;                                       -- export
            pll_sys_outclk2_clk             : out std_logic;                                       -- clk
            reset_reset_n                   : in  std_logic                    := 'X';             -- reset_n
            sw_external_connection_export   : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
            avalon_pwm_output_writedata     : out std_logic_vector(9 downto 0);                     -- writedata
				
				sevenseg_hex0                   : out std_logic_vector(6 downto 0);                    -- hex0
            sevenseg_hex1                   : out std_logic_vector(6 downto 0);                    -- hex1
            sevenseg_hex2                   : out std_logic_vector(6 downto 0);                    -- hex2
            sevenseg_hex3                   : out std_logic_vector(6 downto 0);                    -- hex3
            sevenseg_hex4                   : out std_logic_vector(6 downto 0);                    -- hex4
            sevenseg_hex5                   : out std_logic_vector(6 downto 0)
        );
    end component DE1_SoC_QSYS;

	  
begin
	u0 : component DE1_SoC_QSYS
		port map (
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
		
end architecture;