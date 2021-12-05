#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day5.txt", [read]),
    Lines = read_lines(File),
    io:format("~B ~B~n", [count_crossings(Lines, false), count_crossings(Lines, true)]).

count_crossings(Lines, CountDiags) ->
    AllSpots = lists:sort(lists:flatten([vent_spots(L, CountDiags) || L <- Lines])),
    {_, _, Crossings} = 
        lists:foldl(fun(Spot, {Spot, false, Crossings}) -> {Spot, true, Crossings+1};
                       (Spot, {Spot, true, _} = S) -> S;
                       (Spot, {_, _, Crossings}) -> {Spot, false, Crossings}
                    end, {undefined, false, 0}, AllSpots),
    Crossings.

vent_spots({X0, Y0, X1, Y1}, CountDiags) ->
    Length = max(abs(X1 - X0), abs(Y1 - Y0)),
    if
        X0 == X1; Y0 == Y1; CountDiags ->
            SX = if X0 < X1 -> 1; X0 == X1 -> 0; true -> -1 end,
            SY = if Y0 < Y1 -> 1; Y0 == Y1 -> 0; true -> -1 end,
            [{X0 + SX * I, Y0 + SY * I} || I <- lists:seq(0, Length)];
        true ->
            []
    end.

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
