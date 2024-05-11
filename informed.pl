/*
The problem is reaching from start to goal state in 2d board, each cell is colored with a color (R,G,or B), 
start from the start cell moving up, down, left, right cells that with the same color until reach the goal cell, 
finally you must keep track of the path that you have taken to reach the goal cell, use the A* algorithm to solve the problem, 
make the huristic function to be the manhattan distance between the current cell and the goal cell.
*/

startSearching():-
    write("Start searching..."), nl,
    write("Number of rows: "), read(Nrows), nl,
    write("Number of columns: "), read(Ncolumns), nl,
    write("Initial board colors: "), read(InintialBoardColors), nl,
    write("Start index: "), read(StartIndex), nl,
    write("End index: "), read(GoalIndex), nl,
    search(InintialBoardColors, Nrows, Ncolumns, [[StartIndex, null, 0, x, 0]], [], GoalIndex).

search(_InintialBoardColors, _Nrows, _Ncolumns, Open, Closed, GoalIndex):-
    getBestState(Open, [CurrentStateIndex,ParentIndex,G,H,F], _), 
    CurrentStateIndex = GoalIndex,
    write("Search is complete!"), nl,
    printSolution([CurrentStateIndex,ParentIndex,G,H,F], Closed), !.

search(InintialBoardColors, Nrows, Ncolumns, Open, Closed, GoalIndex):-
    getBestState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(InintialBoardColors, Nrows, Ncolumns, CurrentNode,TmpOpen,Closed,GoalIndex,Children), 
    addChildren(Children, TmpOpen, NewOpen), 
    append(Closed, [CurrentNode], NewClosed), 
    search(InintialBoardColors, Nrows, Ncolumns, NewOpen, NewClosed, GoalIndex).

% Implementation of step 3 to get the next states
getAllValidChildren(InintialBoardColors, Nrows, Ncolumns, Node, Open, Closed, GoalIndex, Children):-
    findall(Next, getNextState(InintialBoardColors, Nrows, Ncolumns, Node,Open,Closed,GoalIndex,Next), Children).

% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).

% Implementation of findMin in getBestState determines the search

% A* search
findMin([X], X):- !.

findMin([Head|T], Min):-
    findMin(T, TmpMin),
    Head = [_,_,_,_HeadH,HeadF],
    TmpMin = [_,_,_,_TmpH,TmpF],
    (TmpF < HeadF -> Min = TmpMin ; Min = Head).

getNextState(InintialBoardColors, Nrows, Ncolumns, [StateIndex,_,G,_,_],Open,Closed,GoalIndex,[NextIndex,StateIndex,NewG,NewH,NewF]):-
    move(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex, MoveCost),
    calculateH(Nrows, Ncolumns, NextIndex, GoalIndex, NewH),
    NewG is G + MoveCost,
    NewF is NewG + NewH,
    ( not(member([NextIndex,_,_,_,_], Open)) ; memberButBetter(NextIndex,Open,NewF) ),
    ( not(member([NextIndex,_,_,_,_],Closed));memberButBetter(NextIndex,Closed,NewF)).

memberButBetter(NextIndex, List, NewF):-
    findall(F, member([NextIndex,_,_,_,F], List), Numbers),
    min_list(Numbers, MinOldF),
    MinOldF > NewF.

% Instead of adding children at the end and searching for the best
% each time using getBestState, we can make addChildren add in the
% right place (sorted open list) and getBestState just returns the
% head of open.

% Implementation of printSolution to print the actual solution path
printSolution([State, null, G, H, F],_):-
    write([State, G, H, F]), nl.

printSolution([State, Parent, G, H, F], Closed):-
    member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    write([State, G, H, F]), nl.

move(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex, 1):- 
    left(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex);
    right(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex);
    up(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex);
    down(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex).

left(InintialBoardColors, _Nrows, Ncolumns, StateIndex, NextIndex):-
    nth0(StateIndex, InintialBoardColors, StateColor),
    not(0 is StateIndex mod Ncolumns),
    NewIndex is StateIndex - 1,
    nth0(NewIndex, InintialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

right(InintialBoardColors, _Nrows, Ncolumns, StateIndex, NextIndex):-
    nth0(StateIndex, InintialBoardColors, StateColor),
    not((Ncolumns - 1) =:= StateIndex mod Ncolumns), % I modified here from (is) to (=:=)
    NewIndex is StateIndex + 1,
    nth0(NewIndex, InintialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

up(InintialBoardColors, _Nrows, Ncolumns, StateIndex, NextIndex):-
    nth0(StateIndex, InintialBoardColors, StateColor),
    StateIndex > Ncolumns - 1,
    NewIndex is StateIndex - Ncolumns,
    nth0(NewIndex, InintialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

down(InintialBoardColors, Nrows, Ncolumns, StateIndex, NextIndex):-
    nth0(StateIndex, InintialBoardColors, StateColor),
    StateIndex < (Nrows - 1) * Ncolumns,
    NewIndex is StateIndex + Ncolumns,
    nth0(NewIndex, InintialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

substitute(Element, [Element|T], NewElement, [NewElement|T]):- !.

substitute(Element, [H|T], NewElement, [H|NewT]):-
    substitute(Element, T, NewElement, NewT).

calculateH(_Nrows, Ncolumns, CurrentIndex, GoalIndex, Hvalue):-
    CurrentRow is div(CurrentIndex, Ncolumns),
    CurrentColumn is mod(CurrentIndex, Ncolumns),
    GoalRow is div(GoalIndex, Ncolumns),
    GoalColumn is mod(GoalIndex, Ncolumns),
    Hvalue is abs(CurrentRow - GoalRow) + abs(CurrentColumn - GoalColumn).


% [r, r, y, y, r, b, r, r, r, r, r, y, b, r, b, y]