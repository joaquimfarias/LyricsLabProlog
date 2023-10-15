:- consult('filtro.pl').
:- use_module(library(http/json)).
:- initialization(init).

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
  adicionarArtista([[Nome, BandaAtual, ListaBandasAnteriores, Funcao]]),
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
opcaoArtista(_):- writeln('Opcao invalida'), sleep(2), menu2('1').

adicionarArtista(DadosDoNovoArtista):- 
  artista(Artistas),
  append(Artistas, DadosDoNovoArtista, NovaListaDeArtistas),
  retract(artista(Artistas)),
  assertz(artista(NovaListaDeArtistas)).

toScreen([], _):- writeln('\nNenhum artista para mostrar.\n'), sleep(3).
toScreen([H|[]], Indice):- write(Indice), artistaToString(H), sleep(2), !.
toScreen([H|T], Indice):- write(Indice), artistaToString(H), sleep(2), NovoIndice is Indice+1, toScreen(T, NovoIndice).

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

init :-
/*
  open('artistas.txt', read, Stream),  % Abra o arquivo para leitura
  read(Stream, Artistas),  % Leia a matriz do arquivo
  close(Stream),
  assertz(artista(Artistas)).  % Feche o arquivo
  assertz(artista([['teste1', 'teste1', ['teste1', 'teste1'], 'teste1'], ['teste2', 'teste2', ['teste2', 'teste2'], 'teste2']])),
  adicionarArtista([['John Lennon', 'The Beatles', ['The Quarrymen'], 'Vocalista']]),
  adicionarArtista([['Paul McCartney', 'The Beatles', ['The Quarrymen'], 'Baixista']]),
  adicionarArtista([['George Harrison', 'The Beatles', ['The Quarrymen'], 'Guitarrista']]),
  adicionarArtista([['Ringo Starr', 'The Beatles', ['Rory Storm and the Hurricanes'], 'Baterista']]),
  adicionarArtista([['Mick Jagger', 'The Rolling Stones', [], 'Vocalista']]),
  adicionarArtista([['Keith Richards', 'The Rolling Stones', [], 'Guitarrista']]),
  adicionarArtista([['Charlie Watts', 'The Rolling Stones', [], 'Baterista']]),
  adicionarArtista([['Ronnie Wood', 'The Rolling Stones', ['Faces'], 'Guitarrista']]),
  adicionarArtista([['Freddie Mercury', 'Queen', ['Ibex', 'Wreckage'], 'Vocalista']]),
  adicionarArtista([['John Deacon', 'Queen', [], 'Baixista']]),
  adicionarArtista([['Roger Taylor', 'Queen', [], 'Baterista']]),
  adicionarArtista([['Elvis Presley', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Bob Dylan', 'Solo', ['The Band'], 'Vocalista']]),
  adicionarArtista([['David Bowie', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Jimi Hendrix', 'The Jimi Hendrix Experience', [], 'Guitarrista']]),
  adicionarArtista([['Noel Gallagher', 'Noel Gallagher\'s High Flying Birds', ['Oasis'], 'Vocalista']]),
  adicionarArtista([['Liam Gallagher', 'Liam Gallagher\'s Beady Eye', ['Oasis'], 'Vocalista']]),
  adicionarArtista([['Thom Yorke', 'Radiohead', [], 'Vocalista']]),
  adicionarArtista([['Jonny Greenwood', 'Radiohead', [], 'Guitarrista']]),
  adicionarArtista([['Colin Greenwood', 'Radiohead', [], 'Baixista']]),
  adicionarArtista([['Philip Selway', 'Radiohead', [], 'Baterista']]),
  adicionarArtista([['Kurt Cobain', 'Nirvana', [], 'Vocalista']]),
  adicionarArtista([['Dave Grohl', 'Foo Fighters', ['Nirvana'], 'Vocalista']]),
  adicionarArtista([['Krist Novoselic', 'Sweet 75', ['Nirvana'], 'Baixista']]),
  adicionarArtista([['Eddie Vedder', 'Pearl Jam', [], 'Vocalista']]),
  adicionarArtista([['Mike McCready', 'Pearl Jam', [], 'Guitarrista']]),
  adicionarArtista([['Jeff Ament', 'Pearl Jam', ['Mother Love Bone'], 'Baixista']]),
  adicionarArtista([['Matt Cameron', 'Soundgarden', ['Pearl Jam'], 'Baterista']]),
  adicionarArtista([['Chris Cornell', 'Soundgarden', ['Audioslave'], 'Vocalista']]),
  adicionarArtista([['Kim Thayil', 'Soundgarden', [], 'Guitarrista']]),
  adicionarArtista([['Ben Shepherd', 'Soundgarden', ['Hater'], 'Baixista']]),
  adicionarArtista([['Nate Mendel', 'Foo Fighters', ['Sunny Day Real Estate'], 'Baixista']]),
  adicionarArtista([['Pat Smear', 'Foo Fighters', ['Germs', 'Nirvana'], 'Guitarrista']]),
  adicionarArtista([['Taylor Hawkins', 'Foo Fighters', [], 'Baterista']]),
  adicionarArtista([['Bono', 'U2', [], 'Vocalista']]),
  adicionarArtista([['The Edge', 'U2', [], 'Guitarrista']]),
  adicionarArtista([['Adam Clayton', 'U2', [], 'Baixista']]),
  adicionarArtista([['Larry Mullen Jr.', 'U2', [], 'Baterista']]),
  adicionarArtista([['Bruce Springsteen', 'E Street Band', ['Solo'], 'Vocalista']]),
  adicionarArtista([['Clarence Clemons', 'E Street Band', [], 'Saxofonista']]),
  adicionarArtista([['Steve Van Zandt', 'E Street Band', [], 'Guitarrista']]),
  adicionarArtista([['Patti Scialfa', 'E Street Band', [], 'Vocalista']]),
  adicionarArtista([['Robert Plant', 'Led Zeppelin', [], 'Vocalista']]),
  adicionarArtista([['Jimmy Page', 'Led Zeppelin', [], 'Guitarrista']]),
  adicionarArtista([['John Paul Jones', 'Led Zeppelin', [], 'Baixista']]),
  adicionarArtista([['John Bonham', 'Led Zeppelin', [], 'Baterista']]),
  adicionarArtista([['Stevie Nicks', 'Fleetwood Mac', ['Buckingham Nicks'], 'Vocalista']]),
  adicionarArtista([['Lindsey Buckingham', 'Fleetwood Mac', ['Buckingham Nicks'], 'Guitarrista']]),
  adicionarArtista([['Christine McVie', 'Fleetwood Mac', [], 'Tecladista']]),
  adicionarArtista([['John McVie', 'Fleetwood Mac', [], 'Baixista']]),
  adicionarArtista([['Mick Fleetwood', 'Fleetwood Mac', [], 'Baterista']]),
  adicionarArtista([['Axl Rose', 'Guns N\' Roses', ['Hollywood Rose', 'L.A. Guns'], 'Vocalista']]),
  adicionarArtista([['Slash', 'Guns N\' Roses', ['Hollywood Rose'], 'Guitarrista']]),
  adicionarArtista([['Duff McKagan', 'Guns N\' Roses', ['Duff McKagan\'s Loaded', 'Velvet Revolver'], 'Baixista']]),
  adicionarArtista([['Steven Adler', 'Guns N\' Roses', ['Hollywood Rose'], 'Baterista']]),
  adicionarArtista([['Roger Waters', 'Pink Floyd', [], 'Baixista']]),
  adicionarArtista([['David Gilmour', 'Pink Floyd', [], 'Guitarrista']]),
  adicionarArtista([['Richard Wright', 'Pink Floyd', [], 'Tecladista']]),
  adicionarArtista([['Nick Mason', 'Pink Floyd', [], 'Baterista']]),
  adicionarArtista([['Roger Daltrey', 'The Who', [], 'Vocalista']]),
  adicionarArtista([['Pete Townshend', 'The Who', [], 'Guitarrista']]),
  adicionarArtista([['John Entwistle', 'The Who', [], 'Baixista']]),
  adicionarArtista([['Jim Morrison', 'The Doors', [], 'Vocalista']]),
  adicionarArtista([['Robby Krieger', 'The Doors', [], 'Guitarrista']]),
  adicionarArtista([['Ray Manzarek', 'The Doors', [], 'Tecladista']]),
  adicionarArtista([['John Densmore', 'The Doors', [], 'Baterista']]),
  adicionarArtista([['Sting', 'The Police', [], 'Baixista']]),
  adicionarArtista([['Andy Summers', 'The Police', [], 'Guitarrista']]),
  adicionarArtista([['Stewart Copeland', 'The Police', [], 'Baterista']]),
  adicionarArtista([['Johnny Cash', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Willie Nelson', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Kris Kristofferson', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Merle Haggard', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Elton John', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Bernie Taupin', 'Solo', [], 'Compositor']]),
  adicionarArtista([['Billy Joel', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['John Mellencamp', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Bob Seger', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Tom Petty', 'Tom Petty and the Heartbreakers', [], 'Vocalista']]),
  adicionarArtista([['Mike Campbell', 'Tom Petty and the Heartbreakers', [], 'Guitarrista']]),
  adicionarArtista([['Benmont Tench', 'Tom Petty and the Heartbreakers', [], 'Tecladista']]),
  adicionarArtista([['Ron Blair', 'Tom Petty and the Heartbreakers', [], 'Baixista']]),
  adicionarArtista([['Stan Lynch', 'Tom Petty and the Heartbreakers', [], 'Baterista']]),
  adicionarArtista([['Johnny Rotten', 'Sex Pistols', ['The Flowers of Romance', 'Public Image Ltd'], 'Vocalista']]),
  adicionarArtista([['Steve Jones', 'Sex Pistols', ['The Professionals'], 'Guitarrista']]),
  adicionarArtista([['Paul Cook', 'Sex Pistols', ['Man Raze'], 'Baterista']]),
  adicionarArtista([['Sid Vicious', 'Sex Pistols', ['The Flowers of Romance', 'Vicious White Kids'], 'Baixista']]),
  adicionarArtista([['Joe Strummer', 'The Clash', ['The 101ers'], 'Vocalista']]),
  adicionarArtista([['Mick Jones', 'The Clash', ['Big Audio Dynamite'], 'Guitarrista']]),
  adicionarArtista([['Paul Simonon', 'The Clash', ['Havana 3am'], 'Baixista']]),
  adicionarArtista([['Topper Headon', 'The Clash', [], 'Baterista']]),
  adicionarArtista([['Tom Waits', 'Solo', [], 'Vocalista']]),
  adicionarArtista([['Keith Moon', 'The Who', [], 'Baterista']]),
  adicionarArtista([['Ray Davies', 'The Kinks', [], 'Vocalista']]),
  adicionarArtista([['Dave Davies', 'The Kinks', [], 'Guitarrista']]),
  adicionarArtista([['Mick Avory', 'The Kinks', ['The Kast Off Kinks'], 'Baterista']]),
  adicionarArtista([['Peter Gabriel', 'Genesis', ['Solo'], 'Vocalista']]),
  adicionarArtista([['Phil Collins', 'Genesis', ['Solo'], 'Baterista']]),
  adicionarArtista([['Tony Banks', 'Genesis', [], 'Tecladista']]),
  adicionarArtista([['Mike Rutherford', 'Genesis', ['Mike + The Mechanics'], 'Baixista']]),
  adicionarArtista([['Peter Frampton', 'Humble Pie', ['The Herd'], 'Vocalista']]),
  adicionarArtista([['Steve Marriott', 'Humble Pie', ['Small Faces'], 'Guitarrista']]),
  adicionarArtista([['Greg Ridley', 'Humble Pie', ['Spooky Tooth'], 'Baixista']]),
  adicionarArtista([['Jerry Shirley', 'Humble Pie', [], 'Baterista']]),
  adicionarArtista([['Freddy Mercury', 'Queen', [], 'Vocalista']]),
  adicionarArtista([['Brian May', 'Queen', [], 'Guitarrista']]),
  artista(Artistas),
  open('artistas.txt', write, Stream),
  write(Stream, Artistas),
  close(Stream),
  writeln("******************"),
  writeln('Dados carregados'),
  writeln("******************"),
  lyricsLab.*/