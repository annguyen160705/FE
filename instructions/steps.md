# RTL





# LINT
verilator --version

verilator --lint-only -Wall --top-module counter rtl/counter.sv

#VERIFY
mkdir -p build/sim build/waves

iverilog -g2012 -s tb_counter -o build/sim/counter.vvp rtl/counter.sv tb/tb_counter.sv
vvp build/sim/counter.vvp

vlib work
vlog rtl/*.sv
vlog tb/*.sv
vsim tb_counter

#LIBERTY

find ~/.volare -name "sky130_fd_sc_hd__tt_025C_1v80.lib" -print -quit



find ~/.volare -name "sky130_fd_sc_hd__ss_100C_1v60.lib" -print -quit


find ~/.volare -name "sky130_fd_sc_hd__ff_n40C_1v95.lib" -print -quit


LIB_TT=$(find ~/.volare -name "sky130_fd_sc_hd__tt_025C_1v80.lib" -print -quit)


LIB_DIR=$(dirname "$LIB_TT")

# Tạo liên kết.


ln -sfn "$LIB_DIR/sky130_fd_sc_hd__tt_025C_1v80.lib" lib/stdcells_tt.lib


ln -sfn "$LIB_DIR/sky130_fd_sc_hd__ss_100C_1v60.lib" lib/stdcells_ss.lib


ln -sfn "$LIB_DIR/sky130_fd_sc_hd__ff_n40C_1v95.lib" lib/stdcells_ff.lib


ln -sfn "$LIB_DIR/sky130_fd_sc_hd__tt_025C_1v80.lib" lib/stdcells.lib

# SYN
mkdir -p build/reports
mkdir -p build/netlists
mkdir -p build/diagrams

yosys

read_verilog -sv rtl/counter.sv

hierarchy -check -top counter

synth -top counter -noabc

read_liberty -lib lib/stdcells_tt.lib

dfflibmap -liberty lib/stdcells_tt.lib

abc -liberty lib/stdcells_tt.lib -D 2000

opt_clean -purge

tee -o build/reports/check_report.txt check -assert

tee -o build/reports/area_report.txt stat -liberty lib/stdcells_tt.lib

write_verilog -noattr -noexpr -simple-lhs build/netlists/counter_mapped.v


# STA

mkdir -p constraints

nano constraints/design.sdc

create_clock -name clk -period 10 [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks clk]

sta

read_liberty lib/stdcells_tt.lib

read_verilog build/netlists/counter_mapped.v

link_design counter

read_sdc constraints/design.sdc

report_checks -path_delay max

report_checks -path_delay min

report_worst_slack

## STA corners
sta scripts/multi_corner.tcl 2>&1 | tee build/reports/multi_corner.log