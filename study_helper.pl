/* Instantiations */
#include 'header.pl'.
#include 'mentor-sort.pl'.

/* Time Urgency */
% past 3 weeks we assume an urgency of 2
time_urgency(X,2) :- coursework(_,X,Z), Z >= 21.
time_urgency(X,4) :- coursework(_,X,Z), Z >= 14, Z < 21.
time_urgency(X,6) :- coursework(_,X,Z), Z >= 7, Z < 14.
time_urgency(X,8) :- coursework(_,X,Z), Z >= 4, Z < 7.
time_urgency(X,10) :- coursework(_,X,Z), Z >= 0, Z < 4.

/* Grade Urgency */
grade_urgency(X,0) :- taking(_,X,Z), Z >= 93.
grade_urgency(X,3) :- taking(_,X,Z), Z >= 90, Z < 93.
grade_urgency(X,6) :- taking(_,X,Z), Z >= 85, Z < 90.
grade_urgency(X,9) :- taking(_,X,Z), Z >= 80, Z < 85.
grade_urgency(X,18) :- taking(_,X,Z), Z >= 75, Z < 80.
grade_urgency(X,27) :- taking(_,X,Z), Z >= 70, Z < 75.
grade_urgency(X,36) :- taking(_,X,Z), Z < 70.

/* Assignments */
assignment(X) :- homework(X).
assignment(X) :- quiz(X).
assignment(X) :- project(X).

/* Assignment Urgency */
a_urgency(X,5) :- homework(X).
a_urgency(X,10) :- quiz(X).
a_urgency(X,15) :- project(X).

/* Exams */
exam(X) :- midterm(X).
exam(X) :- final(X).

/* Exam Urgency */
% this means to work on / study for
% actions can be different such as with quizzes (studying for or completing)
% the functional difference doesnt really matter as long as assume this is study overall
e_urgency(X,20) :- midterm(X).
e_urgency(X,30) :- final(X).

/* Urgency Total */
% Assignment X from Class Z with Due Date A, has an Urgency Rating of Y
hasUrgency(X,Z,A,Y) :- time_urgency(X,B), a_urgency(X,C), taking(_,Z,_), grade_urgency(Z,D), coursework(Z,X,A), assignment(X), Y is B+C+D.
hasUrgency(X,Z,A,Y) :- time_urgency(X,B), e_urgency(X,C), taking(_,Z,_), grade_urgency(Z,D), coursework(Z,X,A), exam(X), Y is B+C+D.

/* Urgency List */
% X = Assignment Name
% Z = Class Name
% A = Due Date
% Y = Urgency Rating
urgencyList(L) :- findall([X,Z,A,Y], hasUrgency(X,Z,A,Y), L). 
mostUrgent(H) :- urgencyList(L), sort_by_index(L,3,[H|T]), write('[Assignment, Class, Days till Due, Urgency Score]').

/* Logical Axioms */
% announcement of work due
% class X has something (Y) due
hasDue(X,Y) :- coursework(X,Y,_), write('You have assignment '), write(Y), 
write(' due for class '), write(X), write('.').
% If you are failing class X and then you need to do task/the assignment Y
failing(X) :- grade_urgency(X,36).
