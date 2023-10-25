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

% Ordena a lista de artistas de forma decrescente
ordenarArtistas([], Temp, Temp).
ordenarArtistas([H|T], Temp, Sorted) :-
  inserirArtistaOrdenado(H, Temp, [], InseridoH),
  ordenarArtistas(T, InseridoH, Sorted).

inserirArtistaOrdenado(Alvo, [], [], [Alvo]).
inserirArtistaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(5, Alvo, AvaliacaoAlvo),
  nth0(5, H, AvaliacaoH),
  AvaliacaoAlvo < AvaliacaoH,
  append(Temp, [H], Esquerdo),
  inserirArtistaOrdenado(Alvo, T, Esquerdo, Resultado).
inserirArtistaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(5, Alvo, AvaliacaoAlvo),
  nth0(5, H, AvaliacaoH),
  AvaliacaoAlvo >= AvaliacaoH,
  append(Temp, [Alvo], X),
  append(X, [H|T], Resultado).
inserirArtistaOrdenado(Alvo, [], Temp, Resultado):-
  append(Temp, [Alvo], Resultado).

% Ordena a lista de musicas de forma decrescente
ordenarMusicas([], Temp, Temp).
ordenarMusicas([H|T], Temp, Sorted):-
  inserirMusicaOrdenado(H, Temp, [], InseridoH),
  ordenarMusicas(T, InseridoH, Sorted).

inserirMusicaOrdenado(Alvo, [], [] ,[Alvo]).
inserirMusicaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(8, Alvo, AvaliacaoAlvo),
  nth0(8, H, AvaliacaoH),
  AvaliacaoAlvo < AvaliacaoH,
  append(Temp, [H], Esquerdo),
  inserirMusicaOrdenado(Alvo, T, Esquerdo, Resultado).
inserirMusicaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(8, Alvo, AvaliacaoAlvo),
  nth0(8, H, AvaliacaoH),
  AvaliacaoAlvo >= AvaliacaoH,
  append(Temp, [Alvo], X),
  append(X, [H|T], Resultado).
inserirMusicaOrdenado(Alvo, [], Temp, Resultado):-
  append(Temp, [Alvo], Resultado).