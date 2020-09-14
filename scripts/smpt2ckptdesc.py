#!/usr/bin/env python3

import os
import sys
from functools import reduce
from operator import add
from typing import List


def read_simpoints(path):
    # type: (str) -> List[int]
    with open(path, "r") as smpt_fp:
        idx = 0
        ret_val = []  # type: List[int]
        for line in smpt_fp:
            if line.strip():
                line_split = line.split(' ')
                line_smpt = int(line_split[0].strip())
                line_idx = int(line_split[1].strip())
                if line_idx != idx:
                    raise RuntimeError("Corrupt input file: " + os.path.join(os.getcwd(), "simpoints"))
                idx += 1
                ret_val.append(line_smpt)

        return ret_val


def read_weights(path):
    # type: (str) -> List[float]
    with open(path, "r") as smpt_fp:
        idx = 0
        ret_val = []  # type: List[float]
        for line in smpt_fp:
            if line.strip():
                line_split = line.split(' ')
                line_weight = float(line_split[0].strip())
                line_idx = int(line_split[1].strip())
                if line_idx != idx:
                    raise RuntimeError("Corrupt input file: " + os.path.join(os.getcwd(), "weights"))
                idx += 1
                ret_val.append(line_weight)

        return ret_val


def main():
    def print_help():
        print("Usage:", file=sys.stderr)
        print("  %s [simpoint_interval] [checkpoint_basename] [path_to_simpoint] [path_to_weights]" % sys.argv[0],
              file=sys.stderr)

        print("Examples:")
        print("  %s 100000000 456.hmmer_ref ./simpoints ./weights" % sys.argv[0], file=sys.stderr)
        print("  %s 100000000 641.leela_s_ref /tmp/spike_sim/simpoints /tmp/spike_sim/weights" % sys.argv[0],
              file=sys.stderr)

    if len(sys.argv) != 5:
        print_help()
        return -1

    try:
        simpoint_interval = int(sys.argv[1])
    except ValueError:
        print("Invalid SimPoint Interval: %s" % sys.argv[1], file=sys.stderr)
        print_help()
        return -1

    ckpt_basename = sys.argv[2]

    for c in ckpt_basename:
        if not (c.isalnum() or c == '-' or c == '_' or c == '.'):
            print("Invalid checkpoint name: " + ckpt_basename + "\n" +
                  "  (a valid checkpoint name can only contain char, digit, '-', '_', '.')", file=sys.stderr)
            return -1
    try:
        simpoints = read_simpoints(sys.argv[3])
        weights = read_weights(sys.argv[4])
    except FileNotFoundError as ef:
        # print("Fail to load simpoint data: %s" % str(ef), file=sys.stderr)
        return -1

    if len(simpoints) != len(weights):
        raise RuntimeError("Input 'weights' and 'simpoints' not match")

    smpt_weight_pos_pair = sorted(list(zip(weights, simpoints)), key=lambda i: i[0])
    for sw, sp in smpt_weight_pos_pair:
        print("%s.%d.%0.2f:%d" % (
            ckpt_basename, sp, sw, sp * simpoint_interval
        ))
    print("%2d - %3.2f%%\t%s" % (len(weights), int(reduce(add, weights)*10000)/100.0, ckpt_basename), file=sys.stderr)


if __name__ == '__main__':
    sys.exit(main())
