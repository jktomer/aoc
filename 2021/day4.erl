#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day4.txt", [read]),
    {Sequence, Boards} = parse(File),
    Index = maps:from_list(lists:zip(Sequence, lists:seq(1, length(Sequence)))),
    {WinTurn, WinBoard} = check_boards(Index, Boards, true),
    WinScore = score_board(Sequence,Index, WinTurn, WinBoard),
    {LoseTurn, LoseBoard} = check_boards(Index, Boards, false),
    LoseScore = score_board(Sequence,Index, LoseTurn, LoseBoard),
    io:format("~B ~B~n", [WinScore, LoseScore]).

score_board(Sequence, Index, WinTurn, Board) ->
    Unmarked = [N || N <- lists:flatten(Board), maps:get(N, Index, infinity) > WinTurn],
    lists:sum(Unmarked) * lists:nth(WinTurn, Sequence).

check_boards(Index, Boards, PlayToWin) ->
    Start = case PlayToWin of
                true -> infinity;
                false -> -1
            end,
    lists:foldl(fun(Board, Acc) -> check_board(Index, Board, PlayToWin, Acc) end, {Start, undefined}, Boards).

check_board(Index, Board, PlayToWin, {Best, _} = Acc) ->
    Cols = [[lists:nth(N, Row) || Row <- Board] || N <- lists:seq(1, length(Board))],
    WinTurn = lists:foldl(fun(Row, Turn) -> check_row(Index, Row, Turn) end, infinity, Board ++ Cols),
    case WinTurn < Best of
        PlayToWin ->
            {WinTurn, Board};
        _ ->
            Acc
    end.

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
        {ok, Row} ->
            [Board | Boards] = Acc,
            read_boards(File, [[[list_to_integer(N) || N <- string:split(string:trim(Row), " ", all), N =/= ""] | Board] | Boards]);
        eof ->
            Acc
    end.
