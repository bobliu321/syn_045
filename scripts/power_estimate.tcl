
# fcampi@sfu.ca Sept 2013
# Post-Layout Power estimation with parasitics from Cadence & multiple SAIF files
#
# VCDs can be SAIF-ied with the command vcd2saif -input file.vcd -output file.vcd.saif -instance /e/uut

#set search_path    "/CMC/setups/ensc450/SOCLAB/LIBRARIES/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/DB"
#set search_path    "/local-scratch/localhome/escmc27/ensc450/Project/ensc450_system/syn_045/lib"
set search_path    "/CMC/setups/ensc450/SOCLAB/LIBRARIES/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/DB  /CMC/setups/ensc450/Project/SRAM_Lib /local-scratch/localhome/escmc27/ensc450/Project/ensc450_system/vhdl/AES_Lib"

# Target library is the library that is used by the synthesis tool 
# in order to map the behavioral RTL logic that is being synthesized
set target_library "NangateOpenCellLibrary_slow.db"
#set target_library "aesbuffer_slow.db"


# The synthetic library variable specified pre-designed technology independent architectures pre-packaged by Synopsys
set synthetic_library [list dw_foundation.sldb ]  

# The link library must contain ALL CELLS used in the design.cOther than the two above, it shall include any IO cell, memory cell, 
# or other cell/block that the user wishes to include in the design from other sources
#set link_library  [concat $target_library $synthetic_library]
set link_library [concat $target_library SRAM.db aesbuffer_slow.db $synthetic_library] 

# Post-Synthesis Netlist
#read_verilog -netlist ./results/fft_core.ref.v
#read_verilog -netlist ../CMC/setups/ensc450/SOCLAB/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Verilog/NangateOpenCellLibrary.v
read_verilog -netlist ../sim/finalv/ensc450.final.v
#read_verilog -netlist ../syn_045/results/aesbuffer.ref.v

# Post Layout Netlist : Goodbye Wireload Models  ###################
#read_verilog -netlist ../syn_045/results/aes128key.ref.v

current_design ensc450
#read_parasitics ../BE_045/results/rgb2gray.spef 
#####################################################################
#vcd2saif -input ../sim/rgb2gray.vcd -output ../sim/rgb2gray.vcd.saif -instance /e/uut
# The analysis here can be repeated indefinitely for all VCD/SAIF files available
set VCDFILES {../sim/ensc450.vcd.saif}

foreach file $VCDFILES {
    read_saif -input $file -instance ensc450tb/uut
    report_power -analysis_effort high 
}

# Writing out reports: Used cells (Area), Timing, Power
report_reference  >  ./results/ensc450_new.rpt
report_timing    -transition_time -capacitance >> ./results/ensc450_new.rpt
report_power     >> ./results/ensc450_new.rpt

#exit
