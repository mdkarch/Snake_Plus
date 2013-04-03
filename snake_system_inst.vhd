  --Example instantiation for system 'snake_system'
  snake_system_inst : snake_system
    port map(
      SRAM_ADDR_from_the_sram => SRAM_ADDR_from_the_sram,
      SRAM_CE_N_from_the_sram => SRAM_CE_N_from_the_sram,
      SRAM_DQ_to_and_from_the_sram => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N_from_the_sram => SRAM_LB_N_from_the_sram,
      SRAM_OE_N_from_the_sram => SRAM_OE_N_from_the_sram,
      SRAM_UB_N_from_the_sram => SRAM_UB_N_from_the_sram,
      SRAM_WE_N_from_the_sram => SRAM_WE_N_from_the_sram,
      VGA_BLANK_from_the_vga => VGA_BLANK_from_the_vga,
      VGA_B_from_the_vga => VGA_B_from_the_vga,
      VGA_CLK_from_the_vga => VGA_CLK_from_the_vga,
      VGA_G_from_the_vga => VGA_G_from_the_vga,
      VGA_HS_from_the_vga => VGA_HS_from_the_vga,
      VGA_R_from_the_vga => VGA_R_from_the_vga,
      VGA_SYNC_from_the_vga => VGA_SYNC_from_the_vga,
      VGA_VS_from_the_vga => VGA_VS_from_the_vga,
      leds_from_the_vga => leds_from_the_vga,
      PS2_Clk_to_the_ps2 => PS2_Clk_to_the_ps2,
      PS2_Data_to_the_ps2 => PS2_Data_to_the_ps2,
      clk_0 => clk_0,
      reset_n => reset_n
    );


