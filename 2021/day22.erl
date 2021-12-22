#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day22.txt", [read]),
    Steps = read_input(File),
    Init = do_cubes(lists:filtermap(fun restrict/1, Steps)),
    Final = do_cubes(Steps),
    io:format("~p ~p~n", [active_size(Init), active_size(Final)]).

active_size(Areas) ->
    lists:sum([(XH+1-XL)*(YH+1-YL)*(ZH+1-ZL) || {XL, XH, YL, YH, ZL, ZH} <- Areas]).

restrict({_, {XL, XH, YL, YH, ZL, ZH}}) when
      XL > 50 orelse YL > 50 orelse ZL > 50 orelse
      XH < -50 orelse YH < -50 orelse ZH < -50 ->
    false;
restrict({T, Ranges}) ->
    {true, {T, list_to_tuple([min(50, max(-50, V)) || V <- tuple_to_list(Ranges)])}}.

do_cubes(Steps) ->
    lists:foldl(fun do_cubes_impl/2, [], Steps).

do_cubes_impl({State, Target}, Active) ->
    Nonoverlapping = lists:append([split(Target, Area) || Area <- Active]),
    do_cubes_impl(State, Target, Nonoverlapping).

do_cubes_impl(off, _, Active) ->
    Active;
do_cubes_impl(on, Target, Active) ->
    [Target | Active].

split({SXL, SXH, SYL, SYH, SZL, SZH}, {EXL, EXH, EYL, EYH, EZL, EZH}) ->
    OXL = max(EXL, SXL),
    OXH = min(EXH, SXH),
    OYL = max(EYL, SYL),
    OYH = min(EYH, SYH),
    lists:filter(fun nonempty/1,
      [
       {EXL, min(EXH, SXL-1), EYL, EYH, EZL, EZH},
       {max(EXL, SXH + 1), EXH, EYL, EYH, EZL, EZH},
       {OXL, OXH, EYL, min(EYH, SYL-1), EZL, EZH},
       {OXL, OXH, max(EYL, SYH+1), EYH, EZL, EZH},
       {OXL, OXH, OYL, OYH, EZL, min(EZH, SZL-1)},
       {OXL, OXH, OYL, OYH, max(EZL, SZH+1), EZH}
      ]).

nonempty({XL, XH, YL, YH, ZL, ZH}) ->
    XL =< XH andalso YL =< YH andalso ZL =< ZH.

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
