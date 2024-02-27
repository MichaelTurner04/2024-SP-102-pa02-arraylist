_Weary William the Workful_
# CS1575 Array-List Assignment

![](workful-willy.png)

**Problem:**
William is down on his luck and needs money, lest he be evicted from his residence by his landlord. Luckily for William, there seems to be many jobs available nearby and no sense of scarcity on his energy. 

William has a rapidly changing schedule for his jobs that will be required to be stored in an ArrayList. At the start of every day, an event may occur. Your task will be to deal with the event and how it will affect William’s schedule using MyVector.hpp and main.cpp.

MyVector.hpp should be modified to replicate the functionality of std::vector as closely as possible (you can use cppreference if you want additional information on how std::vector works). Function definitions and information on how you should actually implement your ArrayList functionality in this assignment can be found in MyVector.h (do NOT modify this file.) It is recommended to use the unit tests as a guide and program each function one-by-one after passing each test.

main.cpp should be modified to interpret and react to input using your built ArrayList. Your program should then give an output depending on the input, more information on this below.

**Input:**

Input will be a stream of lines that will give specific information about an event for William and how it will affect his schedule. 
The first line of input will be a list of jobs that William will start his schedule with, separated by commas. The positions of the job in the list should match the position in William’s schedule, for example the first job that appears in input should be at index 0 in William’s schedule. The rest of the lines of input will be events that affect William’s schedule and they will follow this format:

ADD **job** **timeslot** 
William gets a new job and adds it to his schedule. 
**timeslot** is an integer relating to the position within William’s schedule arraylist, and **job** is a string beginning and ending with quotation marks.  For ADD specifically, the range of **timeslot** is from 0 to the amount of elements in William’s schedule, inclusively. **timeslot** for FIRE and CAR_CRASH have a range from 0 to the amount of element’s in William’s schedule minus 1, inclusively.

FIRE (**job** OR **timeslot**) 
William gets fired from one of his jobs. 
If a job title is given instead of a timeslot, all instances of that job should be removed from William’s schedule.

SLEPT_IN **time** 
William accidentally sleeps in one morning and gets fired from the jobs he missed.
**time** is an integer relating to how many shifts William slept through. All slept through shifts should be removed from William’s schedule. Removed shifts should start at index 0, going upwards.



CAR_CRASH **timeslot**
William crashes his car and can’t make it to any jobs in his schedule for the rest of the day.
**timeslot** is the position in William’s schedule where he crashes his car. Everything at and after the car crash should be removed from William’s schedule, e.g. CAR_CRASH 0 would remove everything from William’s schedule.


DISEASE
William gets struck down with a terrible illness and can’t make it to work at all today.
Remove everything in William’s schedule.

GUILT 
William tracks his schedule on a piece of paper from which he adds more paper to when he runs out of space. Currently, he is using less paper than what he has and is feeling guilty about wasting the excess paper. 
GUILT should call your vector’s shrink_to_fit function onto William’s schedule.

AUDIT **job** 
William gets a letter from the IRS, yippee! They’re just checking for jobs in William’s schedule, since it seems his rapid job hopping and tremendous work ethic has caused some confusion on their end.
**job** will be the string title of a job. Record the results of whether or not **job** is within William’s schedule.

**Example input:**

```
"Dentist", "Garbageman", "Lawyer"
ADD "Janitor" 1
FIRE 0
FIRE "Lawyer"
ADD "Cheesemonger" 0
SLEPT_IN 2
ADD "Pilot" 1
ADD "Baker" 1
CAR_CRASH 2
DISEASE
ADD "Coal Miner" 0
ADD "Magician" 0
ADD "Fireman" 1
FIRE "Magician"
GUILT
AUDIT "Magician"
```

**Output:**
Output will be a summary of William’s schedule and how it changes, consisting of:
The number of times each random event happened, William’s final schedule, the capacity of William’s schedule, the schedule of clones, and the data from AUDIT.

Example output:

```
William has successfully dodged eviction!

7 Shifts Added
3 Shifts Fired From
1 Times Slept In
1 Car Crashes
1 Diseases Caught
1 Times Recycled
1 Times Audited

William’s Final Schedule:
[ Fireman, Coal Miner, ]

Schedule Capacity: 2

Audit:
Found job in schedule: 0
Didn’t find job in schedule: 1
```

**Important Notes:**
To bring this implementation more in line with std::vector and prepare you for working with the standard library implementations directly, some functions have shifted to use an **ArrayListIterator** in place of a normal _integer_ index. 

The **ArrayListIterator** class provided is designed to act exactly like a normal integer.
* It can be used wherever your code expects an integer **(operator int() implicit conversion)**
* It can be incremented / summed with other integers **(operator+)**
* It can be compared to other integers **(operator> / operator<)**

  
Aside from the important values, try to match your output with the example above as close as you can. Don’t mess with the lettering of the events (even if grammatically incorrect), use std::cout on your schedule to print it out like above.

Unit tests are useful and we try to make sure they catch as many faults as possible, but we can’t often test every single edge case. This may lead to the unfortunate outcome where even though you’re passing all unit tests, your code isn’t 100% correct and you run into something when testing the stdio tests.

