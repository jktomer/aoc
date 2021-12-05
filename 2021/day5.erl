#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day5.txt", [read]),
    Lines = read_lines(File),
    io:format("~B ~B~n", [count_crossings(Lines, false), count_crossings(Lines, true)]).

count_crossings(Lines, CountDiags) ->
    Counts = lists:foldl(fun(Line, Acc) -> count_vents(Line, CountDiags, Acc) end, #{}, Lines),
    length(lists:filter(fun(V) -> V > 1 end, maps:values(Counts))).

count_vents({X0, Y0, X1, Y1}, CountDiags, Counts) ->
    Spots =
        if
            X0 == X1 ->
                [{X0, Y} || Y <- lists:seq(min(Y0, Y1), max(Y0, Y1))];
            Y0 == Y1 ->
                [{X, Y0} || X <- lists:seq(min(X0, X1), max(X0, X1))];
            CountDiags ->
                SX = case X0 < X1 of true -> 1; false -> -1 end,
                SY = case Y0 < Y1 of true -> 1; false -> -1 end,
                [{X0 + SX * I, Y0 + SY * I} || I <- lists:seq(0, max(X0, X1) - min(X0, X1))];
            true ->
                []
        end,
    lists:foldl(
                fun(Coord, CountsAcc) ->
                        maps:update_with(Coord, fun(X) -> X+1 end, 1, CountsAcc)
                end,
                Counts, Spots).

read_lines(File) ->
    read_lines(File, []).

read_lines(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            read_lines(File, [parse_line(Line) | Acc]);
        eof ->
            Acc
    end.

parse_line(Line) ->
    {X0, Y0, Rest0} = parse_coord(Line),
    {" -> ", Rest1} = lists:split(4, Rest0),
    {X1, Y1, "\n"} = parse_coord(Rest1),
    {X0, Y0, X1, Y1}.

parse_coord(Line) ->
    {X, Rest0} = string:to_integer(Line),
    {",", Rest1} = lists:split(1, Rest0),
    {Y, Rest} = string:to_integer(Rest1),
    {X, Y, Rest}.
