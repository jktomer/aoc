#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day13.txt", [read]),
    {Dots, Folds} = read_input(File),
    Dots1 = fold(hd(Folds), Dots),
    io:format("~B~n", [maps:size(Dots1)]),
    Dots2 = lists:foldl(fun fold/2, Dots1, tl(Folds)),
    write_dots(Dots2).

write_dots(Dots) ->
    {W, H} = maps:fold(fun({X, Y}, _, {W, H}) -> {max(X, W), max(Y, H)} end, {0, 0}, Dots),
    [io:format("~s~n", [[maps:get({X, Y}, Dots, $ ) || X <- lists:seq(0, W)]]) || Y <- lists:seq(0, H)].

fold(Instruction, Dots) ->
    maps:fold(fun(Dot, _, Acc) -> Acc#{fold_impl(Dot, Instruction) => $#} end, #{}, Dots).

fold_impl({X, Y}, {x, XF}) when X > XF ->
    {XF * 2 - X, Y};
fold_impl({X, Y}, {y, YF}) when Y > YF ->
    {X, YF * 2 - Y};
fold_impl(Pt, _) ->
    Pt.

read_input(File) ->
    Dots = read_dots(File, #{}),
    Folds = lists:reverse(read_folds(File, [])),
    {Dots, Folds}.

read_dots(File, Acc) ->
    case file:read_line(File) of
        {ok, "\n"} -> 
            Acc;
        {ok, Line} ->
            Line1 = string:chomp(Line),
            [X, Y] = [list_to_integer(N) || N <- string:split(Line1, ",")],
            read_dots(File, Acc#{{X, Y} => $#})
    end.

read_folds(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            {_, Inst} = lists:split(length("fold along "), string:chomp(Line)),
            [Axis, $= | Rest] = Inst,
            read_folds(File, [{list_to_atom([Axis]), list_to_integer(Rest)} | Acc]);
        eof ->
            Acc
    end.
