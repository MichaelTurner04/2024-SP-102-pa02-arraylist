#ifndef TEST_UTILS_H
#define TEST_UTILS_H

#include <exception>
#include <iostream>
#include <stdexcept>
#include <string>

template <typename Test>
int test_wrapper(const int argc, const char **argv, Test &&test) {
  if (argc < 2) {
    throw std::invalid_argument(
        "Must pass desired returncode as commandline argument");
  }
  const int desired_retcode = std::stoi(argv[1]);
  bool result = false;
  try {
    result = test();
  } catch (std::exception &e) {
    std::cerr << e.what() << std::endl;
  } catch (...) {
    std::cerr << "An exception of unknown type was thrown" << std::endl;
  }
  return result ? desired_retcode : 1;
}

#endif
