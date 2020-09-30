cpu2006 = 400.perlbench_checkspam_ref 400.perlbench_diffmail_ref 400.perlbench_splitmail_ref 401.bzip2_chicken_ref 401.bzip2_combined_ref 401.bzip2_liberty_ref 401.bzip2_program_ref 401.bzip2_source_ref 401.bzip2_text_ref 403.gcc_ref 410.bwaves_ref 416.gamess_ref 429.mcf_ref 433.milc_ref 434.zeusmp_ref 435.gromacs_ref 436.cactusADM_ref 437.leslie3d_ref 444.namd_ref 445.gobmk_ref 447.dealII_ref 450.soplex_ref 453.povray_ref 454.calculix_ref 456.hmmer_ref 458.sjeng_ref 459.GemsFDTD_ref 462.libquantum_ref 464.h264ref_ref 465.tonto_ref 470.lbm_ref 471.omnetpp_ref 473.astar_biglakes_ref 473.astar_rivers_ref 481.wrf_ref 482.sphinx3_ref 483.xalancbmk_ref

cpu2017 = 600.perlbench_s_diff_ref 600.perlbench_s_spam_ref 600.perlbench_s_split_ref 602.gcc_s_1_ref 602.gcc_s_2_ref 602.gcc_s_3_ref 603.bwaves_s_1_ref 603.bwaves_s_2_ref 605.mcf_s_ref 607.cactuBSSN_s_ref 619.lbm_s_ref 620.omnetpp_s_ref 621.wrf_s_ref 623.xalancbmk_s_ref 625.x264_s_base_ref 625.x264_s_two_pass_ref 627.cam4_s_ref 628.pop2_s_ref 631.deepsjeng_s_ref 638.imagick_s_ref 641.leela_s_ref 644.nab_s_ref 648.exchange2_s_ref 649.fotonik3d_s_ref 654.roms_s_ref 657.xz_s_cld_ref 657.xz_s_docs_ref

.PHONY: all ${cpu2006} ${cpu2017}

all: ${cpu2006} ${cpu2017}
2006: ${cpu2006}
2017: ${cpu2017}

400.perlbench_checkspam_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
400.perlbench_diffmail_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
400.perlbench_splitmail_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_chicken_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_combined_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_liberty_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_program_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_source_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
401.bzip2_text_ref:
	make -f ../verify_rules.mk -C $@ 401.bzip2_html_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
403.gcc_ref:
	make -f ../verify_rules.mk -C $@ 403.gcc_expr_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
410.bwaves_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
416.gamess_ref:
	make -f ../verify_rules.mk -C $@ 416.gamess_cytosine_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # Failed
429.mcf_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
433.milc_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
434.zeusmp_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
435.gromacs_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
436.cactusADM_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
437.leslie3d_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
444.namd_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
445.gobmk_ref:
	make -f ../verify_rules.mk -C $@ 445.gobmk_score2_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
447.dealII_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # Passed but took long time
450.soplex_ref:
	make -f ../verify_rules.mk -C $@ 450.soplex_pds50_mps_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
453.povray_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
454.calculix_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
456.hmmer_ref:
	make -f ../verify_rules.mk -C $@ 456.hmmer_nph3_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
458.sjeng_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
459.GemsFDTD_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
462.libquantum_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
464.h264ref_ref:
	make -f ../verify_rules.mk -C $@ 464.h264ref_foreman_ref_encoder_baseline_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
465.tonto_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
470.lbm_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
471.omnetpp_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
473.astar_biglakes_ref:
	make -f ../verify_rules.mk -C $@ 473.astar_biglakes2048_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
473.astar_rivers_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
481.wrf_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
482.sphinx3_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
483.xalancbmk_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
600.perlbench_s_diff_ref:
	make -f ../verify_rules.mk -C $@ 600.perlbench_s_diffmail_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
600.perlbench_s_spam_ref:
	make -f ../verify_rules.mk -C $@ 600.perlbench_s_checkspam_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
600.perlbench_s_split_ref:
	make -f ../verify_rules.mk -C $@ 600.perlbench_s_splitmail_ref_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
602.gcc_s_1_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
602.gcc_s_2_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
602.gcc_s_3_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
603.bwaves_s_1_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
603.bwaves_s_2_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
605.mcf_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
607.cactuBSSN_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # Still running
619.lbm_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
620.omnetpp_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # Failed
621.wrf_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # x64 binary in script/bin
623.xalancbmk_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
625.x264_s_base_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
625.x264_s_two_pass_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
627.cam4_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # x64 binary in script/bin
628.pop2_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
631.deepsjeng_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
638.imagick_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi # x64 binary in script/bin
641.leela_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
644.nab_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
648.exchange2_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
649.fotonik3d_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
654.roms_s_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
657.xz_s_cld_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
657.xz_s_docs_ref:
	make -f ../verify_rules.mk -C $@ $@_compare ; if [[ $$? -eq 0 ]] ; then echo "$@" >> cmp_succ ; else echo "$@" >> cmp_fail ; fi
