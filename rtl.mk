################################################################################
#                       NORTH CAROLINA STATE UNIVERSITY
#
#                              AnyCore Project
#
# AnyCore Copyright (c) 2007-2011 by Niket K. Choudhary, Salil Wadhavkar,
# and Eric Rotenberg.  All Rights Reserved.
#
# This is a beta-release version.  It must not be redistributed at this time.
#
# Purpose: This is a Makefile for running simulation!!
################################################################################

RISCV_INSTALL_DIR = RISCV_INSTALL_DIR_PLACE_HOLDER
VERILOG_SRC 			= VERILOG_SRC_DIR_PLACE_HOLDER
DW_PATH           = $(VERILOG_SRC)/DW

# Overwrite CONFIG to change the superset configuration.
CONFIG     = CONFIG_PLACE_HOLDER

# Add additional flags
DEFINES    = -64bit -turbo +define+SIM+USE_VPI+VERIFY+PRINT_EN \
						 -INCDIR $(DW_PATH)/sim_ver/ \
						 -INCDIR $(VERILOG_SRC)/testbenches/ \
						 -INCDIR $(VERILOG_SRC)/include/ \
						 #+define+WAVES
VERILATOR_FLAGS = +define+SIM+USE_VPI+VERIFY+PRINT_EN \
						 -I$(DW_PATH)/sim_ver/ \
						 -I$(VERILOG_SRC)/testbenches/ \

QUESTA_FLAGS = -sv +define+SIM+USE_VPI+VERIFY+PRINT_EN -suppress 2263\
						 +incdir+$(DW_PATH)/sim_ver/ \
						 +incdir+$(VERILOG_SRC)/testbenches/ \
						 +incdir+$(VERILOG_SRC)/include/ \

# The Verilog source files
PARAMFILE = $(VERILOG_SRC)/configs/CommonConfig.svh	\
						$(VERILOG_SRC)/configs/$(CONFIG).v

HEADER   = $(PARAMFILE) \
           $(VERILOG_SRC)/ISA/RISCV_ISA.sv \
           $(VERILOG_SRC)/include/structs.svh \

FETCH    = $(VERILOG_SRC)/fetch/*.sv

DECODE   = $(VERILOG_SRC)/decode/*.sv

RENAME   = $(VERILOG_SRC)/rename/*.sv

DISPATCH = $(VERILOG_SRC)/dispatch/*.sv

ISSUEQ   = $(VERILOG_SRC)/issue/*.sv

REGREAD  = $(VERILOG_SRC)/regRead/*.sv

EXECUTE  = $(VERILOG_SRC)/execute/*.sv

WRITEBK  = $(VERILOG_SRC)/writeback/*.sv

LSU      = $(VERILOG_SRC)/lsu/*.sv

RETIRE   = $(VERILOG_SRC)/retire/*.sv

ICACHE	 = $(VERILOG_SRC)/icache/*.sv

DCACHE	 = $(VERILOG_SRC)/dcache/*.sv

MISC     = $(VERILOG_SRC)/lib/*.sv \
	         $(VERILOG_SRC)/bist/*.sv

MEM      = $(VERILOG_SRC)/configs/RAM_Params.svh	\
					 $(VERILOG_SRC)/rams/*.sv	\
           $(VERILOG_SRC)/rams_configurable/*.sv	\

TOP      = $(VERILOG_SRC)/core_top/*.sv

TESTBENCH	=	$(VERILOG_SRC)/testbenches/l2_icache.sv	\
						$(VERILOG_SRC)/testbenches/l2_dcache.sv	\
						$(VERILOG_SRC)/testbenches/memory_hier.sv	\
						$(VERILOG_SRC)/testbenches/simulate.sv

## Config files for dynamic configuration
TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig1.svh
#TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig2.svh
#TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig3.svh
#TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig4.svh
#TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig5.svh
#TB_CONFIG  = $(VERILOG_SRC)/testbenches/TbConfig6.svh

#IODINE   = $(CURRENT)/../iodine/*.sv

DW       = 	 $(DW_PATH)/sim_ver/DW_fifoctl_s2_sf.v \
             $(DW_PATH)/sim_ver/DW_arb_fcfs.v \
             $(DW_PATH)/sim_ver/DW_mult_pipe.v \
             $(DW_PATH)/sim_ver/DW02_mult.v \
             $(DW_PATH)/sim_ver/DW_div_pipe.v \
             $(DW_PATH)/sim_ver/DW_div.v \
             $(DW_PATH)/sim_ver/DW03_pipe_reg.v	\
             $(DW_PATH)/sim_ver/DW_fp_add.v \
             $(DW_PATH)/sim_ver/DW_fp_addsub.v \
             $(DW_PATH)/sim_ver/DW_fp_sub.v \
             $(DW_PATH)/sim_ver/DW_fp_mult.v \
             $(DW_PATH)/sim_ver/DW_fp_sqrt.v \
             $(DW_PATH)/sim_ver/DW_fp_div.v \
             $(DW_PATH)/sim_ver/DW_fp_flt2i.v \
             $(DW_PATH)/sim_ver/DW_fp_cmp.v \
             $(DW_PATH)/sim_ver/DW_fp_i2flt.v


# Combines all the files
FILES    = $(MISC) $(DW) $(MEM) $(FETCH) $(DECODE) $(RENAME) $(DISPATCH) \
            $(ISSUEQ) $(REGREAD) $(EXECUTE) $(WRITEBK) $(RETIRE) $(ICACHE) $(DCACHE) $(TOP) \
					 	$(LSU) $(IODINE) $(TB_CONFIG) $(TESTBENCH)


SERDES				=	$(VERILOG_SRC)/serdes/*
CHIP_TOP      = $(VERILOG_SRC)/top_modules/fab_top.sv
TESTBENCH_CHIP=	$(VERILOG_SRC)/testbenches/l2_icache.sv	\
								$(VERILOG_SRC)/testbenches/l2_dcache.sv	\
								$(VERILOG_SRC)/testbenches/memory_hier.sv	\
								$(VERILOG_SRC)/testbenches/simulate_chip.sv


FILES_CHIP = $(MISC) $(DW) $(MEM) $(FETCH) $(DECODE) $(RENAME) $(DISPATCH) \
            $(ISSUEQ) $(REGREAD) $(EXECUTE) $(WRITEBK) $(RETIRE) $(ICACHE) $(DCACHE) $(TOP) $(CHIP_TOP)\
					 	$(LSU) $(SERDES) $(IODINE) $(TB_CONFIG) $(TESTBENCH_CHIP)


NCSC_RUNARGS = -access rwc -l run.log

# DPI files for Iodine
DPI_CFLAGS = -g -m32 -fPIC -shared -I$(DPI_DIR) -I`ncroot`/tools/inca/include
DEBUG        = +define+PRINT_EN


$(VERILOG_SRC)/include/global_header.svh: $(HEADER) $(TB_CONFIG) $(VERILOG_SRC)/configs/RAM_Params.svh
	echo "\`ifndef GLOBAL_HEADER_GUARD" > $@
	echo "\`define GLOBAL_HEADER_GUARD" >> $@
	echo "" >> $@
	for file in $^ ; do \
		echo "\`include \"$${file}\"" >> $@ ; \
	done
	echo "" >> $@
	echo "\`endif // GLOBAL_HEADER_GUARD" >> $@

run_nc: $(VERILOG_SRC)/include/global_header.svh
	echo "------run_nc------"
	mkdir -p results
	rm -rf *.log results/*
	irun -top worklib.simulate:sv -sv_lib $(RISCV_INSTALL_DIR)/lib/libriscv_dpi.so $(DEFINES) $(NCSC_RUNARGS) $(FILES) 2>&1 |tee console.log

run_g:
	clear
	mkdir -p results
	rm -rf *.log results/*
	irun -gui -top worklib.simulate:sv -sv_lib $(RISCV_INSTALL_DIR)/lib/libriscv_dpi.so $(DEFINES) $(NCSC_RUNARGS) $(FILES) 2>&1 |tee console.log 


# Runs with the gui
run_nc_g: $(VERILOG_SRC)/include/global_header.svh
	echo "------run_nc_g------"
	mkdir -p results
	rm -rf *.log results/*
	irun -gui -top worklib.simulate:sv $(DEFINES)  $(NCSC_RUNARGS) $(FILES) $(VPI_FILES) $(VPI_FLAGS) 2>&1 |tee console.log

# run_verilator:
# 	echo "------run_verilator------"
# 	mkdir -p results
# 	rm -rf *.log results/*
# 	# irun -top worklib.simulate:sv -sv_lib $(RISCV_INSTALL_DIR)/lib/libriscv_dpi.so $(DEFINES) $(NCSC_RUNARGS) $(FILES) 2>&1 |tee console.log
# 	verilator --lint-only --top-module simulate $(VERILATOR_FLAGS) $(FILES)

run_questa: $(VERILOG_SRC)/include/global_header.svh
	echo "------run_questa------"
	mkdir -p results
	rm -rf *.log results/*
	vlib worklib
	vlog $(QUESTA_FLAGS) $(FILES)

chip:
	echo "------chip------"
	mkdir -p results
	rm -rf *.log results/*
	irun -top worklib.simulate:sv $(DEFINES) $(NCSC_RUNARGS) $(FILES_CHIP) $(VPI_FILES) $(VPI_FLAGS)

chip_g:
	echo "------chip_g------"
	mkdir -p results
	rm -rf *.log results/*
	irun  -gui -top worklib.simulate:sv $(DEFINES) $(NCSC_RUNARGS) $(FILES_CHIP) $(VPI_FILES) $(VPI_FLAGS)

clean:
	rm -rf *.o libvpi.so INCA_libs *.log *.sl work irun.* results/* waves.shm* top outfile .simvision out.* iodine_dpi.so run.log* simvision*
