#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import subprocess
from typing import Callable

# Standard python!
from difflib import SequenceMatcher

# Levenshtein edit distance
# pip3 install python-Levenshtein
# dnf/zypper install python3-Levenshtein
# apt install python3-levenshtein
import Levenshtein  # type: ignore

# Sorenson and Jaccard distances
# pip3 install distance
# import distance  # type: ignore

# TODO check out this for future: just match-not
# import filecmp


def seq_match(file1: str, file2: str) -> float:
    with open(file1) as file_1, open(file2) as file_2:
        file1_data = file_1.read()
        file2_data = file_2.read()

    return SequenceMatcher(None, file1_data.upper(), file2_data.upper()).ratio()


def edit_distance(file1: str, file2: str) -> float:
    with open(file1) as file_1, open(file2) as file_2:
        file1_data = file_1.read()
        file2_data = file_2.read()

    return Levenshtein.ratio(file1_data.upper(), file2_data.upper())


# def distance_apply(
#     file1: str, file2: str, diff_func: Callable[[str, str], float]
# ) -> float:
#     with open(file1) as file_1, open(file2) as file_2:
#         file1_data = file_1.read().split()
#         file2_data = file_2.read().split()
#
#     diff_sum = 0.0
#     # FIXME Assumes same number of words,
#     # so does not work well with bad decryptions.
#     print(len(file1_data))
#     for i in range(len(file1_data)):
#         diff_sum += diff_func(file1_data[i].upper(), file2_data[i].upper())
#     diff = diff_sum / len(file1_data)
#     # 0 means identical so subtract 1 to get a similarity ratio
#     return 1 - diff
#
#
# def sorensen_distance(file1: str, file2: str) -> float:
#     """
#     Sorensen-Dice coefficient
#     """
#     return distance_apply(file1, file2, distance.sorensen)
#
#
# def jaccard_distance(file1: str, file2: str) -> float:
#     """
#     Jaccard index
#     """
#     return distance_apply(file1, file2, distance.jaccard)
#
#
# def percent_similar(file1: str, file2: str) -> float:
#     """
#     sequential percent diff, assumes exact same file length
#     """
#     with open(file1) as file_1, open(file2) as file_2:
#         file1_data = file_1.read()
#         file2_data = file_2.read()
#
#     c = 0
#     size = min(len(file1_data), len(file2_data))
#
#     for ichar in range(size):
#         if file1_data[ichar] == file2_data[ichar]:
#             c += 1
#
#     return float(c) / len(file1_data)


def bash_diff(std_file_out: str, correct_file_out: str) -> float:
    diff_output1 = subprocess.run(
        ["diff", std_file_out, correct_file_out],
        timeout=5,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    diff_output2 = subprocess.run(
        [
            "diff",
            "--ignore-all-space",
            "--ignore-blank-lines",
            std_file_out,
            correct_file_out,
        ],
        timeout=5,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    if len(diff_output1.stdout.decode()) == 0:
        # all-good
        return 100
    elif len(diff_output2.stdout.decode()) == 0:
        # extra-whitespace
        return 90
    else:
        # non-match
        return 0


if __name__ == "__main__":
    try:
        file1 = sys.argv[1]
        file2 = sys.argv[2]
        results = []
        results.append(seq_match(file1, file2))
        results.append(edit_distance(file1, file2))
        # results.append(bash_biff(file1, file2))
        # results.append(percent_similar(file1, file2))
        # results.append(sorensen_distance(file1, file2))
        # results.append(jaccard_distance(file1, file2))
        print(round((sum(results) / len(results)) * 100))
    except:
        print(0)
