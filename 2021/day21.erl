#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day21.txt", [read]),
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

play_dirac_nondeterministic(P1, P2) ->
    {A, B, _} = play_dirac_nondeterministic_impl({{P1, P2}, {0, 0}, 1}, #{}),
    max(A, B).

play_dirac_nondeterministic_impl(Key = {{P1, P2}, {S1, S2}, Who}, Cache) ->
    case Cache of
        #{Key := {A, B}} ->
            {A, B, Cache};
        _ when S1 >= 21 ->
            {1, 0, Cache#{{P1, S1, P2, S2, Who} => {1, 0}}};
        _ when S2 >= 21 ->
            {0, 1, Cache#{{P1, S1, P2, S2, Who} => {0, 1}}};
        _ ->
            {AWin, BWin, Cache1} = lists:foldl(
              fun(Roll, {AAcc, BAcc, CAcc}) ->
                      {A, B, C} = play_dirac_nondeterministic_step(Key, Roll, CAcc),
                      {AAcc+A, BAcc+B, C}
              end,
              {0, 0, Cache},
              [
               A+B+C ||
                  A <- [1, 2, 3],
                  B <- [1, 2, 3],
                  C <- [1, 2, 3]
              ]),
            {AWin, BWin, Cache1#{Key => {AWin, BWin}}}
    end.

play_dirac_nondeterministic_step({Pos, Score, Who}, Roll, Cache) ->
    Pos1 = (element(Who, Pos) + Roll - 1) rem 10 + 1,
    Score1 = element(Who, Score) + Pos1,
    play_dirac_nondeterministic_impl(
      {setelement(Who, Pos, Pos1),
       setelement(Who, Score, Score1),
       3 - Who},
      Cache).

read_input(File) ->
    {ok, "Player 1 starting position: " ++ [P1 | "\n"]} = file:read_line(File),
    {ok, "Player 2 starting position: " ++ [P2 | "\n"]} = file:read_line(File),
    {P1 - $0, P2 - $0}.
