main :-
  assertz(artista([['teste1', 'teste1', ['teste1', 'teste1'], 'teste1'], ['teste2', 'teste2', ['teste2', 'teste2'], 'teste2']])),
  adicionarArtista([['Jao do pao', 'Banda padaria', ['Banda do trigo', 'Banda do fermento'], 'Padeiro']]),
  adicionarArtista([['Juse do pao', 'Banda padaria', ['Banda do trigo', 'Banda do fermento', 'Banda do acucar'], 'Batedor de massa']]),
  adicionarArtista([['Maria do pao', 'Banda pao de forma', ['Banda padaria', 'Banda do trigo', 'Banda do fermento', 'Banda do acucar'], 'PaDeiro']]),
  buscarArtistasPorBandaAnterior('Banda padaria', ArtistasFiltrados),
  writeln(ArtistasFiltrados), halt.

adicionarArtista(DadosDoNovoArtista):- 
  artista(Artistas),
  append(Artistas, DadosDoNovoArtista, NovaListaDeArtistas),
  retract(artista(Artistas)),
  assertz(artista(NovaListaDeArtistas)).

buscarArtistaPorNome(NomeParaFiltrar, ArtistasFiltrados) :-
  artista(Artistas),
  filtrarPor(NomeParaFiltrar, 0, Artistas, [], ArtistasFiltrados).

buscarArtistasPorBandaAtual(BandaParaFiltrar, ArtistasFiltrados) :-
  artista(Artistas),
  filtrarPor(BandaParaFiltrar, 1, Artistas, [], ArtistasFiltrados).

buscarArtistasPorFuncao(FuncaoParaFiltrar, ArtistasFiltrados) :-
  artista(Artistas),
  filtrarPor(FuncaoParaFiltrar, 3, Artistas, [], ArtistasFiltrados).

buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar, ArtistasFiltrados) :-
  artista(Artistas),
  filtrarPor(BandaAnteriorParaFiltrar, 2, Artistas, [], ArtistasFiltrados).

filtrarPor(_, _, [], ListaResultado, ListaResultado).
filtrarPor(ParametroDeFiltro, 2, [H|T], ListaResultado, Retorno) :-
  nth0(2, H, ListaDeBandas),
  contem(ParametroDeFiltro, ListaDeBandas),
  append([H], ListaResultado, NovaListaResultado),
  filtrarPor(ParametroDeFiltro, 2, T, NovaListaResultado, Retorno).
filtrarPor(ParametroDeFiltro, 2, [_|T], ListaResultado, Retorno):- filtrarPor(ParametroDeFiltro, 2, T, ListaResultado, Retorno).
filtrarPor(ParametroDeFiltro, Indice, [H|T], ListaResultado, Retorno):-
  nth0(Indice, H, R),
  upperCase(R, UpperR),
  upperCase(ParametroDeFiltro, UpperParametro),
  UpperParametro == UpperR,
  append([H], ListaResultado, NovaListaResultado),
  filtrarPor(ParametroDeFiltro, Indice, T, NovaListaResultado, Retorno).
filtrarPor(ParametroDeFiltro, Indice, [_|T], ListaResultado, Retorno):-
  filtrarPor(ParametroDeFiltro, Indice, T, ListaResultado, Retorno).

upperCase(String, Uppercase) :-
    atom_string(Atom, String),
    upcase_atom(Atom, Uppercase).

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 