
module DE1_SoC_QSYS (
	adc_ltc2308_conduit_end_CONVST,
	adc_ltc2308_conduit_end_SCK,
	adc_ltc2308_conduit_end_SDI,
	adc_ltc2308_conduit_end_SDO,
	avalon_telemetre_us_output_trig,
	avalon_telemetre_us_output_echo,
	avalon_telemetre_us_output_dist_cm,
	clk_clk,
	key_external_connection_export,
	pll_sys_locked_export,
	pll_sys_outclk2_clk,
	reset_reset_n,
	sevenseg_hex0,
	sevenseg_hex1,
	sevenseg_hex2,
	sevenseg_hex3,
	sevenseg_hex4,
	sevenseg_hex5,
	sw_external_connection_export,
	avalon_servomoteur_output_commande);	

	output		adc_ltc2308_conduit_end_CONVST;
	output		adc_ltc2308_conduit_end_SCK;
	output		adc_ltc2308_conduit_end_SDI;
	input		adc_ltc2308_conduit_end_SDO;
	output		avalon_telemetre_us_output_trig;
	input		avalon_telemetre_us_output_echo;
	output	[9:0]	avalon_telemetre_us_output_dist_cm;
	input		clk_clk;
	input	[3:0]	key_external_connection_export;
	output		pll_sys_locked_export;
	output		pll_sys_outclk2_clk;
	input		reset_reset_n;
	output	[6:0]	sevenseg_hex0;
	output	[6:0]	sevenseg_hex1;
	output	[6:0]	sevenseg_hex2;
	output	[6:0]	sevenseg_hex3;
	output	[6:0]	sevenseg_hex4;
	output	[6:0]	sevenseg_hex5;
	input	[9:0]	sw_external_connection_export;
	output		avalon_servomoteur_output_commande;
endmodule
