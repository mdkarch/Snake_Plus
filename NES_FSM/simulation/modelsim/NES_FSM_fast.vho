-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 32-bit"
-- VERSION "Version 12.1 Build 177 11/07/2012 SJ Full Version"

-- DATE "04/18/2013 17:03:58"

-- 
-- Device: Altera EP2C35F672C6 Package FBGA672
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEII;
LIBRARY IEEE;
LIBRARY STD;
USE CYCLONEII.CYCLONEII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE STD.STANDARD.ALL;

ENTITY 	controller IS
    PORT (
	clk : IN std_logic;
	latch : OUT std_logic;
	pulse : OUT std_logic;
	data : IN std_logic;
	leds : OUT std_logic_vector(15 DOWNTO 0);
	counter_c : OUT STD.STANDARD.integer
	);
END controller;

-- Design Ports Information
-- latch	=>  Location: PIN_B9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- pulse	=>  Location: PIN_F13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- data	=>  Location: PIN_C13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- leds[0]	=>  Location: PIN_F14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[1]	=>  Location: PIN_B10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[2]	=>  Location: PIN_C11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[3]	=>  Location: PIN_G12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[4]	=>  Location: PIN_A10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[5]	=>  Location: PIN_J10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[6]	=>  Location: PIN_G13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[7]	=>  Location: PIN_J14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[8]	=>  Location: PIN_D12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[9]	=>  Location: PIN_J11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[10]	=>  Location: PIN_D11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[11]	=>  Location: PIN_A14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[12]	=>  Location: PIN_F12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[13]	=>  Location: PIN_G11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[14]	=>  Location: PIN_B14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- leds[15]	=>  Location: PIN_D14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[0]	=>  Location: PIN_B7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[1]	=>  Location: PIN_F9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[2]	=>  Location: PIN_D8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[3]	=>  Location: PIN_C9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[4]	=>  Location: PIN_F11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[5]	=>  Location: PIN_C8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[6]	=>  Location: PIN_B16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[7]	=>  Location: PIN_H8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[8]	=>  Location: PIN_B12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[9]	=>  Location: PIN_H11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[10]	=>  Location: PIN_D6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[11]	=>  Location: PIN_D7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[12]	=>  Location: PIN_E10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[13]	=>  Location: PIN_G10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[14]	=>  Location: PIN_H12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[15]	=>  Location: PIN_C7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[16]	=>  Location: PIN_A8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[17]	=>  Location: PIN_A7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[18]	=>  Location: PIN_B8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[19]	=>  Location: PIN_E8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[20]	=>  Location: PIN_G9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[21]	=>  Location: PIN_H10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[22]	=>  Location: PIN_A9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[23]	=>  Location: PIN_D10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[24]	=>  Location: PIN_C10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[25]	=>  Location: PIN_J13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[26]	=>  Location: PIN_D9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[27]	=>  Location: PIN_B11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[28]	=>  Location: PIN_E12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[29]	=>  Location: PIN_G14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[30]	=>  Location: PIN_F10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- counter_c[31]	=>  Location: PIN_C12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- clk	=>  Location: PIN_P2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF controller IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_latch : std_logic;
SIGNAL ww_pulse : std_logic;
SIGNAL ww_data : std_logic;
SIGNAL ww_leds : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_counter_c : std_logic_vector(31 DOWNTO 0);
SIGNAL \clk~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clock_60hz_counter[3]~38_combout\ : std_logic;
SIGNAL \clock_60hz_counter[5]~42_combout\ : std_logic;
SIGNAL \clock_60hz_counter[6]~44_combout\ : std_logic;
SIGNAL \clock_60hz_counter[8]~48_combout\ : std_logic;
SIGNAL \clock_60hz_counter[10]~52_combout\ : std_logic;
SIGNAL \clock_60hz_counter[12]~56_combout\ : std_logic;
SIGNAL \clock_60hz_counter[19]~70_combout\ : std_logic;
SIGNAL \clock_60hz_counter[24]~80_combout\ : std_logic;
SIGNAL \clock_60hz_counter[26]~84_combout\ : std_logic;
SIGNAL \LessThan1~1_combout\ : std_logic;
SIGNAL \LessThan2~3_combout\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \LessThan0~1_combout\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \LessThan1~11_combout\ : std_logic;
SIGNAL \clk~combout\ : std_logic;
SIGNAL \clk~clkctrl_outclk\ : std_logic;
SIGNAL \counter[0]~32_combout\ : std_logic;
SIGNAL \counter[11]~55\ : std_logic;
SIGNAL \counter[12]~57\ : std_logic;
SIGNAL \counter[13]~58_combout\ : std_logic;
SIGNAL \clock_60hz_counter[0]~32_combout\ : std_logic;
SIGNAL \clock_60hz_counter[0]~33\ : std_logic;
SIGNAL \clock_60hz_counter[1]~34_combout\ : std_logic;
SIGNAL \clock_60hz_counter[1]~35\ : std_logic;
SIGNAL \clock_60hz_counter[2]~36_combout\ : std_logic;
SIGNAL \clock_60hz_counter[2]~37\ : std_logic;
SIGNAL \clock_60hz_counter[3]~39\ : std_logic;
SIGNAL \clock_60hz_counter[4]~40_combout\ : std_logic;
SIGNAL \clock_60hz_counter[4]~41\ : std_logic;
SIGNAL \clock_60hz_counter[5]~43\ : std_logic;
SIGNAL \clock_60hz_counter[6]~45\ : std_logic;
SIGNAL \clock_60hz_counter[7]~46_combout\ : std_logic;
SIGNAL \clock_60hz_counter[7]~47\ : std_logic;
SIGNAL \clock_60hz_counter[8]~49\ : std_logic;
SIGNAL \clock_60hz_counter[9]~50_combout\ : std_logic;
SIGNAL \clock_60hz_counter[9]~51\ : std_logic;
SIGNAL \clock_60hz_counter[10]~53\ : std_logic;
SIGNAL \clock_60hz_counter[11]~54_combout\ : std_logic;
SIGNAL \clock_60hz_counter[11]~55\ : std_logic;
SIGNAL \clock_60hz_counter[12]~57\ : std_logic;
SIGNAL \clock_60hz_counter[13]~58_combout\ : std_logic;
SIGNAL \clock_60hz_counter[13]~59\ : std_logic;
SIGNAL \clock_60hz_counter[14]~60_combout\ : std_logic;
SIGNAL \clock_60hz_counter[14]~61\ : std_logic;
SIGNAL \clock_60hz_counter[15]~62_combout\ : std_logic;
SIGNAL \clock_60hz_counter[15]~63\ : std_logic;
SIGNAL \clock_60hz_counter[16]~64_combout\ : std_logic;
SIGNAL \clock_60hz_counter[16]~65\ : std_logic;
SIGNAL \clock_60hz_counter[17]~66_combout\ : std_logic;
SIGNAL \clock_60hz_counter[17]~67\ : std_logic;
SIGNAL \clock_60hz_counter[18]~68_combout\ : std_logic;
SIGNAL \clock_60hz_counter[18]~69\ : std_logic;
SIGNAL \clock_60hz_counter[19]~71\ : std_logic;
SIGNAL \clock_60hz_counter[20]~72_combout\ : std_logic;
SIGNAL \clock_60hz_counter[20]~73\ : std_logic;
SIGNAL \clock_60hz_counter[21]~75\ : std_logic;
SIGNAL \clock_60hz_counter[22]~77\ : std_logic;
SIGNAL \clock_60hz_counter[23]~78_combout\ : std_logic;
SIGNAL \clock_60hz_counter[23]~79\ : std_logic;
SIGNAL \clock_60hz_counter[24]~81\ : std_logic;
SIGNAL \clock_60hz_counter[25]~82_combout\ : std_logic;
SIGNAL \clock_60hz_counter[25]~83\ : std_logic;
SIGNAL \clock_60hz_counter[26]~85\ : std_logic;
SIGNAL \clock_60hz_counter[27]~86_combout\ : std_logic;
SIGNAL \clock_60hz_counter[27]~87\ : std_logic;
SIGNAL \clock_60hz_counter[28]~89\ : std_logic;
SIGNAL \clock_60hz_counter[29]~90_combout\ : std_logic;
SIGNAL \clock_60hz_counter[29]~91\ : std_logic;
SIGNAL \clock_60hz_counter[30]~92_combout\ : std_logic;
SIGNAL \clock_60hz_counter[30]~93\ : std_logic;
SIGNAL \clock_60hz_counter[31]~94_combout\ : std_logic;
SIGNAL \clock_60hz_counter[21]~74_combout\ : std_logic;
SIGNAL \clock_60hz_counter[22]~76_combout\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \clock_60hz_counter[28]~88_combout\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \LessThan0~8_combout\ : std_logic;
SIGNAL \clock_60hz~regout\ : std_logic;
SIGNAL \fsm_like_things~0_combout\ : std_logic;
SIGNAL \counter[13]~59\ : std_logic;
SIGNAL \counter[14]~60_combout\ : std_logic;
SIGNAL \counter[14]~61\ : std_logic;
SIGNAL \counter[15]~62_combout\ : std_logic;
SIGNAL \counter[15]~63\ : std_logic;
SIGNAL \counter[16]~64_combout\ : std_logic;
SIGNAL \counter[16]~65\ : std_logic;
SIGNAL \counter[17]~66_combout\ : std_logic;
SIGNAL \counter[17]~67\ : std_logic;
SIGNAL \counter[18]~68_combout\ : std_logic;
SIGNAL \counter[18]~69\ : std_logic;
SIGNAL \counter[19]~71\ : std_logic;
SIGNAL \counter[20]~72_combout\ : std_logic;
SIGNAL \counter[20]~73\ : std_logic;
SIGNAL \counter[21]~75\ : std_logic;
SIGNAL \counter[22]~76_combout\ : std_logic;
SIGNAL \counter[22]~77\ : std_logic;
SIGNAL \counter[23]~79\ : std_logic;
SIGNAL \counter[24]~80_combout\ : std_logic;
SIGNAL \counter[24]~81\ : std_logic;
SIGNAL \counter[25]~82_combout\ : std_logic;
SIGNAL \counter[25]~83\ : std_logic;
SIGNAL \counter[26]~85\ : std_logic;
SIGNAL \counter[27]~86_combout\ : std_logic;
SIGNAL \counter[27]~87\ : std_logic;
SIGNAL \counter[28]~88_combout\ : std_logic;
SIGNAL \counter[28]~89\ : std_logic;
SIGNAL \counter[29]~90_combout\ : std_logic;
SIGNAL \LessThan1~5_combout\ : std_logic;
SIGNAL \counter[29]~91\ : std_logic;
SIGNAL \counter[30]~92_combout\ : std_logic;
SIGNAL \LessThan1~6_combout\ : std_logic;
SIGNAL \counter[5]~42_combout\ : std_logic;
SIGNAL \counter[6]~44_combout\ : std_logic;
SIGNAL \LessThan1~9_combout\ : std_logic;
SIGNAL \counter[8]~48_combout\ : std_logic;
SIGNAL \counter[3]~38_combout\ : std_logic;
SIGNAL \LessThan1~7_combout\ : std_logic;
SIGNAL \LessThan1~8_combout\ : std_logic;
SIGNAL \LessThan1~10_combout\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \Selector0~1_combout\ : std_logic;
SIGNAL \n_s.latch_state~regout\ : std_logic;
SIGNAL \LessThan2~0_combout\ : std_logic;
SIGNAL \LessThan2~1_combout\ : std_logic;
SIGNAL \LessThan2~2_combout\ : std_logic;
SIGNAL \counter[16]~96_combout\ : std_logic;
SIGNAL \counter[16]~97_combout\ : std_logic;
SIGNAL \counter[0]~33\ : std_logic;
SIGNAL \counter[1]~34_combout\ : std_logic;
SIGNAL \counter[1]~35\ : std_logic;
SIGNAL \counter[2]~36_combout\ : std_logic;
SIGNAL \counter[2]~37\ : std_logic;
SIGNAL \counter[3]~39\ : std_logic;
SIGNAL \counter[4]~40_combout\ : std_logic;
SIGNAL \counter[4]~41\ : std_logic;
SIGNAL \counter[5]~43\ : std_logic;
SIGNAL \counter[6]~45\ : std_logic;
SIGNAL \counter[7]~46_combout\ : std_logic;
SIGNAL \counter[7]~47\ : std_logic;
SIGNAL \counter[8]~49\ : std_logic;
SIGNAL \counter[9]~50_combout\ : std_logic;
SIGNAL \counter[9]~51\ : std_logic;
SIGNAL \counter[10]~53\ : std_logic;
SIGNAL \counter[11]~54_combout\ : std_logic;
SIGNAL \counter[12]~56_combout\ : std_logic;
SIGNAL \LessThan1~0_combout\ : std_logic;
SIGNAL \counter[23]~78_combout\ : std_logic;
SIGNAL \LessThan1~3_combout\ : std_logic;
SIGNAL \counter[19]~70_combout\ : std_logic;
SIGNAL \LessThan1~2_combout\ : std_logic;
SIGNAL \LessThan1~4_combout\ : std_logic;
SIGNAL \Selector9~0_combout\ : std_logic;
SIGNAL \Selector9~1_combout\ : std_logic;
SIGNAL \Selector9~2_combout\ : std_logic;
SIGNAL \counter[30]~93\ : std_logic;
SIGNAL \counter[31]~94_combout\ : std_logic;
SIGNAL \LessThan2~4_combout\ : std_logic;
SIGNAL \Selector9~3_combout\ : std_logic;
SIGNAL \n_s.l0~regout\ : std_logic;
SIGNAL \n_s.p0~feeder_combout\ : std_logic;
SIGNAL \n_s~38_combout\ : std_logic;
SIGNAL \n_s.p0~regout\ : std_logic;
SIGNAL \n_s.l1~regout\ : std_logic;
SIGNAL \n_s.p1~feeder_combout\ : std_logic;
SIGNAL \n_s.p1~regout\ : std_logic;
SIGNAL \n_s.l2~regout\ : std_logic;
SIGNAL \n_s.p2~feeder_combout\ : std_logic;
SIGNAL \n_s.p2~regout\ : std_logic;
SIGNAL \n_s.l3~feeder_combout\ : std_logic;
SIGNAL \n_s.l3~regout\ : std_logic;
SIGNAL \n_s.p3~regout\ : std_logic;
SIGNAL \n_s.l4~feeder_combout\ : std_logic;
SIGNAL \n_s.l4~regout\ : std_logic;
SIGNAL \n_s.p4~feeder_combout\ : std_logic;
SIGNAL \n_s.p4~regout\ : std_logic;
SIGNAL \n_s.l5~feeder_combout\ : std_logic;
SIGNAL \n_s.l5~regout\ : std_logic;
SIGNAL \n_s.p5~feeder_combout\ : std_logic;
SIGNAL \n_s.p5~regout\ : std_logic;
SIGNAL \n_s.l6~feeder_combout\ : std_logic;
SIGNAL \n_s.l6~regout\ : std_logic;
SIGNAL \n_s.p6~regout\ : std_logic;
SIGNAL \n_s.l7~feeder_combout\ : std_logic;
SIGNAL \n_s.l7~regout\ : std_logic;
SIGNAL \n_s.p7~feeder_combout\ : std_logic;
SIGNAL \n_s.p7~regout\ : std_logic;
SIGNAL \n_s.done~regout\ : std_logic;
SIGNAL \in_state_machine~0_combout\ : std_logic;
SIGNAL \in_state_machine~regout\ : std_logic;
SIGNAL \latch~2_combout\ : std_logic;
SIGNAL \latch~reg0_regout\ : std_logic;
SIGNAL \WideOr18~1_combout\ : std_logic;
SIGNAL \WideOr18~0_combout\ : std_logic;
SIGNAL \pulse~0_combout\ : std_logic;
SIGNAL \pulse~reg0_regout\ : std_logic;
SIGNAL \leds[0]~reg0_regout\ : std_logic;
SIGNAL \leds[1]~0_combout\ : std_logic;
SIGNAL \leds[1]~reg0_regout\ : std_logic;
SIGNAL \leds[2]~1_combout\ : std_logic;
SIGNAL \leds[2]~reg0_regout\ : std_logic;
SIGNAL \leds[3]~2_combout\ : std_logic;
SIGNAL \leds[3]~reg0_regout\ : std_logic;
SIGNAL \leds[4]~3_combout\ : std_logic;
SIGNAL \leds[4]~reg0_regout\ : std_logic;
SIGNAL \leds[5]~4_combout\ : std_logic;
SIGNAL \leds[5]~reg0_regout\ : std_logic;
SIGNAL \leds[6]~5_combout\ : std_logic;
SIGNAL \leds[6]~reg0_regout\ : std_logic;
SIGNAL \leds[7]~6_combout\ : std_logic;
SIGNAL \leds[7]~reg0_regout\ : std_logic;
SIGNAL \leds[8]~7_combout\ : std_logic;
SIGNAL \leds[8]~reg0_regout\ : std_logic;
SIGNAL \leds[9]~8_combout\ : std_logic;
SIGNAL \leds[9]~reg0_regout\ : std_logic;
SIGNAL \leds[10]~9_combout\ : std_logic;
SIGNAL \leds[10]~reg0_regout\ : std_logic;
SIGNAL \leds[11]~10_combout\ : std_logic;
SIGNAL \leds[11]~reg0_regout\ : std_logic;
SIGNAL \leds[12]~11_combout\ : std_logic;
SIGNAL \leds[12]~reg0_regout\ : std_logic;
SIGNAL \leds[13]~12_combout\ : std_logic;
SIGNAL \leds[13]~reg0_regout\ : std_logic;
SIGNAL \leds[14]~13_combout\ : std_logic;
SIGNAL \leds[14]~reg0_regout\ : std_logic;
SIGNAL \leds[15]~reg0_regout\ : std_logic;
SIGNAL \counter_c[0]~0_combout\ : std_logic;
SIGNAL \counter_c[0]~reg0_regout\ : std_logic;
SIGNAL \counter_c[1]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[1]~reg0_regout\ : std_logic;
SIGNAL \counter_c[2]~reg0_regout\ : std_logic;
SIGNAL \counter_c[3]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[3]~reg0_regout\ : std_logic;
SIGNAL \counter_c[4]~reg0_regout\ : std_logic;
SIGNAL \counter_c[5]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[5]~reg0_regout\ : std_logic;
SIGNAL \counter_c[6]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[6]~reg0_regout\ : std_logic;
SIGNAL \counter_c[7]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[7]~reg0_regout\ : std_logic;
SIGNAL \counter_c[8]~reg0_regout\ : std_logic;
SIGNAL \counter_c[9]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[9]~reg0_regout\ : std_logic;
SIGNAL \counter[10]~52_combout\ : std_logic;
SIGNAL \counter_c[10]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[10]~reg0_regout\ : std_logic;
SIGNAL \counter_c[11]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[11]~reg0_regout\ : std_logic;
SIGNAL \counter_c[12]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[12]~reg0_regout\ : std_logic;
SIGNAL \counter_c[13]~reg0_regout\ : std_logic;
SIGNAL \counter_c[14]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[14]~reg0_regout\ : std_logic;
SIGNAL \counter_c[15]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[15]~reg0_regout\ : std_logic;
SIGNAL \counter_c[16]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[16]~reg0_regout\ : std_logic;
SIGNAL \counter_c[17]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[17]~reg0_regout\ : std_logic;
SIGNAL \counter_c[18]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[18]~reg0_regout\ : std_logic;
SIGNAL \counter_c[19]~reg0_regout\ : std_logic;
SIGNAL \counter_c[20]~reg0_regout\ : std_logic;
SIGNAL \counter[21]~74_combout\ : std_logic;
SIGNAL \counter_c[21]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[21]~reg0_regout\ : std_logic;
SIGNAL \counter_c[22]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[22]~reg0_regout\ : std_logic;
SIGNAL \counter_c[23]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[23]~reg0_regout\ : std_logic;
SIGNAL \counter_c[24]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[24]~reg0_regout\ : std_logic;
SIGNAL \counter_c[25]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[25]~reg0_regout\ : std_logic;
SIGNAL \counter[26]~84_combout\ : std_logic;
SIGNAL \counter_c[26]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[26]~reg0_regout\ : std_logic;
SIGNAL \counter_c[27]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[27]~reg0_regout\ : std_logic;
SIGNAL \counter_c[28]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[28]~reg0_regout\ : std_logic;
SIGNAL \counter_c[29]~reg0feeder_combout\ : std_logic;
SIGNAL \counter_c[29]~reg0_regout\ : std_logic;
SIGNAL \counter_c[30]~reg0_regout\ : std_logic;
SIGNAL \counter_c[31]~1_combout\ : std_logic;
SIGNAL \counter_c[31]~reg0_regout\ : std_logic;
SIGNAL counter : std_logic_vector(31 DOWNTO 0);
SIGNAL clock_60hz_counter : std_logic_vector(31 DOWNTO 0);
SIGNAL \ALT_INV_counter_c[31]~reg0_regout\ : std_logic;
SIGNAL \ALT_INV_counter_c[0]~reg0_regout\ : std_logic;

BEGIN

ww_clk <= clk;
latch <= ww_latch;
pulse <= ww_pulse;
ww_data <= data;
leds <= ww_leds;
counter_c <= IEEE.STD_LOGIC_ARITH.CONV_INTEGER(UNSIGNED(ww_counter_c));
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clk~combout\);
\ALT_INV_counter_c[31]~reg0_regout\ <= NOT \counter_c[31]~reg0_regout\;
\ALT_INV_counter_c[0]~reg0_regout\ <= NOT \counter_c[0]~reg0_regout\;

-- Location: LCFF_X28_Y35_N11
\clock_60hz_counter[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[5]~42_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(5));

-- Location: LCFF_X28_Y35_N13
\clock_60hz_counter[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[6]~44_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(6));

-- Location: LCFF_X28_Y35_N17
\clock_60hz_counter[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[8]~48_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(8));

-- Location: LCFF_X28_Y35_N21
\clock_60hz_counter[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[10]~52_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(10));

-- Location: LCFF_X28_Y35_N25
\clock_60hz_counter[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[12]~56_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(12));

-- Location: LCFF_X28_Y34_N7
\clock_60hz_counter[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[19]~70_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(19));

-- Location: LCFF_X28_Y34_N17
\clock_60hz_counter[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[24]~80_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(24));

-- Location: LCFF_X28_Y34_N21
\clock_60hz_counter[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[26]~84_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(26));

-- Location: LCFF_X28_Y35_N7
\clock_60hz_counter[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[3]~38_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(3));

-- Location: LCCOMB_X28_Y35_N6
\clock_60hz_counter[3]~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[3]~38_combout\ = (clock_60hz_counter(3) & (!\clock_60hz_counter[2]~37\)) # (!clock_60hz_counter(3) & ((\clock_60hz_counter[2]~37\) # (GND)))
-- \clock_60hz_counter[3]~39\ = CARRY((!\clock_60hz_counter[2]~37\) # (!clock_60hz_counter(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(3),
	datad => VCC,
	cin => \clock_60hz_counter[2]~37\,
	combout => \clock_60hz_counter[3]~38_combout\,
	cout => \clock_60hz_counter[3]~39\);

-- Location: LCCOMB_X28_Y35_N10
\clock_60hz_counter[5]~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[5]~42_combout\ = (clock_60hz_counter(5) & (!\clock_60hz_counter[4]~41\)) # (!clock_60hz_counter(5) & ((\clock_60hz_counter[4]~41\) # (GND)))
-- \clock_60hz_counter[5]~43\ = CARRY((!\clock_60hz_counter[4]~41\) # (!clock_60hz_counter(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(5),
	datad => VCC,
	cin => \clock_60hz_counter[4]~41\,
	combout => \clock_60hz_counter[5]~42_combout\,
	cout => \clock_60hz_counter[5]~43\);

-- Location: LCCOMB_X28_Y35_N12
\clock_60hz_counter[6]~44\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[6]~44_combout\ = (clock_60hz_counter(6) & (\clock_60hz_counter[5]~43\ $ (GND))) # (!clock_60hz_counter(6) & (!\clock_60hz_counter[5]~43\ & VCC))
-- \clock_60hz_counter[6]~45\ = CARRY((clock_60hz_counter(6) & !\clock_60hz_counter[5]~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(6),
	datad => VCC,
	cin => \clock_60hz_counter[5]~43\,
	combout => \clock_60hz_counter[6]~44_combout\,
	cout => \clock_60hz_counter[6]~45\);

-- Location: LCCOMB_X28_Y35_N16
\clock_60hz_counter[8]~48\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[8]~48_combout\ = (clock_60hz_counter(8) & (\clock_60hz_counter[7]~47\ $ (GND))) # (!clock_60hz_counter(8) & (!\clock_60hz_counter[7]~47\ & VCC))
-- \clock_60hz_counter[8]~49\ = CARRY((clock_60hz_counter(8) & !\clock_60hz_counter[7]~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(8),
	datad => VCC,
	cin => \clock_60hz_counter[7]~47\,
	combout => \clock_60hz_counter[8]~48_combout\,
	cout => \clock_60hz_counter[8]~49\);

-- Location: LCCOMB_X28_Y35_N20
\clock_60hz_counter[10]~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[10]~52_combout\ = (clock_60hz_counter(10) & (\clock_60hz_counter[9]~51\ $ (GND))) # (!clock_60hz_counter(10) & (!\clock_60hz_counter[9]~51\ & VCC))
-- \clock_60hz_counter[10]~53\ = CARRY((clock_60hz_counter(10) & !\clock_60hz_counter[9]~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(10),
	datad => VCC,
	cin => \clock_60hz_counter[9]~51\,
	combout => \clock_60hz_counter[10]~52_combout\,
	cout => \clock_60hz_counter[10]~53\);

-- Location: LCCOMB_X28_Y35_N24
\clock_60hz_counter[12]~56\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[12]~56_combout\ = (clock_60hz_counter(12) & (\clock_60hz_counter[11]~55\ $ (GND))) # (!clock_60hz_counter(12) & (!\clock_60hz_counter[11]~55\ & VCC))
-- \clock_60hz_counter[12]~57\ = CARRY((clock_60hz_counter(12) & !\clock_60hz_counter[11]~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(12),
	datad => VCC,
	cin => \clock_60hz_counter[11]~55\,
	combout => \clock_60hz_counter[12]~56_combout\,
	cout => \clock_60hz_counter[12]~57\);

-- Location: LCCOMB_X28_Y34_N6
\clock_60hz_counter[19]~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[19]~70_combout\ = (clock_60hz_counter(19) & (!\clock_60hz_counter[18]~69\)) # (!clock_60hz_counter(19) & ((\clock_60hz_counter[18]~69\) # (GND)))
-- \clock_60hz_counter[19]~71\ = CARRY((!\clock_60hz_counter[18]~69\) # (!clock_60hz_counter(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(19),
	datad => VCC,
	cin => \clock_60hz_counter[18]~69\,
	combout => \clock_60hz_counter[19]~70_combout\,
	cout => \clock_60hz_counter[19]~71\);

-- Location: LCCOMB_X28_Y34_N16
\clock_60hz_counter[24]~80\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[24]~80_combout\ = (clock_60hz_counter(24) & (\clock_60hz_counter[23]~79\ $ (GND))) # (!clock_60hz_counter(24) & (!\clock_60hz_counter[23]~79\ & VCC))
-- \clock_60hz_counter[24]~81\ = CARRY((clock_60hz_counter(24) & !\clock_60hz_counter[23]~79\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(24),
	datad => VCC,
	cin => \clock_60hz_counter[23]~79\,
	combout => \clock_60hz_counter[24]~80_combout\,
	cout => \clock_60hz_counter[24]~81\);

-- Location: LCCOMB_X28_Y34_N20
\clock_60hz_counter[26]~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[26]~84_combout\ = (clock_60hz_counter(26) & (\clock_60hz_counter[25]~83\ $ (GND))) # (!clock_60hz_counter(26) & (!\clock_60hz_counter[25]~83\ & VCC))
-- \clock_60hz_counter[26]~85\ = CARRY((clock_60hz_counter(26) & !\clock_60hz_counter[25]~83\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(26),
	datad => VCC,
	cin => \clock_60hz_counter[25]~83\,
	combout => \clock_60hz_counter[26]~84_combout\,
	cout => \clock_60hz_counter[26]~85\);

-- Location: LCCOMB_X21_Y35_N16
\LessThan1~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~1_combout\ = (!counter(15) & (!counter(14) & (!counter(17) & !counter(16))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(15),
	datab => counter(14),
	datac => counter(17),
	datad => counter(16),
	combout => \LessThan1~1_combout\);

-- Location: LCCOMB_X21_Y34_N10
\LessThan2~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~3_combout\ = (!counter(30) & \LessThan1~5_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => counter(30),
	datad => \LessThan1~5_combout\,
	combout => \LessThan2~3_combout\);

-- Location: LCCOMB_X27_Y35_N12
\LessThan0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~0_combout\ = (!clock_60hz_counter(8) & (!clock_60hz_counter(7) & (!clock_60hz_counter(5) & !clock_60hz_counter(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(8),
	datab => clock_60hz_counter(7),
	datac => clock_60hz_counter(5),
	datad => clock_60hz_counter(6),
	combout => \LessThan0~0_combout\);

-- Location: LCCOMB_X27_Y35_N10
\LessThan0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~1_combout\ = (((\LessThan0~0_combout\) # (!clock_60hz_counter(11))) # (!clock_60hz_counter(9))) # (!clock_60hz_counter(10))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(10),
	datab => clock_60hz_counter(9),
	datac => clock_60hz_counter(11),
	datad => \LessThan0~0_combout\,
	combout => \LessThan0~1_combout\);

-- Location: LCCOMB_X27_Y35_N24
\LessThan0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~2_combout\ = ((!clock_60hz_counter(13) & (!clock_60hz_counter(12) & \LessThan0~1_combout\))) # (!clock_60hz_counter(14))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(13),
	datab => clock_60hz_counter(12),
	datac => clock_60hz_counter(14),
	datad => \LessThan0~1_combout\,
	combout => \LessThan0~2_combout\);

-- Location: LCCOMB_X27_Y34_N10
\LessThan0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~5_combout\ = (!clock_60hz_counter(24) & (!clock_60hz_counter(26) & (!clock_60hz_counter(23) & !clock_60hz_counter(25))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(24),
	datab => clock_60hz_counter(26),
	datac => clock_60hz_counter(23),
	datad => clock_60hz_counter(25),
	combout => \LessThan0~5_combout\);

-- Location: LCCOMB_X21_Y35_N10
\LessThan1~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~11_combout\ = (\LessThan1~9_combout\) # ((counter(9) & counter(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(9),
	datab => counter(8),
	datac => \LessThan1~9_combout\,
	combout => \LessThan1~11_combout\);

-- Location: PIN_P2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clk~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_clk,
	combout => \clk~combout\);

-- Location: CLKCTRL_G3
\clk~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~clkctrl_outclk\);

-- Location: LCCOMB_X20_Y35_N0
\counter[0]~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[0]~32_combout\ = counter(0) $ (VCC)
-- \counter[0]~33\ = CARRY(counter(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => counter(0),
	datad => VCC,
	combout => \counter[0]~32_combout\,
	cout => \counter[0]~33\);

-- Location: LCCOMB_X20_Y35_N22
\counter[11]~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[11]~54_combout\ = (counter(11) & (!\counter[10]~53\)) # (!counter(11) & ((\counter[10]~53\) # (GND)))
-- \counter[11]~55\ = CARRY((!\counter[10]~53\) # (!counter(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(11),
	datad => VCC,
	cin => \counter[10]~53\,
	combout => \counter[11]~54_combout\,
	cout => \counter[11]~55\);

-- Location: LCCOMB_X20_Y35_N24
\counter[12]~56\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[12]~56_combout\ = (counter(12) & (\counter[11]~55\ $ (GND))) # (!counter(12) & (!\counter[11]~55\ & VCC))
-- \counter[12]~57\ = CARRY((counter(12) & !\counter[11]~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(12),
	datad => VCC,
	cin => \counter[11]~55\,
	combout => \counter[12]~56_combout\,
	cout => \counter[12]~57\);

-- Location: LCCOMB_X20_Y35_N26
\counter[13]~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[13]~58_combout\ = (counter(13) & (!\counter[12]~57\)) # (!counter(13) & ((\counter[12]~57\) # (GND)))
-- \counter[13]~59\ = CARRY((!\counter[12]~57\) # (!counter(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(13),
	datad => VCC,
	cin => \counter[12]~57\,
	combout => \counter[13]~58_combout\,
	cout => \counter[13]~59\);

-- Location: LCCOMB_X28_Y35_N0
\clock_60hz_counter[0]~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[0]~32_combout\ = clock_60hz_counter(0) $ (VCC)
-- \clock_60hz_counter[0]~33\ = CARRY(clock_60hz_counter(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(0),
	datad => VCC,
	combout => \clock_60hz_counter[0]~32_combout\,
	cout => \clock_60hz_counter[0]~33\);

-- Location: LCFF_X28_Y35_N1
\clock_60hz_counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[0]~32_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(0));

-- Location: LCCOMB_X28_Y35_N2
\clock_60hz_counter[1]~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[1]~34_combout\ = (clock_60hz_counter(1) & (!\clock_60hz_counter[0]~33\)) # (!clock_60hz_counter(1) & ((\clock_60hz_counter[0]~33\) # (GND)))
-- \clock_60hz_counter[1]~35\ = CARRY((!\clock_60hz_counter[0]~33\) # (!clock_60hz_counter(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(1),
	datad => VCC,
	cin => \clock_60hz_counter[0]~33\,
	combout => \clock_60hz_counter[1]~34_combout\,
	cout => \clock_60hz_counter[1]~35\);

-- Location: LCFF_X28_Y35_N3
\clock_60hz_counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[1]~34_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(1));

-- Location: LCCOMB_X28_Y35_N4
\clock_60hz_counter[2]~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[2]~36_combout\ = (clock_60hz_counter(2) & (\clock_60hz_counter[1]~35\ $ (GND))) # (!clock_60hz_counter(2) & (!\clock_60hz_counter[1]~35\ & VCC))
-- \clock_60hz_counter[2]~37\ = CARRY((clock_60hz_counter(2) & !\clock_60hz_counter[1]~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(2),
	datad => VCC,
	cin => \clock_60hz_counter[1]~35\,
	combout => \clock_60hz_counter[2]~36_combout\,
	cout => \clock_60hz_counter[2]~37\);

-- Location: LCFF_X28_Y35_N5
\clock_60hz_counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[2]~36_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(2));

-- Location: LCCOMB_X28_Y35_N8
\clock_60hz_counter[4]~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[4]~40_combout\ = (clock_60hz_counter(4) & (\clock_60hz_counter[3]~39\ $ (GND))) # (!clock_60hz_counter(4) & (!\clock_60hz_counter[3]~39\ & VCC))
-- \clock_60hz_counter[4]~41\ = CARRY((clock_60hz_counter(4) & !\clock_60hz_counter[3]~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(4),
	datad => VCC,
	cin => \clock_60hz_counter[3]~39\,
	combout => \clock_60hz_counter[4]~40_combout\,
	cout => \clock_60hz_counter[4]~41\);

-- Location: LCFF_X28_Y35_N9
\clock_60hz_counter[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[4]~40_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(4));

-- Location: LCCOMB_X28_Y35_N14
\clock_60hz_counter[7]~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[7]~46_combout\ = (clock_60hz_counter(7) & (!\clock_60hz_counter[6]~45\)) # (!clock_60hz_counter(7) & ((\clock_60hz_counter[6]~45\) # (GND)))
-- \clock_60hz_counter[7]~47\ = CARRY((!\clock_60hz_counter[6]~45\) # (!clock_60hz_counter(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(7),
	datad => VCC,
	cin => \clock_60hz_counter[6]~45\,
	combout => \clock_60hz_counter[7]~46_combout\,
	cout => \clock_60hz_counter[7]~47\);

-- Location: LCFF_X28_Y35_N15
\clock_60hz_counter[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[7]~46_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(7));

-- Location: LCCOMB_X28_Y35_N18
\clock_60hz_counter[9]~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[9]~50_combout\ = (clock_60hz_counter(9) & (!\clock_60hz_counter[8]~49\)) # (!clock_60hz_counter(9) & ((\clock_60hz_counter[8]~49\) # (GND)))
-- \clock_60hz_counter[9]~51\ = CARRY((!\clock_60hz_counter[8]~49\) # (!clock_60hz_counter(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(9),
	datad => VCC,
	cin => \clock_60hz_counter[8]~49\,
	combout => \clock_60hz_counter[9]~50_combout\,
	cout => \clock_60hz_counter[9]~51\);

-- Location: LCFF_X28_Y35_N19
\clock_60hz_counter[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[9]~50_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(9));

-- Location: LCCOMB_X28_Y35_N22
\clock_60hz_counter[11]~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[11]~54_combout\ = (clock_60hz_counter(11) & (!\clock_60hz_counter[10]~53\)) # (!clock_60hz_counter(11) & ((\clock_60hz_counter[10]~53\) # (GND)))
-- \clock_60hz_counter[11]~55\ = CARRY((!\clock_60hz_counter[10]~53\) # (!clock_60hz_counter(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(11),
	datad => VCC,
	cin => \clock_60hz_counter[10]~53\,
	combout => \clock_60hz_counter[11]~54_combout\,
	cout => \clock_60hz_counter[11]~55\);

-- Location: LCFF_X28_Y35_N23
\clock_60hz_counter[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[11]~54_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(11));

-- Location: LCCOMB_X28_Y35_N26
\clock_60hz_counter[13]~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[13]~58_combout\ = (clock_60hz_counter(13) & (!\clock_60hz_counter[12]~57\)) # (!clock_60hz_counter(13) & ((\clock_60hz_counter[12]~57\) # (GND)))
-- \clock_60hz_counter[13]~59\ = CARRY((!\clock_60hz_counter[12]~57\) # (!clock_60hz_counter(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(13),
	datad => VCC,
	cin => \clock_60hz_counter[12]~57\,
	combout => \clock_60hz_counter[13]~58_combout\,
	cout => \clock_60hz_counter[13]~59\);

-- Location: LCFF_X28_Y35_N27
\clock_60hz_counter[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[13]~58_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(13));

-- Location: LCCOMB_X28_Y35_N28
\clock_60hz_counter[14]~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[14]~60_combout\ = (clock_60hz_counter(14) & (\clock_60hz_counter[13]~59\ $ (GND))) # (!clock_60hz_counter(14) & (!\clock_60hz_counter[13]~59\ & VCC))
-- \clock_60hz_counter[14]~61\ = CARRY((clock_60hz_counter(14) & !\clock_60hz_counter[13]~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(14),
	datad => VCC,
	cin => \clock_60hz_counter[13]~59\,
	combout => \clock_60hz_counter[14]~60_combout\,
	cout => \clock_60hz_counter[14]~61\);

-- Location: LCFF_X28_Y35_N29
\clock_60hz_counter[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[14]~60_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(14));

-- Location: LCCOMB_X28_Y35_N30
\clock_60hz_counter[15]~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[15]~62_combout\ = (clock_60hz_counter(15) & (!\clock_60hz_counter[14]~61\)) # (!clock_60hz_counter(15) & ((\clock_60hz_counter[14]~61\) # (GND)))
-- \clock_60hz_counter[15]~63\ = CARRY((!\clock_60hz_counter[14]~61\) # (!clock_60hz_counter(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(15),
	datad => VCC,
	cin => \clock_60hz_counter[14]~61\,
	combout => \clock_60hz_counter[15]~62_combout\,
	cout => \clock_60hz_counter[15]~63\);

-- Location: LCFF_X28_Y35_N31
\clock_60hz_counter[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[15]~62_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(15));

-- Location: LCCOMB_X28_Y34_N0
\clock_60hz_counter[16]~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[16]~64_combout\ = (clock_60hz_counter(16) & (\clock_60hz_counter[15]~63\ $ (GND))) # (!clock_60hz_counter(16) & (!\clock_60hz_counter[15]~63\ & VCC))
-- \clock_60hz_counter[16]~65\ = CARRY((clock_60hz_counter(16) & !\clock_60hz_counter[15]~63\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(16),
	datad => VCC,
	cin => \clock_60hz_counter[15]~63\,
	combout => \clock_60hz_counter[16]~64_combout\,
	cout => \clock_60hz_counter[16]~65\);

-- Location: LCFF_X28_Y34_N1
\clock_60hz_counter[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[16]~64_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(16));

-- Location: LCCOMB_X28_Y34_N2
\clock_60hz_counter[17]~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[17]~66_combout\ = (clock_60hz_counter(17) & (!\clock_60hz_counter[16]~65\)) # (!clock_60hz_counter(17) & ((\clock_60hz_counter[16]~65\) # (GND)))
-- \clock_60hz_counter[17]~67\ = CARRY((!\clock_60hz_counter[16]~65\) # (!clock_60hz_counter(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(17),
	datad => VCC,
	cin => \clock_60hz_counter[16]~65\,
	combout => \clock_60hz_counter[17]~66_combout\,
	cout => \clock_60hz_counter[17]~67\);

-- Location: LCFF_X28_Y34_N3
\clock_60hz_counter[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[17]~66_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(17));

-- Location: LCCOMB_X28_Y34_N4
\clock_60hz_counter[18]~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[18]~68_combout\ = (clock_60hz_counter(18) & (\clock_60hz_counter[17]~67\ $ (GND))) # (!clock_60hz_counter(18) & (!\clock_60hz_counter[17]~67\ & VCC))
-- \clock_60hz_counter[18]~69\ = CARRY((clock_60hz_counter(18) & !\clock_60hz_counter[17]~67\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(18),
	datad => VCC,
	cin => \clock_60hz_counter[17]~67\,
	combout => \clock_60hz_counter[18]~68_combout\,
	cout => \clock_60hz_counter[18]~69\);

-- Location: LCFF_X28_Y34_N5
\clock_60hz_counter[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[18]~68_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(18));

-- Location: LCCOMB_X28_Y34_N8
\clock_60hz_counter[20]~72\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[20]~72_combout\ = (clock_60hz_counter(20) & (\clock_60hz_counter[19]~71\ $ (GND))) # (!clock_60hz_counter(20) & (!\clock_60hz_counter[19]~71\ & VCC))
-- \clock_60hz_counter[20]~73\ = CARRY((clock_60hz_counter(20) & !\clock_60hz_counter[19]~71\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(20),
	datad => VCC,
	cin => \clock_60hz_counter[19]~71\,
	combout => \clock_60hz_counter[20]~72_combout\,
	cout => \clock_60hz_counter[20]~73\);

-- Location: LCFF_X28_Y34_N9
\clock_60hz_counter[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[20]~72_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(20));

-- Location: LCCOMB_X28_Y34_N10
\clock_60hz_counter[21]~74\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[21]~74_combout\ = (clock_60hz_counter(21) & (!\clock_60hz_counter[20]~73\)) # (!clock_60hz_counter(21) & ((\clock_60hz_counter[20]~73\) # (GND)))
-- \clock_60hz_counter[21]~75\ = CARRY((!\clock_60hz_counter[20]~73\) # (!clock_60hz_counter(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(21),
	datad => VCC,
	cin => \clock_60hz_counter[20]~73\,
	combout => \clock_60hz_counter[21]~74_combout\,
	cout => \clock_60hz_counter[21]~75\);

-- Location: LCCOMB_X28_Y34_N12
\clock_60hz_counter[22]~76\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[22]~76_combout\ = (clock_60hz_counter(22) & (\clock_60hz_counter[21]~75\ $ (GND))) # (!clock_60hz_counter(22) & (!\clock_60hz_counter[21]~75\ & VCC))
-- \clock_60hz_counter[22]~77\ = CARRY((clock_60hz_counter(22) & !\clock_60hz_counter[21]~75\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(22),
	datad => VCC,
	cin => \clock_60hz_counter[21]~75\,
	combout => \clock_60hz_counter[22]~76_combout\,
	cout => \clock_60hz_counter[22]~77\);

-- Location: LCCOMB_X28_Y34_N14
\clock_60hz_counter[23]~78\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[23]~78_combout\ = (clock_60hz_counter(23) & (!\clock_60hz_counter[22]~77\)) # (!clock_60hz_counter(23) & ((\clock_60hz_counter[22]~77\) # (GND)))
-- \clock_60hz_counter[23]~79\ = CARRY((!\clock_60hz_counter[22]~77\) # (!clock_60hz_counter(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(23),
	datad => VCC,
	cin => \clock_60hz_counter[22]~77\,
	combout => \clock_60hz_counter[23]~78_combout\,
	cout => \clock_60hz_counter[23]~79\);

-- Location: LCFF_X28_Y34_N15
\clock_60hz_counter[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[23]~78_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(23));

-- Location: LCCOMB_X28_Y34_N18
\clock_60hz_counter[25]~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[25]~82_combout\ = (clock_60hz_counter(25) & (!\clock_60hz_counter[24]~81\)) # (!clock_60hz_counter(25) & ((\clock_60hz_counter[24]~81\) # (GND)))
-- \clock_60hz_counter[25]~83\ = CARRY((!\clock_60hz_counter[24]~81\) # (!clock_60hz_counter(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(25),
	datad => VCC,
	cin => \clock_60hz_counter[24]~81\,
	combout => \clock_60hz_counter[25]~82_combout\,
	cout => \clock_60hz_counter[25]~83\);

-- Location: LCFF_X28_Y34_N19
\clock_60hz_counter[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[25]~82_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(25));

-- Location: LCCOMB_X28_Y34_N22
\clock_60hz_counter[27]~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[27]~86_combout\ = (clock_60hz_counter(27) & (!\clock_60hz_counter[26]~85\)) # (!clock_60hz_counter(27) & ((\clock_60hz_counter[26]~85\) # (GND)))
-- \clock_60hz_counter[27]~87\ = CARRY((!\clock_60hz_counter[26]~85\) # (!clock_60hz_counter(27)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(27),
	datad => VCC,
	cin => \clock_60hz_counter[26]~85\,
	combout => \clock_60hz_counter[27]~86_combout\,
	cout => \clock_60hz_counter[27]~87\);

-- Location: LCFF_X28_Y34_N23
\clock_60hz_counter[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[27]~86_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(27));

-- Location: LCCOMB_X28_Y34_N24
\clock_60hz_counter[28]~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[28]~88_combout\ = (clock_60hz_counter(28) & (\clock_60hz_counter[27]~87\ $ (GND))) # (!clock_60hz_counter(28) & (!\clock_60hz_counter[27]~87\ & VCC))
-- \clock_60hz_counter[28]~89\ = CARRY((clock_60hz_counter(28) & !\clock_60hz_counter[27]~87\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(28),
	datad => VCC,
	cin => \clock_60hz_counter[27]~87\,
	combout => \clock_60hz_counter[28]~88_combout\,
	cout => \clock_60hz_counter[28]~89\);

-- Location: LCCOMB_X28_Y34_N26
\clock_60hz_counter[29]~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[29]~90_combout\ = (clock_60hz_counter(29) & (!\clock_60hz_counter[28]~89\)) # (!clock_60hz_counter(29) & ((\clock_60hz_counter[28]~89\) # (GND)))
-- \clock_60hz_counter[29]~91\ = CARRY((!\clock_60hz_counter[28]~89\) # (!clock_60hz_counter(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(29),
	datad => VCC,
	cin => \clock_60hz_counter[28]~89\,
	combout => \clock_60hz_counter[29]~90_combout\,
	cout => \clock_60hz_counter[29]~91\);

-- Location: LCFF_X28_Y34_N27
\clock_60hz_counter[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[29]~90_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(29));

-- Location: LCCOMB_X28_Y34_N28
\clock_60hz_counter[30]~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[30]~92_combout\ = (clock_60hz_counter(30) & (\clock_60hz_counter[29]~91\ $ (GND))) # (!clock_60hz_counter(30) & (!\clock_60hz_counter[29]~91\ & VCC))
-- \clock_60hz_counter[30]~93\ = CARRY((clock_60hz_counter(30) & !\clock_60hz_counter[29]~91\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => clock_60hz_counter(30),
	datad => VCC,
	cin => \clock_60hz_counter[29]~91\,
	combout => \clock_60hz_counter[30]~92_combout\,
	cout => \clock_60hz_counter[30]~93\);

-- Location: LCFF_X28_Y34_N29
\clock_60hz_counter[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[30]~92_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(30));

-- Location: LCCOMB_X28_Y34_N30
\clock_60hz_counter[31]~94\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_60hz_counter[31]~94_combout\ = \clock_60hz_counter[30]~93\ $ (clock_60hz_counter(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => clock_60hz_counter(31),
	cin => \clock_60hz_counter[30]~93\,
	combout => \clock_60hz_counter[31]~94_combout\);

-- Location: LCFF_X28_Y34_N31
\clock_60hz_counter[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[31]~94_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(31));

-- Location: LCFF_X28_Y34_N11
\clock_60hz_counter[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[21]~74_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(21));

-- Location: LCFF_X28_Y34_N13
\clock_60hz_counter[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[22]~76_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(22));

-- Location: LCCOMB_X27_Y34_N0
\LessThan0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~4_combout\ = (!clock_60hz_counter(19) & (!clock_60hz_counter(20) & (!clock_60hz_counter(21) & !clock_60hz_counter(22))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(19),
	datab => clock_60hz_counter(20),
	datac => clock_60hz_counter(21),
	datad => clock_60hz_counter(22),
	combout => \LessThan0~4_combout\);

-- Location: LCFF_X28_Y34_N25
\clock_60hz_counter[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \clock_60hz_counter[28]~88_combout\,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => clock_60hz_counter(28));

-- Location: LCCOMB_X27_Y34_N24
\LessThan0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~6_combout\ = (!clock_60hz_counter(29) & (!clock_60hz_counter(28) & (!clock_60hz_counter(27) & !clock_60hz_counter(30))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(29),
	datab => clock_60hz_counter(28),
	datac => clock_60hz_counter(27),
	datad => clock_60hz_counter(30),
	combout => \LessThan0~6_combout\);

-- Location: LCCOMB_X27_Y34_N6
\LessThan0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~3_combout\ = (!clock_60hz_counter(17) & (!clock_60hz_counter(16) & (!clock_60hz_counter(18) & !clock_60hz_counter(15))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => clock_60hz_counter(17),
	datab => clock_60hz_counter(16),
	datac => clock_60hz_counter(18),
	datad => clock_60hz_counter(15),
	combout => \LessThan0~3_combout\);

-- Location: LCCOMB_X27_Y34_N2
\LessThan0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~7_combout\ = (\LessThan0~5_combout\ & (\LessThan0~4_combout\ & (\LessThan0~6_combout\ & \LessThan0~3_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~5_combout\,
	datab => \LessThan0~4_combout\,
	datac => \LessThan0~6_combout\,
	datad => \LessThan0~3_combout\,
	combout => \LessThan0~7_combout\);

-- Location: LCCOMB_X27_Y35_N8
\LessThan0~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~8_combout\ = (!clock_60hz_counter(31) & ((!\LessThan0~7_combout\) # (!\LessThan0~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~2_combout\,
	datab => clock_60hz_counter(31),
	datad => \LessThan0~7_combout\,
	combout => \LessThan0~8_combout\);

-- Location: LCFF_X27_Y35_N21
clock_60hz : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \LessThan0~8_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_60hz~regout\);

-- Location: LCCOMB_X27_Y35_N22
\fsm_like_things~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \fsm_like_things~0_combout\ = (\clock_60hz~regout\) # (\in_state_machine~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_60hz~regout\,
	datad => \in_state_machine~regout\,
	combout => \fsm_like_things~0_combout\);

-- Location: LCFF_X20_Y35_N27
\counter[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[13]~58_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(13));

-- Location: LCCOMB_X20_Y35_N28
\counter[14]~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[14]~60_combout\ = (counter(14) & (\counter[13]~59\ $ (GND))) # (!counter(14) & (!\counter[13]~59\ & VCC))
-- \counter[14]~61\ = CARRY((counter(14) & !\counter[13]~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(14),
	datad => VCC,
	cin => \counter[13]~59\,
	combout => \counter[14]~60_combout\,
	cout => \counter[14]~61\);

-- Location: LCFF_X20_Y35_N29
\counter[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[14]~60_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(14));

-- Location: LCCOMB_X20_Y35_N30
\counter[15]~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[15]~62_combout\ = (counter(15) & (!\counter[14]~61\)) # (!counter(15) & ((\counter[14]~61\) # (GND)))
-- \counter[15]~63\ = CARRY((!\counter[14]~61\) # (!counter(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(15),
	datad => VCC,
	cin => \counter[14]~61\,
	combout => \counter[15]~62_combout\,
	cout => \counter[15]~63\);

-- Location: LCFF_X20_Y35_N31
\counter[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[15]~62_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(15));

-- Location: LCCOMB_X20_Y34_N0
\counter[16]~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[16]~64_combout\ = (counter(16) & (\counter[15]~63\ $ (GND))) # (!counter(16) & (!\counter[15]~63\ & VCC))
-- \counter[16]~65\ = CARRY((counter(16) & !\counter[15]~63\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(16),
	datad => VCC,
	cin => \counter[15]~63\,
	combout => \counter[16]~64_combout\,
	cout => \counter[16]~65\);

-- Location: LCFF_X20_Y34_N1
\counter[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[16]~64_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(16));

-- Location: LCCOMB_X20_Y34_N2
\counter[17]~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[17]~66_combout\ = (counter(17) & (!\counter[16]~65\)) # (!counter(17) & ((\counter[16]~65\) # (GND)))
-- \counter[17]~67\ = CARRY((!\counter[16]~65\) # (!counter(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(17),
	datad => VCC,
	cin => \counter[16]~65\,
	combout => \counter[17]~66_combout\,
	cout => \counter[17]~67\);

-- Location: LCFF_X20_Y34_N3
\counter[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[17]~66_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(17));

-- Location: LCCOMB_X20_Y34_N4
\counter[18]~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[18]~68_combout\ = (counter(18) & (\counter[17]~67\ $ (GND))) # (!counter(18) & (!\counter[17]~67\ & VCC))
-- \counter[18]~69\ = CARRY((counter(18) & !\counter[17]~67\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(18),
	datad => VCC,
	cin => \counter[17]~67\,
	combout => \counter[18]~68_combout\,
	cout => \counter[18]~69\);

-- Location: LCFF_X20_Y34_N5
\counter[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[18]~68_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(18));

-- Location: LCCOMB_X20_Y34_N6
\counter[19]~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[19]~70_combout\ = (counter(19) & (!\counter[18]~69\)) # (!counter(19) & ((\counter[18]~69\) # (GND)))
-- \counter[19]~71\ = CARRY((!\counter[18]~69\) # (!counter(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(19),
	datad => VCC,
	cin => \counter[18]~69\,
	combout => \counter[19]~70_combout\,
	cout => \counter[19]~71\);

-- Location: LCCOMB_X20_Y34_N8
\counter[20]~72\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[20]~72_combout\ = (counter(20) & (\counter[19]~71\ $ (GND))) # (!counter(20) & (!\counter[19]~71\ & VCC))
-- \counter[20]~73\ = CARRY((counter(20) & !\counter[19]~71\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(20),
	datad => VCC,
	cin => \counter[19]~71\,
	combout => \counter[20]~72_combout\,
	cout => \counter[20]~73\);

-- Location: LCFF_X20_Y34_N9
\counter[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[20]~72_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(20));

-- Location: LCCOMB_X20_Y34_N10
\counter[21]~74\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[21]~74_combout\ = (counter(21) & (!\counter[20]~73\)) # (!counter(21) & ((\counter[20]~73\) # (GND)))
-- \counter[21]~75\ = CARRY((!\counter[20]~73\) # (!counter(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(21),
	datad => VCC,
	cin => \counter[20]~73\,
	combout => \counter[21]~74_combout\,
	cout => \counter[21]~75\);

-- Location: LCCOMB_X20_Y34_N12
\counter[22]~76\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[22]~76_combout\ = (counter(22) & (\counter[21]~75\ $ (GND))) # (!counter(22) & (!\counter[21]~75\ & VCC))
-- \counter[22]~77\ = CARRY((counter(22) & !\counter[21]~75\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(22),
	datad => VCC,
	cin => \counter[21]~75\,
	combout => \counter[22]~76_combout\,
	cout => \counter[22]~77\);

-- Location: LCFF_X21_Y34_N29
\counter[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \counter[22]~76_combout\,
	sclr => \counter[16]~97_combout\,
	sload => VCC,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(22));

-- Location: LCCOMB_X20_Y34_N14
\counter[23]~78\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[23]~78_combout\ = (counter(23) & (!\counter[22]~77\)) # (!counter(23) & ((\counter[22]~77\) # (GND)))
-- \counter[23]~79\ = CARRY((!\counter[22]~77\) # (!counter(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(23),
	datad => VCC,
	cin => \counter[22]~77\,
	combout => \counter[23]~78_combout\,
	cout => \counter[23]~79\);

-- Location: LCCOMB_X20_Y34_N16
\counter[24]~80\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[24]~80_combout\ = (counter(24) & (\counter[23]~79\ $ (GND))) # (!counter(24) & (!\counter[23]~79\ & VCC))
-- \counter[24]~81\ = CARRY((counter(24) & !\counter[23]~79\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(24),
	datad => VCC,
	cin => \counter[23]~79\,
	combout => \counter[24]~80_combout\,
	cout => \counter[24]~81\);

-- Location: LCFF_X21_Y34_N13
\counter[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \counter[24]~80_combout\,
	sclr => \counter[16]~97_combout\,
	sload => VCC,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(24));

-- Location: LCCOMB_X20_Y34_N18
\counter[25]~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[25]~82_combout\ = (counter(25) & (!\counter[24]~81\)) # (!counter(25) & ((\counter[24]~81\) # (GND)))
-- \counter[25]~83\ = CARRY((!\counter[24]~81\) # (!counter(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(25),
	datad => VCC,
	cin => \counter[24]~81\,
	combout => \counter[25]~82_combout\,
	cout => \counter[25]~83\);

-- Location: LCFF_X21_Y34_N15
\counter[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \counter[25]~82_combout\,
	sclr => \counter[16]~97_combout\,
	sload => VCC,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(25));

-- Location: LCCOMB_X20_Y34_N20
\counter[26]~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[26]~84_combout\ = (counter(26) & (\counter[25]~83\ $ (GND))) # (!counter(26) & (!\counter[25]~83\ & VCC))
-- \counter[26]~85\ = CARRY((counter(26) & !\counter[25]~83\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(26),
	datad => VCC,
	cin => \counter[25]~83\,
	combout => \counter[26]~84_combout\,
	cout => \counter[26]~85\);

-- Location: LCCOMB_X20_Y34_N22
\counter[27]~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[27]~86_combout\ = (counter(27) & (!\counter[26]~85\)) # (!counter(27) & ((\counter[26]~85\) # (GND)))
-- \counter[27]~87\ = CARRY((!\counter[26]~85\) # (!counter(27)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(27),
	datad => VCC,
	cin => \counter[26]~85\,
	combout => \counter[27]~86_combout\,
	cout => \counter[27]~87\);

-- Location: LCFF_X20_Y34_N23
\counter[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[27]~86_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(27));

-- Location: LCCOMB_X20_Y34_N24
\counter[28]~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[28]~88_combout\ = (counter(28) & (\counter[27]~87\ $ (GND))) # (!counter(28) & (!\counter[27]~87\ & VCC))
-- \counter[28]~89\ = CARRY((counter(28) & !\counter[27]~87\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(28),
	datad => VCC,
	cin => \counter[27]~87\,
	combout => \counter[28]~88_combout\,
	cout => \counter[28]~89\);

-- Location: LCFF_X20_Y34_N25
\counter[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[28]~88_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(28));

-- Location: LCCOMB_X20_Y34_N26
\counter[29]~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[29]~90_combout\ = (counter(29) & (!\counter[28]~89\)) # (!counter(29) & ((\counter[28]~89\) # (GND)))
-- \counter[29]~91\ = CARRY((!\counter[28]~89\) # (!counter(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(29),
	datad => VCC,
	cin => \counter[28]~89\,
	combout => \counter[29]~90_combout\,
	cout => \counter[29]~91\);

-- Location: LCFF_X20_Y34_N27
\counter[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[29]~90_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(29));

-- Location: LCCOMB_X21_Y34_N0
\LessThan1~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~5_combout\ = (!counter(26) & (!counter(28) & (!counter(29) & !counter(27))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(26),
	datab => counter(28),
	datac => counter(29),
	datad => counter(27),
	combout => \LessThan1~5_combout\);

-- Location: LCCOMB_X20_Y34_N28
\counter[30]~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[30]~92_combout\ = (counter(30) & (\counter[29]~91\ $ (GND))) # (!counter(30) & (!\counter[29]~91\ & VCC))
-- \counter[30]~93\ = CARRY((counter(30) & !\counter[29]~91\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(30),
	datad => VCC,
	cin => \counter[29]~91\,
	combout => \counter[30]~92_combout\,
	cout => \counter[30]~93\);

-- Location: LCFF_X20_Y34_N29
\counter[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[30]~92_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(30));

-- Location: LCCOMB_X21_Y35_N30
\LessThan1~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~6_combout\ = (\LessThan1~5_combout\ & (!counter(30) & \LessThan1~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \LessThan1~5_combout\,
	datac => counter(30),
	datad => \LessThan1~4_combout\,
	combout => \LessThan1~6_combout\);

-- Location: LCCOMB_X20_Y35_N10
\counter[5]~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[5]~42_combout\ = (counter(5) & (!\counter[4]~41\)) # (!counter(5) & ((\counter[4]~41\) # (GND)))
-- \counter[5]~43\ = CARRY((!\counter[4]~41\) # (!counter(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(5),
	datad => VCC,
	cin => \counter[4]~41\,
	combout => \counter[5]~42_combout\,
	cout => \counter[5]~43\);

-- Location: LCFF_X20_Y35_N11
\counter[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[5]~42_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(5));

-- Location: LCCOMB_X20_Y35_N12
\counter[6]~44\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[6]~44_combout\ = (counter(6) & (\counter[5]~43\ $ (GND))) # (!counter(6) & (!\counter[5]~43\ & VCC))
-- \counter[6]~45\ = CARRY((counter(6) & !\counter[5]~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(6),
	datad => VCC,
	cin => \counter[5]~43\,
	combout => \counter[6]~44_combout\,
	cout => \counter[6]~45\);

-- Location: LCFF_X20_Y35_N13
\counter[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[6]~44_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(6));

-- Location: LCCOMB_X21_Y35_N4
\LessThan1~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~9_combout\ = (counter(9) & ((counter(7)) # ((counter(5) & counter(6)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(7),
	datab => counter(9),
	datac => counter(5),
	datad => counter(6),
	combout => \LessThan1~9_combout\);

-- Location: LCCOMB_X20_Y35_N16
\counter[8]~48\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[8]~48_combout\ = (counter(8) & (\counter[7]~47\ $ (GND))) # (!counter(8) & (!\counter[7]~47\ & VCC))
-- \counter[8]~49\ = CARRY((counter(8) & !\counter[7]~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(8),
	datad => VCC,
	cin => \counter[7]~47\,
	combout => \counter[8]~48_combout\,
	cout => \counter[8]~49\);

-- Location: LCFF_X20_Y35_N17
\counter[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[8]~48_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(8));

-- Location: LCCOMB_X20_Y35_N6
\counter[3]~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[3]~38_combout\ = (counter(3) & (!\counter[2]~37\)) # (!counter(3) & ((\counter[2]~37\) # (GND)))
-- \counter[3]~39\ = CARRY((!\counter[2]~37\) # (!counter(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(3),
	datad => VCC,
	cin => \counter[2]~37\,
	combout => \counter[3]~38_combout\,
	cout => \counter[3]~39\);

-- Location: LCFF_X20_Y35_N7
\counter[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[3]~38_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(3));

-- Location: LCCOMB_X21_Y35_N0
\LessThan1~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~7_combout\ = (counter(3) & ((counter(0)) # ((counter(2)) # (counter(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(0),
	datab => counter(2),
	datac => counter(3),
	datad => counter(1),
	combout => \LessThan1~7_combout\);

-- Location: LCCOMB_X21_Y35_N22
\LessThan1~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~8_combout\ = (counter(6) & (counter(4) & (counter(9) & \LessThan1~7_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(6),
	datab => counter(4),
	datac => counter(9),
	datad => \LessThan1~7_combout\,
	combout => \LessThan1~8_combout\);

-- Location: LCCOMB_X22_Y35_N24
\LessThan1~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~10_combout\ = (\LessThan1~9_combout\) # ((\LessThan1~8_combout\) # ((counter(9) & counter(8))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(9),
	datab => \LessThan1~9_combout\,
	datac => counter(8),
	datad => \LessThan1~8_combout\,
	combout => \LessThan1~10_combout\);

-- Location: LCCOMB_X21_Y35_N14
\Selector0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector0~0_combout\ = (!\n_s.latch_state~regout\ & ((counter(31)) # ((\LessThan1~6_combout\ & !\LessThan1~10_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101000001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(31),
	datab => \LessThan1~6_combout\,
	datac => \n_s.latch_state~regout\,
	datad => \LessThan1~10_combout\,
	combout => \Selector0~0_combout\);

-- Location: LCCOMB_X22_Y35_N14
\Selector0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector0~1_combout\ = (!\Selector0~0_combout\ & ((\LessThan2~4_combout\) # (!\n_s.done~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010111011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan2~4_combout\,
	datab => \n_s.done~regout\,
	datad => \Selector0~0_combout\,
	combout => \Selector0~1_combout\);

-- Location: LCFF_X22_Y35_N15
\n_s.latch_state\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \Selector0~1_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.latch_state~regout\);

-- Location: LCCOMB_X21_Y35_N12
\LessThan2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~0_combout\ = (counter(3) & (counter(2) & ((counter(0)) # (counter(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(0),
	datab => counter(3),
	datac => counter(2),
	datad => counter(1),
	combout => \LessThan2~0_combout\);

-- Location: LCCOMB_X21_Y35_N6
\LessThan2~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~1_combout\ = (counter(6)) # ((counter(5) & ((counter(4)) # (\LessThan2~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(6),
	datab => counter(4),
	datac => counter(5),
	datad => \LessThan2~0_combout\,
	combout => \LessThan2~1_combout\);

-- Location: LCCOMB_X21_Y35_N24
\LessThan2~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~2_combout\ = (counter(9)) # ((counter(8) & ((counter(7)) # (\LessThan2~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(7),
	datab => counter(8),
	datac => counter(9),
	datad => \LessThan2~1_combout\,
	combout => \LessThan2~2_combout\);

-- Location: LCCOMB_X21_Y35_N8
\counter[16]~96\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[16]~96_combout\ = (\n_s.latch_state~regout\ & (((\LessThan2~2_combout\)))) # (!\n_s.latch_state~regout\ & ((\LessThan1~11_combout\) # ((\LessThan1~8_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~11_combout\,
	datab => \n_s.latch_state~regout\,
	datac => \LessThan2~2_combout\,
	datad => \LessThan1~8_combout\,
	combout => \counter[16]~96_combout\);

-- Location: LCCOMB_X21_Y35_N2
\counter[16]~97\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[16]~97_combout\ = (!counter(31) & ((\counter[16]~96_combout\) # (!\LessThan1~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(31),
	datac => \counter[16]~96_combout\,
	datad => \LessThan1~6_combout\,
	combout => \counter[16]~97_combout\);

-- Location: LCFF_X20_Y35_N1
\counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[0]~32_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(0));

-- Location: LCCOMB_X20_Y35_N2
\counter[1]~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[1]~34_combout\ = (counter(1) & (!\counter[0]~33\)) # (!counter(1) & ((\counter[0]~33\) # (GND)))
-- \counter[1]~35\ = CARRY((!\counter[0]~33\) # (!counter(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(1),
	datad => VCC,
	cin => \counter[0]~33\,
	combout => \counter[1]~34_combout\,
	cout => \counter[1]~35\);

-- Location: LCFF_X20_Y35_N3
\counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[1]~34_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(1));

-- Location: LCCOMB_X20_Y35_N4
\counter[2]~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[2]~36_combout\ = (counter(2) & (\counter[1]~35\ $ (GND))) # (!counter(2) & (!\counter[1]~35\ & VCC))
-- \counter[2]~37\ = CARRY((counter(2) & !\counter[1]~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(2),
	datad => VCC,
	cin => \counter[1]~35\,
	combout => \counter[2]~36_combout\,
	cout => \counter[2]~37\);

-- Location: LCFF_X20_Y35_N5
\counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[2]~36_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(2));

-- Location: LCCOMB_X20_Y35_N8
\counter[4]~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[4]~40_combout\ = (counter(4) & (\counter[3]~39\ $ (GND))) # (!counter(4) & (!\counter[3]~39\ & VCC))
-- \counter[4]~41\ = CARRY((counter(4) & !\counter[3]~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(4),
	datad => VCC,
	cin => \counter[3]~39\,
	combout => \counter[4]~40_combout\,
	cout => \counter[4]~41\);

-- Location: LCFF_X20_Y35_N9
\counter[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[4]~40_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(4));

-- Location: LCCOMB_X20_Y35_N14
\counter[7]~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[7]~46_combout\ = (counter(7) & (!\counter[6]~45\)) # (!counter(7) & ((\counter[6]~45\) # (GND)))
-- \counter[7]~47\ = CARRY((!\counter[6]~45\) # (!counter(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(7),
	datad => VCC,
	cin => \counter[6]~45\,
	combout => \counter[7]~46_combout\,
	cout => \counter[7]~47\);

-- Location: LCFF_X20_Y35_N15
\counter[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[7]~46_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(7));

-- Location: LCCOMB_X20_Y35_N18
\counter[9]~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[9]~50_combout\ = (counter(9) & (!\counter[8]~49\)) # (!counter(9) & ((\counter[8]~49\) # (GND)))
-- \counter[9]~51\ = CARRY((!\counter[8]~49\) # (!counter(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter(9),
	datad => VCC,
	cin => \counter[8]~49\,
	combout => \counter[9]~50_combout\,
	cout => \counter[9]~51\);

-- Location: LCFF_X20_Y35_N19
\counter[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[9]~50_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(9));

-- Location: LCCOMB_X20_Y35_N20
\counter[10]~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[10]~52_combout\ = (counter(10) & (\counter[9]~51\ $ (GND))) # (!counter(10) & (!\counter[9]~51\ & VCC))
-- \counter[10]~53\ = CARRY((counter(10) & !\counter[9]~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter(10),
	datad => VCC,
	cin => \counter[9]~51\,
	combout => \counter[10]~52_combout\,
	cout => \counter[10]~53\);

-- Location: LCFF_X20_Y35_N23
\counter[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[11]~54_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(11));

-- Location: LCFF_X20_Y35_N25
\counter[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[12]~56_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(12));

-- Location: LCCOMB_X21_Y35_N26
\LessThan1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~0_combout\ = (!counter(10) & (!counter(11) & (!counter(12) & !counter(13))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(10),
	datab => counter(11),
	datac => counter(12),
	datad => counter(13),
	combout => \LessThan1~0_combout\);

-- Location: LCFF_X21_Y34_N3
\counter[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \counter[23]~78_combout\,
	sclr => \counter[16]~97_combout\,
	sload => VCC,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(23));

-- Location: LCCOMB_X21_Y34_N26
\LessThan1~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~3_combout\ = (!counter(24) & (!counter(23) & (!counter(25) & !counter(22))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(24),
	datab => counter(23),
	datac => counter(25),
	datad => counter(22),
	combout => \LessThan1~3_combout\);

-- Location: LCFF_X20_Y34_N7
\counter[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[19]~70_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(19));

-- Location: LCCOMB_X21_Y35_N18
\LessThan1~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~2_combout\ = (!counter(21) & (!counter(18) & (!counter(19) & !counter(20))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(21),
	datab => counter(18),
	datac => counter(19),
	datad => counter(20),
	combout => \LessThan1~2_combout\);

-- Location: LCCOMB_X21_Y35_N28
\LessThan1~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan1~4_combout\ = (\LessThan1~1_combout\ & (\LessThan1~0_combout\ & (\LessThan1~3_combout\ & \LessThan1~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~1_combout\,
	datab => \LessThan1~0_combout\,
	datac => \LessThan1~3_combout\,
	datad => \LessThan1~2_combout\,
	combout => \LessThan1~4_combout\);

-- Location: LCCOMB_X22_Y35_N2
\Selector9~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector9~0_combout\ = (counter(30)) # ((counter(9) & counter(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(9),
	datac => counter(8),
	datad => counter(30),
	combout => \Selector9~0_combout\);

-- Location: LCCOMB_X22_Y35_N28
\Selector9~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector9~1_combout\ = (\LessThan1~5_combout\ & (!\LessThan1~8_combout\ & (!\LessThan1~9_combout\ & !\Selector9~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~5_combout\,
	datab => \LessThan1~8_combout\,
	datac => \LessThan1~9_combout\,
	datad => \Selector9~0_combout\,
	combout => \Selector9~1_combout\);

-- Location: LCCOMB_X22_Y35_N30
\Selector9~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector9~2_combout\ = (!counter(31) & (!\n_s.latch_state~regout\ & ((!\Selector9~1_combout\) # (!\LessThan1~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(31),
	datab => \LessThan1~4_combout\,
	datac => \n_s.latch_state~regout\,
	datad => \Selector9~1_combout\,
	combout => \Selector9~2_combout\);

-- Location: LCCOMB_X20_Y34_N30
\counter[31]~94\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter[31]~94_combout\ = \counter[30]~93\ $ (counter(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => counter(31),
	cin => \counter[30]~93\,
	combout => \counter[31]~94_combout\);

-- Location: LCFF_X20_Y34_N31
\counter[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[31]~94_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(31));

-- Location: LCCOMB_X22_Y35_N12
\LessThan2~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~4_combout\ = (counter(31)) # ((\LessThan2~3_combout\ & (\LessThan1~4_combout\ & !\LessThan2~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan2~3_combout\,
	datab => \LessThan1~4_combout\,
	datac => counter(31),
	datad => \LessThan2~2_combout\,
	combout => \LessThan2~4_combout\);

-- Location: LCCOMB_X22_Y35_N10
\Selector9~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \Selector9~3_combout\ = (\Selector9~2_combout\) # ((\n_s.l0~regout\ & \LessThan2~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Selector9~2_combout\,
	datac => \n_s.l0~regout\,
	datad => \LessThan2~4_combout\,
	combout => \Selector9~3_combout\);

-- Location: LCFF_X22_Y35_N11
\n_s.l0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \Selector9~3_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l0~regout\);

-- Location: LCCOMB_X23_Y35_N14
\n_s.p0~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p0~feeder_combout\ = \n_s.l0~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l0~regout\,
	combout => \n_s.p0~feeder_combout\);

-- Location: LCCOMB_X22_Y35_N20
\n_s~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s~38_combout\ = (!counter(31) & (\fsm_like_things~0_combout\ & ((\LessThan2~2_combout\) # (!\LessThan1~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(31),
	datab => \LessThan2~2_combout\,
	datac => \LessThan1~6_combout\,
	datad => \fsm_like_things~0_combout\,
	combout => \n_s~38_combout\);

-- Location: LCFF_X23_Y35_N15
\n_s.p0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p0~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p0~regout\);

-- Location: LCFF_X23_Y35_N27
\n_s.l1\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \n_s.p0~regout\,
	sload => VCC,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l1~regout\);

-- Location: LCCOMB_X23_Y35_N20
\n_s.p1~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p1~feeder_combout\ = \n_s.l1~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l1~regout\,
	combout => \n_s.p1~feeder_combout\);

-- Location: LCFF_X23_Y35_N21
\n_s.p1\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p1~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p1~regout\);

-- Location: LCFF_X23_Y35_N17
\n_s.l2\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \n_s.p1~regout\,
	sload => VCC,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l2~regout\);

-- Location: LCCOMB_X24_Y35_N28
\n_s.p2~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p2~feeder_combout\ = \n_s.l2~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l2~regout\,
	combout => \n_s.p2~feeder_combout\);

-- Location: LCFF_X24_Y35_N29
\n_s.p2\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p2~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p2~regout\);

-- Location: LCCOMB_X24_Y35_N24
\n_s.l3~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.l3~feeder_combout\ = \n_s.p2~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.p2~regout\,
	combout => \n_s.l3~feeder_combout\);

-- Location: LCFF_X24_Y35_N25
\n_s.l3\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.l3~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l3~regout\);

-- Location: LCFF_X24_Y35_N19
\n_s.p3\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \n_s.l3~regout\,
	sload => VCC,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p3~regout\);

-- Location: LCCOMB_X23_Y35_N10
\n_s.l4~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.l4~feeder_combout\ = \n_s.p3~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.p3~regout\,
	combout => \n_s.l4~feeder_combout\);

-- Location: LCFF_X23_Y35_N11
\n_s.l4\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.l4~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l4~regout\);

-- Location: LCCOMB_X23_Y35_N22
\n_s.p4~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p4~feeder_combout\ = \n_s.l4~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l4~regout\,
	combout => \n_s.p4~feeder_combout\);

-- Location: LCFF_X23_Y35_N23
\n_s.p4\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p4~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p4~regout\);

-- Location: LCCOMB_X23_Y35_N28
\n_s.l5~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.l5~feeder_combout\ = \n_s.p4~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.p4~regout\,
	combout => \n_s.l5~feeder_combout\);

-- Location: LCFF_X23_Y35_N29
\n_s.l5\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.l5~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l5~regout\);

-- Location: LCCOMB_X23_Y35_N12
\n_s.p5~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p5~feeder_combout\ = \n_s.l5~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l5~regout\,
	combout => \n_s.p5~feeder_combout\);

-- Location: LCFF_X23_Y35_N13
\n_s.p5\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p5~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p5~regout\);

-- Location: LCCOMB_X23_Y35_N24
\n_s.l6~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.l6~feeder_combout\ = \n_s.p5~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.p5~regout\,
	combout => \n_s.l6~feeder_combout\);

-- Location: LCFF_X23_Y35_N25
\n_s.l6\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.l6~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l6~regout\);

-- Location: LCFF_X23_Y35_N19
\n_s.p6\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \n_s.l6~regout\,
	sload => VCC,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p6~regout\);

-- Location: LCCOMB_X23_Y35_N6
\n_s.l7~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.l7~feeder_combout\ = \n_s.p6~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.p6~regout\,
	combout => \n_s.l7~feeder_combout\);

-- Location: LCFF_X23_Y35_N7
\n_s.l7\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.l7~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.l7~regout\);

-- Location: LCCOMB_X23_Y35_N4
\n_s.p7~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \n_s.p7~feeder_combout\ = \n_s.l7~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \n_s.l7~regout\,
	combout => \n_s.p7~feeder_combout\);

-- Location: LCFF_X23_Y35_N5
\n_s.p7\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \n_s.p7~feeder_combout\,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.p7~regout\);

-- Location: LCFF_X23_Y35_N31
\n_s.done\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \n_s.p7~regout\,
	sload => VCC,
	ena => \n_s~38_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \n_s.done~regout\);

-- Location: LCCOMB_X22_Y35_N22
\in_state_machine~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \in_state_machine~0_combout\ = (counter(31)) # (((\LessThan1~6_combout\ & !\LessThan2~2_combout\)) # (!\n_s.done~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111111011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter(31),
	datab => \n_s.done~regout\,
	datac => \LessThan1~6_combout\,
	datad => \LessThan2~2_combout\,
	combout => \in_state_machine~0_combout\);

-- Location: LCFF_X22_Y35_N23
in_state_machine : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \in_state_machine~0_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \in_state_machine~regout\);

-- Location: LCCOMB_X21_Y35_N20
\latch~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \latch~2_combout\ = (\Selector0~0_combout\ & ((\in_state_machine~regout\) # (\clock_60hz~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \in_state_machine~regout\,
	datac => \Selector0~0_combout\,
	datad => \clock_60hz~regout\,
	combout => \latch~2_combout\);

-- Location: LCFF_X21_Y35_N21
\latch~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \latch~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \latch~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N2
\WideOr18~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \WideOr18~1_combout\ = (\n_s.p5~regout\) # ((\n_s.p6~regout\) # ((\n_s.p7~regout\) # (\n_s.p4~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.p5~regout\,
	datab => \n_s.p6~regout\,
	datac => \n_s.p7~regout\,
	datad => \n_s.p4~regout\,
	combout => \WideOr18~1_combout\);

-- Location: LCCOMB_X24_Y35_N20
\WideOr18~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \WideOr18~0_combout\ = (\n_s.p0~regout\) # ((\n_s.p2~regout\) # ((\n_s.p1~regout\) # (\n_s.p3~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.p0~regout\,
	datab => \n_s.p2~regout\,
	datac => \n_s.p1~regout\,
	datad => \n_s.p3~regout\,
	combout => \WideOr18~0_combout\);

-- Location: LCCOMB_X24_Y35_N16
\pulse~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \pulse~0_combout\ = (\fsm_like_things~0_combout\ & (\LessThan2~4_combout\ & ((\WideOr18~1_combout\) # (\WideOr18~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \WideOr18~1_combout\,
	datac => \WideOr18~0_combout\,
	datad => \LessThan2~4_combout\,
	combout => \pulse~0_combout\);

-- Location: LCFF_X24_Y35_N17
\pulse~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \pulse~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pulse~reg0_regout\);

-- Location: LCFF_X27_Y35_N9
\leds[0]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \in_state_machine~regout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[0]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N8
\leds[1]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[1]~0_combout\ = (\fsm_like_things~0_combout\ & ((\Selector0~0_combout\) # ((\n_s.latch_state~regout\ & \leds[1]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[1]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.latch_state~regout\,
	datac => \leds[1]~reg0_regout\,
	datad => \Selector0~0_combout\,
	combout => \leds[1]~0_combout\);

-- Location: LCFF_X22_Y35_N9
\leds[1]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[1]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[1]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N18
\leds[2]~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[2]~1_combout\ = (\n_s.l0~regout\ & ((\fsm_like_things~0_combout\ & ((\LessThan2~4_combout\))) # (!\fsm_like_things~0_combout\ & (\leds[2]~reg0_regout\)))) # (!\n_s.l0~regout\ & (((\leds[2]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.l0~regout\,
	datab => \fsm_like_things~0_combout\,
	datac => \leds[2]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[2]~1_combout\);

-- Location: LCFF_X22_Y35_N19
\leds[2]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[2]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[2]~reg0_regout\);

-- Location: LCCOMB_X23_Y35_N0
\leds[3]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[3]~2_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.p0~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.p0~regout\ & (\leds[3]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[3]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.p0~regout\,
	datac => \leds[3]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[3]~2_combout\);

-- Location: LCFF_X23_Y35_N1
\leds[3]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[3]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[3]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N16
\leds[4]~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[4]~3_combout\ = (\n_s.l1~regout\ & ((\fsm_like_things~0_combout\ & ((\LessThan2~4_combout\))) # (!\fsm_like_things~0_combout\ & (\leds[4]~reg0_regout\)))) # (!\n_s.l1~regout\ & (((\leds[4]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.l1~regout\,
	datab => \fsm_like_things~0_combout\,
	datac => \leds[4]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[4]~3_combout\);

-- Location: LCFF_X22_Y35_N17
\leds[4]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[4]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[4]~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N10
\leds[5]~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[5]~4_combout\ = (\n_s.p1~regout\ & ((\fsm_like_things~0_combout\ & ((\LessThan2~4_combout\))) # (!\fsm_like_things~0_combout\ & (\leds[5]~reg0_regout\)))) # (!\n_s.p1~regout\ & (((\leds[5]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.p1~regout\,
	datab => \fsm_like_things~0_combout\,
	datac => \leds[5]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[5]~4_combout\);

-- Location: LCFF_X24_Y35_N11
\leds[5]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[5]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[5]~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N4
\leds[6]~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[6]~5_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.l2~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.l2~regout\ & (\leds[6]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[6]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.l2~regout\,
	datac => \leds[6]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[6]~5_combout\);

-- Location: LCFF_X24_Y35_N5
\leds[6]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[6]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[6]~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N22
\leds[7]~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[7]~6_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.p2~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.p2~regout\ & (\leds[7]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[7]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.p2~regout\,
	datac => \leds[7]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[7]~6_combout\);

-- Location: LCFF_X24_Y35_N23
\leds[7]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[7]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[7]~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N0
\leds[8]~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[8]~7_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.l3~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.l3~regout\ & (\leds[8]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[8]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.l3~regout\,
	datac => \leds[8]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[8]~7_combout\);

-- Location: LCFF_X24_Y35_N1
\leds[8]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[8]~reg0_regout\);

-- Location: LCCOMB_X24_Y35_N26
\leds[9]~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[9]~8_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.p3~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.p3~regout\ & (\leds[9]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[9]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.p3~regout\,
	datac => \leds[9]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[9]~8_combout\);

-- Location: LCFF_X24_Y35_N27
\leds[9]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[9]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[9]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N26
\leds[10]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[10]~9_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.l4~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.l4~regout\ & (\leds[10]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[10]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.l4~regout\,
	datac => \leds[10]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[10]~9_combout\);

-- Location: LCFF_X22_Y35_N27
\leds[10]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[10]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[10]~reg0_regout\);

-- Location: LCCOMB_X23_Y35_N2
\leds[11]~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[11]~10_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.p4~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.p4~regout\ & (\leds[11]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[11]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.p4~regout\,
	datac => \leds[11]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[11]~10_combout\);

-- Location: LCFF_X23_Y35_N3
\leds[11]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[11]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[11]~reg0_regout\);

-- Location: LCCOMB_X23_Y35_N8
\leds[12]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[12]~11_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.l5~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.l5~regout\ & (\leds[12]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[12]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.l5~regout\,
	datac => \leds[12]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[12]~11_combout\);

-- Location: LCFF_X23_Y35_N9
\leds[12]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[12]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[12]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N0
\leds[13]~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[13]~12_combout\ = (\n_s.p5~regout\ & ((\fsm_like_things~0_combout\ & ((\LessThan2~4_combout\))) # (!\fsm_like_things~0_combout\ & (\leds[13]~reg0_regout\)))) # (!\n_s.p5~regout\ & (((\leds[13]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \n_s.p5~regout\,
	datab => \fsm_like_things~0_combout\,
	datac => \leds[13]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[13]~12_combout\);

-- Location: LCFF_X22_Y35_N1
\leds[13]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[13]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[13]~reg0_regout\);

-- Location: LCCOMB_X22_Y35_N6
\leds[14]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \leds[14]~13_combout\ = (\fsm_like_things~0_combout\ & ((\n_s.done~regout\ & ((\LessThan2~4_combout\))) # (!\n_s.done~regout\ & (\leds[14]~reg0_regout\)))) # (!\fsm_like_things~0_combout\ & (((\leds[14]~reg0_regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fsm_like_things~0_combout\,
	datab => \n_s.done~regout\,
	datac => \leds[14]~reg0_regout\,
	datad => \LessThan2~4_combout\,
	combout => \leds[14]~13_combout\);

-- Location: LCFF_X22_Y35_N7
\leds[14]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \leds[14]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[14]~reg0_regout\);

-- Location: LCFF_X27_Y35_N19
\leds[15]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => \clock_60hz~regout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \leds[15]~reg0_regout\);

-- Location: LCCOMB_X19_Y35_N0
\counter_c[0]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[0]~0_combout\ = !counter(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => counter(0),
	combout => \counter_c[0]~0_combout\);

-- Location: LCFF_X19_Y35_N1
\counter_c[0]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[0]~reg0_regout\);

-- Location: LCCOMB_X17_Y35_N20
\counter_c[1]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[1]~reg0feeder_combout\ = counter(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(1),
	combout => \counter_c[1]~reg0feeder_combout\);

-- Location: LCFF_X17_Y35_N21
\counter_c[1]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[1]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[1]~reg0_regout\);

-- Location: LCFF_X18_Y35_N17
\counter_c[2]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(2),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[2]~reg0_regout\);

-- Location: LCCOMB_X17_Y35_N26
\counter_c[3]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[3]~reg0feeder_combout\ = counter(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(3),
	combout => \counter_c[3]~reg0feeder_combout\);

-- Location: LCFF_X17_Y35_N27
\counter_c[3]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[3]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[3]~reg0_regout\);

-- Location: LCFF_X19_Y35_N27
\counter_c[4]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(4),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[4]~reg0_regout\);

-- Location: LCCOMB_X18_Y35_N22
\counter_c[5]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[5]~reg0feeder_combout\ = counter(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(5),
	combout => \counter_c[5]~reg0feeder_combout\);

-- Location: LCFF_X18_Y35_N23
\counter_c[5]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[5]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[5]~reg0_regout\);

-- Location: LCCOMB_X30_Y35_N16
\counter_c[6]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[6]~reg0feeder_combout\ = counter(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(6),
	combout => \counter_c[6]~reg0feeder_combout\);

-- Location: LCFF_X30_Y35_N17
\counter_c[6]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[6]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[6]~reg0_regout\);

-- Location: LCCOMB_X17_Y35_N12
\counter_c[7]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[7]~reg0feeder_combout\ = counter(7)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(7),
	combout => \counter_c[7]~reg0feeder_combout\);

-- Location: LCFF_X17_Y35_N13
\counter_c[7]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[7]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[7]~reg0_regout\);

-- Location: LCFF_X22_Y35_N5
\counter_c[8]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(8),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[8]~reg0_regout\);

-- Location: LCCOMB_X19_Y35_N24
\counter_c[9]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[9]~reg0feeder_combout\ = counter(9)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(9),
	combout => \counter_c[9]~reg0feeder_combout\);

-- Location: LCFF_X19_Y35_N25
\counter_c[9]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[9]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[9]~reg0_regout\);

-- Location: LCFF_X20_Y35_N21
\counter[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[10]~52_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(10));

-- Location: LCCOMB_X19_Y35_N10
\counter_c[10]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[10]~reg0feeder_combout\ = counter(10)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(10),
	combout => \counter_c[10]~reg0feeder_combout\);

-- Location: LCFF_X19_Y35_N11
\counter_c[10]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[10]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[10]~reg0_regout\);

-- Location: LCCOMB_X18_Y35_N20
\counter_c[11]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[11]~reg0feeder_combout\ = counter(11)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(11),
	combout => \counter_c[11]~reg0feeder_combout\);

-- Location: LCFF_X18_Y35_N21
\counter_c[11]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[11]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[11]~reg0_regout\);

-- Location: LCCOMB_X19_Y35_N16
\counter_c[12]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[12]~reg0feeder_combout\ = counter(12)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(12),
	combout => \counter_c[12]~reg0feeder_combout\);

-- Location: LCFF_X19_Y35_N17
\counter_c[12]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[12]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[12]~reg0_regout\);

-- Location: LCFF_X19_Y35_N19
\counter_c[13]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(13),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[13]~reg0_regout\);

-- Location: LCCOMB_X19_Y35_N12
\counter_c[14]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[14]~reg0feeder_combout\ = counter(14)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(14),
	combout => \counter_c[14]~reg0feeder_combout\);

-- Location: LCFF_X19_Y35_N13
\counter_c[14]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[14]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[14]~reg0_regout\);

-- Location: LCCOMB_X18_Y35_N10
\counter_c[15]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[15]~reg0feeder_combout\ = counter(15)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(15),
	combout => \counter_c[15]~reg0feeder_combout\);

-- Location: LCFF_X18_Y35_N11
\counter_c[15]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[15]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[15]~reg0_regout\);

-- Location: LCCOMB_X17_Y35_N18
\counter_c[16]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[16]~reg0feeder_combout\ = counter(16)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(16),
	combout => \counter_c[16]~reg0feeder_combout\);

-- Location: LCFF_X17_Y35_N19
\counter_c[16]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[16]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[16]~reg0_regout\);

-- Location: LCCOMB_X16_Y35_N16
\counter_c[17]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[17]~reg0feeder_combout\ = counter(17)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(17),
	combout => \counter_c[17]~reg0feeder_combout\);

-- Location: LCFF_X16_Y35_N17
\counter_c[17]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[17]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[17]~reg0_regout\);

-- Location: LCCOMB_X17_Y35_N0
\counter_c[18]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[18]~reg0feeder_combout\ = counter(18)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(18),
	combout => \counter_c[18]~reg0feeder_combout\);

-- Location: LCFF_X17_Y35_N1
\counter_c[18]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[18]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[18]~reg0_regout\);

-- Location: LCFF_X17_Y35_N23
\counter_c[19]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(19),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[19]~reg0_regout\);

-- Location: LCFF_X16_Y35_N27
\counter_c[20]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(20),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[20]~reg0_regout\);

-- Location: LCFF_X20_Y34_N11
\counter[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[21]~74_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(21));

-- Location: LCCOMB_X16_Y35_N4
\counter_c[21]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[21]~reg0feeder_combout\ = counter(21)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(21),
	combout => \counter_c[21]~reg0feeder_combout\);

-- Location: LCFF_X16_Y35_N5
\counter_c[21]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[21]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[21]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N24
\counter_c[22]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[22]~reg0feeder_combout\ = counter(22)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(22),
	combout => \counter_c[22]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N25
\counter_c[22]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[22]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[22]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N22
\counter_c[23]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[23]~reg0feeder_combout\ = counter(23)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => counter(23),
	combout => \counter_c[23]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N23
\counter_c[23]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[23]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[23]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N16
\counter_c[24]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[24]~reg0feeder_combout\ = counter(24)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(24),
	combout => \counter_c[24]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N17
\counter_c[24]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[24]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[24]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N18
\counter_c[25]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[25]~reg0feeder_combout\ = counter(25)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(25),
	combout => \counter_c[25]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N19
\counter_c[25]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[25]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[25]~reg0_regout\);

-- Location: LCFF_X20_Y34_N21
\counter[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter[26]~84_combout\,
	sclr => \counter[16]~97_combout\,
	ena => \fsm_like_things~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => counter(26));

-- Location: LCCOMB_X21_Y34_N20
\counter_c[26]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[26]~reg0feeder_combout\ = counter(26)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => counter(26),
	combout => \counter_c[26]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N21
\counter_c[26]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[26]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[26]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N30
\counter_c[27]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[27]~reg0feeder_combout\ = counter(27)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(27),
	combout => \counter_c[27]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N31
\counter_c[27]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[27]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[27]~reg0_regout\);

-- Location: LCCOMB_X21_Y34_N8
\counter_c[28]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[28]~reg0feeder_combout\ = counter(28)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(28),
	combout => \counter_c[28]~reg0feeder_combout\);

-- Location: LCFF_X21_Y34_N9
\counter_c[28]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[28]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[28]~reg0_regout\);

-- Location: LCCOMB_X27_Y34_N16
\counter_c[29]~reg0feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[29]~reg0feeder_combout\ = counter(29)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(29),
	combout => \counter_c[29]~reg0feeder_combout\);

-- Location: LCFF_X27_Y34_N17
\counter_c[29]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[29]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[29]~reg0_regout\);

-- Location: LCFF_X19_Y35_N23
\counter_c[30]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	sdata => counter(30),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[30]~reg0_regout\);

-- Location: LCCOMB_X22_Y34_N0
\counter_c[31]~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \counter_c[31]~1_combout\ = !counter(31)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => counter(31),
	combout => \counter_c[31]~1_combout\);

-- Location: LCFF_X22_Y34_N1
\counter_c[31]~reg0\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \counter_c[31]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \counter_c[31]~reg0_regout\);

-- Location: PIN_B9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\latch~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \latch~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_latch);

-- Location: PIN_F13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\pulse~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \pulse~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_pulse);

-- Location: PIN_C13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\data~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_data);

-- Location: PIN_F14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[0]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(0));

-- Location: PIN_B10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[1]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(1));

-- Location: PIN_C11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[2]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(2));

-- Location: PIN_G12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[3]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(3));

-- Location: PIN_A10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[4]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(4));

-- Location: PIN_J10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[5]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(5));

-- Location: PIN_G13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[6]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(6));

-- Location: PIN_J14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[7]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[7]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(7));

-- Location: PIN_D12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[8]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[8]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(8));

-- Location: PIN_J11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[9]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[9]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(9));

-- Location: PIN_D11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[10]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[10]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(10));

-- Location: PIN_A14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[11]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[11]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(11));

-- Location: PIN_F12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[12]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[12]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(12));

-- Location: PIN_G11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[13]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[13]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(13));

-- Location: PIN_B14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[14]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[14]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(14));

-- Location: PIN_D14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\leds[15]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \leds[15]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_leds(15));

-- Location: PIN_B7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_counter_c[0]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(0));

-- Location: PIN_F9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[1]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(1));

-- Location: PIN_D8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[2]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(2));

-- Location: PIN_C9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[3]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(3));

-- Location: PIN_F11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[4]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(4));

-- Location: PIN_C8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[5]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(5));

-- Location: PIN_B16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[6]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(6));

-- Location: PIN_H8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[7]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[7]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(7));

-- Location: PIN_B12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[8]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[8]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(8));

-- Location: PIN_H11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[9]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[9]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(9));

-- Location: PIN_D6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[10]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[10]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(10));

-- Location: PIN_D7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[11]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[11]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(11));

-- Location: PIN_E10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[12]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[12]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(12));

-- Location: PIN_G10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[13]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[13]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(13));

-- Location: PIN_H12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[14]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[14]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(14));

-- Location: PIN_C7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[15]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[15]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(15));

-- Location: PIN_A8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[16]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[16]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(16));

-- Location: PIN_A7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[17]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[17]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(17));

-- Location: PIN_B8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[18]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[18]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(18));

-- Location: PIN_E8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[19]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[19]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(19));

-- Location: PIN_G9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[20]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[20]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(20));

-- Location: PIN_H10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[21]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[21]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(21));

-- Location: PIN_A9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[22]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[22]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(22));

-- Location: PIN_D10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[23]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[23]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(23));

-- Location: PIN_C10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[24]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[24]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(24));

-- Location: PIN_J13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[25]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[25]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(25));

-- Location: PIN_D9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[26]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[26]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(26));

-- Location: PIN_B11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[27]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[27]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(27));

-- Location: PIN_E12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[28]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[28]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(28));

-- Location: PIN_G14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[29]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[29]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(29));

-- Location: PIN_F10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[30]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \counter_c[30]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(30));

-- Location: PIN_C12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\counter_c[31]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_counter_c[31]~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_counter_c(31));
END structure;


