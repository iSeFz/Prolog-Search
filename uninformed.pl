% Assignment Board: [y,y,y,r,b,y,b,y,b,b,b,y,b,b,b,y]

% Main method to start the check
checkForCycles:-
    write("\tUninformed Search [Check For Cycles]\n"),
    write("Number of rows: "), read(NRows), nl,
    write("Number of columns: "), read(MColumns), nl,
    write("Initial board colors: "), read(InitialBoardColors), nl,
    Ncells is (NRows * MColumns) - 1,
    between(0, Ncells, StartIndex),
    search(InitialBoardColors, NRows, MColumns, [StartIndex, null], [], StartIndex).

% Search base case to check if the goal is reached
search(_InintialBoardColors, _NRows, MColumns, [CurrentIndex, ParentIndex], Closed, GoalIndex):-
    CurrentIndex = GoalIndex,
    ParentIndex \= null,
    write("\t\tSolution found!\n"),
    printSolution(MColumns, [CurrentIndex, ParentIndex], Closed, GoalIndex), !.

% Search recursive case to keep searching
search(InitialBoardColors, NRows, MColumns, [CurrentIndex, ParentIndex], Closed, GoalIndex):-
    move(InitialBoardColors, NRows, MColumns, CurrentIndex, NextIndex),
    NextIndex \= ParentIndex,
    not(member([NextIndex, _], Closed)),
    search(InitialBoardColors, NRows, MColumns, [NextIndex, CurrentIndex], [[NextIndex, CurrentIndex] | Closed], GoalIndex).

% Base case to print the solution when the goal is reached
printSolution(MColumns, [State, GoalIndex], _, GoalIndex):-
    % Convert the index into a 2D coordinate
    GoalRow is GoalIndex // MColumns, % Floor the result
    GoalColumn is GoalIndex mod MColumns,
    write(GoalRow), write(","), write(GoalColumn), write(" => "),
    % write([GoalIndex, null]), nl,
    StateRow is State // MColumns, % Floor the result
    StateColumn is State mod MColumns,
    write(StateRow), write(","), write(StateColumn), write(" => ").
    % write([State, GoalIndex]), nl.

% Recursive case to print the solution
printSolution(MColumns, [State, Parent], Closed, GoalIndex):-
    member([Parent, GrandParent], Closed),
    Parent \= GoalIndex,
    printSolution(MColumns, [Parent, GrandParent], Closed, GoalIndex),
    StateRow is State // MColumns, % Floor the result
    StateColumn is State mod MColumns,
    write(StateRow), write(","), write(StateColumn), write(" => ").
    % write([State, Parent]), nl.

% Method to move the empty cell to the left, right, up or down
move(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex):- 
    left(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex);
    right(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex);
    up(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex);
    down(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex).

% Methods to check if the empty cell can move to the left, right, up or down
left(InitialBoardColors, _NRows, MColumns, StateIndex, NextIndex):-
    nth0(StateIndex, InitialBoardColors, StateColor),
    not(0 is StateIndex mod MColumns),
    NewIndex is StateIndex - 1,
    nth0(NewIndex, InitialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

right(InitialBoardColors, _NRows, MColumns, StateIndex, NextIndex):-
    nth0(StateIndex, InitialBoardColors, StateColor),
    not((MColumns - 1) =:= StateIndex mod MColumns),
    NewIndex is StateIndex + 1,
    nth0(NewIndex, InitialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

up(InitialBoardColors, _NRows, MColumns, StateIndex, NextIndex):-
    nth0(StateIndex, InitialBoardColors, StateColor),
    StateIndex > MColumns - 1,
    NewIndex is StateIndex - MColumns,
    nth0(NewIndex, InitialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.

down(InitialBoardColors, NRows, MColumns, StateIndex, NextIndex):-
    nth0(StateIndex, InitialBoardColors, StateColor),
    StateIndex < (NRows - 1) * MColumns,
    NewIndex is StateIndex + MColumns,
    nth0(NewIndex, InitialBoardColors, NewIndexColor),
    StateColor = NewIndexColor,
    NextIndex is NewIndex.