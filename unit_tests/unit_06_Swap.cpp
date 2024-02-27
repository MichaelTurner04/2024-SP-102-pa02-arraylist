#include "MyVector.h"
#include "test_utils.hpp"
#include <ctime>
#include <stdlib.h>
#include <vector>

int main(const int argc, const char **argv) {
  return test_wrapper(argc, argv, []() {
    time_t seed;
    srand(time(&seed));

    MyVector<int> your_vect, your_other_vect;
    std::vector<int> test_vect, test_other_vect;

    int x = rand() % 5 + 3;
    for (int k = 0; k < x; k++) {
      int rand_int = rand() % 100;
      your_vect.push_back(rand_int);
      test_vect.push_back(rand_int);
    }

    int y = rand() % 10 + 16;
    for (int k = 0; k < y; k++) {
      int rand_int = rand() % 100;
      your_other_vect.push_back(rand_int);
      test_other_vect.push_back(rand_int);
    }

    your_vect.swap(your_other_vect);
    test_vect.swap(test_other_vect);

    // checking size/capacity
    if (your_vect.size() != test_vect.size()) {
      cout << "Your vector's swap function does not swap the size of swapped "
              "vectors."
           << endl;
      return false;
    }

    if (your_vect.capacity() != test_vect.capacity()) {
      cout << "Your vector's swap function does not swap the capacity of "
              "swapped vectors."
           << endl;
      return false;
    }

    // checking contents
    auto test_iter = test_vect.begin();
    for (int k = 0; k < y; k++) {
      if (your_vect[k] != *test_iter++) {
        cout << "Your vector's swap function is incorrect. Here is your "
                "vector and the goal (correct) vector: "
             << endl;
        cout << "Your vector: < ";
        for (int i = 0; i < your_vect.size() && i < 50; i++) {
          cout << your_vect[i] << ", ";
        }
        cout << ">" << endl << "Goal vector: < ";
        for (int i = 0; i < test_vect.size(); i++) {
          cout << test_vect[i] << ", ";
        }
        cout << ">" << endl;
        return false;
      }
    }

    test_iter = test_other_vect.begin();
    for (int k = 0; k < x; k++) {
      if (your_other_vect[k] != *test_iter++) {
        cout << "Your vector's swap function is incorrect. Here is your "
                "vector and the goal (correct) vector: "
             << endl;
        cout << "Your vector: < ";
        for (int i = 0; i < your_other_vect.size() && i < 50; i++) {
          cout << your_other_vect[i] << ", ";
        }
        cout << ">" << endl << "Goal vector: < ";
        for (int i = 0; i < test_other_vect.size(); i++) {
          cout << test_other_vect[i] << ", ";
        }
        cout << ">" << endl;
        return false;
      }
    }

    return true;
  });
}
