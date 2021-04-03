
# fcampi@sfu.ca Sept 2013
# Post-Layout Power estimation with parasitics from Cadence & multiple SAIF files
#
# VCDs can be SAIF-ied with the command vcd2saif -input file.vcd -output file.vcd.saif -instance /e/uut

set search_path    "/CMC/setups/ensc450/SOCLAB/LIBRARIES/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/DB"

# Target library is the library that is used by the synthesis tool 
# in order to map the behavioral RTL logic that is being synthesized
set target_library "NangateOpenCellLibrary_slow.db"

# The synthetic library variable specified pre-designed technology independent architectures pre-packaged by Synopsys
set synthetic_library [list dw_foundation.sldb ]  

# The link library must contain ALL CELLS used in the design.cOther than the two above, it shall include any IO cell, memory cell, 
# or other cell/block that the user wishes to include in the design from other sources
set link_library  [concat $target_library $synthetic_library]

# Post-Synthesis Netlist
#read_verilog -netlist ./results/fft_core.ref.v
#read_verilog -netlist ../CMC/setups/ensc450/SOCLAB/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Verilog/NangateOpenCellLibrary.v
read_verilog -netlist ../BE_045/results/verilog/aes128key.final.v


# Post Layout Netlist : Goodbye Wireload Models  ###################
#read_verilog -netlist ../syn_045/results/aes128key.ref.v

current_design aes128key
#read_parasitics ../BE_045/results/rgb2gray.spef 
#####################################################################
#vcd2saif -input ../sim/rgb2gray.vcd -output ../sim/rgb2gray.vcd.saif -instance /e/uut
# The analysis here can be repeated indefinitely for all VCD/SAIF files available
set VCDFILES {../sim/aes128key.vcd.saif}

foreach file $VCDFILES {
    read_saif -input $file -instance aes128keytb/uut
    report_power -analysis_effort high 
}

# Writing out reports: Used cells (Area), Timing, Power
report_reference  >  ./results/aes128key_new.rpt
report_timing    -transition_time -capacitance >> ./results/aes128key_new.rpt
report_power     >> ./results/aes128key_new.rpt

#exit
