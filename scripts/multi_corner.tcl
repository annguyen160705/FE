
# ==========================================
# MULTI-CORNER STA - SKY130
# Design: counter
# ==========================================

# 1. Define process corners (ADDED)
define_corners ss tt ff

# 2. Corner list
set corners {ss tt ff}

# 3. Liberty library paths
array set corner_libs {
    ss "lib/stdcells_ss.lib"
    tt "lib/stdcells_tt.lib"
    ff "lib/stdcells_ff.lib"
}

# 4. Read Liberty BEFORE linking (MOVED)
foreach corner $corners {
    puts "Loading Liberty: $corner"
    read_liberty -corner $corner $corner_libs($corner)
}

# 5. Read netlist (CORRECTED)
read_verilog build/netlists/counter_mapped.v

# 6. Link design
link_design counter

# 7. Read SDC
read_sdc constraints/design.sdc

# 8. Multi-corner timing analysis
foreach corner $corners {

    puts "\n=================================="
    puts "CORNER: $corner"
    puts "=================================="

    puts "\nSETUP TIMING:"
    report_checks -corner $corner -path_delay max

    puts "\nHOLD TIMING:"
    report_checks -corner $corner -path_delay min
}

puts "\nMULTI-CORNER STA COMPLETED"
