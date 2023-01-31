
module DE1_SoC_QSYS (
	adc_ltc2308_conduit_end_CONVST,
	adc_ltc2308_conduit_end_SCK,
	adc_ltc2308_conduit_end_SDI,
	adc_ltc2308_conduit_end_SDO,
	avalon_servomoteur_conduit_commande,
	avalon_seven_segment_conduit_hex0,
	avalon_seven_segment_conduit_hex1,
	avalon_seven_segment_conduit_hex2,
	avalon_seven_segment_conduit_hex3,
	avalon_seven_segment_conduit_hex4,
	avalon_seven_segment_conduit_hex5,
	avalon_telemetre_us_conduit_dist_cm,
	avalon_telemetre_us_conduit_echo,
	avalon_telemetre_us_conduit_trig,
	clk_clk,
	key_external_connection_export,
	pll_sys_locked_export,
	pll_sys_outclk2_clk,
	reset_reset_n,
	sw_external_connection_export);	

	output		adc_ltc2308_conduit_end_CONVST;
	output		adc_ltc2308_conduit_end_SCK;
	output		adc_ltc2308_conduit_end_SDI;
	input		adc_ltc2308_conduit_end_SDO;
	output		avalon_servomoteur_conduit_commande;
	output	[6:0]	avalon_seven_segment_conduit_hex0;
	output	[6:0]	avalon_seven_segment_conduit_hex1;
	output	[6:0]	avalon_seven_segment_conduit_hex2;
	output	[6:0]	avalon_seven_segment_conduit_hex3;
	output	[6:0]	avalon_seven_segment_conduit_hex4;
	output	[6:0]	avalon_seven_segment_conduit_hex5;
	output	[9:0]	avalon_telemetre_us_conduit_dist_cm;
	input		avalon_telemetre_us_conduit_echo;
	output		avalon_telemetre_us_conduit_trig;
	input		clk_clk;
	input	[3:0]	key_external_connection_export;
	output		pll_sys_locked_export;
	output		pll_sys_outclk2_clk;
	input		reset_reset_n;
	input	[9:0]	sw_external_connection_export;
endmodule
