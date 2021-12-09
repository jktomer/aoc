#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day8.txt", [read]),
    Cases = read_input(File),
    EasyCases = [O || {_, Os} <- Cases, O <- Os, lists:member(length(O), [2, 3, 4, 7])],
    Res = [deduce(Case) || Case <- Cases],
    io:format("~p ~B~n", [length(EasyCases), lists:sum(Res)]).

deduce({AllDigits, Outputs}) ->
    [[One], [Four], [Seven], FiveSegs, SixSegs, [Eight]] = [digits_with_size(Segs, AllDigits) || Segs <- [2, 4, 3, 5, 6, 7]],
    [Six] = [D || D <- SixSegs, length(D -- One) == 5],
    [Nine] = [D || D <- SixSegs, length(D -- Four) == 2],
    [Zero] = SixSegs -- [Six, Nine],
    [Five] = [D || D <- FiveSegs, D -- Six == []],
    [Three] = [D || D <- FiveSegs, length(D -- One) == 3],
    [Two] = FiveSegs -- [Five, Three],
    Map = #{
            Zero => 0,
            One => 1,
            Two => 2,
            Three => 3,
            Four => 4,
            Five => 5,
            Six => 6,
            Seven => 7,
            Eight => 8,
            Nine => 9
            },
    list_to_integer([maps:get(O, Map) + $0 || O <- Outputs]).

digits_with_size(Segs, AllDigits) ->
    [D || D <- AllDigits, length(D) == Segs].

read_input(File) ->
    read_input(File, []).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> read_input(File, [lists:split(10, [lists:sort(Digit) || Digit <- string:lexemes(Line, " |\n")]) | Acc]);
        eof -> Acc
    end.
