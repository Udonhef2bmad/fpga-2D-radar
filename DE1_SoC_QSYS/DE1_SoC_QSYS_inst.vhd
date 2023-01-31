	component DE1_SoC_QSYS is
		port (
			adc_ltc2308_conduit_end_CONVST      : out std_logic;                                       -- CONVST
			adc_ltc2308_conduit_end_SCK         : out std_logic;                                       -- SCK
			adc_ltc2308_conduit_end_SDI         : out std_logic;                                       -- SDI
			adc_ltc2308_conduit_end_SDO         : in  std_logic                    := 'X';             -- SDO
			avalon_servomoteur_conduit_commande : out std_logic;                                       -- commande
			avalon_seven_segment_conduit_hex0   : out std_logic_vector(6 downto 0);                    -- hex0
			avalon_seven_segment_conduit_hex1   : out std_logic_vector(6 downto 0);                    -- hex1
			avalon_seven_segment_conduit_hex2   : out std_logic_vector(6 downto 0);                    -- hex2
			avalon_seven_segment_conduit_hex3   : out std_logic_vector(6 downto 0);                    -- hex3
			avalon_seven_segment_conduit_hex4   : out std_logic_vector(6 downto 0);                    -- hex4
			avalon_seven_segment_conduit_hex5   : out std_logic_vector(6 downto 0);                    -- hex5
			avalon_telemetre_us_conduit_dist_cm : out std_logic_vector(9 downto 0);                    -- dist_cm
			avalon_telemetre_us_conduit_echo    : in  std_logic                    := 'X';             -- echo
			avalon_telemetre_us_conduit_trig    : out std_logic;                                       -- trig
			clk_clk                             : in  std_logic                    := 'X';             -- clk
			key_external_connection_export      : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			pll_sys_locked_export               : out std_logic;                                       -- export
			pll_sys_outclk2_clk                 : out std_logic;                                       -- clk
			reset_reset_n                       : in  std_logic                    := 'X';             -- reset_n
			sw_external_connection_export       : in  std_logic_vector(9 downto 0) := (others => 'X')  -- export
		);
	end component DE1_SoC_QSYS;

	u0 : component DE1_SoC_QSYS
		port map (
			adc_ltc2308_conduit_end_CONVST      => CONNECTED_TO_adc_ltc2308_conduit_end_CONVST,      --      adc_ltc2308_conduit_end.CONVST
			adc_ltc2308_conduit_end_SCK         => CONNECTED_TO_adc_ltc2308_conduit_end_SCK,         --                             .SCK
			adc_ltc2308_conduit_end_SDI         => CONNECTED_TO_adc_ltc2308_conduit_end_SDI,         --                             .SDI
			adc_ltc2308_conduit_end_SDO         => CONNECTED_TO_adc_ltc2308_conduit_end_SDO,         --                             .SDO
			avalon_servomoteur_conduit_commande => CONNECTED_TO_avalon_servomoteur_conduit_commande, --   avalon_servomoteur_conduit.commande
			avalon_seven_segment_conduit_hex0   => CONNECTED_TO_avalon_seven_segment_conduit_hex0,   -- avalon_seven_segment_conduit.hex0
			avalon_seven_segment_conduit_hex1   => CONNECTED_TO_avalon_seven_segment_conduit_hex1,   --                             .hex1
			avalon_seven_segment_conduit_hex2   => CONNECTED_TO_avalon_seven_segment_conduit_hex2,   --                             .hex2
			avalon_seven_segment_conduit_hex3   => CONNECTED_TO_avalon_seven_segment_conduit_hex3,   --                             .hex3
			avalon_seven_segment_conduit_hex4   => CONNECTED_TO_avalon_seven_segment_conduit_hex4,   --                             .hex4
			avalon_seven_segment_conduit_hex5   => CONNECTED_TO_avalon_seven_segment_conduit_hex5,   --                             .hex5
			avalon_telemetre_us_conduit_dist_cm => CONNECTED_TO_avalon_telemetre_us_conduit_dist_cm, --  avalon_telemetre_us_conduit.dist_cm
			avalon_telemetre_us_conduit_echo    => CONNECTED_TO_avalon_telemetre_us_conduit_echo,    --                             .echo
			avalon_telemetre_us_conduit_trig    => CONNECTED_TO_avalon_telemetre_us_conduit_trig,    --                             .trig
			clk_clk                             => CONNECTED_TO_clk_clk,                             --                          clk.clk
			key_external_connection_export      => CONNECTED_TO_key_external_connection_export,      --      key_external_connection.export
			pll_sys_locked_export               => CONNECTED_TO_pll_sys_locked_export,               --               pll_sys_locked.export
			pll_sys_outclk2_clk                 => CONNECTED_TO_pll_sys_outclk2_clk,                 --              pll_sys_outclk2.clk
			reset_reset_n                       => CONNECTED_TO_reset_reset_n,                       --                        reset.reset_n
			sw_external_connection_export       => CONNECTED_TO_sw_external_connection_export        --       sw_external_connection.export
		);

