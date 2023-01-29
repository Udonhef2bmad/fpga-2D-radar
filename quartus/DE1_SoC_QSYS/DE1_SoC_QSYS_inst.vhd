	component DE1_SoC_QSYS is
		port (
			adc_ltc2308_conduit_end_CONVST     : out std_logic;                                       -- CONVST
			adc_ltc2308_conduit_end_SCK        : out std_logic;                                       -- SCK
			adc_ltc2308_conduit_end_SDI        : out std_logic;                                       -- SDI
			adc_ltc2308_conduit_end_SDO        : in  std_logic                    := 'X';             -- SDO
			avalon_telemetre_us_output_trig    : out std_logic;                                       -- trig
			avalon_telemetre_us_output_echo    : in  std_logic                    := 'X';             -- echo
			avalon_telemetre_us_output_dist_cm : out std_logic_vector(9 downto 0);                    -- dist_cm
			clk_clk                            : in  std_logic                    := 'X';             -- clk
			key_external_connection_export     : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			pll_sys_locked_export              : out std_logic;                                       -- export
			pll_sys_outclk2_clk                : out std_logic;                                       -- clk
			reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
			sevenseg_hex0                      : out std_logic_vector(6 downto 0);                    -- hex0
			sevenseg_hex1                      : out std_logic_vector(6 downto 0);                    -- hex1
			sevenseg_hex2                      : out std_logic_vector(6 downto 0);                    -- hex2
			sevenseg_hex3                      : out std_logic_vector(6 downto 0);                    -- hex3
			sevenseg_hex4                      : out std_logic_vector(6 downto 0);                    -- hex4
			sevenseg_hex5                      : out std_logic_vector(6 downto 0);                    -- hex5
			sw_external_connection_export      : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
			avalon_servomoteur_output_commande : out std_logic                                        -- commande
		);
	end component DE1_SoC_QSYS;

	u0 : component DE1_SoC_QSYS
		port map (
			adc_ltc2308_conduit_end_CONVST     => CONNECTED_TO_adc_ltc2308_conduit_end_CONVST,     --    adc_ltc2308_conduit_end.CONVST
			adc_ltc2308_conduit_end_SCK        => CONNECTED_TO_adc_ltc2308_conduit_end_SCK,        --                           .SCK
			adc_ltc2308_conduit_end_SDI        => CONNECTED_TO_adc_ltc2308_conduit_end_SDI,        --                           .SDI
			adc_ltc2308_conduit_end_SDO        => CONNECTED_TO_adc_ltc2308_conduit_end_SDO,        --                           .SDO
			avalon_telemetre_us_output_trig    => CONNECTED_TO_avalon_telemetre_us_output_trig,    -- avalon_telemetre_us_output.trig
			avalon_telemetre_us_output_echo    => CONNECTED_TO_avalon_telemetre_us_output_echo,    --                           .echo
			avalon_telemetre_us_output_dist_cm => CONNECTED_TO_avalon_telemetre_us_output_dist_cm, --                           .dist_cm
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                        clk.clk
			key_external_connection_export     => CONNECTED_TO_key_external_connection_export,     --    key_external_connection.export
			pll_sys_locked_export              => CONNECTED_TO_pll_sys_locked_export,              --             pll_sys_locked.export
			pll_sys_outclk2_clk                => CONNECTED_TO_pll_sys_outclk2_clk,                --            pll_sys_outclk2.clk
			reset_reset_n                      => CONNECTED_TO_reset_reset_n,                      --                      reset.reset_n
			sevenseg_hex0                      => CONNECTED_TO_sevenseg_hex0,                      --                   sevenseg.hex0
			sevenseg_hex1                      => CONNECTED_TO_sevenseg_hex1,                      --                           .hex1
			sevenseg_hex2                      => CONNECTED_TO_sevenseg_hex2,                      --                           .hex2
			sevenseg_hex3                      => CONNECTED_TO_sevenseg_hex3,                      --                           .hex3
			sevenseg_hex4                      => CONNECTED_TO_sevenseg_hex4,                      --                           .hex4
			sevenseg_hex5                      => CONNECTED_TO_sevenseg_hex5,                      --                           .hex5
			sw_external_connection_export      => CONNECTED_TO_sw_external_connection_export,      --     sw_external_connection.export
			avalon_servomoteur_output_commande => CONNECTED_TO_avalon_servomoteur_output_commande  --  avalon_servomoteur_output.commande
		);

