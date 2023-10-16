:- consult('artistas.pl').
:- dynamic (artista/4).


buscarArtistaPorNome(NomeParaFiltrar) :-
  findall([NomeParaFiltrar, BandaAtual, BandasAnteriores, Funcao],
          artista(NomeParaFiltrar, BandaAtual, BandasAnteriores, Funcao),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  findall([Nome, BandaParaFiltrar, BandasAnteriores, Funcao],
          artista(Nome, BandaParaFiltrar, BandasAnteriores, Funcao),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAnterior('') :-
  write("entrou 1"),
  findall([Nome, BandaAtual, [], Funcao],
          artista(Nome, BandaAtual, [], Funcao),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).
buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  BandaAnteriorParaFiltrar \= '',
  write("entrou 2"),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao),
          member(BandaAnteriorParaFiltrar, BandasAnteriores)),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorFuncao(FuncaoParaFiltrar) :-
  findall([Nome, BandaAtual, BandasAnteriores, FuncaoParaFiltrar],
          artista(Nome, BandaAtual, BandasAnteriores, FuncaoParaFiltrar),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

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