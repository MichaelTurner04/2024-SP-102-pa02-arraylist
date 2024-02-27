/*
Background reading:

General container library
http://en.cppreference.com/w/cpp/container

Vector
http://en.cppreference.com/w/cpp/container/MyVector
(This wiki the most “official”, but still unofficial, source of C++ knowledge
for end-programmers)

http://www.cplusplus.com/reference/MyVector/MyVector/
(This may also help, but if these links differ, go with en.cppreference.com
instead)

Overloading operator syntax
https://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B
*/

#include "MyVector.h"
#include <iostream>
#include <string>

using namespace std;

void add(MyVector<string> &theVector, const string &jobTitle, int timeSlot);
void fire(MyVector<string> &theVector, const string &jobTtile);
void fire(MyVector<string> &theVector, int timeSlot);
void sleepIn(MyVector<string> &theVector, int time);
void carCrash(MyVector<string> &theVector, int timeSlot);
void disease(MyVector<string> &theVector);
void guilt(MyVector<string> &theVector);

void output(MyVector<string> &theVector, int numADD, int numFIRE, int numSLEPT, int numCRASH, int numDISEASE, int numGUILT, int numAUDIT, int foundAUDIT);

int main() {
  MyVector<string> schedule;
  string startingScheduleLine;
  getline(cin, startingScheduleLine);
  string startingJob;
  bool endOfLine = false;

  while (!endOfLine) {
    int find = startingScheduleLine.find(',');
    if (find > -1) {
      startingJob = startingScheduleLine.substr(0, find);
      startingJob = startingJob.substr(1);
      startingJob.pop_back();
      schedule.push_back(startingJob);
      startingScheduleLine = startingScheduleLine.substr(find + 2);
    } else {
      startingJob = startingScheduleLine;
      startingJob = startingJob.substr(1);
      startingJob.pop_back();
      schedule.push_back(startingJob);
      endOfLine = true;
    }
  }

  string func = "";
  int numADD = 0, numFIRE = 0, numSLEPT = 0, numCRASH = 0, numDISEASE = 0,
      numGUILT = 0, numAUDIT = 0;
  int foundAUDIT = 0;

  while (getline(cin, func) && func != "") {

    if (func.substr(0, 3) == "ADD") {
      string jobTitle;
      int timeSlot;
      string afterADD = func.substr(4);
      jobTitle = afterADD.substr(1, afterADD.find_last_of('"') - 1);
      timeSlot = stoi(afterADD.substr(afterADD.find_last_of('"') + 2));

      numADD++;

      add(schedule, jobTitle, timeSlot);
    } else if (func.substr(0, 4) == "FIRE") {
      if (func.find('"') != func.npos) {
        string jobNoQuotes;
        jobNoQuotes = func.substr(6);
        jobNoQuotes.pop_back();

        fire(schedule, jobNoQuotes);
      } else {
        int timeInt = stoi(func.substr(5));
        fire(schedule, timeInt);
      }
      numFIRE++;
    } else if (func.substr(0, 8) == "SLEPT_IN") {
      int time;
      time = stoi(func.substr(9));
      sleepIn(schedule, time);
      numSLEPT++;
    } else if (func.substr(0, 9) == "CAR_CRASH") {
      int time;
      time = stoi(func.substr(10));
      carCrash(schedule, time);
      numCRASH++;
    } else if (func.substr(0, 7) == "DISEASE") {
      disease(schedule);
      numDISEASE++;
    } else if (func.substr(0, 5) == "GUILT") {
      guilt(schedule);
      numGUILT++;
    } else if (func.substr(0, 5) == "AUDIT") {
      numAUDIT++;
      string jobNoQuotes;
      jobNoQuotes = func.substr(7);
      jobNoQuotes.pop_back();
      if (schedule.find(jobNoQuotes) != -1) {
        foundAUDIT++;
      }
    } else {
      string lost;
      getline(cin, lost);
      cout << "Unrecognized input. Please try again." << endl;
    }
  }

  output(schedule, numADD, numFIRE, numSLEPT, numCRASH, numDISEASE, numGUILT, numAUDIT, foundAUDIT);
  
  return 0;
}

void output(MyVector<string> &schedule, int numADD, int numFIRE, int numSLEPT, int numCRASH, int numDISEASE, int numGUILT, int numAUDIT, int foundAUDIT)
{
  cout << "William has successfully dodged eviction!" << endl << endl;
  cout << numADD << " Shifts Added" << endl;
  cout << numFIRE << " Shifts Fired From" << endl;
  cout << numSLEPT << " Times Slept In" << endl;
  cout << numCRASH << " Car Crashes" << endl;
  cout << numDISEASE << " Diseases Caught" << endl;
  cout << numGUILT << " Times Recycled" << endl;
  cout << numAUDIT << " Times Audited" << endl << endl;
  cout << "William's Final Schedule:" << endl << schedule << endl << endl;
  cout << "Schedule Capacity: " << schedule.capacity() << endl << endl;
  cout << "Audit:" << endl;
  cout << "Found job in schedule: " << foundAUDIT << endl;
  cout << "Didn't find job in schedule: " << numAUDIT - foundAUDIT << endl;
}

/*
YOU MAY USE THE SUGGESTED FUNCTIONS BELOW
	OR ADD YOUR OWN AND EDIT THE MAIN ABOVE
*/


// add function - Inserts job in the given time slot
// If timeslot >= len of MyVector is passed,
// job is appended to the end.
void add(MyVector<string> &theVector, const string &jobTitle, int timeSlot) {

}

// If he is fired from a specific job, it goes
// through his schedule from back to front,
// erasing each instance of that job from his schedule
void fire(MyVector<string> &theVector, const string &jobTtile) {

}

// If will is fired from a job in a specific time slot
// it deletes that time slot from his schedule
void fire(MyVector<string> &theVector, int timeSlot) {

}

// Perform the "Sleep in" event
void sleepIn(MyVector<string> &theVector, int time) {

}

// Perform the "Car crash" event
void carCrash(MyVector<string> &theVector, int timeSlot) {

}

// Perform the "Disease" event
void disease(MyVector<string> &theVector) {  }

// Perform the "Guilt" event
void guilt(MyVector<string> &theVector) {  }
