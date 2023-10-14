buscarArtistaPorNome(NomeParaFiltrar) :-
  artista(Artistas),
  filtrarPor(NomeParaFiltrar, 0, Artistas, [], ArtistasFiltrados),
  toScreen(ArtistasFiltrados, 1).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  artista(Artistas),
  filtrarPor(BandaParaFiltrar, 1, Artistas, [], ArtistasFiltrados),
  toScreen(ArtistasFiltrados, 1).

buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  artista(Artistas),
  filtrarPor(BandaAnteriorParaFiltrar, 2, Artistas, [], ArtistasFiltrados),
  toScreen(ArtistasFiltrados, 1).

buscarArtistasPorFuncao(FuncaoParaFiltrar) :-
  artista(Artistas),
  filtrarPor(FuncaoParaFiltrar, 3, Artistas, [], ArtistasFiltrados),
  toScreen(ArtistasFiltrados, 1).

filtrarPor(_, _, [], ListaResultado, ListaResultado):- !.
filtrarPor(ParametroDeFiltro, 2, [H|T], ListaResultado, Retorno) :-
  nth0(2, H, ListaDeBandas),
  contem(ParametroDeFiltro, ListaDeBandas),
  append([H], ListaResultado, NovaListaResultado),
  filtrarPor(ParametroDeFiltro, 2, T, NovaListaResultado, Retorno).
filtrarPor(ParametroDeFiltro, 2, [_|T], ListaResultado, Retorno):- filtrarPor(ParametroDeFiltro, 2, T, ListaResultado, Retorno).

filtrarPor(ParametroDeFiltro, Indice, [H|T], ListaResultado, Retorno):-
  Indice \= 2,
  nth0(Indice, H, R),
  upperCase(R, UpperR),
  upperCase(ParametroDeFiltro, UpperParametro),
  UpperParametro == UpperR,
  append([H], ListaResultado, NovaListaResultado),
  filtrarPor(ParametroDeFiltro, Indice, T, NovaListaResultado, Retorno).
filtrarPor(ParametroDeFiltro, Indice, [_|T], ListaResultado, Retorno):-
  Indice \= 2,
  filtrarPor(ParametroDeFiltro, Indice, T, ListaResultado, Retorno).

upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 