/* Design Input */
% Get the size of the grid and the colors of the cells
getInput:-
    write("Enter the number of rows:"), nl,
    read(N),
    write("Enter the number of columns:"), nl,
    read(M),
    Size is N * M,
    % Storing the grid into a 1D array
    getColorsInput(Size, [], InitialState),
    write(InitialState). % For debugging purposes

/* Design State Representation */
% Base case reached when the size of the list is 0
getColorsInput(0, InitialState, InitialState).
% Get the color of each cell as long as the size is positive
getColorsInput(Size, CurrentList, InitialState):-
    Size > 0, !, % Check for the size each time
    write("Enter the color of the cell"), nl,
    read(Color),
    append(CurrentList, [Color], UpdatedList),
    NewSize is Size - 1,
    getColorsInput(NewSize, UpdatedList, InitialState).

/* Design Output */
% Convert the index into a 2D coordinate
convertIndexInto2D(Index, M, Row, Col):-
    Row is Index // M, % Floor the result
    Col is Index mod M.

% Print a pair of indices with an arrow between them
printPairs([]):- !. % Empty list case
printPairs([Row, Col | Tail]):-
    write(Row), write(","), write(Col),
    % Check if it's the last pair to print, omit the arrow
    (Tail = [] -> true; write(" -> ")),
    printPairs(Tail).

% Convert each index in the cycle list into a 2D coordinate
convertCycleList(_, [], CL, CL):- !.  % Empty list case
convertCycleList(MColumns, [Index | Tail], CurrentList, ConvertedCycleList) :-
    convertIndexInto2D(Index, MColumns, Row, Col),
    append(CurrentList, [Row, Col], UpdatedList),
    convertCycleList(MColumns, Tail, UpdatedList, ConvertedCycleList).

% Print the resulting cycle and its color
printOutput(MColumns, CycleList, Color):-
    convertCycleList(MColumns, CycleList, [], ConvertedCycleList),
    write("Cycle List: "), printPairs(ConvertedCycleList), nl,
    write("Color: "), write(Color), nl.

/* TODO */
% Print the list from the beginning to the middle,
% Then print from the end to the middle + 1 (excluding the middle)

/* Testing */
% getInput. % Test the input
% printOutput(4, [9, 10, 14, 13], 'Blue'). % Test the output
