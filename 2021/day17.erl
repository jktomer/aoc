#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day17.txt", [read]),
    Input = read_input(File),
    Results = lists:map(fun eval/1, Input),
    io:format("~p ~p~n", [Results, 0]).

eval(TargetArea = {{_, X1}, {Y0, _}}) ->
    Trajectories = lists:filtermap(fun(Trajectory) -> validate(Trajectory, TargetArea) end, [{DX, DY} || DX <- lists:seq(1, X1), DY <- lists:seq(Y0, X1)]),
    {lists:max(Trajectories), length(Trajectories)}.

validate(Trajectory, TargetArea) ->
    validate({0, 0}, Trajectory, 0, TargetArea).

validate({X, Y}, _, YBest, {{X0, X1}, {Y0, Y1}}) when X >= X0 andalso X =< X1 andalso Y >= Y0 andalso Y =< Y1 ->
    {true, YBest};
validate({X, Y}, _, _, {{_, X1}, {Y0, _}}) when X > X1 orelse Y < Y0 ->
    false;
validate({X, Y}, {DX, DY}, YBest, TargetArea) ->
    validate({X + DX, Y + DY}, {max(DX-1, 0), DY-1}, max(YBest, Y+DY), TargetArea).

read_input(File) ->
    lists:reverse(read_input(File, [])).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            read_input(File, [decode_input(Line) | Acc]);
        eof -> Acc
    end.

decode_input(Line) ->
    "target area: x=" ++ Rest = Line,
    {X, Rest1} = parse_pair(Rest),
    ", y=" ++ Rest2 = Rest1,
    {Y, "\n"} = parse_pair(Rest2),
    {X, Y}.

parse_pair(String) ->
    {Min, Rest0} = string:to_integer(String),
    ".." ++ Rest1 = Rest0,
    {Max, Rest} = string:to_integer(Rest1),
    {{Min, Max}, Rest}.
