:- consult('artistas.pl').
:- dynamic (artista/4).

lenArtistas(X) :-
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          TodosOsArtistas),
  length(TodosOsArtistas, X).

buscarArtistaPorNome(NomeParaFiltrar) :-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  upcase_atom(BandaParaFiltrar, BandaParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(BandaAtual, BandaAtualUpCase),
          BandaParaFiltrarUpCase == BandaAtualUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAnterior('') :-
  findall([Nome, BandaAtual, [], Funcoes, _],
          artista(Nome, BandaAtual, [], Funcoes, _),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  toScreen(ArtistasFiltrados, 1, Len).
buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  BandaAnteriorParaFiltrar \= '',
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
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

setArtista(Nome, BandaAtual, ListaBandasAnteriores, Funcoes):-
  writeln('entrou'),
  open('artistas.pl', append, Stream),
  lenArtistas(X),
  Id is X + 1,
  assertz(artista(Nome, BandaAtual, ListaBandasAnteriores, Funcoes, Id)),
  format(string(Modelo), 'artista(\"~q\", \"~q\", ~q, ~q, ~q).~n', [Nome, BandaAtual, ListaBandasAnteriores, Funcoes, Id]),
  writeln(Modelo),
  write(Stream, Modelo),
  close(Stream).

artistaValido(Id, Nome) :- 
  artista(ANome, _, _, _, Id),
  upperCase(Nome, NomeUp),
  upperCase(ANome, ANomeUp),
  NomeUp == ANomeUp.

removerBandaAtual(Id) :-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  BandaAtual \= '',
  append([BandaAtual], BandasAnteriores, NovaBandasAnteriores),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, '', NovaBandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.
removerBandaAtual(_).

atualizarBandaAtual(Id, NovaBandaAtual):-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  BandaAtual \= '',
  append([BandaAtual], BandasAnteriores, NovaBandasAnteriores),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, NovaBandaAtual, NovaBandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.
atualizarBandaAtual(Id, NovaBandaAtual):-
  artista(Nome, _, BandasAnteriores, Funcoes, Id),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, NovaBandaAtual, BandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.

upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 

naoContemArtista(NomeParaFiltrar):-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, 0).