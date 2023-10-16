:- consult('artistas.pl').
:- dynamic (artista/4).


buscarArtistaPorNome(NomeParaFiltrar) :-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  upcase_atom(BandaParaFiltrar, BandaParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao),
          upcase_atom(BandaAtual, BandaAtualUpCase),
          BandaParaFiltrarUpCase == BandaAtualUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAnterior('') :-
  findall([Nome, BandaAtual, [], Funcao],
          artista(Nome, BandaAtual, [], Funcao),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).
buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  BandaAnteriorParaFiltrar \= '',
  findall([Nome, BandaAtual, BandasAnteriores, Funcao],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao),
          upcase_atom(BandaAnteriorParaFiltrar, BandaAnteriorParaFiltrarUpCase),
          contem(BandaAnteriorParaFiltrarUpCase, BandasAnteriores)),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorFuncao(FuncaoParaFiltrar) :-
  upcase_atom(FuncaoParaFiltrar, FuncaoParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao),
          upcase_atom(Funcao, FuncaoUpCase),
          FuncaoParaFiltrarUpCase == FuncaoUpCase),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 