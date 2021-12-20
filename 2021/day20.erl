#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day20.txt", [read]),
    {Algo, Image} = read_input(File),
    {Part1, 0} = step(Algo, step(Algo, {Image, 0})),
    {Part2, 0} = lists:foldl(fun(_, Acc) -> step(Algo, Acc) end, {Part1, 0}, lists:seq(3, 50)),
    io:format("~p ~p~n", [count(Part1), count(Part2)]).

count(Img) ->
    lists:sum([lists:sum([B band 1 || B <- Row]) || Row <- Img]).

step(Algo, {Img, Vastness}) ->
    Width = length(hd(Img)),
    Height = length(Img),
    VIn = (512 - Vastness) rem 512,
    <<_:VIn, Vastness1:1, _/bits>> = Algo,
    Img1 = [[compute(Algo, Img, Vastness, Y, X) || X <- lists:seq(0, Width+1) ] || Y <- lists:seq(0, Height + 1) ],
    {Img1, Vastness1}.

compute(Algo, Img, Vastness, Y, X) ->
    <<Input:9>> = << <<B:1>> || B <- fetch_section(Img, Vastness, Y, X) >>,
    <<_:Input, O:1, _/bits>> = Algo,
    O.

fetch_section(Img, Vastness, Y, X) ->
    [fetch_bit(Img, Vastness, YY, XX) || YY <- lists:seq(Y-1, Y+1), XX <- lists:seq(X-1, X+1)].

fetch_bit(Img, Vastness, Y, X) when X =< 0 orelse Y =< 0 orelse Y > length(Img) orelse X > length(hd(Img)) ->
    Vastness;
fetch_bit(Img, _, Y, X) ->
    lists:nth(X, lists:nth(Y, Img)) band 1.

read_input(File) ->
    {ok, AlgoStr} = file:read_line(File),
    Algo = << <<B:1>> || B <- string:chomp(AlgoStr) >>,
    {ok, "\n"} = file:read_line(File),
    Image = lists:reverse(read_input(File, [])),
    {Algo, Image}.

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            read_input(File, [string:chomp(Line) | Acc]);
        eof -> 
            Acc
    end.
