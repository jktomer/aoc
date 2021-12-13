#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day13.txt", [read]),
    {Dots, W, H, Folds} = read_input(File),
    {Dots1, W1, H1} = fold(hd(Folds), {Dots, W, H}),
    io:format("~B~n", [maps:size(Dots1)]),
    {Dots2, W2, H2} = lists:foldl(fun fold/2, {Dots1, W1, H1}, tl(Folds)),
    write_dots(W2, H2, Dots2).

write_dots(W, H, Dots) ->
    [io:format("~s~n", [[maps:get({X, Y}, Dots, $ ) || X <- lists:seq(0, W-1)]]) || Y <- lists:seq(0, H-1)].

fold(Instruction, {Dots, W, H}) ->
    Dots1 = maps:fold(fun(Dot, _, Acc) -> Acc#{fold_impl(Dot, Instruction) => $#} end, #{}, Dots),
    {W1, H1} = fold_dims(W, H, Instruction),
    {Dots1, W1, H1}.

fold_dims(_, H, {x, XF}) ->
    {XF, H};
fold_dims(W, _, {y, YF}) ->
    {W, YF}.

fold_impl({X, Y}, {x, XF}) when X > XF ->
    {XF * 2 - X, Y};
fold_impl({X, Y}, {y, YF}) when Y > YF ->
    {X, YF * 2 - Y};
fold_impl(Pt, _) ->
    Pt.

read_input(File) ->
    {Dots, W, H} = read_dots(File, 0, 0, #{}),
    Folds = lists:reverse(read_folds(File, [])),
    {Dots, W, H, Folds}.

read_dots(File, W, H, Acc) ->
    case file:read_line(File) of
        {ok, "\n"} -> 
            {Acc, W, H};
        {ok, Line} ->
            Line1 = string:chomp(Line),
            [X, Y] = [list_to_integer(N) || N <- string:split(Line1, ",")],
            read_dots(File, max(W, X+1), max(H, Y+1), Acc#{{X, Y} => $#})
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
