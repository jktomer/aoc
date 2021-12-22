#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day22.txt", [read]),
    Steps = read_input(File),
    Init = do_cubes(lists:filtermap(fun restrict/1, Steps)),
    io:format("~p ~p~n", [sets:size(Init), 0]).

restrict({_, {XL, XH, YL, YH, ZL, ZH}}) when
      XL > 50 orelse YL > 50 orelse ZL > 50 orelse
      XH < -50 orelse YH < -50 orelse ZH < -50 ->
    false;
restrict({T, Ranges}) ->
    {true, {T, list_to_tuple([min(50, max(-50, V)) || V <- tuple_to_list(Ranges)])}}.

do_cubes(Steps) ->
    lists:foldl(fun do_cubes_impl/2, sets:new(), Steps).

do_cubes_impl({on, Ranges}, State) ->
    lists:foldl(
      fun sets:add_element/2,
      State,
      all_points(Ranges));
do_cubes_impl({off, Ranges}, State) ->
    lists:foldl(
      fun sets:del_element/2,
      State,
      all_points(Ranges)).

all_points({XL, XH, YL, YH, ZL, ZH}) ->
      [{X, Y, Z} ||
          X <- lists:seq(XL, XH),
          Y <- lists:seq(YL, YH),
          Z <- lists:seq(ZL, ZH)].

read_input(File) ->
    lists:reverse(read_input(File, [])).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            read_input(File, [parse_instr(Line)|Acc]);
        eof -> Acc
    end.

parse_instr(Line) ->
    [State, "x=" ++ Rest] = string:split(Line, " "),
    {XL, ".." ++ Rest1} = string:to_integer(Rest),
    {XH, ",y=" ++ Rest2} = string:to_integer(Rest1),
    {YL, ".." ++ Rest3} = string:to_integer(Rest2),
    {YH, ",z=" ++ Rest4} = string:to_integer(Rest3),
    {ZL, ".." ++ Rest5} = string:to_integer(Rest4),
    {ZH, "\n"} = string:to_integer(Rest5),
    {list_to_atom(State), {XL, XH, YL, YH, ZL, ZH}}.
