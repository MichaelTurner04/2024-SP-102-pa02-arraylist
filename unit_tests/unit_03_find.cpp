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

    int r;
    int x = rand() % 10 + 5;
    for (int k = 0; k < x; k++) {
      r = rand() % 200 + 100;
      your_vect.push_back(r);
    }

    int b = your_vect.find(r);
    if (your_vect[b] != r) {
      cout << "Your vector's find function is incorrect. Your vector found "
           << r << " at position " << b
           << ", when position b in your vector holds " << your_vect[b] << endl
           << "Your vector: < ";
      for (int i = 0; i < your_vect.size() && i < 50; i++) {
        cout << your_vect[i] << ", ";
      }
      cout << ">" << endl;
      return false;
    }

    int y = rand() % 100;
    int a = your_vect.find(y);
    if (your_vect.find(y) != -1) {
      cout << "Your vector's find function returned a valid index when it "
              "should have "
              "returned -1. Trying to find: "
           << y << endl
           << "Your vector: < ";
      for (int i = 0; i < your_vect.size() && i < 50; i++) {
        cout << your_vect[i] << ", ";
      }
      cout << ">" << endl;
      return false;
    }

    return true;
  });
}
