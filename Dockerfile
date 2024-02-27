FROM fedora:latest

RUN dnf install -y file python3-pip python3-devel gcc diffutils ncurses gdb cppcheck clang-tools-extra cmake make fish tmux ranger vim-X11 git g++ nano python3-Levenshtein valgrind
RUN pip3 install valgreen
# RUN useradd -m student
# USER student
# WORKDIR /home/student
