#include "MyVector.h"

int main() {

  MyVector<int> v;

  v.push_back(0);
  v.push_back(1);
  v.push_back(2);

  MyVector<int> v2 = v;

  return 0;
}