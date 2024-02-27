#include "MyVector.h"

int main() {

  MyVector<int> v;

  v.push_back(0);
  v.push_back(1);
  v.push_back(2);

  ArrayListIterator it = v.begin() + 1;
  v.erase(it);

  return 0;
}