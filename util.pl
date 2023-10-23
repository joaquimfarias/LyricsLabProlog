upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

listToString([], Resultado, Resultado):- !.
listToString([H|[]], Resultado, Retorno):- atom_concat(H, "", UltimoResultado), atom_concat(Resultado, UltimoResultado, Retorno), !.
listToString([H|T], Resultado, Retorno):-
  atom_concat(H, " | ", NovoElemento),
  atom_concat(Resultado, NovoElemento, NovoResultado),
  listToString(T, NovoResultado, Retorno).

splitVS('', []).
splitVS(String, Retorno) :-
  split_string(String, ",", " ", Retorno).
  
artistaToScreen([], _, _):- writeln('\nNenhum artista para mostrar.\n'), sleep(3).
artistaToScreen([H|[]], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), !.
artistaToScreen([H|T], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), NovoIndice is Indice+1, artistaToScreen(T, NovoIndice, Len).
