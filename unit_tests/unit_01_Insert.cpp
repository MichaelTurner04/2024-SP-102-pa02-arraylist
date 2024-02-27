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

    MyVector<int> your_vect;
    vector<int> test_vect;
    int x = rand() % 10 + 6;

    for (int k = 0; k < x; k++) {
      int r = rand() % 50;
      your_vect.push_back(r);
      test_vect.push_back(r);
    }

    for (int i = 0; i < 3; i++) {
      int y = rand() % (x + i);
      int z = rand() % 100;
      your_vect.insert(your_vect.begin() + y, z);
      test_vect.insert(test_vect.begin() + y, z);
    }

    for (int j = 0; j < test_vect.size(); j++) {
      if (your_vect[j] != test_vect[j]) {
        cout << "Your vector's insert function is incorrect. Here is your "
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

    return true;
  });
}
