#include "MyVector.h"

int main() {

  MyVector<int> v;

  v.push_back(0);
  v.push_back(1);
  v.push_back(2);

  v.shrink_to_fit();

  return 0;
}