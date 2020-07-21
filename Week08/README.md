# README
I've ultimately set this up using NSFetchedResultsController rather than the provided arrays, givent that it's so much easier to get bonus features automatically.  As such, I've implemented insert and delete using NSFetchedResultsContrllerDelegate.

In terms of other dataa we'd want to preload, it might be helful to load JSON data for a photo library of sandwiches to choose from, and given the implementation of the SauceAmount enum, it could also be helpful to preload those enum states into the sauce entity.
