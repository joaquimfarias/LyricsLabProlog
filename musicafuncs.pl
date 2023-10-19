:- use_module(library(csv)).
:-dynamic(musica/9).
:-initialization(carregaMusicas).

carregaMusicas :- 
    consult('musicas.pl').

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
    recuperaMusicasComArtista(Artista, Musicas, Resultado).

recuperaMusicasComArtista(_, [], []).
recuperaMusicasComArtista(Artista, [musica(Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao) | T], [musica(Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao) | Resultado]) :-
    temEsseArtista(Participantes, Artista),
    recuperaMusicasComArtista(Artista, T, Resultado).
recuperaMusicasComArtista(Artista, [_|T], Resultado) :-
    recuperaMusicasComArtista(Artista, T, Resultado).


musicasPorBanda(Banda, Resultado) :- %Recupera Musicas que tem a mesma Banda.
    todasAsMusicas(Musicas),
    recuperaMusicasComBanda(Banda, Musicas, Resultado).


recuperaMusicasComBanda(_, [], []).
recuperaMusicasComBanda(Banda, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    bandaEIgual(Banda, NomeBanda),
    recuperaMusicasComBanda(Banda, T, Resultado).
recuperaMusicasComBanda(Banda, [_ | T], Resultado) :-
    recuperaMusicasComBanda(Banda, T, Resultado).


bandaEIgual(Banda, Banda).

temEsseArtista([Artista], Artista).
temEsseArtista([Artista | _], Artista).
temEsseArtista([_ | T], Artista):-
    temEsseArtista(T, Artista).
    







%Micelaneas.

printarMusicas :-
    todasAsMusicas(Musicas),
    write(Musicas).


todasAsMusicas(Musicas) :- 
    findall(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            Musicas).