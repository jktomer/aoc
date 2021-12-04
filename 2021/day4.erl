#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day4.txt", [read]),
    {Sequence, Boards} = parse(File),
    Index = maps:from_list(lists:zip(Sequence, lists:seq(1, length(Sequence)))),
    Scores = [score_board(Sequence, Index, Board) || Board <- Boards],
    {_WinTurn, WinScore} = lists:min(Scores),
    {_LoseTurn, LoseScore} = lists:max(Scores),
    io:format("~B ~B~n", [WinScore, LoseScore]).

score_board(Sequence, Index, Board) ->
    WinTurn = win_turn(Index, Board),
    Unmarked = [N || N <- lists:flatten(Board), maps:get(N, Index, infinity) > WinTurn],
    {WinTurn, lists:sum(Unmarked) * lists:nth(WinTurn, Sequence)}.

win_turn(Index, Board) ->
    Cols = [[lists:nth(N, Row) || Row <- Board] || N <- lists:seq(1, length(Board))],
    lists:foldl(fun(Row, Turn) -> check_row(Index, Row, Turn) end, infinity, Board ++ Cols).

check_row(Index, Row, Best) ->
    min(Best, lists:max([maps:get(N, Index, infinity) || N <- Row])).

parse(File) ->
    {ok, Sequence0} = file:read_line(File),
    Sequence = [list_to_integer(N) || N <- string:split(string:trim(Sequence0), ",", all)],
    Boards = read_boards(File),
    {Sequence, Boards}.

read_boards(File) ->
    read_boards(File, []).

read_boards(File, Acc) ->
    case file:read_line(File) of
        {ok, "\n"} ->
            read_boards(File, [[] | Acc]);
        {ok, Line} ->
            [Board | Boards] = Acc,
            Row = [list_to_integer(N) || N <- string:split(string:trim(Line), " ", all), N =/= ""],
            Board1 = [Row | Board],
            read_boards(File, [Board1 | Boards]);
        eof ->
            Acc
    end.
