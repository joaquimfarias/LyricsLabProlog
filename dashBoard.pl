:- consult('artistasRepo.pl'), consult('util.pl').

topNArtistas(0):- !.
topNArtistas(N) :-
  getAllArtistas(TodosOsArtistas),
  ordenarArtistas(TodosOsArtistas, [], ArtistasOrdenados),
  length(ArtistasOrdenados, Len),
  Minimo is min(N, Len),
  dashBoartArtistaToScreen(ArtistasOrdenados, 1, Minimo),!.

dashBoartArtistaToScreen([], _, _):- !.
dashBoartArtistaToScreen(_, Indice, Limite):-
  Indice > Limite, !.
dashBoartArtistaToScreen([H|T], Indice, Limite):-
  Indice =< Limite,
  dashBoartArtistaToString(H, Indice),
  Time is 2/Limite, sleep(Time),
  NovoIndice is Indice + 1,
  dashBoartArtistaToScreen(T, NovoIndice, Limite), !.

dashBoartArtistaToString(Artista, Indice):-
  write('\n'), write(Indice), writeln(' Lugar'),
  nth0(0, Artista, Nome),
  nth0(5, Artista, Avaliacao),

  musicasPorArtista(Nome, ListaDeMusicas),
  ordenarMusicas(ListaDeMusicas, [], MusicasOrdenadas),
  nth0(0, MusicasOrdenadas, MelhorMusica),
  nth0(1, MelhorMusica, NomeMusica),
  nth0(8, MelhorMusica, AvaliacaoMusica),

  writeln('#=#=#=#=#=#=#=#=#=#'),
  write(Nome), write(' com '), format('~2f', Avaliacao), writeln(' de avaliacao'),
  write(NomeMusica), write(' e a melhor musica do artista com '), write(AvaliacaoMusica), writeln(' de avaliacao'),
  writeln('#=#=#=#=#=#=#=#=#=#').