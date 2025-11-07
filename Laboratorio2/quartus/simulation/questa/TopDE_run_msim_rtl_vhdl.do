transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/ramD.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/ramI.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/basic_circuits/adder.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/basic_circuits/Mux2x1.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/riscv_pkg.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/uniciclo.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/TopDE.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/alu.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/xreg.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/control/alu_control.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/control/general_control.vhd}
vcom -2008 -work work {/home/henrique/Documentos/Organizacao-e-Arquitetura-de-Computadores/Laboratorio2/components/gen_imm.vhd}

