:- consult('artistas.pl').
:- dynamic (artista/4).

lenArtistas(X) :-
  findall([Nome, BandaAtual, BandasAnteriores, Funcao, _],
          artista(Nome, BandaAtual, BandasAnteriores, Funcao, _),
          TodosOsArtistas),
  length(TodosOsArtistas, X).

buscarArtistaPorNome(NomeParaFiltrar) :-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  writeln(ArtistasFiltrados),
  writeln(NomeParaFiltrar),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  upcase_atom(BandaParaFiltrar, BandaParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao, _),
          upcase_atom(BandaAtual, BandaAtualUpCase),
          BandaParaFiltrarUpCase == BandaAtualUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAnterior('') :-
  findall([Nome, BandaAtual, [], Funcao, _],
          artista(Nome, BandaAtual, [], Funcao, _),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).
buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  BandaAnteriorParaFiltrar \= '',
  findall([Nome, BandaAtual, BandasAnteriores, Funcao, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao, _),
          upcase_atom(BandaAnteriorParaFiltrar, BandaAnteriorParaFiltrarUpCase),
          contem(BandaAnteriorParaFiltrarUpCase, BandasAnteriores)),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorFuncao(FuncoesParaFiltrar) :-
  upcase_atom(FuncoesParaFiltrar, FuncoesParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          contem(FuncoesParaFiltrarUpCase, Funcoes)),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

setArtista(Nome, BandaAtual, ListaBandasAnteriores, Funcao):-
  open('artistas.pl', append, Stream),
  lenArtistas(X),
  Id is X + 1,
  assertz(artista(Nome, BandaAtual, ListaBandasAnteriores, Funcao, Id)),
  format(string(Modelo), 'artista(\"~q\", \"~q\", ~q, ~q, ~q).~n', [Nome, BandaAtual, ListaBandasAnteriores, Funcao, Id]),
  write(Stream, Modelo),
  close(Stream).

upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 

naoContemArtista(NomeParaFiltrar):-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcao, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcao, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, 0).