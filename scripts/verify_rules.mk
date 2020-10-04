# RISCV_INSTALL_DIR ?= RISCV_INSTALL_DIR_PLACEHOLDER
# SIMPOINT_TOOL_DIR ?= SIMPOINT_TOOL_DIR_PLACEHOLDER
# SCRIPTS_DIR ?= SCRIPTS_DIR_PLACEHOLDER
# SPIKE_ARGS ?= SPIKE_ARGS_PLACEHOLDER
# bmarks ?= BMARKS_PLACEHOLDER
# SPEC_CPU2006_ROOT ?= "/opt/spec2006"
# SPEC_CPU2017_ROOT ?= "/opt/spec2017"

RISCV_INSTALL_DIR ?= $(RISCV)
SIMPOINT_TOOL_DIR = $(RISCV)/../anycore-riscv-tests/SimPoint
SCRIPTS_DIR       = $(RISCV)/../anycore-riscv-tests/scripts

SPEC_CPU2006_ROOT ?= PATH_TO_SPECKLE/SPEC/cpu2006
SPEC_CPU2017_ROOT ?= PATH_TO_SPECKLE/SPEC/cpu2017

SPIKE_ARGS        = ""
bmarks            = ""

.PHONY: all ${bmarks} check_riscv_install check_simpoint_dir

all: ${bmarks} check_riscv_install

check_riscv_install:
	@echo "RISCV_INSTALL_DIR = $(RISCV_INSTALL_DIR)"
	@if [ "$(RISCV_INSTALL_DIR)" = "" ]; then \
		echo "Error: Please set RISCV_INSTALL_DIR to the installation path."; exit 2; \
	else true; fi

check_simpoint_dir:
	@echo "SIMPOINT_TOOL_DIR = $(SIMPOINT_TOOL_DIR)"
	@if [ "$(SIMPOINT_TOOL_DIR)" = "" ]; then \
		echo "Error: Please set SIMPOINT_TOOL_DIR to the simpoint tool build path."; exit 2; \
	else true; fi

.ONESHELL:
.PHONY: simpoints
simpoints:	check_simpoint_dir
	-gunzip bbv_proc_0.bb.gz -c > bbv.bb ; $(SIMPOINT_TOOL_DIR)/bin/simpoint -maxK 10 -saveSimpoints simpoints -saveSimpointWeights weights -loadFVFile bbv.bb | tee smpt.log; rm -f bbv.bb

# Spike related
SPIKE_TRIM              = "$(SCRIPTS_DIR)/spike_trim.py"
SPIKE_CMD               = ;-nice -19 $(RISCV_INSTALL_DIR)/bin/spike $(SPIKE_ARGS)

# CPU2006 cmds
CPU2006_BENCH           = "$(SPEC_CPU2006_ROOT)/benchspec/CPU2006"
CPU2006_DIFF            = SPEC=$(SPEC_CPU2006_ROOT) SPECPERLLIB=$(SPEC_CPU2006_ROOT)/bin:$(SPEC_CPU2006_ROOT)/bin/lib $(SPEC_CPU2006_ROOT)/bin/specperl $(SPEC_CPU2006_ROOT)/bin/specdiff

# CPU2017 cmds
CPU2017_BENCH           = "$(SPEC_CPU2017_ROOT)/benchspec/CPU"
CPU2017_DIFF            = SPEC=$(SPEC_CPU2017_ROOT) SPECPERLLIB=$(SPEC_CPU2017_ROOT)/bin/lib:$(SPEC_CPU2017_ROOT)/bin $(SPEC_CPU2017_ROOT)/bin/specperl $(SPEC_CPU2017_ROOT)/bin/harness/specdiff
#"../run_base_refspeed_riscv-m64.0000/diffwrf_621_base.riscv-m64"
CPU2017_621_DIFFWRF     = "$(SCRIPTS_DIR)/bin/diffwrf_621_base.x64-m64"
#""../run_base_refspeed_x64-m64.0000/imagevalidate_625_base.x64-m64"
CPU2017_625_X264_VAL    = "$(SCRIPTS_DIR)/bin/imagevalidate_625_base.x64-m64"
#"../run_base_refspeed_riscv-m64.0000/cam4_validate_627_base.riscv-m64"
CPU2017_627_CAM4_VAL    = "$(SCRIPTS_DIR)/bin/cam4_validate_627_base.x64-m64"
#"../run_base_refspeed_riscv-m64.0000/imagevalidate_638_base.riscv-m64"
CPU2017_638_IMAGICK_VAL = "$(SCRIPTS_DIR)/bin/imagevalidate_638_base.x64-m64"

#########################
# Run rules for CPU2006 #
#########################

400.perlbench_checkspam_ref:
	$(SPIKE_CMD) -m2048 pk -c ./perlbench_base.riscv -I./lib checkspam.pl 2500 5 25 11 150 1 1 1 1 2>&1 | tee run.log
400.perlbench_diffmail_ref:
	$(SPIKE_CMD) -m2048 pk -c ./perlbench_base.riscv -I./lib diffmail.pl 4 800 10 17 19 300 2>&1 | tee run.log
400.perlbench_splitmail_ref:
	$(SPIKE_CMD) -m2048 pk -c ./perlbench_base.riscv -I./lib splitmail.pl 1600 12 26 16 4500 2>&1 | tee run.log

401.bzip2_source_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv input.source 280 2>&1 | tee run.log
401.bzip2_chicken_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv chicken.jpg 30 2>&1 | tee run.log
401.bzip2_liberty_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv liberty.jpg 30 2>&1 | tee run.log
401.bzip2_program_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv input.program 280 2>&1 | tee run.log
401.bzip2_html_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv text.html 280 2>&1 | tee run.log
401.bzip2_combined_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bzip2_base.riscv input.combined 200 2>&1 | tee run.log

403.gcc_166_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv 166.in -o 166.s 2>&1 | tee run.log
403.gcc_200_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv 200.in -o 200.s 2>&1 | tee run.log
403.gcc_c-typeck_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv c-typeck.in -o c-typeck.s 2>&1 | tee run.log
403.gcc_cp-decl_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv cp-decl.in -o cp-decl.s 2>&1 | tee run.log
403.gcc_expr_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv expr.in -o expr.s 2>&1 | tee run.log
403.gcc_expr2_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv expr2.in -o expr2.s 2>&1 | tee run.log
403.gcc_g23_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv g23.in -o g23.s 2>&1 | tee run.log
403.gcc_s04_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv s04.in -o s04.s 2>&1 | tee run.log
403.gcc_scilab_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gcc_base.riscv scilab.in -o scilab.s 2>&1 | tee run.log

410.bwaves_ref:
	$(SPIKE_CMD) -m2048 pk -c ./bwaves_base.riscv 2>&1 | tee run.log

416.gamess_cytosine_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gamess_base.riscv < cytosine.2.config 2>&1 | tee run.log
416.gamess_h2ocu2_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gamess_base.riscv < h2ocu2+.gradient.config 2>&1 | tee run.log
416.gamess_triazolium_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gamess_base.riscv < triazolium.config 2>&1 | tee run.log

429.mcf_ref:
	$(SPIKE_CMD) -m2048 pk -c ./mcf_base.riscv inp.in 2>&1 | tee run.log

433.milc_ref:
	$(SPIKE_CMD) -m2048 pk -c ./milc_base.riscv < su3imp.in 2>&1 | tee run.log

434.zeusmp_ref:
	$(SPIKE_CMD) -m2048 pk -c ./zeusmp_base.riscv 2>&1 | tee run.log

435.gromacs_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gromacs_base.riscv -silent -deffnm gromacs -nice 0 2>&1 | tee run.log

436.cactusADM_ref:
	$(SPIKE_CMD) -m2048 pk -c ./cactusADM_base.riscv benchADM.par 2>&1 | tee run.log

437.leslie3d_ref:
	$(SPIKE_CMD) -m2048 pk -c ./leslie3d_base.riscv < leslie3d.in 2>&1 | tee run.log

444.namd_ref:
	$(SPIKE_CMD) -m2048 pk -c ./namd_base.riscv --input namd.input --iterations 38 --output namd.out 2>&1 | tee run.log

445.gobmk_13x13_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gobmk_base.riscv --quiet --mode gtp < 13x13.tst 2>&1 | tee run.log
445.gobmk_nngs_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gobmk_base.riscv --quiet --mode gtp < nngs.tst 2>&1 | tee run.log
445.gobmk_score2_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gobmk_base.riscv --quiet --mode gtp < score2.tst 2>&1 | tee run.log
445.gobmk_trevorc_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gobmk_base.riscv --quiet --mode gtp < trevorc.tst 2>&1 | tee run.log
445.gobmk_trevord_ref:
	$(SPIKE_CMD) -m2048 pk -c ./gobmk_base.riscv --quiet --mode gtp < trevord.tst 2>&1 | tee run.log

447.dealII_ref:
	$(SPIKE_CMD) -m2048 pk -c ./dealII_base.riscv 23 2>&1 | tee run.log

450.soplex_pds50_mps_ref:
	$(SPIKE_CMD) -m2048 pk -c ./soplex_base.riscv -s1 -e -m45000 pds-50.mps 2>&1 | tee run.log
450.soplex_ref_mps_ref:
	$(SPIKE_CMD) -m2048 pk -c ./soplex_base.riscv -m3500 ref.mps 2>&1 | tee run.log

453.povray_ref:
	$(SPIKE_CMD) -m2048 pk -c ./povray_base.riscv SPEC-benchmark-ref.ini 2>&1 | tee run.log

454.calculix_ref:
	$(SPIKE_CMD) -m2048 pk -c ./calculix_base.riscv -i  hyperviscoplastic 2>&1 | tee run.log

456.hmmer_test:
	$(SPIKE_CMD) -m2048 pk -c ./hmmer_base.riscv --fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 bombesin.hmm 2>&1 | tee run.log
456.hmmer_nph3_ref:
	$(SPIKE_CMD) -m2048 pk -c ./hmmer_base.riscv nph3.hmm swiss41 2>&1 | tee run.log
456.hmmer_retro_ref:
	$(SPIKE_CMD) -m2048 pk -c ./hmmer_base.riscv --fixed 0 --mean 500 --num 500000 --sd 350 --seed 0 retro.hmm 2>&1 | tee run.log

458.sjeng_ref:
	$(SPIKE_CMD) -m2048 pk -c ./sjeng_base.riscv ref.txt 2>&1 | tee run.log

459.GemsFDTD_ref:
	$(SPIKE_CMD) -m2048 pk -c ./GemsFDTD_base.riscv 2>&1 | tee run.log

462.libquantum_ref:
	$(SPIKE_CMD) -m2048 pk -c ./libquantum_base.riscv 1397 8 2>&1 | tee run.log

464.h264ref_foreman_ref_encoder_baseline_ref:
	$(SPIKE_CMD) -m2048 pk -c ./h264ref_base.riscv -d foreman_ref_encoder_baseline.cfg 2>&1 | tee run.log
464.h264ref_foreman_ref_encoder_main_ref:
	$(SPIKE_CMD) -m2048 pk -c ./h264ref_base.riscv -d foreman_ref_encoder_main.cfg 2>&1 | tee run.log
464.h264ref_sss_encoder_main_ref:
	$(SPIKE_CMD) -m2048 pk -c ./h264ref_base.riscv -d sss_encoder_main.cfg 2>&1 | tee run.log

465.tonto_ref:
	$(SPIKE_CMD) -m2048 pk -c ./tonto_base.riscv 2>&1 | tee run.log

470.lbm_ref:
	$(SPIKE_CMD) -m2048 pk -c ./lbm_base.riscv 3000 reference.dat 0 0 100_100_130_ldc.of 2>&1 | tee run.log

471.omnetpp_ref:
	$(SPIKE_CMD) -m2048 pk -c ./omnetpp_base.riscv omnetpp.ini 2>&1 | tee run.log

473.astar_biglakes2048_ref:
	$(SPIKE_CMD) -m2048 pk -c ./astar_base.riscv BigLakes2048.cfg 2>&1 | tee run.log
473.astar_rivers_ref:
	$(SPIKE_CMD) -m2048 pk -c ./astar_base.riscv rivers.cfg 2>&1 | tee run.log

481.wrf_ref:
	$(SPIKE_CMD) -m2048 pk -c ./wrf_base.riscv 2>&1 | tee run.log

482.sphinx3_ref:
	$(SPIKE_CMD) -m2048 pk -c ./sphinx_livepretend_base.riscv ctlfile . args.an4 2>&1 | tee run.log

483.xalancbmk_ref:
	$(SPIKE_CMD) -m2048 pk -c ./Xalan_base.riscv -v t5.xml xalanc.xsl 2>&1 | tee run.log

#########################
# Run rules for CPU2017 #
#########################

600.perlbench_s_checkspam_ref:
	$(SPIKE_CMD) -m16384 pk -c ./perlbench_s_base.riscv-m64 -I./lib checkspam.pl 2500 5 25 11 150 1 1 1 1 2>&1 | tee run.log
600.perlbench_s_diffmail_ref:
	$(SPIKE_CMD) -m16384 pk -c ./perlbench_s_base.riscv-m64 -I./lib diffmail.pl 4 800 10 17 19 300 2>&1 | tee run.log
600.perlbench_s_splitmail_ref:
	$(SPIKE_CMD) -m16384 pk -c ./perlbench_s_base.riscv-m64 -I./lib splitmail.pl 6400 12 26 16 100 0 2>&1 | tee run.log

602.gcc_s_1_ref:
	$(SPIKE_CMD) -m16384 pk -c ./sgcc_base.riscv-m64 gcc-pp.c -O5 -fipa-pta -o gcc-pp.opts-O5_-fipa-pta.s 2>&1 | tee run.log
602.gcc_s_2_ref:
	$(SPIKE_CMD) -m16384 pk -c ./sgcc_base.riscv-m64 gcc-pp.c -O5 -finline-limit=1000 -fselective-scheduling -fselective-scheduling2 -o gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.s 2>&1 | tee run.log
602.gcc_s_3_ref:
	$(SPIKE_CMD) -m16384 pk -c ./sgcc_base.riscv-m64 gcc-pp.c -O5 -finline-limit=24000 -fgcse -fgcse-las -fgcse-lm -fgcse-sm -o gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.s 2>&1 | tee run.log

603.bwaves_s_1_ref:
	$(SPIKE_CMD) -m16384 pk -c ./speed_bwaves_base.riscv-m64 bwaves_1 < bwaves_1.in 2>&1 | tee run.log
603.bwaves_s_2_ref:
	$(SPIKE_CMD) -m16384 pk -c ./speed_bwaves_base.riscv-m64 bwaves_2 < bwaves_2.in 2>&1 | tee run.log

605.mcf_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./mcf_s_base.riscv-m64 inp.in  2>&1 | tee run.log

607.cactuBSSN_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./cactuBSSN_s_base.riscv-m64 spec_ref.par   2>&1 | tee run.log

619.lbm_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./lbm_s_base.riscv-m64 2000 reference.dat 0 0 200_200_260_ldc.of 2>&1 | tee run.log

620.omnetpp_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./omnetpp_s_base.riscv-m64 -c General -r 0 2>&1 | tee run.log

621.wrf_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./wrf_s_base.riscv-m64 2>&1 | tee run.log

623.xalancbmk_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./xalancbmk_s_base.riscv-m64 -v t5.xml xalanc.xsl 2>&1 | tee run.log

625.x264_s_two_pass_ref:
	$(SPIKE_CMD) -m16384 pk -c ./x264_s_base.riscv-m64 --pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 2>&1 | tee run_pass_1.log
	$(SPIKE_CMD) -m16384 pk -c ./x264_s_base.riscv-m64 --pass 2 --stats x264_stats.log --bitrate 1000 --dumpyuv 200 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 2>&1 | tee run_pass_2.log

625.x264_s_base_ref:
	$(SPIKE_CMD) -m16384 pk -c ./x264_s_base.riscv-m64 --seek 500 --dumpyuv 200 --frames 1250 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 2>&1 | tee run.log

627.cam4_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./cam4_s_base.riscv-m64 2>&1 | tee run.log

628.pop2_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./speed_pop2_base.riscv-m64 2>&1 | tee run.log

631.deepsjeng_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./deepsjeng_s_base.riscv-m64 ref.txt 2>&1 | tee run.log

638.imagick_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./imagick_s_base.riscv-m64 -limit disk 0 refspeed_input.tga -resize 817% -rotate -2.76 -shave 540x375 -alpha remove -auto-level -contrast-stretch 1x1% -colorspace Lab -channel R -equalize +channel -colorspace sRGB -define histogram:unique-colors=false -adaptive-blur 0x5 -despeckle -auto-gamma -adaptive-sharpen 55 -enhance -brightness-contrast 10x10 -resize 30% refspeed_output.tga 2>&1 | tee run.log

641.leela_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./leela_s_base.riscv-m64 ref.sgf 2>&1 | tee run.log

644.nab_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./nab_s_base.riscv-m64 3j1n 20140317 220 2>&1 | tee run.log

648.exchange2_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./exchange2_s_base.riscv-m64 6 2>&1 | tee run.log

649.fotonik3d_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./fotonik3d_s_base.riscv-m64 2>&1 | tee run.log

654.roms_s_ref:
	$(SPIKE_CMD) -m16384 pk -c ./sroms_base.riscv-m64 < ocean_benchmark3.in 2>&1 | tee run.log

657.xz_s_docs_ref:
	$(SPIKE_CMD) -m16384 pk -c ./xz_s_base.riscv-m64 cpu2006docs.tar.xz 6643 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 1036078272 1111795472 4 2>&1 | tee run.log
657.xz_s_cld_ref:
	$(SPIKE_CMD) -m16384 pk -c ./xz_s_base.riscv-m64 cld.tar.xz 1400 19cf30ae51eddcbefda78dd06014b4b96281456e078ca7c13e1c0c9e6aaea8dff3efb4ad6b0456697718cede6bd5454852652806a657bb56e07d61128434b474 536995164 539938872 8 2>&1 | tee run.log

#################################
# Postprocess rules for CPU2006 #
#################################

400.perlbench_checkspam_ref_postprocess:
	$(SPIKE_TRIM) run.log > checkspam.2500.5.25.11.150.1.1.1.1.out # stderr: checkspam.2500.5.25.11.150.1.1.1.1.err
400.perlbench_diffmail_ref_postprocess:
	$(SPIKE_TRIM) run.log > diffmail.4.800.10.17.19.300.out # stderr: diffmail.4.800.10.17.19.300.err
400.perlbench_splitmail_ref_postprocess:
	$(SPIKE_TRIM) run.log > splitmail.1600.12.26.16.4500.out # stderr: splitmail.1600.12.26.16.4500.err

401.bzip2_source_ref_postprocess:
	$(SPIKE_TRIM) run.log > input.source.out # stderr: input.source.err
401.bzip2_chicken_ref_postprocess:
	$(SPIKE_TRIM) run.log > chicken.jpg.out # stderr: chicken.jpg.err
401.bzip2_liberty_ref_postprocess:
	$(SPIKE_TRIM) run.log > liberty.jpg.out # stderr: liberty.jpg.err
401.bzip2_program_ref_postprocess:
	$(SPIKE_TRIM) run.log > input.program.out # stderr: input.program.err
401.bzip2_html_ref_postprocess:
	$(SPIKE_TRIM) run.log > text.html.out # stderr: text.html.err
401.bzip2_combined_ref_postprocess:
	$(SPIKE_TRIM) run.log > input.combined.out # stderr: input.combined.err

403.gcc_166_ref_postprocess:
	$(SPIKE_TRIM) run.log > 166.out # stderr: 166.err
403.gcc_200_ref_postprocess:
	$(SPIKE_TRIM) run.log > 200.out # stderr: 200.err
403.gcc_c-typeck_ref_postprocess:
	$(SPIKE_TRIM) run.log > c-typeck.out # stderr: c-typeck.err
403.gcc_cp-decl_ref_postprocess:
	$(SPIKE_TRIM) run.log > cp-decl.out # stderr: cp-decl.err
403.gcc_expr_ref_postprocess:
	$(SPIKE_TRIM) run.log > expr.out # stderr: expr.err
403.gcc_expr2_ref_postprocess:
	$(SPIKE_TRIM) run.log > expr2.out # stderr: expr2.err
403.gcc_g23_ref_postprocess:
	$(SPIKE_TRIM) run.log > g23.out # stderr: g23.err
403.gcc_s04_ref_postprocess:
	$(SPIKE_TRIM) run.log > s04.out # stderr: s04.err
403.gcc_scilab_ref_postprocess:
	$(SPIKE_TRIM) run.log > scilab.out # stderr: scilab.err

410.bwaves_ref_postprocess:
	echo

416.gamess_cytosine_ref_postprocess:
	$(SPIKE_TRIM) run.log > cytosine.2.out # stderr: cytosine.2.err
416.gamess_h2ocu2_ref_postprocess:
	$(SPIKE_TRIM) run.log > h2ocu2+.gradient.out # stderr: h2ocu2+.gradient.err
416.gamess_triazolium_ref_postprocess:
	$(SPIKE_TRIM) run.log > triazolium.out # stderr: triazolium.err

429.mcf_ref_postprocess:
	$(SPIKE_TRIM) run.log > inp.out # stderr: inp.err

433.milc_ref_postprocess:
	$(SPIKE_TRIM) run.log > su3imp.out # stderr: su3imp.err

434.zeusmp_ref_postprocess:
	$(SPIKE_TRIM) run.log > zeusmp.stdout # stderr: zeusmp.err

435.gromacs_ref_postprocess:
	echo

436.cactusADM_ref_postprocess:
	$(SPIKE_TRIM) run.log > benchADM.out # stderr: benchADM.err

437.leslie3d_ref_postprocess:
	$(SPIKE_TRIM) run.log > leslie3d.stdout # stderr: leslie3d.err

444.namd_ref_postprocess:
	$(SPIKE_TRIM) run.log > namd.stdout # stderr: namd.err

445.gobmk_13x13_ref_postprocess:
	$(SPIKE_TRIM) run.log > 13x13.out # stderr: 13x13.err
445.gobmk_nngs_ref_postprocess:
	$(SPIKE_TRIM) run.log > nngs.out # stderr: nngs.err
445.gobmk_score2_ref_postprocess:
	$(SPIKE_TRIM) run.log > score2.out # stderr: score2.err
445.gobmk_trevorc_ref_postprocess:
	$(SPIKE_TRIM) run.log > trevorc.out # stderr: trevorc.err
445.gobmk_trevord_ref_postprocess:
	$(SPIKE_TRIM) run.log > trevord.out # stderr: trevord.err

447.dealII_ref_postprocess:
	$(SPIKE_TRIM) run.log > log # stderr: dealII.err

450.soplex_pds50_mps_ref_postprocess:
	$(SPIKE_TRIM) run.log > pds-50.mps.out # stderr: pds-50.mps.stderr
450.soplex_ref_mps_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.stderr

453.povray_ref_postprocess:
	$(SPIKE_TRIM) run.log > SPEC-benchmark-ref.stdout # stderr: SPEC-benchmark-ref.stderr

454.calculix_ref_postprocess:
	$(SPIKE_TRIM) run.log > hyperviscoplastic.log # stderr: hyperviscoplastic.err

456.hmmer_test_postprocess:
	$(SPIKE_TRIM) run.log > bombesin.out # stderr: bombesin.err
456.hmmer_nph3_ref_postprocess:
	$(SPIKE_TRIM) run.log > nph3.out # stderr: nph3.err
456.hmmer_retro_ref_postprocess:
	$(SPIKE_TRIM) run.log > retro.out # stderr: retro.err

458.sjeng_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.err

459.GemsFDTD_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.log # stderr: ref.err

462.libquantum_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.err

464.h264ref_foreman_ref_encoder_baseline_ref_postprocess:
	$(SPIKE_TRIM) run.log > foreman_ref_baseline_encodelog.out # stderr: foreman_ref_baseline_encodelog.err
464.h264ref_foreman_ref_encoder_main_ref_postprocess:
	$(SPIKE_TRIM) run.log > foreman_ref_main_encodelog.out # stderr: foreman_ref_main_encodelog.err
464.h264ref_sss_encoder_main_ref_postprocess:
	$(SPIKE_TRIM) run.log > sss_main_encodelog.out # stderr: sss_main_encodelog.err

465.tonto_ref_postprocess:
	$(SPIKE_TRIM) run.log > tonto.out # stderr: tonto.err

470.lbm_ref_postprocess:
	$(SPIKE_TRIM) run.log > lbm.out # stderr: lbm.err

471.omnetpp_ref_postprocess:
	$(SPIKE_TRIM) run.log > omnetpp.log # stderr: omnetpp.err

473.astar_biglakes2048_ref_postprocess:
	$(SPIKE_TRIM) run.log > BigLakes2048.out # stderr: BigLakes2048.err
473.astar_rivers_ref_postprocess:
	$(SPIKE_TRIM) run.log > rivers.out # stderr: rivers.err

481.wrf_ref_postprocess:
	$(SPIKE_TRIM) run.log > rsl.out.0000 # stderr: wrf.err

482.sphinx3_ref_postprocess:
	$(SPIKE_TRIM) run.log > an4.log # stderr: an4.err

483.xalancbmk_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.err

#################################
# Postprocess rules for CPU2017 #
#################################

600.perlbench_s_checkspam_ref_postprocess:
	$(SPIKE_TRIM) run.log > checkspam.2500.5.25.11.150.1.1.1.1.out # stderr: checkspam.2500.5.25.11.150.1.1.1.1.err
600.perlbench_s_diffmail_ref_postprocess:
	$(SPIKE_TRIM) run.log > diffmail.4.800.10.17.19.300.out # stderr: diffmail.4.800.10.17.19.300.err
600.perlbench_s_splitmail_ref_postprocess:
	$(SPIKE_TRIM) run.log > splitmail.6400.12.26.16.100.0.out # stderr: splitmail.6400.12.26.16.100.0.err

602.gcc_s_1_ref_postprocess:
	$(SPIKE_TRIM) run.log > gcc-pp.opts-O5_-fipa-pta.out # stderr: gcc-pp.opts-O5_-fipa-pta.err
602.gcc_s_2_ref_postprocess:
	$(SPIKE_TRIM) run.log > gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.out # stderr: gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.err
602.gcc_s_3_ref_postprocess:
	$(SPIKE_TRIM) run.log > gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.out # stderr: gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.err

603.bwaves_s_1_ref_postprocess:
	$(SPIKE_TRIM) run.log > bwaves_1.out # stderr: bwaves_1.err
603.bwaves_s_2_ref_postprocess:
	$(SPIKE_TRIM) run.log > bwaves_2.out # stderr: bwaves_2.err

605.mcf_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > inp.out # stderr: inp.err

607.cactuBSSN_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > spec_ref.out # stderr: spec_ref.err

619.lbm_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > lbm.out # stderr: lbm.err

620.omnetpp_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > omnetpp.General-0.out # stderr: omnetpp.General-0.err

621.wrf_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > rsl.out.0000 # stderr: wrf.err

623.xalancbmk_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref-t5.out # stderr: ref-t5.err

625.x264_s_two_pass_ref_postprocess:
	$(SPIKE_TRIM) run_pass_1.log > run_000-1000_x264_s_base.x64-m64_x264_pass1.out # stderr: run_000-1000_x264_s_base.x64-m64_x264_pass1.err
	$(SPIKE_TRIM) run_pass_2.log > run_000-1000_x264_s_base.x64-m64_x264_pass2.out # stderr: run_000-1000_x264_s_base.x64-m64_x264_pass2.err

625.x264_s_base_ref_postprocess:
	$(SPIKE_TRIM) run.log > run_0500-1250_x264_s_base.x64-m64_x264.out # stderr: run_0500-1250_x264_s_base.x64-m64_x264.err

627.cam4_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > cam4_s_base.riscv-m64.txt # stderr: cam4_s_base.riscv-m64.err

628.pop2_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > pop2_s.out # stderr: pop2_s.err

631.deepsjeng_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.err

638.imagick_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > refspeed_convert.out # stderr: refspeed_convert.err

641.leela_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > ref.out # stderr: ref.err

644.nab_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > 3j1n.out # stderr: 3j1n.err

648.exchange2_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > exchange2.txt # stderr: exchange2.err

649.fotonik3d_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > fotonik3d_s.log # stderr: fotonik3d_s.err

654.roms_s_ref_postprocess:
	$(SPIKE_TRIM) run.log > ocean_benchmark3.log # stderr: ocean_benchmark3.err

657.xz_s_docs_ref_postprocess:
	$(SPIKE_TRIM) run.log > cpu2006docs.tar-6643-4.out # stderr: cpu2006docs.tar-6643-4.err
657.xz_s_cld_ref_postprocess:
	$(SPIKE_TRIM) run.log > cld.tar-1400-8.out # stderr: cld.tar-1400-8.err

##############################
# Validate rules for CPU2006 #
##############################

400.perlbench_checkspam_ref_compare: 400.perlbench_checkspam_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/400.perlbench/data/ref/output/checkspam.2500.5.25.11.150.1.1.1.1.out checkspam.2500.5.25.11.150.1.1.1.1.out > checkspam.2500.5.25.11.150.1.1.1.1.out.cmp
400.perlbench_diffmail_ref_compare: 400.perlbench_diffmail_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/400.perlbench/data/ref/output/diffmail.4.800.10.17.19.300.out diffmail.4.800.10.17.19.300.out > diffmail.4.800.10.17.19.300.out.cmp
400.perlbench_splitmail_ref_compare: 400.perlbench_splitmail_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/400.perlbench/data/ref/output/splitmail.1600.12.26.16.4500.out splitmail.1600.12.26.16.4500.out > splitmail.1600.12.26.16.4500.out.cmp

401.bzip2_source_ref_compare: 401.bzip2_source_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/input.source.out input.source.out > input.source.out.cmp
401.bzip2_chicken_ref_compare: 401.bzip2_chicken_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/chicken.jpg.out chicken.jpg.out > chicken.jpg.out.cmp
401.bzip2_liberty_ref_compare: 401.bzip2_liberty_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/liberty.jpg.out liberty.jpg.out > liberty.jpg.out.cmp
401.bzip2_program_ref_compare: 401.bzip2_program_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/input.program.out input.program.out > input.program.out.cmp
401.bzip2_html_ref_compare: 401.bzip2_html_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/text.html.out text.html.out > text.html.out.cmp
401.bzip2_combined_ref_compare: 401.bzip2_combined_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/401.bzip2/data/ref/output/input.combined.out input.combined.out > input.combined.out.cmp

403.gcc_166_ref_compare: 403.gcc_166_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/166.s 166.s > 166.s.cmp
403.gcc_200_ref_compare: 403.gcc_200_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/200.s 200.s > 200.s.cmp
403.gcc_c-typeck_ref_compare: 403.gcc_c-typeck_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/c-typeck.s c-typeck.s > c-typeck.s.cmp
403.gcc_cp-decl_ref_compare: 403.gcc_cp-decl_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/cp-decl.s cp-decl.s > cp-decl.s.cmp
403.gcc_expr_ref_compare: 403.gcc_expr_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/expr.s expr.s > expr.s.cmp
403.gcc_expr2_ref_compare: 403.gcc_expr2_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/expr2.s expr2.s > expr2.s.cmp
403.gcc_g23_ref_compare: 403.gcc_g23_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/g23.s g23.s > g23.s.cmp
403.gcc_s04_ref_compare: 403.gcc_s04_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/s04.s s04.s > s04.s.cmp
403.gcc_scilab_ref_compare: 403.gcc_scilab_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/403.gcc/data/ref/output/scilab.s scilab.s > scilab.s.cmp

410.bwaves_ref_compare: 410.bwaves_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-16 $(CPU2006_BENCH)/410.bwaves/data/ref/output/bwaves.out bwaves.out > bwaves.out.cmp
	$(CPU2006_DIFF) -m -l 10  --reltol 0.015 $(CPU2006_BENCH)/410.bwaves/data/ref/output/bwaves2.out bwaves2.out > bwaves2.out.cmp
	$(CPU2006_DIFF) -m -l 10  --reltol 1e-06 $(CPU2006_BENCH)/410.bwaves/data/ref/output/bwaves3.out bwaves3.out > bwaves3.out.cmp

416.gamess_cytosine_ref_compare: 416.gamess_cytosine_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.0001  --ignorecase $(CPU2006_BENCH)/416.gamess/data/ref/output/cytosine.2.out cytosine.2.out > cytosine.2.out.cmp
416.gamess_h2ocu2_ref_compare: 416.gamess_h2ocu2_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.0001  --ignorecase $(CPU2006_BENCH)/416.gamess/data/ref/output/h2ocu2+.gradient.out h2ocu2+.gradient.out > h2ocu2+.gradient.out.cmp
416.gamess_triazolium_ref_compare: 416.gamess_triazolium_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.0001  --ignorecase $(CPU2006_BENCH)/416.gamess/data/ref/output/triazolium.out triazolium.out > triazolium.out.cmp

429.mcf_ref_compare: 429.mcf_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/429.mcf/data/ref/output/inp.out inp.out > inp.out.cmp
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/429.mcf/data/ref/output/mcf.out mcf.out > mcf.out.cmp

433.milc_ref_compare: 433.milc_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 2e-07  --reltol 0.0001 $(CPU2006_BENCH)/433.milc/data/ref/output/su3imp.out su3imp.out > su3imp.out.cmp

434.zeusmp_ref_compare: 434.zeusmp_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 0.001  --reltol 0.001 $(CPU2006_BENCH)/434.zeusmp/data/ref/output/tsl000aa tsl000aa > tsl000aa.cmp

435.gromacs_ref_compare: 435.gromacs_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --reltol 0.0125 $(CPU2006_BENCH)/435.gromacs/data/ref/output/gromacs.out gromacs.out > gromacs.out.cmp

436.cactusADM_ref_compare: 436.cactusADM_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --floatcompare $(CPU2006_BENCH)/436.cactusADM/data/ref/output/benchADM.out benchADM.out > benchADM.out.cmp

437.leslie3d_ref_compare: 437.leslie3d_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --floatcompare $(CPU2006_BENCH)/437.leslie3d/data/ref/output/leslie3d.out leslie3d.out > leslie3d.out.cmp

444.namd_ref_compare: 444.namd_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05 $(CPU2006_BENCH)/444.namd/data/ref/output/namd.out namd.out > namd.out.cmp

445.gobmk_13x13_ref_compare: 445.gobmk_13x13_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/445.gobmk/data/ref/output/13x13.out 13x13.out > 13x13.out.cmp
445.gobmk_nngs_ref_compare: 445.gobmk_nngs_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/445.gobmk/data/ref/output/nngs.out nngs.out > nngs.out.cmp
445.gobmk_score2_ref_compare: 445.gobmk_score2_ref_postprocess
	$(CPU2006_DIFF) -c -m -l 10 $(CPU2006_BENCH)/445.gobmk/data/ref/output/score2.out score2.out > score2.out.cmp
445.gobmk_trevorc_ref_compare: 445.gobmk_trevorc_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/445.gobmk/data/ref/output/trevorc.out trevorc.out > trevorc.out.cmp
445.gobmk_trevord_ref_compare: 445.gobmk_trevord_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/445.gobmk/data/ref/output/trevord.out trevord.out > trevord.out.cmp

447.dealII_ref_compare: 447.dealII_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-0.eps grid-0.eps > grid-0.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-1.eps grid-1.eps > grid-1.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-2.eps grid-2.eps > grid-2.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-3.eps grid-3.eps > grid-3.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-4.eps grid-4.eps > grid-4.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-5.eps grid-5.eps > grid-5.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-6.eps grid-6.eps > grid-6.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-7.eps grid-7.eps > grid-7.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/grid-8.eps grid-8.eps > grid-8.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-0.gmv solution-0.gmv > solution-0.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-1.gmv solution-1.gmv > solution-1.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-2.gmv solution-2.gmv > solution-2.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-3.gmv solution-3.gmv > solution-3.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-4.gmv solution-4.gmv > solution-4.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-5.gmv solution-5.gmv > solution-5.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-6.gmv solution-6.gmv > solution-6.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-7.gmv solution-7.gmv > solution-7.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/all/output/solution-8.gmv solution-8.gmv > solution-8.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-10.eps grid-10.eps > grid-10.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-11.eps grid-11.eps > grid-11.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-12.eps grid-12.eps > grid-12.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-13.eps grid-13.eps > grid-13.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-14.eps grid-14.eps > grid-14.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-15.eps grid-15.eps > grid-15.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-16.eps grid-16.eps > grid-16.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-17.eps grid-17.eps > grid-17.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-18.eps grid-18.eps > grid-18.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-19.eps grid-19.eps > grid-19.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-20.eps grid-20.eps > grid-20.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-21.eps grid-21.eps > grid-21.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-22.eps grid-22.eps > grid-22.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-23.eps grid-23.eps > grid-23.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/grid-9.eps grid-9.eps > grid-9.eps.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/log log > log.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-10.gmv solution-10.gmv > solution-10.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-11.gmv solution-11.gmv > solution-11.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-12.gmv solution-12.gmv > solution-12.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-13.gmv solution-13.gmv > solution-13.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-14.gmv solution-14.gmv > solution-14.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-15.gmv solution-15.gmv > solution-15.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-16.gmv solution-16.gmv > solution-16.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-17.gmv solution-17.gmv > solution-17.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-18.gmv solution-18.gmv > solution-18.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-19.gmv solution-19.gmv > solution-19.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-20.gmv solution-20.gmv > solution-20.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-21.gmv solution-21.gmv > solution-21.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-22.gmv solution-22.gmv > solution-22.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-23.gmv solution-23.gmv > solution-23.gmv.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/447.dealII/data/ref/output/solution-9.gmv solution-9.gmv > solution-9.gmv.cmp

450.soplex_pds50_mps_ref_compare: 450.soplex_pds50_mps_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 20  --reltol 0.0001  --obiwan $(CPU2006_BENCH)/450.soplex/data/ref/output/pds-50.mps.info pds-50.mps.info > pds-50.mps.info.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.02  --obiwan $(CPU2006_BENCH)/450.soplex/data/ref/output/pds-50.mps.out pds-50.mps.out > pds-50.mps.out.cmp
450.soplex_ref_mps_ref_compare: 450.soplex_ref_mps_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 20  --reltol 0.0001  --obiwan $(CPU2006_BENCH)/450.soplex/data/ref/output/ref.mps.info ref.mps.info > ref.mps.info.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.02  --obiwan $(CPU2006_BENCH)/450.soplex/data/ref/output/ref.out ref.out > ref.out.cmp

453.povray_ref_compare: 453.povray_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 0  --reltol 5e-05 $(CPU2006_BENCH)/453.povray/data/ref/output/SPEC-benchmark.log SPEC-benchmark.log > SPEC-benchmark.log.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 0  --reltol 5e-05  --skiptol 50  --binary $(CPU2006_BENCH)/453.povray/data/ref/output/SPEC-benchmark.tga SPEC-benchmark.tga > SPEC-benchmark.tga.cmp

454.calculix_ref_compare: 454.calculix_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-09  --reltol 1e-09  --obiwan $(CPU2006_BENCH)/454.calculix/data/ref/output/SPECtestformatmodifier_z.txt SPECtestformatmodifier_z.txt > SPECtestformatmodifier_z.txt.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-09  --reltol 1e-09  --obiwan $(CPU2006_BENCH)/454.calculix/data/ref/output/hyperviscoplastic.dat hyperviscoplastic.dat > hyperviscoplastic.dat.cmp

456.hmmer_test_compare: 456.hmmer_test_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.002 $(CPU2006_BENCH)/456.hmmer/data/test/output/bombesin.out bombesin.out > bombesin.out.cmp
456.hmmer_nph3_ref_compare: 456.hmmer_nph3_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.002 $(CPU2006_BENCH)/456.hmmer/data/ref/output/nph3.out nph3.out > nph3.out.cmp
456.hmmer_retro_ref_compare: 456.hmmer_retro_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-05  --reltol 0.002 $(CPU2006_BENCH)/456.hmmer/data/ref/output/retro.out retro.out > retro.out.cmp

458.sjeng_ref_compare: 458.sjeng_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/458.sjeng/data/ref/output/ref.out ref.out > ref.out.cmp

459.GemsFDTD_ref_compare: 459.GemsFDTD_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-10  --reltol 1e-09  --obiwan $(CPU2006_BENCH)/459.GemsFDTD/data/ref/output/sphere_td.nft sphere_td.nft > sphere_td.nft.cmp

462.libquantum_ref_compare: 462.libquantum_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --obiwan $(CPU2006_BENCH)/462.libquantum/data/ref/output/ref.out ref.out > ref.out.cmp

464.h264ref_foreman_ref_encoder_baseline_ref_compare: 464.h264ref_foreman_ref_encoder_baseline_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/foreman_ref_baseline_encodelog.out foreman_ref_baseline_encodelog.out > foreman_ref_baseline_encodelog.out.cmp
	$(CPU2006_DIFF) -m -l 10  --binary  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/foreman_ref_baseline_leakybucketparam.cfg foreman_ref_baseline_leakybucketparam.cfg > foreman_ref_baseline_leakybucketparam.cfg.cmp
464.h264ref_foreman_ref_encoder_main_ref_compare: 464.h264ref_foreman_ref_encoder_main_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/foreman_ref_main_encodelog.out foreman_ref_main_encodelog.out > foreman_ref_main_encodelog.out.cmp
	$(CPU2006_DIFF) -m -l 10  --binary  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/foreman_ref_main_leakybucketparam.cfg foreman_ref_main_leakybucketparam.cfg > foreman_ref_main_leakybucketparam.cfg.cmp
464.h264ref_sss_encoder_main_ref_compare: 464.h264ref_sss_encoder_main_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/sss_main_encodelog.out sss_main_encodelog.out > sss_main_encodelog.out.cmp
	$(CPU2006_DIFF) -m -l 10  --binary  --cw  --floatcompare $(CPU2006_BENCH)/464.h264ref/data/ref/output/sss_main_leakybucketparam.cfg sss_main_leakybucketparam.cfg > sss_main_leakybucketparam.cfg.cmp

465.tonto_ref_compare: 465.tonto_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --reltol 0.006 $(CPU2006_BENCH)/465.tonto/data/ref/output/stdout stdout > stdout.cmp

470.lbm_ref_compare: 470.lbm_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-07 $(CPU2006_BENCH)/470.lbm/data/ref/output/lbm.out lbm.out > lbm.out.cmp

471.omnetpp_ref_compare: 471.omnetpp_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-06  --reltol 1e-05 $(CPU2006_BENCH)/471.omnetpp/data/ref/output/omnetpp.log omnetpp.log > omnetpp.log.cmp
	$(CPU2006_DIFF) -m -l 10  --abstol 1e-06  --reltol 1e-05 $(CPU2006_BENCH)/471.omnetpp/data/ref/output/omnetpp.sca omnetpp.sca > omnetpp.sca.cmp

473.astar_biglakes2048_ref_compare: 473.astar_biglakes2048_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --reltol 0.001 $(CPU2006_BENCH)/473.astar/data/ref/output/BigLakes2048.out BigLakes2048.out > BigLakes2048.out.cmp
473.astar_rivers_ref_compare: 473.astar_rivers_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --reltol 0.001 $(CPU2006_BENCH)/473.astar/data/ref/output/rivers.out rivers.out > rivers.out.cmp

481.wrf_ref_compare: 481.wrf_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --abstol 0.01  --reltol 0.05 $(CPU2006_BENCH)/481.wrf/data/ref/output/rsl.out.0000 rsl.out.0000 > rsl.out.0000.cmp

482.sphinx3_ref_compare: 482.sphinx3_ref_postprocess
	$(CPU2006_DIFF) -m -l 10  --reltol 0.001  --floatcompare $(CPU2006_BENCH)/482.sphinx3/data/ref/output/an4.log an4.log > an4.log.cmp
	$(CPU2006_DIFF) -m -l 10  --reltol 0.0004  --floatcompare $(CPU2006_BENCH)/482.sphinx3/data/ref/output/considered.out considered.out > considered.out.cmp
	$(CPU2006_DIFF) -m -l 10  --reltol 1e-06  --floatcompare $(CPU2006_BENCH)/482.sphinx3/data/ref/output/total_considered.out total_considered.out > total_considered.out.cmp

483.xalancbmk_ref_compare: 483.xalancbmk_ref_postprocess
	$(CPU2006_DIFF) -m -l 10 $(CPU2006_BENCH)/483.xalancbmk/data/ref/output/ref.out ref.out > ref.out.cmp

##############################
# Validate rules for CPU2017 #
##############################

600.perlbench_s_checkspam_ref_compare: 600.perlbench_s_checkspam_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/500.perlbench_r/data/refrate/output/checkspam.2500.5.25.11.150.1.1.1.1.out checkspam.2500.5.25.11.150.1.1.1.1.out > checkspam.2500.5.25.11.150.1.1.1.1.out.cmp
600.perlbench_s_diffmail_ref_compare: 600.perlbench_s_diffmail_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/500.perlbench_r/data/refrate/output/diffmail.4.800.10.17.19.300.out diffmail.4.800.10.17.19.300.out > diffmail.4.800.10.17.19.300.out.cmp
600.perlbench_s_splitmail_ref_compare: 600.perlbench_s_splitmail_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/500.perlbench_r/data/refrate/output/splitmail.6400.12.26.16.100.0.out splitmail.6400.12.26.16.100.0.out > splitmail.6400.12.26.16.100.0.out.cmp

602.gcc_s_1_ref_compare: 602.gcc_s_1_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/502.gcc_r/data/refspeed/output/gcc-pp.opts-O5_-fipa-pta.s gcc-pp.opts-O5_-fipa-pta.s > gcc-pp.opts-O5_-fipa-pta.s.cmp
602.gcc_s_2_ref_compare: 602.gcc_s_2_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/502.gcc_r/data/refspeed/output/gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.s gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.s > gcc-pp.opts-O5_-finline-limit_1000_-fselective-scheduling_-fselective-scheduling2.s.cmp
602.gcc_s_3_ref_compare: 602.gcc_s_3_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --floatcompare --nonansupport $(CPU2017_BENCH)/502.gcc_r/data/refspeed/output/gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.s gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.s > gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.s.cmp

603.bwaves_s_1_ref_compare: 603.bwaves_s_1_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-16 --reltol 0.015 $(CPU2017_BENCH)/503.bwaves_r/data/refspeed/output/bwaves_1.out bwaves_1.out > bwaves_1.out.cmp
603.bwaves_s_2_ref_compare: 603.bwaves_s_2_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-16 --reltol 0.015 $(CPU2017_BENCH)/503.bwaves_r/data/refspeed/output/bwaves_2.out bwaves_2.out > bwaves_2.out.cmp

605.mcf_s_ref_compare: 605.mcf_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/505.mcf_r/data/refspeed/output/inp.out inp.out > inp.out.cmp
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/505.mcf_r/data/refspeed/output/mcf.out mcf.out > mcf.out.cmp

607.cactuBSSN_s_ref_compare: 607.cactuBSSN_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 5e-13 --floatcompare $(CPU2017_BENCH)/507.cactuBSSN_r/data/refspeed/output/gxx.xl gxx.xl > gxx.xl.cmp
	$(CPU2017_DIFF) -m -l 10 --abstol 5e-13 --floatcompare $(CPU2017_BENCH)/507.cactuBSSN_r/data/refspeed/output/gxy.xl gxy.xl > gxy.xl.cmp
	$(CPU2017_DIFF) -m -l 10 --floatcompare $(CPU2017_BENCH)/507.cactuBSSN_r/data/refspeed/output/spec_ref.out spec_ref.out > spec_ref.out.cmp

619.lbm_s_ref_compare: 619.lbm_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-07 $(CPU2017_BENCH)/619.lbm_s/data/refspeed/output/lbm.out lbm.out > lbm.out.cmp

620.omnetpp_s_ref_compare: 620.omnetpp_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-06 --reltol 1e-05 $(CPU2017_BENCH)/520.omnetpp_r/data/refrate/output/General-0.sca General-0.sca > General-0.sca.cmp

621.wrf_s_ref_compare: 621.wrf_s_ref_postprocess
	$(CPU2017_621_DIFFWRF) wrfout_d01_2000-01-24_15_00_00 $(CPU2017_BENCH)/521.wrf_r/data/refspeed/compare/wrf_reference_01 > diffwrf_output_01.txt 2>> diffwrf_01.err
	$(CPU2017_DIFF) -m -l 10 --cw $(CPU2017_BENCH)/521.wrf_r/data/refspeed/output/diffwrf_output_01.txt diffwrf_output_01.txt > diffwrf_output_01.txt.cmp

623.xalancbmk_s_ref_compare: 623.xalancbmk_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/523.xalancbmk_r/data/refrate/output/ref-t5.out ref-t5.out > ref-t5.out.cmp

625.x264_s_two_pass_ref_compare: 625.x264_s_two_pass_ref_postprocess
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_200.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_200.org.tga > imagevalidate_frame_200.out 2>> imagevalidate_frame_200.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_400.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_400.org.tga > imagevalidate_frame_400.out 2>> imagevalidate_frame_400.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_600.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_600.org.tga > imagevalidate_frame_600.out 2>> imagevalidate_frame_600.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_800.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_800.org.tga > imagevalidate_frame_800.out 2>> imagevalidate_frame_800.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_999.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_999.org.tga > imagevalidate_frame_999.out 2>> imagevalidate_frame_999.err
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_200.out imagevalidate_frame_200.out > imagevalidate_frame_200.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_400.out imagevalidate_frame_400.out > imagevalidate_frame_400.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_600.out imagevalidate_frame_600.out > imagevalidate_frame_600.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_800.out imagevalidate_frame_800.out > imagevalidate_frame_800.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_999.out imagevalidate_frame_999.out > imagevalidate_frame_999.out.cmp

625.x264_s_base_ref_compare: 625.x264_s_base_ref_postprocess
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_700.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_700.org.tga > imagevalidate_frame_700.out 2>> imagevalidate_frame_700.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_900.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_900.org.tga > imagevalidate_frame_900.out 2>> imagevalidate_frame_900.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_1100.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_1100.org.tga > imagevalidate_frame_1100.out 2>> imagevalidate_frame_1100.err
	$(CPU2017_625_X264_VAL) -avg -threshold 0.5 -maxthreshold 20 frame_1249.yuv $(CPU2017_BENCH)/525.x264_r/data/refrate/compare/frame_1249.org.tga > imagevalidate_frame_1249.out 2>> imagevalidate_frame_1249.err
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_700.out imagevalidate_frame_700.out > imagevalidate_frame_700.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_900.out imagevalidate_frame_900.out > imagevalidate_frame_900.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_1100.out imagevalidate_frame_1100.out > imagevalidate_frame_1100.out.cmp
	$(CPU2017_DIFF) -m -l 10 --reltol 0.085 $(CPU2017_BENCH)/525.x264_r/data/refrate/output/imagevalidate_frame_1249.out imagevalidate_frame_1249.out > imagevalidate_frame_1249.out.cmp

627.cam4_s_ref_compare: 627.cam4_s_ref_postprocess
	$(CPU2017_627_CAM4_VAL) 10 0.0035 $(CPU2017_BENCH)/527.cam4_r/data/refspeed/compare/h0_ctrl.nc h0.nc > cam4_validate.txt 2>> cam4_validate_627_base.riscv-m64.err
	$(CPU2017_DIFF) -m -l 10 --cw $(CPU2017_BENCH)/527.cam4_r/data/refspeed/output/cam4_validate.txt cam4_validate.txt > cam4_validate.txt.cmp

628.pop2_s_ref_compare: 628.pop2_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 0.03 --reltol 0.03 $(CPU2017_BENCH)/628.pop2_s/data/refspeed/output/ocn.log ocn.log > ocn.log.cmp

631.deepsjeng_s_ref_compare: 631.deepsjeng_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --obiwan $(CPU2017_BENCH)/631.deepsjeng_s/data/refspeed/output/ref.out ref.out > ref.out.cmp

638.imagick_s_ref_compare: 638.imagick_s_ref_postprocess
	$(CPU2017_638_IMAGICK_VAL) -avg -threshold 0.9 -maxthreshold 0.001 refspeed_output.tga $(CPU2017_BENCH)/538.imagick_r/data/refspeed/compare/refspeed_expected.tga > refspeed_validate.out 2>> refspeed_validate.err
	$(CPU2017_DIFF) -m -l 10 --reltol 0.01 $(CPU2017_BENCH)/538.imagick_r/data/refspeed/output/refspeed_validate.out refspeed_validate.out > refspeed_validate.out.cmp

641.leela_s_ref_compare: 641.leela_s_ref_postprocess
	$(CPU2017_DIFF) -c -m -l 10 $(CPU2017_BENCH)/541.leela_r/data/refrate/output/ref.out ref.out > ref.out.cmp

644.nab_s_ref_compare: 644.nab_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --reltol 0.01 --skipreltol 2 $(CPU2017_BENCH)/544.nab_r/data/refspeed/output/3j1n.out 3j1n.out > 3j1n.out.cmp

648.exchange2_s_ref_compare: 648.exchange2_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/548.exchange2_r/data/refrate/output/s.txt s.txt > s.txt.cmp

649.fotonik3d_s_ref_compare: 649.fotonik3d_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-27 --reltol 1e-10 --obiwan --floatcompare $(CPU2017_BENCH)/549.fotonik3d_r/data/refspeed/output/pscyee.out pscyee.out > pscyee.out.cmp

654.roms_s_ref_compare: 654.roms_s_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 --abstol 1e-07 --reltol 1e-07 $(CPU2017_BENCH)/554.roms_r/data/refspeed/output/ocean_benchmark3.log ocean_benchmark3.log > ocean_benchmark3.log.cmp

657.xz_s_docs_ref_compare: 657.xz_s_docs_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/557.xz_r/data/refspeed/output/cpu2006docs.tar-6643-4.out cpu2006docs.tar-6643-4.out > cpu2006docs.tar-6643-4.out.cmp
657.xz_s_cld_ref_compare: 657.xz_s_cld_ref_postprocess
	$(CPU2017_DIFF) -m -l 10 $(CPU2017_BENCH)/557.xz_r/data/refspeed/output/cld.tar-1400-8.out cld.tar-1400-8.out > cld.tar-1400-8.out.cmp
