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
  
limitarCasasDecimais(Numero, NumeroFormatado) :-
  atomic_list_concat(['~2f', Numero], '', Formato),
  format(atom(NumeroFormatado), Formato, [Numero]).