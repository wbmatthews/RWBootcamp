# Week 2 Assignment

I decided to start with structs as I understand that generally it's a best practice to start there and then switch to classes if necessary.  I wanted to experiment a bit with nested structs as well as keep the game rounds as self-contained as possible, so the BullsEyeRound is a struct itself within the BullsEyeGame class.  I switched that to class as I figured there was only ever going to be one anyways, and it has all the properties that need frequent mutating.

I then added a protocal to define BullsEyeableType--a value that has a difference fuction, as well as newRandom and initialValue type properties so that I could use the exact same objects for Ints or RGB structs.

Once I got all that working I followed Audrey's advice and bundled up all the apps into one 3-tabbed app as a stretch exercise and to doubly-prove to myself that all three versions we using the same game object.