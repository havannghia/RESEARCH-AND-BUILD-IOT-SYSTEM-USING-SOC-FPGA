# TCL File Generated by Component Editor 18.1
# Sat Sep 28 17:16:08 ICT 2019
# DO NOT MODIFY


# 
# SHA_256 "SHA_256" v1.0
#  2019.09.28.17:16:08
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module SHA_256
# 
set_module_property DESCRIPTION ""
set_module_property NAME SHA_256
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME SHA_256
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL SHA_256_Controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file CH.v VERILOG PATH ip/SHA_Optimate_Done_v3/CH.v
add_fileset_file Compressor.v VERILOG PATH ip/SHA_Optimate_Done_v3/Compressor.v
add_fileset_file FIFO.v VERILOG PATH ip/SHA_Optimate_Done_v3/FIFO.v
add_fileset_file Fi0.v VERILOG PATH ip/SHA_Optimate_Done_v3/Fi0.v
add_fileset_file Fi1.v VERILOG PATH ip/SHA_Optimate_Done_v3/Fi1.v
add_fileset_file MAJ.v VERILOG PATH ip/SHA_Optimate_Done_v3/MAJ.v
add_fileset_file Padding.v VERILOG PATH ip/SHA_Optimate_Done_v3/Padding.v
add_fileset_file SHA_256.v VERILOG PATH ip/SHA_Optimate_Done_v3/SHA_256.v
add_fileset_file SHA_256_Controller.v VERILOG PATH ip/SHA_Optimate_Done_v3/SHA_256_Controller.v TOP_LEVEL_FILE
add_fileset_file Scheduler.v VERILOG PATH ip/SHA_Optimate_Done_v3/Scheduler.v
add_fileset_file Sigma0.v VERILOG PATH ip/SHA_Optimate_Done_v3/Sigma0.v
add_fileset_file Sigma1.v VERILOG PATH ip/SHA_Optimate_Done_v3/Sigma1.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock system_clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink iRstn reset_n Input 1


# 
# connection point master_read
# 
add_interface master_read avalon start
set_interface_property master_read addressUnits SYMBOLS
set_interface_property master_read associatedClock system_clock
set_interface_property master_read associatedReset reset_sink
set_interface_property master_read bitsPerSymbol 8
set_interface_property master_read burstOnBurstBoundariesOnly false
set_interface_property master_read burstcountUnits WORDS
set_interface_property master_read doStreamReads false
set_interface_property master_read doStreamWrites false
set_interface_property master_read holdTime 0
set_interface_property master_read linewrapBursts false
set_interface_property master_read maximumPendingReadTransactions 0
set_interface_property master_read maximumPendingWriteTransactions 0
set_interface_property master_read readLatency 0
set_interface_property master_read readWaitTime 1
set_interface_property master_read setupTime 0
set_interface_property master_read timingUnits Cycles
set_interface_property master_read writeWaitTime 0
set_interface_property master_read ENABLED true
set_interface_property master_read EXPORT_OF ""
set_interface_property master_read PORT_NAME_MAP ""
set_interface_property master_read CMSIS_SVD_VARIABLES ""
set_interface_property master_read SVD_ADDRESS_GROUP ""

add_interface_port master_read oAddress_Master_Read address Output 32
add_interface_port master_read oRead_Master_Read read Output 1
add_interface_port master_read iDataValid_Master_Read readdatavalid Input 1
add_interface_port master_read iWait_Master_Read waitrequest Input 1
add_interface_port master_read iReadData_Master_Read readdata Input 32


# 
# connection point master_write
# 
add_interface master_write avalon start
set_interface_property master_write addressUnits SYMBOLS
set_interface_property master_write associatedClock system_clock
set_interface_property master_write associatedReset reset_sink
set_interface_property master_write bitsPerSymbol 8
set_interface_property master_write burstOnBurstBoundariesOnly false
set_interface_property master_write burstcountUnits WORDS
set_interface_property master_write doStreamReads false
set_interface_property master_write doStreamWrites false
set_interface_property master_write holdTime 0
set_interface_property master_write linewrapBursts false
set_interface_property master_write maximumPendingReadTransactions 0
set_interface_property master_write maximumPendingWriteTransactions 0
set_interface_property master_write readLatency 0
set_interface_property master_write readWaitTime 1
set_interface_property master_write setupTime 0
set_interface_property master_write timingUnits Cycles
set_interface_property master_write writeWaitTime 0
set_interface_property master_write ENABLED true
set_interface_property master_write EXPORT_OF ""
set_interface_property master_write PORT_NAME_MAP ""
set_interface_property master_write CMSIS_SVD_VARIABLES ""
set_interface_property master_write SVD_ADDRESS_GROUP ""

add_interface_port master_write oAddress_Master_Write address Output 32
add_interface_port master_write oData_Master_Write writedata Output 32
add_interface_port master_write oWrite_Master_Write write Output 1
add_interface_port master_write iWait_Master_Write waitrequest Input 1


# 
# connection point control_status
# 
add_interface control_status avalon end
set_interface_property control_status addressUnits WORDS
set_interface_property control_status associatedClock system_clock
set_interface_property control_status associatedReset reset_sink
set_interface_property control_status bitsPerSymbol 8
set_interface_property control_status burstOnBurstBoundariesOnly false
set_interface_property control_status burstcountUnits WORDS
set_interface_property control_status explicitAddressSpan 0
set_interface_property control_status holdTime 0
set_interface_property control_status linewrapBursts false
set_interface_property control_status maximumPendingReadTransactions 0
set_interface_property control_status maximumPendingWriteTransactions 0
set_interface_property control_status readLatency 0
set_interface_property control_status readWaitTime 1
set_interface_property control_status setupTime 0
set_interface_property control_status timingUnits Cycles
set_interface_property control_status writeWaitTime 0
set_interface_property control_status ENABLED true
set_interface_property control_status EXPORT_OF ""
set_interface_property control_status PORT_NAME_MAP ""
set_interface_property control_status CMSIS_SVD_VARIABLES ""
set_interface_property control_status SVD_ADDRESS_GROUP ""

add_interface_port control_status iWrite_Control write Input 1
add_interface_port control_status iRead_Control read Input 1
add_interface_port control_status iAddress_Control address Input 3
add_interface_port control_status iData_Control writedata Input 32
add_interface_port control_status oData_Control readdata Output 32
add_interface_port control_status iChipSelect_Control chipselect Input 1
set_interface_assignment control_status embeddedsw.configuration.isFlash 0
set_interface_assignment control_status embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment control_status embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment control_status embeddedsw.configuration.isPrintableDevice 0


# 
# connection point system_clock
# 
add_interface system_clock clock end
set_interface_property system_clock clockRate 0
set_interface_property system_clock ENABLED true
set_interface_property system_clock EXPORT_OF ""
set_interface_property system_clock PORT_NAME_MAP ""
set_interface_property system_clock CMSIS_SVD_VARIABLES ""
set_interface_property system_clock SVD_ADDRESS_GROUP ""

add_interface_port system_clock iClk clk Input 1


# 
# connection point sha_clock
# 
add_interface sha_clock clock end
set_interface_property sha_clock clockRate 0
set_interface_property sha_clock ENABLED true
set_interface_property sha_clock EXPORT_OF ""
set_interface_property sha_clock PORT_NAME_MAP ""
set_interface_property sha_clock CMSIS_SVD_VARIABLES ""
set_interface_property sha_clock SVD_ADDRESS_GROUP ""

add_interface_port sha_clock iSHA_clk clk Input 1

