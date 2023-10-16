:- consult('artistasFiltro.pl'), consult('artistas.pl').
:- dynamic (artista/4).
:- initialization(lyricsLab).

lyricsLab :-
  writeln('\n================='),
  writeln('1. Artistas'),
  writeln('2. Bandas'),
  writeln('3. Musicas'),
  writeln('0. Sair'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  menu2(OpcaoUpper),
  lyricsLab.

menu2('1') :- 
  writeln('\n================='),
  writeln('1. Adicionar um novo artista'),
  writeln('2. Buscar artistas pelo NOME'),
  writeln('3. Buscar artistas pela BANDA ATUAL'),
  writeln('4. Buscar artistas por uma das BANDAS ANTERIORES'),
  writeln('5. Buscar artistas por FUNCAO NA BANDA'),
  writeln('0. Voltar'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoArtista(OpcaoUpper).
menu2('0') :- halt.
menu2(_) :- writeln('Opcao invalida'), sleep(2).

opcaoArtista('1') :-
  writeln('\n================='),
  write(' - Nome do artista: '),
  read(Nome),
  write(' - Banda atual: '),
  read(BandaAtual),
  write(' - Lista de bandas anteriores (separe com virgula e espaco ", " ou vazio caso nao tenha): '),
  read(BandasAnterioresString),
  splitBandasAnteriores(BandasAnterioresString, ListaBandasAnteriores),
  write(' - Funcao na banda atual: '),
  read(Funcao),
  adicionarArtista(Nome, BandaAtual, ListaBandasAnteriores, Funcao),
  writeln('Artista adicionado com sucesso!\n'),
  sleep(2),
  buscarArtistaPorNome(Nome).
opcaoArtista('2') :-
  writeln('\n================='),
  write(' - Nome do artista (serao apresentados todos os artistas de mesmo nome): '),
  read(Nome),
  buscarArtistaPorNome(Nome).
opcaoArtista('3') :-
  writeln('\n================='),
  write(' - Nome da banda atual do artista: '),
  read(BandaAtual),
  buscarArtistasPorBandaAtual(BandaAtual).
opcaoArtista('4') :-
  writeln('\n================='),
  write(' - Nome de uma das bandas anteriores do artista: '),
  read(BandaAnterior),
  buscarArtistasPorBandaAnterior(BandaAnterior).
opcaoArtista('5') :-
  writeln('\n================='),
  write(' - Funcao do artista: '),
  read(Funcao),
  buscarArtistasPorFuncao(Funcao).
opcaoArtista('0') :- lyricsLab.
opcaoArtista(_):- writeln('Opcao invalida $$$'), sleep(2), menu2('1').

adicionarArtista(Nome, BandaAtual, ListaBandasAnteriores, Funcao):-
  assertz(artista(Nome, BandaAtual, ListaBandasAnteriores, Funcao)),
  open('artistas.pl', append, Stream),
  format(string(Modelo), 'artista(\'~q\', \'~q\', ~q, \'~q\').~n', [Nome, BandaAtual, ListaBandasAnteriores, Funcao]),
  write(Stream, Modelo),
  close(Stream).

toScreen([], _, _):- writeln('\nNenhum artista para mostrar.\n'), sleep(3).
toScreen([H|[]], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), !.
toScreen([H|T], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), NovoIndice is Indice+1, toScreen(T, NovoIndice, Len).

artistaToString(Artista):-
  nth0(0, Artista, Nome),
  atom_concat(" - Nome: ", Nome, L1),
  
  nth0(1, Artista, BandaAtual),
  atom_concat(" - Banda atual: ", BandaAtual, L2),
  
  nth0(2, Artista, BandasAnteriores),
  bandasAnterioresToString(BandasAnteriores, '', STRBandasAnteriores),
  atom_concat(" - Bandas anteriores: ", STRBandasAnteriores, L3),
  
  nth0(3, Artista, Funcao),
  atom_concat(" - Funcao na banda: ", Funcao, L4),

  writeln('\n*=*=*=*=*=*=*=*=*=*'),
  writeln(L1),
  writeln(L2),
  writeln(L3),
  writeln(L4),
  writeln('*=*=*=*=*=*=*=*=*=*\n'),
  sleep(0).

bandasAnterioresToString([], Resultado, Resultado):- !.
bandasAnterioresToString([H|[]], Resultado, Retorno):- atom_concat(H, "", UltimaBanda), atom_concat(Resultado, UltimaBanda, Retorno), !.
bandasAnterioresToString([H|T], Resultado, Retorno):-
  atom_concat(H, " | ", NovaBanda),
  atom_concat(Resultado, NovaBanda, NovoResultado),
  bandasAnterioresToString(T, NovoResultado, Retorno).

splitBandasAnteriores('0', []).
splitBandasAnteriores(StringBandas, Retorno) :-
  split_string(StringBandas, ",", " ", Retorno).