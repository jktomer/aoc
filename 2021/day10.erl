#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day10.txt", [read]),
    Lines = read_input(File),
    Diags = lists:map(fun diagnose/1, Lines),
    [Corrupted, Incomplete] = [proplists:get_all_values(K, Diags) || K <- [corrupted, incomplete]],
    io:format("~p ~p~n", [lists:sum(Corrupted), lists:nth(length(Incomplete) div 2 + 1, lists:sort(Incomplete))]).

diagnose(Line) ->
    diagnose([], Line).

diagnose(Stack, []) ->
    {incomplete, incomplete_score(Stack)};
diagnose(Stack, [$( | Rest]) ->
    diagnose([$) | Stack], Rest);
diagnose(Stack, [$[ | Rest]) ->
    diagnose([$] | Stack], Rest);
diagnose(Stack, [${ | Rest]) ->
    diagnose([$} | Stack], Rest);
diagnose(Stack, [$< | Rest]) ->
    diagnose([$> | Stack], Rest);
diagnose([Char | Stack], [Char | Rest]) ->
    diagnose(Stack, Rest);
diagnose(_, [Bad | _]) ->
    {corrupted, corrupted_score(Bad)}.

corrupted_score($)) ->
    3;
corrupted_score($]) ->
    57;
corrupted_score($}) ->
    1197;
corrupted_score($>) ->
    25137.

incomplete_score(Stack) ->
    lists:foldl(
      fun(S, Acc) -> Acc * 5 + S end,
      0,
      lists:map(
        fun($)) -> 1;
           ($]) -> 2;
           ($}) -> 3;
           ($>) -> 4
        end,
        Stack)).


read_input(File) ->
    read_input(File, []).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            read_input(File, [string:chomp(Line)|Acc]);
        eof -> Acc
    end.
