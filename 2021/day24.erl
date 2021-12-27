#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day24.txt", [read]),
    Program = read_input(File),
    io:format("~p~n", [eval(Program)]).

eval(Program) ->
    Tab = ets:new(x, []),
    ets:insert(Tab, {{0, 0, 0, 0}, 0, 0}),
    Vals = lists:append(eval(Program, Tab)),
    {lists:min(Vals), lists:max(Vals)}.

eval([], Tab) ->
    ets:match(Tab, {{'_', '_', '_', 0}, '$1', '$2'});
eval([{_, inp, R} | T], Tab) ->
    {Insns, NextStage} = lists:splitwith(fun({_, inp, _}) -> false; (_) -> true end, T),
    NewTab = ets:new(x, []),
    eval_section(Tab, NewTab, R, Insns),
    ets:delete(Tab),
    io:format("After ~s, ~p possible states~n", [fmt(hd(Insns)), ets:info(NewTab, size)]),
    eval(NextStage, NewTab).

eval_section(Tab, NewTab, Reg, Insns) ->
    eval_section(Tab, NewTab, Reg, Insns, ets:match_object(Tab, '$1', 1)).
eval_section(_Tab, _NewTab, _Reg, _Insns, '$end_of_table') ->
    ok;
eval_section(Tab, NewTab, Reg, Insns, {[{State, M0, N0}], Cont}) ->
    States0 = [{reg(Reg, State, D), M0 * 10 + D, N0 * 10 + D} || D <- lists:seq(1, 9)],
    lists:foreach(
      fun({S, M, N}) ->
              S1 = lists:foldl(fun eval_op/2, S, Insns),
              S1 =/= false and update_state(NewTab, S1, M, N)
      end,
      States0),
    eval_section(Tab, NewTab, Reg, Insns, ets:match_object(Cont)).

update_state(Tab, State, M, N) ->
    case ets:lookup(Tab, State) of
        [{State, M0, N0}] ->
            ets:insert(Tab, {State, min(M0, M), max(N0, N)});
        [] ->
            ets:insert(Tab, {State, M, N})
    end.

eval_op(_, false) ->
    false;
eval_op({_Line, Op, R, RI}, State) ->
    Res = compute(Op, reg(R, State), reg(RI, State)),
    Res =/= false andalso reg(R, State, Res).

compute(add, X, Y) -> X + Y;
compute(mul, X, Y) -> X * Y;
compute('div', X, Y) -> Y =/= 0 andalso X div Y;
compute(mod, X, Y) -> X >= 0 andalso Y > 0 andalso X rem Y;
compute(eql, X, X) -> 1;
compute(eql, _X, _Y) -> 0.


read_input(File) ->
    lists:reverse(read_input(File, [])).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            LineNo = length(Acc) + 1,
            Instruction =
                case string:split(Line, " ", all) of
                    ["inp", [R | "\n"]] ->
                        {LineNo, inp, reg(R)};
                    [Op, [Reg1], [Reg2 | "\n"]] when Reg2 > $9 ->
                        {LineNo, list_to_atom(Op), reg(Reg1), reg(Reg2)};
                    [Op, [Reg], Imm] ->
                        {LineNo, list_to_atom(Op), reg(Reg), element(1, string:to_integer(Imm))}
                end,
            read_input(File, [Instruction|Acc]);
        eof -> Acc
    end.

reg(C) -> C.
reg(R, State) when R >= $w -> element(R - $w + 1, State);
reg(Imm, _State) -> Imm.
reg(R, State, Val) -> setelement(R - $w + 1, State, Val).
fmt({Line, inp, R}) ->
    io_lib:format("~p inp ~c", [Line, R]);
fmt({Line, Op, R, RI}) ->
    io_lib:format("~p ~p ~c ~p", [Line, Op, R, if RI >= $w -> list_to_atom([RI]); true -> RI end]).
