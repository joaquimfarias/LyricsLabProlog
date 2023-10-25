:- consult('artistasRepo.pl').

topNArtistas(0).
topNArtistas(N) :-
  getAllArtistas(TodosOsArtistas),
  artistaSort(TodosOsArtistas, [], TodosOsArtistasOrdenados),
  length(TodosOsArtistasOrdenados, Len),
  dashArtistaToScreen(TodosOsArtistasOrdenados, 1, N, Len).

artistaSort([], Temp, Temp).
artistaSort([H|T], Temp, Retorno) :-
  inserirArtistaOrdenado(H, Temp, [], NovaTemp),
  artistaSort(T, NovaTemp, Retorno).

inserirArtistaOrdenado(Alvo, [], Temp, Retorno) :- append(Temp, [Alvo], Retorno).
inserirArtistaOrdenado(Alvo, [H|T], Temp, Retorno) :-
  nth0(5, Alvo, Avaliacao),
  nth0(5, H, Avaliacao2),
  Avaliacao < Avaliacao2,
  append(Temp, [H], NovoTemp),
  inserirArtistaOrdenado(Alvo, T, NovoTemp, Retorno), !.
inserirArtistaOrdenado(Alvo, [H|T], Temp, Retorno) :-
  append(Temp, [Alvo], X),
  append(X, [H|T], Retorno).

musicaSort([], Temp, Temp).
musicaSort([H|T], Temp, Retorno) :-
  inserirMusicaOrdenado(H, Temp, [], NovaTemp),
  musicaSort(T, NovaTemp, Retorno).

inserirMusicaOrdenado(Alvo, [], Temp, Retorno) :- append(Temp, Alvo, Retorno).
inserirMusicaOrdenado(Alvo, [H|T], Temp, Retorno) :-  
  nth0(8, Alvo, Avaliacao),
  nth0(8, Alvo, Avaliacao2),
  Avaliacao < Avaliacao2,
  append(Temp, [H], NovoTemp),
  inserirMusicaOrdenado(Alvo, T, NovoTemp, Retorno), !.
inserirMusicaOrdenado(Alvo, [H|T], Temp, Retorno) :-
  append(Temp, [Alvo], X),
  append(X, [H|T], Retorno).

dashArtistaToScreen([], _, _, _):- !.
dashArtistaToScreen([H|_], Limite, Limite, Len) :- 
  write('\n'), write(Limite), writeln(' Lugar'),
  nth0(0, H, Nome),
  nth0(5, H, Avaliacao),
  
  musicasPorArtista(Nome, ListaDeMusicas),
  musicaSort(ListaDeMusicas, [], MusicasOrdenadas),
  writeln(MusicasOrdenadas),
  nth0(0, MusicasOrdenadas, MelhorMusica),
  nth0(1, MelhorMusica, NomeMusica),
  nth0(8, MelhorMusica, AvaliacaoMusica),

  writeln('#=#=#=#=#=#=#=#=#=#'),
  write(Nome), write(' com '), format('~2f', Avaliacao), writeln(' de avaliacao'),
  write(NomeMusica), write(' e a melhor musica do artista com '), write(AvaliacaoMusica), writeln(' de avaliacao'),
  writeln('#=#=#=#=#=#=#=#=#=#'),
  Time is 2/Len, sleep(Time), !.
dashArtistaToScreen([H|T], Indice, Limite, Len) :- 
  Indice < Limite,
  write('\n'), write(Indice), writeln(' Lugar'),
  nth0(0, H, Nome),
  nth0(5, H, Avaliacao),
  
  musicasPorArtista(Nome, ListaDeMusicas),
  musicaSort(ListaDeMusicas, [], MusicasOrdenadas),
  nth0(0, MusicasOrdenadas, MelhorMusica),
  nth0(1, MelhorMusica, NomeMusica),
  nth0(8, MelhorMusica, AvaliacaoMusica),

  writeln('#=#=#=#=#=#=#=#=#=#'),
  write(Nome), write(' com '), format('~2f', Avaliacao), writeln(' de avaliacao'),
  write(NomeMusica), write(' e a melhor musica do artista com '), write(AvaliacaoMusica), writeln(' de avaliacao'),
  writeln('#=#=#=#=#=#=#=#=#=#'),
  Time is 2/Len, sleep(Time),
  NovoIndice is Indice + 1,
  dashArtistaToScreen(T, NovoIndice, Limite, Len).