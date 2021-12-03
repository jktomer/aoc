#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day3.txt", [read]),
    Lines = read_lines(File),
    Width = length(hd(Lines)),
    {Gamma, Epsilon} = part1(Width, Lines),
    io:format("~B * ~B = ~B~n", [Gamma, Epsilon, Gamma * Epsilon]),
    [Oxy, CO2] = part2(Width, [list_to_integer(L, 2) || L <- Lines]),
    io:format("~B * ~B = ~B~n", [Oxy, CO2, Oxy * CO2]).

part1(Width, Lines) ->
    Counts = lists:foldl(fun gamma/2, [0 || _ <- lists:seq(1, Width)], Lines),
    GammaBits = [if C < length(Lines) / 2 -> $0; true -> $1 end || C <- Counts],
    Gamma = list_to_integer(GammaBits, 2),
    {Gamma, (1 bsl Width) - Gamma - 1}.

gamma(Str, Counts) ->
    [C + S - $0 || {S, C} <- lists:zip(Str, Counts)].

part2(Width, Nums) ->
    [part2(lists:sort(Nums), 1 bsl (Width-1), PreferCommon) || PreferCommon <- [true, false]].

part2([N], _, _) -> N;
part2(Nums, Mask, PreferCommon) ->
    MoreOnes = lists:nth(length(Nums) div 2 + 1, Nums) band Mask =/= 0,
    PreferZero = MoreOnes xor PreferCommon,
    part2([N || N <- Nums, (N band Mask == 0) == PreferZero], Mask bsr 1, PreferCommon).

read_lines(File) ->
    lists:reverse(read_lines(File, [])).

read_lines(File, Acc) ->
    case file:read_line(File) of
        eof -> Acc;          
        {ok, Line} -> read_lines(File, [string:trim(Line) | Acc])
    end.
