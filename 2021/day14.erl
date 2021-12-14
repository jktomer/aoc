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
    Freq = maps:fold(fun({K, _}, V, Map) -> Map#{K => maps:get(K, Map, 0) + V} end, #{}, Pairs),
    Counts = lists:sort(maps:values(Freq)),
    lists:last(Counts) - hd(Counts).

pair_insert(Pairs, Rules) ->
    maps:fold(fun(K, V, Acc) -> pair_insert(K, V, Rules, Acc) end, #{}, Pairs).

pair_insert({A, B}, Count, Rules, Acc) ->
    case Rules of
        #{{A, B} := C} ->
            AC = maps:get({A, C}, Acc, 0),
            CB = maps:get({C, B}, Acc, 0),
            Acc#{{A, C} => AC + Count, {C, B} => CB + Count};
        _ ->
            Acc#{{A, B} => maps:get({A, B}, Acc, 0) + Count}
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
