#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day19.txt", [read]),
    Scans = read_input(File),
    {Beacons, Scanners} = coalesce(Scans),
    Dists = [manhattan(A, B) || A <- Scanners, B <- Scanners],
    io:format("~p ~p~n", [length(Beacons), lists:max(Dists)]).

coalesce(Map) ->
    coalesce(Map, []).

coalesce(M, Scanners) when map_size(M) == 1 ->
    {hd(maps:values(M)), [{0, 0, 0} | Scanners]};
coalesce(M, Scanners) ->
    K = maps:keys(M),
    coalesce(M, Scanners, [{A, B} || A <- K, B <- K, A =/= B]).

coalesce(M, Scanners, [{K1, K2} | Candidates]) ->
    #{K1 := B1, K2 := B2} = M,
    case try_coalesce(B1, B2) of
        undefined ->
            coalesce(M, Scanners, Candidates);
        {Offset, NewBeacons} ->
            coalesce(maps:remove(K2, M#{K1 := NewBeacons}), [Offset | Scanners])
    end.

manhattan({X1, Y1, Z1}, {X2, Y2, Z2}) ->
    abs(X1-X2)+abs(Y1-Y2)+abs(Z1-Z2).

try_coalesce(B1, B2) ->
    try_coalesce(B1, B2, all_orientations()).
try_coalesce(_, _, []) ->
    undefined;
try_coalesce(B1, B2, [O | Os]) ->
    Oriented = orient(O, B2),
    case try_coalesce_oriented(B1, Oriented) of
        undefined ->
            try_coalesce(B1, B2, Os);
        Offset ->
            {Offset, lists:umerge(B1, lists:sort(untranslate(Offset, Oriented)))}
    end.

all_orientations() ->
    [{X, SX, Y, SY, Z, SZ} ||
        X <- [1, 2, 3],
        Y <- [1, 2, 3] -- [X],
        Z <- [6 - X - Y],
        SX <- [1, -1],
        SY <- [1, -1],
        SZ <- [(3 - 2 * ((Y + 3 - X) rem 3)) * SX * SY]].
     
orient(O, Bs) when is_list(Bs) ->
    [orient(O, B) || B <- Bs];
orient({X, SX, Y, SY, Z, SZ}, B) ->
    {pick(X, SX, B), pick(Y, SY, B), pick(Z, SZ, B)}.

pick(Axis, Sign, Beacon) ->
    element(Axis, Beacon) * Sign.

try_coalesce_oriented(B1, B2) ->
    Offsets = 
        lists:foldl(
          fun({{X1, Y1, Z1}, {X2, Y2, Z2}}, Acc) ->
              maps:update_with({X2-X1, Y2-Y1, Z2-Z1}, fun(V) -> V+1 end, 1, Acc)
          end,
          #{},
          [{A, B} || A <- B1, B <- B2]),
    GoodOffsets = maps:filter(fun(_, V) -> V >= 12 end, Offsets),
    case maps:keys(GoodOffsets) of
        [] ->
            undefined;
        [Offset] ->
            Offset
    end.
                                  
untranslate({DX, DY, DZ}, Beacons) ->
    [{X - DX, Y - DY, Z - DZ} || {X, Y, Z} <- Beacons].

read_input(File) ->
    read_input(File, #{}, [], undefined).

read_input(File, Map, List, Scanner) ->
    case file:read_line(File) of
        {ok, "--- scanner " ++ Rest} -> 
            {N, _} = string:to_integer(Rest),
            read_input(File, Map, List, N);
        {ok, "\n"} ->
            read_input(File, Map#{Scanner => lists:sort(List)}, [], undefined);
        {ok, Line} ->
            Coords = string:split(string:chomp(Line), ",", all),
            Beacon = list_to_tuple([list_to_integer(N) || N <- Coords]),
            read_input(File, Map, [Beacon | List], Scanner);
        eof -> 
            Map#{Scanner => List}
    end.
