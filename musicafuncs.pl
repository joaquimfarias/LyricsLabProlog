:- use_module(library(csv)).
:-dynamic(musica/9).
:-initialization(carregaMusicas).

carregaMusicas :- 
    consult('musicas.pl'), consult('util.pl').

%Area CRUD

salvarMusicas :-
    open('musicas.pl', write, Stream),
    forall(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
           format(Stream, 'musica(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n', 
                  [Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao])),
    close(Stream).

adicionaMusica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    calculaId(Id),
    asserta(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)),
    salvarMusicas.
adicionaMusica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    asserta(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)),
    salvarMusicas.

calculaId(IdASerGerado) :-
    todasAsMusicas(Musicas),
    maiorId(Musicas, MaiorId),
    Resultado is MaiorId + 1,
    IdASerGerado = Resultado.

maiorId([], 1).
maiorId([musica(Id, _, _, _, _, _, _, _, _)], Id).
maiorId([musica(Id, _, _, _, _, _, _, _, _) | T], MaiorId) :-
    maiorId(T, MaiorResto),
    (Id > MaiorResto -> MaiorId = Id; MaiorId = MaiorResto).

selecionaMusica(Id, R) :-
 musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),R = musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao).


deletaMusica(Id):- 
 selecionaMusica(Id, Musica),
 retract(Musica),
 salvarMusicas.


atualizaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao):-
 deletaMusica(Id),
 adicionaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao).


%Area filtros

musicasPorArtista(Artista, Resultado) :- % Retorna todas as musicas que tem o artista passado como participante dela.
    todasAsMusicas(Musicas),
    upperCase(Artista, ArtistaUper),
    recuperaMusicasComArtista(ArtistaUper, Musicas, Resultado).

recuperaMusicasComArtista(_, [], []).
recuperaMusicasComArtista(Artista, [musica(Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao) | T], [[Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao] | Resultado]) :-
    estaDentro(Participantes, Artista),
    recuperaMusicasComArtista(Artista, T, Resultado).
recuperaMusicasComArtista(Artista, [_|T], Resultado) :-
    recuperaMusicasComArtista(Artista, T, Resultado).


musicasPorBanda(Banda, Resultado) :- %Recupera Musicas que tem a mesma Banda.
    todasAsMusicas(Musicas),
    recuperaMusicasComBanda(Banda, Musicas, Resultado).


recuperaMusicasComBanda(_, [], []).
recuperaMusicasComBanda(Banda, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    ehDoMesmoJeito(Banda, NomeBanda),
    recuperaMusicasComBanda(Banda, T, Resultado).
recuperaMusicasComBanda(Banda, [_ | T], Resultado) :-
    recuperaMusicasComBanda(Banda, T, Resultado).



    

%Filtros de musica

filtroMusicasPorTrecho(Trecho, Resultado) :- %Filtra musicas que tem coincidencia da letra com o trecho
    todasAsMusicas(Musicas), 
    filtroMusicasPorTrecho2(Trecho, Musicas, Resultado).

filtroMusicasPorTrecho2(_, [], []).
filtroMusicasPorTrecho2(Trecho, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    temCoincidencia(Trecho  , Letra),
    filtroMusicasPorTrecho2(Trecho, T, Resultado).
filtroMusicasPorTrecho2(Trecho, [_| T], Resultado) :-
    filtroMusicasPorTrecho2(Trecho, T, Resultado).


filtroMusicasPorRitmo(Ritmo, Resultado) :- % Filtra musicas que tem o mesmo ritmo.
    todasAsMusicas(Musicas),
    filtroMusicasPorRitmo2(Ritmo, Musicas, Resultado).

filtroMusicasPorRitmo2(_, [], []).
filtroMusicasPorRitmo2(Ritmo2, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    ehDoMesmoJeito(Ritmo2, Ritmo),
    filtroMusicasPorRitmo2(Ritmo2, T, Resultado).
filtroMusicasPorRitmo2(Ritmo, [_ | T], Resultado):-
    filtroMusicasPorRitmo2(Ritmo, T, Resultado).




filtrarMusicasInstrumento(Instrumento, Resultado) :- % Filtra musicas que tem o mesmo instrumento.
    todasAsMusicas(Musicas),
    upperCase(Instrumento, Aumentado),
    filtrarMusicasInstrumento2(Aumentado, Musicas, Resultado).

filtrarMusicasInstrumento2(_, [], []).
filtrarMusicasInstrumento2(Instrumento,[musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    estaDentro(Instrumentos, Instrumento),
    filtrarMusicasInstrumento2(Instrumento, T, Resultado).
filtrarMusicasInstrumento2(Instrumento, [_ | T], Resultado):-
    filtrarMusicasInstrumento2(Instrumento, T, Resultado).


filtroMusicasPorNome(Nome, Resultado) :- % Filtra musicas que tem coincidencia nome.
    todasAsMusicas(Musicas),
    filtroMusicasPorNome2(Nome, Musicas, Resultado).

filtroMusicasPorNome2(_, [], []).
filtroMusicasPorNome2(Nome2, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    temCoincidencia(Nome2, Nome),
    filtroMusicasPorNome2(Nome2, T, Resultado).
filtroMusicasPorNome2(Nome2, [_ | T], Resultado):-
    filtroMusicasPorNome2(Nome2, T, Resultado).


%Micelaneas.

printarMusicas :-
    todasAsMusicas(Musicas),
    write(Musicas).


todasAsMusicas(Musicas) :- 
    findall(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            Musicas).


%Funcoes Auxiliares.

temCoincidencia(String1, String2) :- %Verifica se a primeira string esta contida na segunda.
    upperCase(String1, String11),
    upperCase(String2, String22),
    atom_chars(String11, String1Formatada),
    atom_chars(String22, String2Formatada),
    temCoincidencia2(String1Formatada, String2Formatada, String1Formatada).

temCoincidencia2([], _, _). 

temCoincidencia2([_ | _], [_ | T2], Clone) :-
    temCoincidencia2(Clone, T2, Clone).

temCoincidencia2([H | T], [H | T2], Clone) :-
    temCoincidencia2(T, T2, Clone).


ehDoMesmoJeito(String1, String2) :-
    upperCase(String1, R1),
    upperCase(String2, R2),
    ehIgual(R1, R2).

ehIgual(String, String).


estaDentro([X], Y):- upperCase(X, UperX), UperX = Y.
estaDentro([X | _], Y):- upperCase(X, UperX), UperX = Y.
estaDentro([_ | T], Y):-
    estaDentro(T, Y).

ln :- write('\n').

exibirMusica(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)) :- %Exibicao de musicas
    writeln("============================"),
    write("Id: "), write(Id),
    ln,
    write("Nome: "), write(Nome),
    ln,
    write("Instrumentos: "), write(Instrumentos),
    ln,
    write("Participantes: "), write(Participantes),
    ln,
    write("Ritmo: "), write(Ritmo),
    ln,
    write("Data de lancamento: "), write(DataLancamento),
    ln,
    write("Letra: "), write(Letra),
    ln,
    write("Nome da banda: "), write(NomeBanda),
    ln,
    write("Avaliacao: "), write(Avaliacao),
    ln,
    writeln("============================").


exibirMusicas([]). %Exibicao de varias musicas.
exibirMusicas([H | T]) :-
    exibirMusica(H),
    exibirMusicas(T).
    