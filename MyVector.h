/*
 * Simplified version of the std::vector
 * This is your h file. Do not edit it!
 * If you edit it, you risk getting a 0.
 * To see the function specifications in more detail, check en.cppreference!
 * Make sure to test your vector with multiple types: (e.g., int, char, long,
 * etc.)
 */

#ifndef MYVECTOR_H
#define MYVECTOR_H

#include <iostream>
#include <stdexcept>
#include <string>

using std::cerr;
using std::cin;
using std::cout;
using std::endl;
using std::string;

class ArrayListIterator {
  int index;

public:
  ArrayListIterator(int i) : index(i) {}
  operator int() {
    return index;
  } // allows Iterator to be used like an int/index
  ArrayListIterator operator+(int increment) {
    index += increment;
    return *this;
  } // allows +/++
  bool operator>(int comp) { return index > comp; }
  bool operator<(int comp) { return index < comp; }
};

template <typename T> class MyVector {
private:
  T *data = nullptr;
  int max_elements;
  int num_elements;

public:
  // Should default array pointer to nullptr, and do all the stuff a constructor
  // does. Just a simple default constructor.
  MyVector() : max_elements(4), num_elements(0) { data = new T[4]; }

  ~MyVector();

  // Make sure this does a deep copy.
  const MyVector<T> &operator=(const MyVector<T> &source);

  // Make sure this does a deep copy
  MyVector(const MyVector<T> &source);

  // Returns the element of the array by reference, so it can be read or
  // written.
  T &operator[](int index);

  // Purpose: Returns the element stored at the index by reference
  // Parameters: index - The location of the element to be returned.
  // This one should throw an std::out_of_range exception when out-of-bounds
  T &at(int index);

  // Purpose: Returns the element stored at the front of the vector
  T &front();

  // Purpose: Returns the element stored at the back of the vector
  T &back();

  // Purpose: Returns the maximum number of elements that can be stored in the
  // current Vector
  int capacity();

  // Purpose: Ensures that there is enough room for a specific number of
  // elements Parameters: new_cap - The amount of space to be reserved in the
  // array. Postconditions: Increases max_size to new_cap if new_cap > max_size
  // Other functions should check that their operations are not going beyond the
  // size limit, and call this one if so By default, you should double the size
  // of the current array when it fills up. NOTE: reserve does not do the
  // checking of whether it's full; another function should do that, and then
  // call reserve, which just adjusts the size to whatever it is called with,
  // only if it is greater than current. Inital size is 0, so a special case is
  // needed to grow to 1, then 2, 4, etc., which is handled in another function
  // (like push_back for example).
  void reserve(int new_max_elements);

  // This function should shrink the array list to where max_elements =
  // num_elements i.e. capacity is equal to the number of elements in the array
  // list.
  void shrink_to_fit();

  // Purpose: Clears the MyVector
  // Postconditions: current size set to 0, storage size remains the same.
  void clear();

  // Purpose: appends the value x to the end of an MyVector. If the array list
  // is currently at full capacity, double the capacity. If capacity is
  // currently at 0, set the capacity using the reserve function to 1.
  // Parameters: x is value to be added to MyVector
  // Postconditions: current size is incremented by 1
  //     If the number of elements have increased over capacity, the storage
  //     array is grown.
  void push_back(const T &value);

  // Removes the last element of the vector
  void pop_back();

  // Purpose: inserts the value x at the position i
  //     (before the value currently at i) in the  MyVector. If the array list
  //     is currently at full capacity, double the capacity. If capacity is
  //     currently at 0, set the capacity using the reserve function to 1.
  // Parameters: x is value to be added to MyVector
  //             i is the position to insert x at
  // Postconditions: current size is incremented by 1
  //     If the number of elements have increased over capacity, the storage
  //     array is grown.
  void insert(ArrayListIterator position, const T &value);

  // Purpose: Removes the element at index i in the array
  // Parameters: i, the index of the element to remove
  // Postconditions: if the size of the list is greater than 0
  //     size is decremented by one.
  void erase(ArrayListIterator position);

  // Returns the size of the actual data stored in the array list
  // Remember, with indexing at 0, this is 1 more than the last elements
  // position index
  int size();

  // Purpose: returns the index position of value if it is found in the
  // array list, returns -1 otherwise
  int find(const T &value);

  // Purpose: exchanges the contents and capacity of two array lists
  // Parameters: other, the array list to exchange with the calling object
  // Postconditions: data points to the storage array previously belonging to
  // other num_elements and max_elements adjusted accordingly similarly, other
  // now stores the data from the calling object OPERATE ONLY ON "data",
  // individual elements remain untouched
  void swap(MyVector &other);

  ArrayListIterator begin() { return ArrayListIterator(0); }
  ArrayListIterator end() { return ArrayListIterator(num_elements); }
};

// We're giving you this one.
// This relies on you having implemented the .at() and .size() member functions
// first. It may be a good idea to get those working, so you can test with this.
template <typename T>
std::ostream &operator<<(std::ostream &out, MyVector<T> &my_list) {
  out << "[ ";

  for (int i = 0; i < my_list.size(); i++) {
    out << my_list.at(i) << ", ";
  }

  out << "]";

  return out;
}

#include "MyVector.hpp"

#endif
