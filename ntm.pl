/*
TODO:
    - ☐ Add more comments
    - ☒ Change 'accept' predicate to be 'ntm' predicate
    - ☐ Add solutions in comments for sample inputs given in assignment
    - ☐ Better variable names?
    - ☑ Better way to handle b-k symbol on tape
    - ☑ Add our names somewhere
    - ☐ Remove this todo list :)

*/
/* @authors: Oisin Nolan - 00000000, Sophie Crowley - 17330036, Madeleine Comtois -17301720
 * @version: 25/02/2021
 */

% MoveRight
transition(MoveRight, _, _, L, [TapeInput|T], Q, [TapeInput|L], T, Qn) :-
    member([Q, TapeInput, Qn], MoveRight).

% MoveLeft
transition(_, MoveLeft, _, [H|T], [TapeInput|R], Q, T, [H,TapeInput|R], Qn) :-
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

accept(MoveRight, MoveLeft, Write, Halt, [[L, R, Q]|Rest], Output) :-
    findall([Ln, Rn, Qn], transition(MoveRight, MoveLeft, Write, L, R, Q, Ln, Rn, Qn), Children),
    add2frontier(Children, Rest, NewFrontier),
	accept(MoveRight, MoveLeft, Write, Halt, NewFrontier, Output).

% nTm(+move-right,+move-left,+write-list,+halt-list,+input,?output)
nTm(MoveRight, MoveLeft, Write, Halt, Input, Output) :-
    append(Input, [b-k], NewInput),
    accept(MoveRight, MoveLeft, Write, Halt, [[[],NewInput,q0]], Output).



/** <examples>

?- nTm([],[],[],[[q0,X]],[b-k,i,n,b-k,p,u,t,b-k,b-k],Out).

?- nTm([[q1,1,q2],[q1,0,q2],[q1,b-k,q2]],[],
         [[q0,0,1,q1], [q2,0,b-k,q1]],
         [[q1,b-k]],
         [0,0,0,0,0],
         Out).
         
?- nTm([[mr1,h,we],[mr1,e,wl],[mr1,l,wp],[mr1,p,hbk],
          [mr,l,wo],[mr,o,wo],[mp,o,wp]],
         [[q0,0,lbk],[lbk,b-k,lbk]],
         [[q0,0,h,mr1],[we,1,e,mr1],[wl,0,l,mr1],[wp,1,p,mr1],
          [q0,0,l,mr],[wo,1,o,mr],[wo,0,o,mp]],
         [[hbk,b-k]],
         [0,1,0,1],
         Output).

*/