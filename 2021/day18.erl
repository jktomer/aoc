#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day18.txt", [read]),
    Pairs = read_input(File),
    Sum = lists:foldl(fun snail_add/2, hd(Pairs), tl(Pairs)),
    BiggestPairSum = lists:max([snail_magnitude(snail_add(X, Y)) || X <- Pairs, Y <- Pairs, X =/= Y]),
    io:format("~p ~p~n", [snail_magnitude(Sum), BiggestPairSum]).

snail_magnitude([X, Y]) ->
    3 * snail_magnitude(X) + 2 * snail_magnitude(Y);
snail_magnitude(N) ->
    N.

% reverse arg order because of foldl
snail_add(X, Y) ->
    Res = snail_reduce([Y, X]),
    % io:format("~p + ~p = ~p~n", [Y, X, Res]),
    Res.

snail_reduce(Pair) ->
    % io:format("reducing ~p~n", [Pair]),
    case snail_explode(Pair) of
        {boom, _, _, NewPair} ->
            snail_reduce(NewPair);
        done ->
            case snail_split(Pair) of
                {crack, NewPair} ->
                    snail_reduce(NewPair);
                done ->
                    Pair
            end
    end.

snail_explode(Pair) ->
    snail_explode(Pair, 0).

snail_explode([X, Y], 4) ->
    {boom, X, Y, 0};
snail_explode([X, Y], N) ->
    case snail_explode(X, N+1) of
        {boom, L, R, T} ->
            {boom, L, 0, [T, add_tip(Y, R, left)]};
        done ->
            case snail_explode(Y, N+1) of
                {boom, L, R, T} ->
                    {boom, 0, R, [add_tip(X, L, right), T]};
                done ->
                    done
            end
    end;
snail_explode(_, _) ->
    done.


add_tip(X, N, _) when is_integer(X) ->
    X+N;
add_tip([X, Y], N, left) ->
    [add_tip(X, N, left), Y];
add_tip([X, Y], N, right) ->
    [X, add_tip(Y, N, right)].

snail_split(X) when is_integer(X), X >= 10 ->
    {crack, [X div 2, (X+1) div 2]};
snail_split([X, Y]) ->
    case snail_split(X) of
        {crack, T} ->
            {crack, [T, Y]};
        done ->
            case snail_split(Y) of
                {crack, T} ->
                    {crack, [X, T]};
                done ->
                    done
            end
    end;
snail_split(_) ->
    done.


read_input(File) ->
    lists:reverse(read_input(File, [])).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            {ok, Toks, _} = erl_scan:string(Line++"."),
            {ok, List} = erl_parse:parse_term(Toks),
            read_input(File, [List|Acc]);
        eof -> Acc
    end.
