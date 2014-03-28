# Family tree

In this exercise, we were given a project where the foundation was already built and we had to continue building from there.
_________________

This is a command-line app to track a family tree. It's an exercise in using Active Record without Rails, and playing around with associations that aren't always straightforward.

So far, the only functionality that's been implemented is tracking which people are married to each other.

Future features:

* Tracking children
* Reporting parents
* Reporting siblings, cousins, uncles/aunts, etc.
* Tracking divorces



#Problem Description---

Family tree
Build a program that will let people create a family tree.

As a twist for Fun Friday, I've already started this project for you. Clone my repo and pick up where I left off. I've started out small - users can enter two people, and describe them as spouses.

Here are the features I want you to build:

Let users enter a person, and describe that person as the child of two people.
Flesh out the user interface to show a list of people, and lets you choose one to see who they're married to and who their parents are.
Show who somebody's grandparents and grandchildren are.
Add support for siblings, cousins, uncles, aunts, etc.
Finally, add support for divorces, which may be almost as difficult in the database as in real life.
Hint: I did a bad job of modeling the relationships. My design is very inflexible and not DRY. You'll have to think about how to refactor it as you go.
