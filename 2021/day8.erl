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
    [[One], [Four], [Seven], [Eight]] = [digits_with_size(Segs, AllDigits) || Segs <- [2, 4, 3, 7]],
    [Top] = Seven -- One,
    FiveSeg = digits_with_size(5, AllDigits),
    CenterCol = [Seg || Seg <- hd(FiveSeg), lists:all(fun(D) -> lists:member(Seg, D) end, tl(FiveSeg))],
    CB = CenterCol -- [Top],
    [Bottom] = CB -- Four,
    [Center] = CB -- [Bottom],
    [UL] = (Four -- [Center]) -- One,
    [Five] = [D || D <- FiveSeg, lists:member(UL, D)],
    [Two] = [D || D <- FiveSeg, length(D -- Five) == 2],
    [Three] = FiveSeg -- [Two, Five],
    [UR] = Four -- Five,
    [LL] = Two -- Three,
    [LR] = Three -- Two,
    Six = lists:sort([Top, UL, Center, LL, LR, Bottom]),
    Zero = lists:sort([Top, UL, UR, LL, LR, Bottom]),
    Nine = lists:sort([Top, UL, UR, Center, LR, Bottom]),
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
