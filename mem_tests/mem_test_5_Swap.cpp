#include "MyVector.h"

int main() {

  MyVector<int> v;

  v.push_back(0);
  v.push_back(1);
  v.push_back(2);

  MyVector<int> v2;

  v2.push_back(3);
  v2.push_back(4);
  v2.push_back(5);

  v.swap(v2);

  return 0;
}