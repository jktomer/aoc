#!/usr/bin/env escript
%% -*- erlang -*-

main(_) ->
    {ok, File} = file:open("day1.txt", [read]),
    Lines = read_all_ints(File),
    Part1 = count_depth_increases(Lines, 1),
    Part2 = count_depth_increases(Lines, 3),
    io:format("~B ~B~n", [Part1, Part2]).

count_depth_increases(Depths, WindowSize) ->
    count_depth_increases(Depths, lists:nthtail(WindowSize, Depths), 0).

count_depth_increases(_, [], N) ->
    N;
count_depth_increases([Expire | Old], [Next | New], N) ->
    Deeper = if Next > Expire -> 1; true -> 0 end,
    count_depth_increases(Old, New, N + Deeper).

read_all_ints(File) ->
    lists:reverse(read_all_ints(File, [])).

read_all_ints(File, Acc) ->
    case file:read_line(File) of
        {error, _} -> Acc;
        eof -> Acc;
        {ok, Line} -> read_all_ints(File, [list_to_integer(string:trim(Line)) | Acc])
    end.
