FROM python:3.8.5-slim-buster

RUN apt-get update

# C++ tools
RUN apt-get install -y --no-install-recommends g++ cppcheck clang-format cmake make

# Python tools
RUN pip3 install python-Levenshtein mypy black