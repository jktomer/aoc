#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day14.txt", [read, binary]),
    {Pairs, Rules} = read_input(File),
    Part1 = lists:foldl(fun(_, Acc) -> pair_insert(Acc, Rules) end, Pairs, lists:seq(1, 10)),
    Part2 = lists:foldl(fun(_, Acc) -> pair_insert(Acc, Rules) end, Part1, lists:seq(11, 40)),
    io:format("~p ~p~n", [result(Part1), result(Part2)]).

result(Pairs) ->
    Freq = maps:fold(fun({K, _}, V, Map) -> maps:update_with(K, fun(C) -> V+C end, V, Map) end, #{}, Pairs),
    FreqInv = lists:sort([{V, K} || {K, V} <- maps:to_list(Freq)]),
    {Least, _} = hd(FreqInv),
    {Most, _} = lists:last(FreqInv),
    Most - Least.

pair_insert(Pairs, Rules) ->
    maps:fold(fun(K, V, Acc) -> pair_insert(K, V, Rules, Acc) end, #{}, Pairs).

pair_insert({A, B}, Count, Rules, Acc) ->
    Update = fun(V) -> V + Count end,
    case Rules of
        #{{A, B} := C} ->
            Acc1 = maps:update_with({A, C}, Update, Count, Acc),
            maps:update_with({C, B}, Update, Count, Acc1);
        _ ->
            maps:update_with({A, B}, Update, Count, Acc)
    end.

read_input(File) ->
    {ok, Start} = file:read_line(File),
    {ok, <<"\n">>} = file:read_line(File),
    {pairify(Start, #{}), read_rules(File, #{})}.

% Leave the final pair with the \n in; it means we can get the char
% populations of the whole string by looking at first elements of each pair
% only.
pairify(<<_:8>>, Acc) ->
    Acc;
pairify(<<A:8, B:8, Rest/binary>>, Acc) ->
    pairify(<<B:8, Rest/binary>>, maps:update_with({A, B}, fun(V) -> V+1 end, 1, Acc)).


read_rules(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            <<X:8, Y:8, " -> ", Z:8, "\n">> = Line,
            read_rules(File, Acc#{{X,Y} => Z});
        eof ->
            Acc
    end.
