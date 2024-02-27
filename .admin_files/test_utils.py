#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import importlib

# python3 seemingly respects only abspaths, while ipython3 is ok with relative, like '..' here.
# Temporarily add the current path to the system path for importing the student's source code,
# and unit tests
sys.path.append(
    os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "unit_tests"
    )
)


def test_wrapper() -> None:
    return_code = int(sys.argv[2])
    sys.argv[2] = "nice try..."
    try:
        module = os.path.splitext(os.path.basename(sys.argv[1]))[0]
        importlib.import_module(module)
    except Exception as e:
        raise e
    sys.exit(return_code)


test_wrapper()
