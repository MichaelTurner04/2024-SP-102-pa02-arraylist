cmake_minimum_required(VERSION 3.6)

project(grade.sh LANGUAGES CXX)

# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "../../unit_tests")
file(GLOB unit_tests "../unit_tests/*.cpp")
file(GLOB student_src "../*.cpp")

# Remove the file containing the main() function
list(FILTER student_src EXCLUDE REGEX ".*${MAIN_FILE}$")

foreach(unit_test ${unit_tests})
    get_filename_component(test_name ${unit_test} NAME_WE)
    add_executable(${test_name} ${unit_test} ${student_src})
    target_include_directories(${test_name} PRIVATE "../" "./")
endforeach()