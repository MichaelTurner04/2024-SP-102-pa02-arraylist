#include "MyVector.h"
#include "test_utils.hpp"
#include <ctime>
#include <stdlib.h>
#include <vector>
using std::vector;

int main(const int argc, const char **argv) {
  return test_wrapper(argc, argv, []() {
    time_t seed;
    srand(time(&seed));

    MyVector<char> your_vect;
    vector<char> test_vect;
    int r = rand() % 20 + 10;
    for (int k = 0; k < r; k++) {
      your_vect.push_back('a');
      test_vect.push_back('a');
    }

    your_vect.clear();
    test_vect.clear();

    if (your_vect.size() != test_vect.size()) {
      cout << "Your vector's size is incorrect after using the clear function. "
              "Current size: "
           << your_vect.size() << " | Should be: " << test_vect.size() << endl;
      return false;
    }
    if (your_vect.capacity() != test_vect.capacity()) {
      cout << "Your vector's capacity is incorrect after using the clear "
              "function. Current capacity: "
           << your_vect.capacity() << " | Should be: " << test_vect.capacity()
           << endl;
      return false;
    }

    return true;
  });
}
