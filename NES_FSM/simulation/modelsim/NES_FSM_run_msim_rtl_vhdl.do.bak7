transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/user3/spring13/ie2147/Desktop/NES_FSM/controller.vhd}

vcom -93 -work work {/home/user3/spring13/ie2147/Desktop/NES_FSM/controller_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  controller_tb

add wave *
view structure
view signals
run 100 us
