#!/bin/bash

# Clears the screen
tput reset
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
ORANGE=$(tput setaf 202)
RESET=$(tput sgr0)

section() {
    echo -e "\n$BLUE===========================================================================================================================$RESET"
}

subsection() {
    echo -e "\n$YELLOW---------------------------------------------------------------------------------------------------------------------------$RESET"
}

keepgoing() {
    if [ $annoying_nodebug = "d" ]; then
        echo -e "\nPress ""$CYAN""Enter""$RESET"" now to continue."
        read -r
    fi
}

check_hashes() {
    # This should be run before any file students could potentially edit.
    # Assumes you've addded the relevant files to hash_gen.sh
    # usage: check_hashes
    # () creates a subshell, and so no need to cd back
    (
        cd .admin_files
        bash hash_gen.sh
        # cd ..
    )
    if diff .admin_files/hashes.txt .admin_files/grader_hashes.txt &>/dev/null; then
        :
        # echo "Hashes ok"
    else
        section
        echo -e "$RED\nDon't edit any of the auotgrader's files, or you will fail!$RESET"
        echo "Notice the files listed below, with the long hashes in front of them."
        echo -e "Those are the files you broke.\n"
        diff .admin_files/hashes.txt .admin_files/grader_hashes.txt
        echo -e "\nIf you are seeing this, then type:"
        echo "    $ $MAGENTA git log$RESET"
        echo "Then look at the log to find the first four letters of the hash of the instructor's last commit; copy it."
        echo "Then type:"
        echo "    $ $MAGENTA git checkout firstfourlettersofthehashoftheinstructorslastcommit fileorfolderyoubroke $RESET"
        echo -e "You must do this for each file you broke (or just the super-folder of the grader-files), and then re-run grade.sh.\n"
        grade=0
        echo "You edited our stuff, and so you get 0; see the output for details" >"$student_file"
        echo $grade >>"$student_file"
        exit 1
    fi
}
check_hashes

for python_package_name in Levenshtein; do
    if ! python3 -c "import $python_package_name"; then
        echo -e "\npip: Install $package_name using "$MAGENTA""pip3 install --upgrade $python_package_name --user""$RESET" before proceeding, or"
        echo "OpenSuse: Install $package_name using "$MAGENTA""sudo zypper install python3-$python_package_name""$RESET" before proceeding, or"
        echo "Debian: Install $package_name using "$MAGENTA""sudo apt install python3-$python_package_name""$RESET" before proceeding"
        echo -e "    If not found, try lowercase spelling), or"
        echo "Fedora: Install $package_name using "$MAGENTA""sudo dnf install python3-$python_package_name""$RESET" before proceeding."
        exit 1
    fi
done
if [ $language = "python" ]; then
    # Some OS's (OpenSuse) install pudb3 as pudb
    if command -v pudb3 >/dev/null 2>&1; then
        pudb3=pudb3
    else
        pudb3=pudb
    fi
    if ! command -v $pudb3 &>/dev/null; then
        echo "Install pudb3 before proceeding."
        echo "pip3 install pudb --upgrade --user"
        echo "sudo dnf install python3-pudb"
        echo "sudo apt install python3-pudb"
        echo "sudo zypper install python3-pudb"
        exit 1
    fi
    for package_name in mypy black py2cfg; do
        if ! command -v $package_name &>/dev/null; then
            echo Install $package_name before proceeding.
            echo "$MAGENTA""pip3 install --upgrade $package_name --user"
            echo "sudo dnf install $package_name"
            echo "sudo apt install $package_name"
            echo "sudo zypper install $package_name""$RESET"
            exit 1
        fi
    done
fi
if [ $language = "bash" ]; then
    if ! [ -x ./shfmt ]; then
        if ! command -v shfmt &>/dev/null; then
            echo "Install shfmt before proceeding:"
            echo "$MAGENTA""wget -O ~/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.1.2/shfmt_v3.1.2_linux_amd64""$RESET"
            echo "$MAGENTA""chmod +x ~/bin/shfmt""$RESET"
            exit 1
        fi
    fi
    for package_name in shellcheck; do
        if ! command -v $package_name &>/dev/null; then
            echo Install $package_name before proceeding.
            echo "Use your Linux system's package manager (apt/zypper/dnf/etc)."
            exit 1
        fi
    done
fi
if [ $language = "cpp" ]; then
    for package_name in clang-format cmake make cppcheck gdb; do
        if ! command -v $package_name &>/dev/null; then
            echo Install $package_name before proceeding.
            echo "Use your Linux system's package manager (apt/zypper/dnf/etc)."
            exit 1
        fi
    done
fi
if [ $language = "rust" ]; then
    for package_name in rustc gdb; do # TODO rustfmt on containter is not great?
        if ! command -v $package_name &>/dev/null; then
            echo Install $package_name before proceeding.
            echo "Use your Linux system's package manager (apt/zypper/dnf/etc)."
            exit 1
        fi
    done
fi

echo -e "Welcome to grade.sh!\nThis script will mommy you through completing this programming assignment.\n"
echo -e "    $MAGENTA""Magenta""$RESET" is bash/shell commands.
echo -e "    $GREEN""Green""$RESET" is used to indicate a pass.
echo -e "    $RED""Red""$RESET" is used to indicate a fail.
echo -e "    $ORANGE""Orange""$RESET" marks the text of a header for a block of tests of a single type.
echo -e "    $CYAN""Cyan""$RESET" draws your attention to something you have to do.
echo -e "\nActually$CYAN read ALL the output generated by this script!\n$RESET"
echo -e "\nFor this particular assignment:"
if [ "$fuzzy_partial_credit" = false ]; then
    echo "* Diffs are computed rigidly -- no partial credit!"
else
    echo "* Diffs are computed fuzzy -- with partial credit!"
fi
echo "* Each launch of your $main_file code must run in under $process_timeout seconds"
echo -e "\nPress ""$CYAN""Enter""$RESET"" now to continue."
read -r

section
echo "Which of the following modes do you want to run in?"
echo -e "    1) debug+grade mode (d)"
echo -e "    2) grade only mode (g)"
echo "Type 'd' or 'g', then hit ""$CYAN""Enter""$RESET""."
read -r annoying_nodebug
[ -z "$annoying_nodebug" ] && annoying_nodebug="g"

grade_update() {
    # Updates grade and prints, based on the return code of preceeding statement
    # Expects grade for each unit/test to be 0-100
    # Usage: grade_update test_name points_to_add expected_retcode
    return_status=$?
    check_hashes
    echo -e "\nTest for: $1"
    if [ "$return_status" == "$3" ]; then
        if [ "$2" -lt 100 ]; then
            echo "$RED    This test gave you $2 more points$RESET"
        else
            echo "$GREEN    This test gave you $2 more points$RESET"
        fi
        ((grade = grade + "$2"))
    else
        echo "$RED    This test gave you 0 more points$RESET"
    fi
    ((num_tests = num_tests + 1))
}

mem_tests() {

  echo "Memory tests only supported for C++"
}

unit_tests() {
    # Executes a directory of our python unit tests.
    # Assumes they don't neeed any standard input (write a custom line for that).
    # Usage: unit_tests
    if [ "$language" = "cpp" ]; then
        glob_expr="unit_tests/*.cpp"
        pushd .admin_files >/dev/null 2>&1
        mkdir -p build >/dev/null 2>&1
        pushd build >/dev/null 2>&1
	##
	#echo Pre-Compilation check
	cp ../../unit_tests/*.cpp ./ >/dev/null 2>&1
	test_glob="*.cpp"
	cp ../../*.h ./ >/dev/null 2>&1
	cp ../../*.hpp ./
	cp ../test_utils.hpp ./ >/dev/null 2>&1
	for ut in $test_glob; do
		g++ -g $ut
		if [ $? -ne 0 ]; then
			echo $RED $ut unable to compile. Please fix the issues above.
			echo "This unit test will not be scored"
		fi
	done
	rm -f ./*
        ##
	cmake .. -DCMAKE_BUILD_TYPE=Debug -DMAIN_FILE:STRING="$main_file" >/dev/null 2>&1
        make >/dev/null 2>&1
        popd >/dev/null 2>&1
        popd >/dev/null 2>&1
        check_hashes
	#cp .gdbinit .admin_files/build
    elif [ "$language" = "python" ]; then
        glob_expr="unit_tests/*.py"
    elif [ "$language" = "bash" ]; then
        glob_expr="unit_tests/*.sh"
    elif [ "$language" = "rust" ]; then
        glob_expr="unit_tests/*.rs"
        cargo build
    fi
    first="0"
    for testpath in $glob_expr; do
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we will run unit tests.""$RESET"
            [ $annoying_nodebug = 'd' ] && echo "See the ./unit_tests/ folder for more detail."
            first="1"
            keepgoing
        fi
        subsection
        expected_retcode=$(((RANDOM % 250) + 5))
        filename=$(basename "$testpath")
        if [ "$language" = "cpp" ]; then
            testname="$(basename "$filename" .cpp)"
            echo Running command: $ " $MAGENTA"timeout "$process_timeout" ./.admin_files/build/"$testname" "$expected_retcode""$RESET"
            timeout "$process_timeout" ./.admin_files/build/"$testname" "$expected_retcode"
        elif [ "$language" = "python" ]; then
            echo Running command: $ " $MAGENTA"timeout "$process_timeout" python3 unit_tests/"$filename""$RESET"
            timeout "$process_timeout" python3 .admin_files/test_utils.py unit_tests/"$filename" "$expected_retcode"
        elif [ "$language" = "bash" ]; then
            echo Running command: $ " $MAGENTA"timeout "$process_timeout" bash unit_tests/"$filename" "$expected_retcode""$RESET"
            timeout "$process_timeout" bash unit_tests/"$filename" "$expected_retcode"
        elif [ "$language" = "rust" ]; then
            testname="$(basename "$filename" .rs)"
            echo Running command: $ " $MAGENTA"timeout "$process_timeout" ./target/debug/"$testname" "$expected_retcode""$RESET"
            timeout "$process_timeout" ./target/debug/"$testname" "$expected_retcode"
        fi
        # TODO detect return code 0 and warn students not to use exit() ?
        if [ $? -eq "$expected_retcode" ]; then
            grade_update "$filename" 100 0
        else
            grade_update "$filename" 0 0
            # https://stackoverflow.com/questions/20010199/how-to-determine-if-a-process-runs-inside-lxc-docker#20012536
            if [ "$annoying_nodebug" = "g" ] || grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
                :
            else
                if [ "$language" = "cpp" ]; then
                    debug_cmd=(gdb '--eval-command="break main"' '--eval-command="run"' --args ./.admin_files/build/"$testname" 123)
                elif [ "$language" = "python" ]; then
                    debug_cmd=("$pudb3" "$testpath")
                elif [ "$language" = "bash" ]; then
                    debug_cmd=(bash -x "$testpath" 123)
                    # TODO a real bash debugger like bashdb?
                elif [ "$language" = "rust" ]; then
                    debug_cmd=(gdb '--eval-command="break main"' '--eval-command="run"' --args ./target/debug/"$testname" 123)
                fi
                echo -e "\nWe will now launch the debugger as follows:"
                echo -e "$ $MAGENTA" "${debug_cmd[@]}" "$RESET"
                keepgoing
                ${debug_cmd[@]}
            fi
        fi
        check_hashes
    done
}

stdio_tests() {
    # Tests a python script (first and only arg) against directory of std-in/out
    # Saves outputs and diffs
    # Usage: stdio_tests main_file.py

    # For C++, build the student's main()
    if [ "$language" = "cpp" ]; then
        prog_name=("./program" "$main_file_arguments")
        # g++ -Wall -Werror -Wpedantic -g -std=c++14 $1 -o "$prog_name"
        # TODO: Can this be any more discerning, in case of multiple main()s?
        g++ -Wall -Werror -Wpedantic -g -std=c++14 ./*.cpp -o "program"
	if [ $? -ne 0 ]; then
		echo $RED Unable to compile main program, stdio will not be tested
	fi
    elif [ "$language" = "python" ]; then
        prog_name=(python3 "$1" "$main_file_arguments")
    elif [ "$language" = "bash" ]; then
        prog_name=(bash "$1" "$main_file_arguments")
    elif [ "$language" = "rust" ]; then
        prog_name=("./program" "$main_file_arguments")
        cargo build
        mv ./target/debug/program program
    fi

    rm -rf stdio_tests/outputs/*
    rm -rf stdio_tests/goals/.*.swp
    first="0"
    for testpath in stdio_tests/inputs/*.txt; do
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we will run Standard Input/Output (std io) tests.""$RESET"
            [ $annoying_nodebug = 'd' ] && echo "See the ./stdio_tests/ folder for more detail, including diffs."
            first="1"
            keepgoing
        fi
        filename=$(basename "$testpath")
        testname="${filename%_*}"
        subsection
        echo -e "Running command: $ $MAGENTA" timeout "$process_timeout" "${prog_name[@]}" "<$testpath" ">stdio_tests/outputs/$testname"_output.txt"$RESET"
        t0=$(date +%s.%N)
        timeout "$process_timeout" "${prog_name[@]}" <"$testpath" >stdio_tests/outputs/"$testname"_output.txt
        check_hashes
        echo -e "Your main driver program took the following duration of time to run on the above sample:"
        your_time=$(echo "print($(date +%s.%N) - $t0)" | python3)
        echo -e "    $your_time seconds"
        diff -y -W 200 stdio_tests/goals/"$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt >stdio_tests/diffs/"$testname".txt
        vim -d stdio_tests/goals/"$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt \
            -c 'highlight DiffAdd ctermbg=Grey ctermfg=White' \
            -c 'highlight DiffDelete ctermbg=Grey ctermfg=Black' \
            -c 'highlight DiffChange ctermbg=Grey ctermfg=Black' \
            -c 'highlight DiffText ctermbg=DarkGrey ctermfg=White' \
            -c TOhtml \
            -c "w! stdio_tests/diffs/$testname.html" \
            -c 'qa!' >/dev/null 2>&1
        if [ "$fuzzy_partial_credit" = false ]; then
            diff stdio_tests/goals/"$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt >/dev/null 2>&1
            grade_update "$testpath" 100 0
            # Just a useless placeholder here:
            fuzzy_diff=0
        else
            fuzzy_diff=$(python3 .admin_files/fuzzydiffer.py "stdio_tests/goals/$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt)
            grade_update "$testpath" "$fuzzy_diff" 0
        fi
        diff stdio_tests/goals/"$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt >/dev/null 2>&1
        if [ "$?" -eq 0 ] || [ "$fuzzy_diff" -eq 100 ]; then
            # bash's no-op is most clear positive logic here...
            :
        else
            if [ "$annoying_nodebug" = "g" ] || grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
                :
            else
                if [ "$language" = "cpp" ]; then
                    # http://mywiki.wooledge.org/BashFAQ/050
                    debug_cmd=(gdb '--eval-command="break main"' --args "${prog_name[@]}")
                elif [ "$language" = "python" ]; then
                    debug_cmd=("$pudb3" "$1" "$main_file_arguments")
                elif [ "$language" = "bash" ]; then
                    debug_cmd=(bash -x "$1" "$main_file_arguments")
                    # TODO a real bash debugger like bashdb?
                elif [ "$language" = "bash" ]; then
                    debug_cmd=(gdb '--eval-command="break main"' --args "${prog_name[@]}")
                elif [ "$language" = "rust" ]; then
                    debug_cmd=(gdb '--eval-command="break main"' --args "${prog_name[@]}")
                fi
                echo -e "\nWe will now run the following to show you your non-caputred output:\n\t$ $MAGENTA" "${prog_name[@]}" "<$testpath$RESET"
                keepgoing
                echo ">>>>your output>>>>"
                "${prog_name[@]}" <"$testpath"
                check_hashes
                echo "<<<<your output<<<<"
                echo -e "\nWe will now show you the differences between your caputred standard out and the goal."
                echo "Type$MAGENTA esc :qa!$RESET to leave Vim when you are done."
                keepgoing
                # Either meld or vim works, up to you!
                # meld --diff "stdio_tests/goals/$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt &
                vim -d "stdio_tests/goals/$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt \
                    -c 'highlight DiffAdd ctermbg=Grey ctermfg=White' \
                    -c 'highlight DiffDelete ctermbg=Grey ctermfg=Black' \
                    -c 'highlight DiffChange ctermbg=Grey ctermfg=Black' \
                    -c 'highlight DiffText ctermbg=DarkGrey ctermfg=White'
                echo -e "\nWe will now launch the debugger as follows:"
                echo -e "$ $MAGENTA" "${debug_cmd[@]}" "$RESET"
                echo -e "while YOU copy the contents of $ $MAGENTA cat $testpath $RESET by hand"
                keepgoing
                "${debug_cmd[@]}"
                check_hashes
            fi
        fi
    done
    if [ "$language" = "cpp" ] || [ "$language" = "rust" ]; then
        rm -f "${prog_name[@]}"
    fi
}

arg_tests() {
    # Tests a python script (first and only arg) against directory of std-in/out
    # Saves outputs and diffs
    # Usage: arg_tests main_file.py

    # For C++, build the student's main()
    if [ "$language" = "cpp" ]; then
        prog_name=("./program")
        # g++ -Wall -Werror -Wpedantic -g -std=c++14 $1 -o "$prog_name"
        # TODO: Can this be any more discerning, in case of multiple main()s?
        g++ -Wall -Werror -Wpedantic -g -std=c++14 ./*.cpp -o "program"
    elif [ "$language" = "python" ]; then
        prog_name=(python3 "$1")
    elif [ "$language" = "bash" ]; then
        prog_name=(bash "$1")
    elif [ "$language" = "rust" ]; then
        prog_name=("./program")
        cargo build
        mv ./target/debug/program program
    fi

    rm -rf arg_tests/outputs/*
    rm -rf arg_tests/goals/.*.swp
    first="0"
    for testpath in arg_tests/args/*.txt; do
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we will run argument-based tests.""$RESET"
            [ $annoying_nodebug = 'd' ] && echo "See the ./arg_tests/ folder for more detail, including diffs."
            first="1"
            keepgoing
        fi
        filename=$(basename "$testpath")
        testname="${filename%_*}"
        read -ra testargs <"$testpath"
        subsection
        echo -e "Running command: $ $MAGENTA" timeout "$process_timeout" "${prog_name[@]}" "${testargs[@]}" "$RESET"
        t0=$(date +%s.%N)
        timeout "$process_timeout" "${prog_name[@]}" "${testargs[@]}"
        check_hashes
        echo -e "Your main driver program took the following duration of time to run on the above sample:"
        your_time=$(echo "print($(date +%s.%N) - $t0)" | python3)
        echo -e "    $your_time seconds"
        diff -y -W 200 arg_tests/goals/"$testname"_output.txt arg_tests/outputs/"$testname"_output.txt >arg_tests/diffs/"$testname".txt
        vim -d arg_tests/goals/"$testname"_output.txt arg_tests/outputs/"$testname"_output.txt \
            -c 'highlight DiffAdd ctermbg=Grey ctermfg=White' \
            -c 'highlight DiffDelete ctermbg=Grey ctermfg=Black' \
            -c 'highlight DiffChange ctermbg=Grey ctermfg=Black' \
            -c 'highlight DiffText ctermbg=DarkGrey ctermfg=White' \
            -c TOhtml \
            -c "w! arg_tests/diffs/$testname.html" \
            -c 'qa!' >/dev/null 2>&1
        if [ "$fuzzy_partial_credit" = false ]; then
            diff arg_tests/goals/"$testname"_output.txt arg_tests/outputs/"$testname"_output.txt >/dev/null 2>&1
            grade_update "$testpath" 100 0
            # Just a useless placeholder here:
            fuzzy_diff=0
        else
            fuzzy_diff=$(python3 .admin_files/fuzzydiffer.py "arg_tests/goals/$testname"_output.txt arg_tests/outputs/"$testname"_output.txt)
            grade_update "$testpath" "$fuzzy_diff" 0
        fi
        diff stdio_tests/goals/"$testname"_output.txt stdio_tests/outputs/"$testname"_output.txt >/dev/null 2>&1
        if [ "$?" -eq 0 ] || [ "$fuzzy_diff" -eq 100 ]; then
            # bash's no-op is most clear positive logic here...
            :
        else
            if [ "$annoying_nodebug" = "g" ] || grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
                :
            else
                if [ "$language" = "cpp" ]; then
                    # http://mywiki.wooledge.org/BashFAQ/050
                    debug_cmd=(gdb '--eval-command="break main"' --args "${prog_name[@]}" "${testargs[@]}")
                elif [ "$language" = "python" ]; then
                    debug_cmd=("$pudb3" "$1" "${testargs[@]}")
                elif [ "$language" = "bash" ]; then
                    debug_cmd=(bash -x "$1" "${testargs[@]}")
                    # TODO a real bash debugger like bashdb?
                elif [ "$language" = "rust" ]; then
                    debug_cmd=(gdb '--eval-command="break main"' --args "${prog_name[@]}" "${testargs[@]}")
                fi
                echo -e "\nWe will now show you the differences between your argument-based output and ours."
                echo "Type$MAGENTA esc :qa!$RESET to leave Vim when you are done."
                keepgoing
                # Either meld or vim works, up to you!
                # meld --diff "arg_tests/goals/$testname"_output.txt arg_tests/outputs/"$testname"_output.txt &
                vim -d "arg_tests/goals/$testname"_output.txt arg_tests/outputs/"$testname"_output.txt \
                    -c 'highlight DiffAdd ctermbg=Grey ctermfg=White' \
                    -c 'highlight DiffDelete ctermbg=Grey ctermfg=Black' \
                    -c 'highlight DiffChange ctermbg=Grey ctermfg=Black' \
                    -c 'highlight DiffText ctermbg=DarkGrey ctermfg=White'
                echo -e "\nWe will now launch the debugger as follows:"
                echo -e "$ $MAGENTA" "${debug_cmd[@]}" "$RESET"
                keepgoing
                "${debug_cmd[@]}"
                check_hashes
            fi
        fi
    done
    if [ "$language" = "cpp" ] || [ "$language" = "rust" ]; then
        rm -f "${prog_name[@]}"
    fi
}

cfg_tests() {
    # Set the cutoff limit for SVG/DOT diffs. The student still needs to generate a
    # graph reasonably close to the original otherwise it's too easy to hardcode
    # solutions
    fuzzy_cutoff=60

    # Tests that student implemented py files for each cfg_tests/*.svg file
    # Usage: cfg_tests

    # For C++, build the student's main()
    if [ "$language" = "cpp" ]; then
        :
        # TODO which cfg generator to use?
    elif [ "$language" = "python" ]; then
        cfg_generator=py2cfg
    elif [ "$language" = "bash" ]; then
        :
        # TODO Probably no cfg generator exists, or will?
    fi

    first="0"
    for testpath in cfg_tests/goals/*.txt; do
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we will run control-flow-graph based tests.""$RESET"
            [ $annoying_nodebug = 'd' ] && echo "See the ./cfg_tests/ folder for more detail."
            first="1"
            keepgoing
            rm -rf *.svg
        fi
        subsection

        filename=$(basename $testpath)
        filename="${filename%.*}"

        echo "Running command: $ $MAGENTA $cfg_generator ${filename}.py --diffable cfg_tests/outputs/${filename}.txt$RESET"
        $cfg_generator ${filename}.py --diffable cfg_tests/outputs/${filename}.txt

        if diff "cfg_tests/outputs/${filename}.txt" "./$testpath" &>/dev/null; then
            fuzzy_diff=$(python3 .admin_files/fuzzydiffer.py ${filename}_cfg.svg cfg_tests/goal_cfgs/${filename}_cfg.svg)
            if (("$fuzzy_diff" < "$fuzzy_cutoff")); then
                grade_update "Your code CFG match with $testpath test" 0 0
            else
                echo "" >/dev/null
                grade_update "Your code CFG match with $testpath test" 100 0
            fi
        else
            grade_update "Your code CFG match with $testpath test" 0 0
            # https://stackoverflow.com/questions/20010199/how-to-determine-if-a-process-runs-inside-lxc-docker#20012536
            if [ "$annoying_nodebug" = "g" ] || grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
                :
            else
                if [ "$language" = "cpp" ]; then
                    :
                    # TODO
                elif [ "$language" = "python" ]; then
                    # TODO what if the file had args?
                    debug_cmd=("$cfg_generator" "${filename}.py" "--debug")
                elif [ "$language" = "bash" ]; then
                    :
                    # TODO
                elif [ "$language" = "rust" ]; then
                    :
                    # TODO
                fi
                echo -e "\nWe will now launch the debugger as follows:"
                echo -e "$ $MAGENTA" "${debug_cmd[@]}" "$RESET"
                keepgoing
                "${debug_cmd[@]}"
            fi
        fi
    done
}

doctest_tests() {
    # Tests that student implemented py files for each cfg_tests/*.svg file
    # Usage: cfg_tests

    # For C++, build the student's main()
    if [ "$language" = "cpp" ]; then
        :
        doctest_string="junk"
        # TODO are there any doctest options for cpp?
    elif [ "$language" = "python" ]; then
        doctest_string="doctest.testmod"
        doctest_command="python3 -m doctest -v $1"
    elif [ "$language" = "bash" ]; then
        :
        doctest_string="junk"
        # likely these exist for bash
    fi
    if grep "$doctest_string" "$1" &>/dev/null; then
        section
        echo "$ORANGE""Below here, we will run doctest based tests.""$RESET"
        [ $annoying_nodebug = 'd' ] && echo "See the function docstring in $1 itself for more detail."
        keepgoing

        echo "Running command: $ $MAGENTA $doctest_command $RESET"
        if $doctest_command &>/dev/null; then
            grade_update "Doctests in function docstring" 100 0
        else
            grade_update "Doctests in function docstring" 0 0
            # https://stackoverflow.com/questions/20010199/how-to-determine-if-a-process-runs-inside-lxc-docker#20012536
            if [ "$annoying_nodebug" = "g" ] || grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
                :
            else
                if [ "$language" = "cpp" ]; then
                    :
                    # TODO
                elif [ "$language" = "python" ]; then
                    $doctest_command
                    debug_cmd=("$pudb3" "$1" "$main_file_arguments")
                elif [ "$language" = "bash" ]; then
                    :
                    # TODO
                elif [ "$language" = "rust" ]; then
                    :
                    # TODO
                fi
                echo -e "\nWe will now launch the debugger as follows:"
                echo -e "$ $MAGENTA" "${debug_cmd[@]}" "$RESET"
                keepgoing
                "${debug_cmd[@]}"
            fi
        fi
    fi
}

files_exist() {
    # https://stackoverflow.com/questions/4069188/how-to-pass-an-associative-array-as-argument-to-a-function-in-bash
    # https://stackoverflow.com/questions/3112687/how-to-iterate-over-associative-arrays-in-bash
    local -n arr=$1
    first="0"
    for exist_file in "${!arr[@]}"; do
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we will run tests for existence of files and their type data:""$RESET"
            first="1"
            keepgoing
        fi
        subsection
        echo -e "Checking for the existence of '$exist_file' and its containing type of data:" "'${arr["$exist_file"]}.'"
        [ -f "$exist_file" ] && file "$exist_file" | grep "${arr["$exist_file"]}" >/dev/null 2>&1
        grade_update \""$exist_file\" with type containing \"${arr["$exist_file"]}\" existed" 100 0
    done
}

######## Init -> ########
num_tests=0
grade=0
check_hashes

if [ ! "$(uname)" = Linux ]; then
    echo "Run this on a Linux platform!"
    exit 1
fi

if ! [ "$annoying_nodebug" = "g" ] && ! grep 'docker\|lxc' /proc/1/cgroup >/dev/null 2>&1; then
    if [ "$language" = "cpp" ]; then
        :
        # TODO Find a good C++ flowchart generator and run here
    elif [ "$language" = "python" ]; then
        section
        echo You may find the following Control Flow Graphs helpful in thinking about your code:
        for pyfile in *.py; do
            py2cfg "$pyfile"
        done
        ls ./*.svg
        echo -e "\nDo you want to show the control flow graphs for your code?"
        echo "Type y or n, then$CYAN Enter.$RESET"
        read -r cfg_open
        [ -z "$cfg_open" ] && cfg_open="n"
        if [ "$cfg_open" = "y" ]; then
            for svgfile in ./*.svg; do
                xdg-open "$svgfile"
            done
        fi
    elif [ "$language" = "bash" ]; then
        :
        # TODO A flowchart generator for bash does not likely exist...
    elif [ "$language" = "rust" ]; then
        :
        # TODO a flowchart generator?
    fi
fi
######## <- Init ########

######## Standard tests -> ########
shopt -s nullglob
unit_tests
stdio_tests "$main_file"
arg_tests "$main_file"
doctest_tests "$main_file"
cfg_tests
files_exist file_arr
shopt -u nullglob
######## <- Standard tests ########

######## Memory tests -> ########

if [ "$enable_memory_tests" = true ]; then

  if ! command -v valgrind &>/dev/null; then
    echo Install valgrind before proceeding.
    echo "Use your Linux system's package manager (apt/zypper/dnf/etc)."
    exit 1
  fi

  has_valgreen=true
  if ! command -v valgreen &>/dev/null; then
    echo Install valgreen to receive cleaner feedback.
    echo For Debian:
    echo "sudo apt install pipx ; pipx ensurepath ; pipx install valgreen"
    has_valgreen=false
  fi



  if [ "$language" = "cpp" ]; then
    glob_expr="./*.cpp"
    pushd mem_tests >/dev/null 2>&1
    mkdir build >/dev/null 2>&1
    cp ../*.h build  # Copy any header files
    cp ../*.hpp build
    cp ./*.cpp build # Copy tests
    pushd build >/dev/null 2>&1
    for testpath in $glob_expr; do
      testname=$(basename "$testpath" .cpp)
      g++ -g $(basename "$testpath") -o "$testname"
    done
    popd >/dev/null 2>&1
    popd >/dev/null 2>&1
    glob_expr="mem_tests/*.cpp"
    first="0"
    for testpath in $glob_expr; do
      if [ $first = "0" ]; then
        section
        echo "$ORANGE""Below here, we will run memory tests.""$RESET"
        first=1
        keepgoing
      fi
      subsection
      filename="$(basename $testpath)"
      testname="$(basename $testpath .cpp)"
      #echo Running command:
      timeout "$process_timeout" valgrind --leak-check=full --track-origins=yes --show-reachable=yes --error-exitcode=1 ./mem_tests/build/"$testname" >valgrind.out 2>valgrind.err
      if [ $? -eq 0 ]; then
            grade_update "$filename" 100 0
      else
            grade_update "$filename" 0 0
            if [ $has_valgreen = true ]; then
                valgreen ./mem_tests/build/"$testname"
            else
		cat valgrind.out
		cat valgrind.err
	    fi
      fi
    done
    rm -rf mem_tests/build #clean up
    rm valgrind.out valgrind.err
  else
    echo "Memory tests only supported for C++"
  fi
fi
######## <- Memory tests ########

######## Static analysis -> ########
if [ "$enable_static_analysis" = true ]; then
    section
    echo -e "$ORANGE""Below here, we present suggestions from automatic static analysis:""$RESET"
    keepgoing
    subsection
    if [ "$language" = "cpp" ]; then
        echo "Running command: $" "$MAGENTA cppcheck --enable=all --error-exitcode=1 --language=c++ ./*.cpp ./*.h ./*.hpp$RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA man cppcheck$RESET and $ $MAGENTA cppcheck --help$RESET for more detail.\n"
        cppcheck --enable=all --suppress=missingIncludeSystem --suppress=unusedFunction --suppress=noExplicitConstructor --error-exitcode=1 --language=c++ ./*.cpp ./*.h ./*.hpp
    elif [ "$language" = "python" ]; then
        echo "Running command: $" "$MAGENTA mypy --strict --disallow-any-explicit ./*.py$RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA man mypy$RESET and $ $MAGENTA mypy --help$RESET for more detail.\n"
        mypy --strict --disallow-any-explicit ./*.py
    elif [ "$language" = "bash" ]; then
        echo "Running command: $" "$MAGENTA shellcheck --check-sourced --external-sources $main_file $RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA man shellcheck$RESET and $ $MAGENTA shellcheck --help$RESET for more detail.\n"
        shellcheck --check-sourced --external-sources "$main_file"
    elif [ "$language" = "rust" ]; then
        :
        # cargo check
        # This is just basically the first step of compilation by cargo run...
        # Is there any more deep check? I doubt it...
    fi
#    grade_update "static analysis / typechecking" 100 0
fi
######## <- Static analysis ########

######## Format check -> ########
if [ "$enable_format_check" = true ]; then
    section
    echo -e "$ORANGE""Below here, we present suggestions about automatic code formatting style:""$RESET"
    keepgoing
    subsection
    shopt -s nullglob
    if [ "$language" = "cpp" ]; then
        echo "Running command: $" "$MAGENTA python3 .admin_files/run-clang-format.py -r --style=LLVM --exclude './.admin_files/build/*' .$RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA"" clang-format --help$RESET for more detail.\n"
        python3 .admin_files/run-clang-format.py -r --style=LLVM --exclude './.admin_files/build/*' .
        # CI needed this script instead of local command?
        # clang-format --dry-run --Werror --style=Microsoft *.cpp *.h *.hpp
    elif [ "$language" = "python" ]; then
        echo "Running command: $" "$MAGENTA black --check ./*.py$RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA man black$RESET and $ $MAGENTA black --help$RESET for more detail."
        [ $annoying_nodebug = 'd' ] && echo -e "If you are passing locally, but not on the server, or vice-versa, check: $MAGENTA black --version$RESET\n"
        black --check ./*.py
    elif [ "$language" = "bash" ]; then
        echo "Running command: $" "$MAGENTA shfmt -i 4 -d .$RESET"
        # https://www.arachnoid.com/linux/beautify_bash/
        # https://github.com/mvdan/sh#shfmt
        # Format dir with: ./go/bin/shfmt -i 4 -w .
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA"" shfmt --help$RESET for more detail.\n"
        if [ -x ./shfmt ]; then
            ./shfmt -i 4 -d .
        elif command -v shfmt >/dev/null 2>&1; then
            shfmt -i 4 -d .
        else
            echo "Install shfmt to run the Bash format check!"
            (exit 1)
        fi
    elif [ "$language" = "rust" ]; then
        echo "Running command: $" "$MAGENTA rustfmt --check ./src/*.rs$RESET"
        [ $annoying_nodebug = 'd' ] && echo -e "\nSee $ ""$MAGENTA rustfmt --help$RESET for more detail."
        if command -v rustfmt >/dev/null 2>&1; then
            rustfmt --check ./src/*.rs
        elif [ -x ./.admin_files/rustfmt ]; then
            ./.admin_files/rustfmt --check ./src/*.rs
        else
            echo "Install rustfmt to run the rust format check!"
            (exit 1)
        fi
    fi
    grade_update "auto-format style check" 100 0
    shopt -u nullglob
fi
######## <- Format check ########

######## Variable custom tests -> ########
first="0"
for func in $(compgen -A function); do
    if grep -q "^custom_test" - <<<"$func"; then
        if [ $first = "0" ]; then
            section
            echo "$ORANGE""Below here, we present custom tests.""$RESET"
            echo "If you want to see what's happening in the custom tests,"
            echo "then read the tests themselves at the bottom of the grade.sh file."
            first="1"
            keepgoing
        fi
        custom_test_score=-1
        check_hashes
        subsection
        echo "* Doing custom test: $func"
        $func
        check_hashes
        if [ "$custom_test_score" -ne "-1" ]; then
            grade_update "$func" "$custom_test_score" 0
        fi
    fi
done
######## <- Variable custom tests ########

######## Cleanup -> ########
rm -rf __pycache__
rm -rf .admin_files/__pycache__
rm -rf .admin_files/build
rm -rf .mypy_cache
rm -rf unit_tests/.mypy_cache
rm -rf mem_tests/build #testing in progress
######## <- Cleanup ########

######## Reporting and grading -> ########
grade=$(echo "print(int($grade / $num_tests))" | python3)
echo -e "Your total grade is:\n$grade" >$student_file
section
cat $student_file
if [ -f student_git_pass_threshold.txt ]; then
    pass_threshold=$(cat student_git_pass_threshold.txt)
    check_hashes
else
    pass_threshold=70
fi
notdone=$(python3 -c "print($grade < $pass_threshold)")
check_hashes
perfect=$(python3 -c "print($grade == 100)")
echo -e "\n"$CYAN"The last step is to push your changes to git-classes:"
echo -e "    Make sure the CI passes, turns green, and you inspect the job itself for your grade."
echo -e "    Your repo will turn green with a grade of $pass_threshold (set in student_git_pass_threshold.txt)."
echo -e "    Actually look at the Gitlab CI details to see what we think your current grade is."
echo -e "    Unless you see the output and numerical grade above on Gitlab, do not assume you are done!\n""$RESET"
if [ "$notdone" == "True" ]; then
    echo -e "$RED\nYou're not passing yet.$RESET"
    echo -e "To see why, run this script in debug mode!\n"
    exit 1
else
    if [ "$perfect" == "True" ]; then
        echo -e "$GREEN\nIt's perfect. Congratulations!\n$RESET"
    else
        echo -e "$GREEN\nYou're passing; decide how much you want the extra points!\n$RESET"
    fi
    exit 0
fi
######## <- Reporting and grading ########
