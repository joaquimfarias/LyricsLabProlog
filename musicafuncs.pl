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

% - Melhores musicas artista, recebe o nome do artista e o top musicas(um inteiros que representa as n melhores musicas).


mediaMusicasArtista(Artista, Media) :- 
    todasAsMusicas(Musicas),
    mediaArtista(Musicas, Artista, 0, Media).

mediaArtista([musica(_,_,_,Participantes,_,_,_,_,_)], Artista, Resultado, Resultado):-
    not(temEsseArtista(Participantes, Artista)).
mediaArtista([musica(_, _, _, Participantes, _, _, _, _, _) | T], Artista, Soma, Media) :-
    not(temEsseArtista(Participantes, Artista)),
    mediaArtista(T, Artista, Soma, Media).
mediaArtista([musica(_, _, _, Participantes, _, _, _, _, Avaliacao)], Artista, Soma, Media):- 
    temEsseArtista(Participantes, Artista),
    Resultado is Soma + Avaliacao,
    Media = Resultado.
mediaArtista([musica(_, _, _, Participantes, _, _, _, _, Avaliacao) | T], Artista, Soma, Media) :-
    temEsseArtista(Participantes, Artista),
    Resultado is Soma + Avaliacao,
    mediaArtista(T, Artista, Resultado, Media).

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