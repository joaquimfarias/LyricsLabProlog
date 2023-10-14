:-dynamic(musica/8).



adicionaMusica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    asserta(musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)).

selecionaMusica(Id, R) :-
 musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
 R = musica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) .







 %adicionaMusica("Nome2", ["Instrumentos"], ["Participantes"], "Rimo", "32", "Letra", "NomeBanda", 3).