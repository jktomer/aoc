#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day12.txt", [read]),
    Edges = read_input(File),
    Paths = distinct_paths(Edges, false),
    Paths1 = distinct_paths(Edges, true),
    io:format("~p ~p~n", [Paths, Paths1]).

distinct_paths(Edges, MayRevisitOneSmall) ->
    distinct_paths(Edges, MayRevisitOneSmall, {false, start}, #{}).

distinct_paths(_Edges, _, {false, 'end'}, _Visited) ->
    1;
distinct_paths(_Edges, _, {false, start}, #{start := _}) ->
    0;
distinct_paths(Edges, MayRevisitOneSmall, {Big, Cave} = Where, Visited) ->
    case {Big, MayRevisitOneSmall, Visited} of
        {false, false, #{Cave := _}} ->
            0;
        {false, true, #{Cave := _}} ->
            distinct_paths(Edges, false, Where, maps:remove(Cave, Visited));
        _ ->
            Next = proplists:get_all_values(Where, Edges),
            lists:sum([distinct_paths(Edges, MayRevisitOneSmall, Cave1, Visited#{Cave => ok}) || Cave1 <- Next])
    end.

read_input(File) ->
    read_input(File, []).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            Line1 = string:chomp(Line),
            [Cave0, Cave1] = [parse_cave(C) || C <- string:split(Line1, "-")],
            read_input(File, [{Cave0, Cave1}, {Cave1, Cave0} | Acc]);
        eof -> Acc
    end.

parse_cave(Name) ->
    {string:uppercase(Name) == Name, list_to_atom(Name)}.
