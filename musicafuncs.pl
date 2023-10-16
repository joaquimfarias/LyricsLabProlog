:- use_module(library(csv)).
:-dynamic(musica/8).
:-initialization(carregaMusicas).

carregaMusicas :- 
    consult('musicas.pl').


salvarMusicas :-
    open('musicas.pl', write, Stream),
    forall(musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
           format(Stream, 'musica(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n', 
                  [Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao])),
    close(Stream).

adicionaMusica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    asserta(musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)),
    salvarMusicas.

selecionaMusica(Id, R) :-
 musica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),R = musica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao).


deletaMusica(Id):- 
 selecionaMusica(Id, Musica),
 retract(Musica),
 salvarMusicas.


atualizaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao):-
 deletaMusica(Id),
 adicionaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao).











printarMusicas :-
    findall((Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            Musicas),
    printaElas(Musicas).







 %adicionaMusica('Nome3', ['Instrumentos1'], ['Participantes1'], 'Rimo1', '32', 'Letra', 'NomeBanda', 4).