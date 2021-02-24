/*

TODO:
    - Add more comments
    - Change 'accept' predicate to be 'ntm' predicate
    - Add solutions in comments for sample inputs given in assignment
    - Better variable names?
    - Better way to handle b-k symbol on tape
    - Add our names somewhere
    - Remove this todo list :)

*/

% MoveRight if R is empty []
transition(_, MoveRight, _, L, [TapeInput|[]], Q, [TapeInput|L], [b-k], Qn) :-
    member([Q, TapeInput, Qn], MoveRight).

% MoveRight
transition(_, MoveRight, _, L, [TapeInput|T], Q, [TapeInput|L], T, Qn) :-
    member([Q, TapeInput, Qn], MoveRight).

% MoveLeft if L is empty []
transition(MoveLeft, _, _, [H|[]], [TapeInput|R], Q, [b-k], [H,TapeInput|R], Qn) :-
    member([Q, TapeInput, Qn], MoveLeft).

% MoveLeft
transition(MoveLeft, _, _, [H|T], [TapeInput|R], Q, T, [H,TapeInput|R], Qn) :-
    member([Q, TapeInput, Qn], MoveLeft).

% Write
transition(_, _, Write, L, [TapeInput|T], Q, L, [Overwrite|T], Qn) :-
    member([Q, TapeInput, Overwrite, Qn], Write).

add2frontier(Children,[],Children).
add2frontier(Children,[H|T],[H|More]) :-
	add2frontier(Children,T,More).

reverse([],Z,Z).
reverse([H|T],Z,Acc) :-
    reverse(T,Z,[H|Acc]).

remove_blanks_from_left([], []).
remove_blanks_from_left([H|T], [H|T]) :-
    not(H = b-k).
remove_blanks_from_left([b-k|T], Output) :-
    remove_blanks_from_left(T, Output).

accept(_, _, _, Halt, [[L, [H|T], Q]|_], Output) :-
    member([Q,H], Halt),
    reverse(L, L_Reversed, []),
    append(L_Reversed, [H|T], OutputTape),
    remove_blanks_from_left(OutputTape, No_L_Blanks_Output),
    reverse(No_L_Blanks_Output, Reversed_Output, []),
    remove_blanks_from_left(Reversed_Output, Reverse_No_R_Blanks_Output),
    reverse(Reverse_No_R_Blanks_Output, Output, []).

accept(MoveLeft, MoveRight, Write, Halt, [[L, R, Q]|Rest], Output) :-
    findall([Ln, Rn, Qn], transition(MoveLeft, MoveRight, Write, L, R, Q, Ln, Rn, Qn), Children),
    add2frontier(Children, Rest, NewFrontier),
	accept(MoveLeft, MoveRight, Write, Halt, NewFrontier, Output).

% nTm(+move-right,+move-left,+write-list,+halt-list,+input,?output)
nTm(MoveRight, MoveLeft, Write, Halt, Input, Output) :-
    accept(MoveLeft, MoveRight, Write, Halt, [[[],Input,q0]], Output).