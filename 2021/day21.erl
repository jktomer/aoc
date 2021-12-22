#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day21e.txt", [read]),
    {P1, P2} = read_input(File),
    {LoseScore, Rolls} = play_dirac_deterministic(P1, P2),
    NWins = play_dirac_nondeterministic(P1, P2),
    io:format("~p ~p~n", [LoseScore * Rolls, NWins]).

play_dirac_deterministic(P1, P2) ->
    play_dirac_deterministic(P1, 0, P2, 0, 0, 1).

play_dirac_deterministic(_, S1, _, S2, Rolls, _) when S2 >= 1000 ->
    {S1, Rolls};
play_dirac_deterministic(P1, S1, P2, S2, Rolls, Roll) ->
    Moves = lists:sum([(Roll - 1 + N) rem 100 + 1 || N <- lists:seq(0, 2)]),
    NextRoll = (Roll + 2) rem 100 + 1,
    P1x = (P1 + Moves - 1) rem 10 + 1,
    S1x = S1 + P1x,
    play_dirac_deterministic(P2, S2, P1x, S1x, Rolls + 3, NextRoll).

play_dirac_nondeterministic(P1, P2) when is_integer(P1) ->
    element(1, play_dirac_nondeterministic_impl({P1, 0, P2, 0, 2}, #{})).

play_dirac_nondeterministic_impl(Key = {P1, S1, P2, S2, Who}, Cache) ->
    case Cache of
        #{Key := Val} ->
            {Val, Cache};
        _ when S2 >= 21 ->
            {Who rem 2, Cache#{{P1, S1, P2, S2, Who} => 1}};
        _ ->
            {_, Res, Cache1} = lists:foldl(
              fun play_dirac_nondeterministic_step/2,
              {Key, 0, Cache},
              [
               A+B+C ||
                  A <- [1, 2, 3],
                  B <- [1, 2, 3],
                  C <- [1, 2, 3]
              ]),
            {Res, Cache1#{Key => Res}}
    end.

play_dirac_nondeterministic_step(Roll, {Key = {P1, S1, P2, S2, Who}, Acc, Cache}) ->
    P1x = (P1 + Roll - 1) rem 10 + 1,
    S1x = S1 + P1x,
    {Res, Cache1} = play_dirac_nondeterministic_impl({P2, S2, P1x, S1x, 3 - Who}, Cache),
    {Key, Acc+Res, Cache1}.

read_input(File) ->
    {ok, "Player 1 starting position: " ++ [P1 | "\n"]} = file:read_line(File),
    {ok, "Player 2 starting position: " ++ [P2 | "\n"]} = file:read_line(File),
    {P1 - $0, P2 - $0}.
