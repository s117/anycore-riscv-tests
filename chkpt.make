include Makefile

RISCV_CHKPTS_REGEX := .*\/(([0-9]{3}\.[a-zA-Z0-9_]+)\.+([0-9]+)\.([0-1]\.[0-9]{1,2}))\.gz
AVAIL_CHKPTS := $(shell find $(RISCV_CHKPT_STORAGE_ROOT) -type f -iname "*.gz" | grep -E -e '$(RISCV_CHKPTS_REGEX)' | sort | sed -E 's/$(RISCV_CHKPTS_REGEX)/\1+\2+\3+\4+\0/')

RESTORE_CHKPT_TEST_DIR = $(SCRATCH_SPACE)/riscv_restore_chkpt


ifndef RISCV_CHKPT_STORAGE_ROOT
$(info Error:)
$(info Variable 'RISCV_CHKPT_STORAGE_ROOT' is not set.)
$(info )
$(info Hint:)
$(info This is the path to the checkpoint storage directory.)
$(info To fix this error, set RISCV_CHKPT_STORAGE_ROOT to the root where .gz checkpoints stores.)
$(info )
$(error missing critical enviroment variable )
else
$(info Using checkpoints from directory "$(RISCV_CHKPT_STORAGE_ROOT)")
endif

define restore_chkpt_rule
$(1):
	if [[ ! -f $(5) ]]; then \
		echo "Error: The checkpoint file" $(5) "doesn't exist."; exit 2; \
	else true; fi
	echo "BMARK_BIN_DIR = $(2)"
	echo "SIMPOINT_TOOL_DIR = $(SIMPOINT_TOOL_DIR)"
	#echo "1:$1 2:$2 3:$3 4:$4"
	echo "Spawn sim env for run" $(2) "at" $(RESTORE_CHKPT_TEST_DIR)/$(1)
	SPEC_BIN_DIR=$(SPEC_BIN_DIR) atool_sim_env_spawn -f $(2) $(RESTORE_CHKPT_TEST_DIR)/$(1)
	cp -fv $(ANYCORE_TEST_DIR)/spike.mk $(RESTORE_CHKPT_TEST_DIR)/$(1)/Makefile
	sed -i -e 's:RISCV_INSTALL_DIR_PLACEHOLDER:$(RISCV_INSTALL_DIR):g' $(RESTORE_CHKPT_TEST_DIR)/$(1)/Makefile
	sed -i -e 's:SIMPOINT_TOOL_DIR_PLACEHOLDER:$(SIMPOINT_TOOL_DIR):g' $(RESTORE_CHKPT_TEST_DIR)/$(1)/Makefile
	sed -i -e 's:BMARKS_PLACEHOLDER:$(2):g' $(RESTORE_CHKPT_TEST_DIR)/$(1)/Makefile
	sed -i -e 's:SPIKE_ARGS_PLACEHOLDER:"-f$(5)":g' $(RESTORE_CHKPT_TEST_DIR)/$(1)/Makefile

	$(MAKE) -C $(RESTORE_CHKPT_TEST_DIR)/$(1) -f Makefile all
endef

get_chkpt_name =     $(word 1,$(subst +, ,$(1)))
get_chkpt_run_name = $(word 2,$(subst +, ,$(1)))
get_chkpt_smpt_pos = $(word 3,$(subst +, ,$(1)))
get_chkpt_smpt_pct = $(word 4,$(subst +, ,$(1)))
get_chkpt_filepath = $(word 5,$(subst +, ,$(1)))
# Call the macro spec_checkpoint_rule(testcase,benchmark_location,benchmark) - No spaces between arguments
$(foreach testcase,$(patsubst \,,$(AVAIL_CHKPTS)),$(eval $(call restore_chkpt_rule,$(call get_chkpt_name,$(testcase)),$(call get_chkpt_run_name,$(testcase)),$(call get_chkpt_smpt_pos,$(testcase)),$(call get_chkpt_smpt_pct,$(testcase)),$(call get_chkpt_filepath,$(testcase)))))
