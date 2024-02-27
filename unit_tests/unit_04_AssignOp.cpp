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

    MyVector<int> your_vect, your_copy;
    vector<int> test_vect;
    int x = rand() % 10 + 3;
    for (int k = 0; k < x; k++) {
      int r = rand() % 50;
      your_vect.push_back(r);
    }

    your_copy = your_vect;
    for (int j = 0; j < x; j++) {
      if (your_vect[j] != your_copy[j]) {
        cout << "Your vector's assignment operator function is incorrect. Here "
                "is your "
                "vector and the vector you copied to: "
             << endl;
        cout << "Your vector: < ";
        for (int i = 0; i < your_vect.size() && i < 50; i++) {
          cout << your_vect[i] << ", ";
        }
        cout << ">" << endl << "Copy vector: < ";
        for (int i = 0; i < your_copy.size(); i++) {
          cout << your_copy[i] << ", ";
        }
        cout << ">" << endl;
        return false;
      }
    }

    int y = rand() % 100;
    int z = rand() % x;
    your_vect[x] = y; // is it a deep copy?
    if (your_copy[x] == y) {
      cout << "Your vector's assignment operator function is a shallow copy "
              "(Changes made to the data within the original vector carry over "
              "to the copied vector. This should not happen.)"
           << endl;
      return false;
    }

    return true;
  });
}
