#!/bin/bash

# Run this file whenever you make changes to the grader code,
# especially just before assignment release.
# To prevent cheating the autograder,
# this `setup.sh`should be run once before launching the assignment,
# and, assigner auto-upload gpg signed commits should be used (in conjunction).
# .admin_files/ should be included in the student repo.
#
# To prevent hacking of unit tests by students,
# we MUST make sure they did not modify the grader files.

# Even all this does not protect against editing the grade.sh while it is running?
# To protect against such an attack, containerizing any single line calling their code with the minimal files given to it helps.
# <https://stackoverflow.com/questions/4249063/run-an-untrusted-c-program-in-a-sandbox-in-linux-that-prevents-it-from-opening-f>
# https://firejail.wordpress.com/

bash hash_gen.sh
cp hashes.txt grader_hashes.txt
