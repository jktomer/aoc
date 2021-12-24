#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day24.txt", [read]),
    Program = read_input(File),
    io:format("~p~n", [eval(Program)]).

eval(Program) ->
    Ranges = maps:values(eval(Program, [], #{{0, 0, 0, 0} => {0, 0}})),
    Min = lists:min([Min || {Min, _} <- Ranges]),
    Max = lists:max([Max || {_, Max} <- Ranges]),
    {Min, Max}.

eval([], [], States) ->
    maps:filter(fun({_, _, _, Z}, _) -> Z == 0 end, States);
eval([Insn = {_, _, _, _} | T], Acc, States) ->
    eval(T, [Insn | Acc], States);
eval([Insn = {_Line, inp, R} | T], [], States) when map_size(States) < 1000000 ->
    States1 =
        maps:fold(
          fun(State, {M, N}, StatesAcc) ->
                  lists:foldl(
                    fun(D, StatesAcc1) ->
                            State1 = reg(R, State, D),
                            maps:update_with(
                              State1,
                              fun({M0, N0}) -> {min(M0, M * 10 + D), max(N0, N * 10 + D)} end,
                              {M * 10 + D, N * 10 + D},
                              StatesAcc1)
                    end,
                    StatesAcc,
                    lists:seq(1, 9))
          end,
          #{},
          States),
    io:format("After ~s, ~p possible states~n", [fmt(Insn), map_size(States1)]),
    eval(T, [], States1);
eval([Insn = {_Line, inp, R} | T], [], States) ->
    StateList = maps:to_list(States),
    lists:foldl(
      fun(D, Acc) ->
              States1 =
                  maps:from_list(
                    [{reg(R, S, D), {M * 10 + D, N * 10 + D}} ||
                        {S, {M, N}} <- StateList]),
              io:format("After ~s ~p, continuing sequentially with ~p states~n",
                        [fmt(Insn), D, map_size(States1)]),
              States2 = eval(T, [], States1),
              io:format("After ~s ~p, adding ~p to ~p possible states~n",
                        [fmt(Insn), D, map_size(States2), map_size(Acc)]),
              maps:merge_with(
                fun(_, {M0, N0}, {M1, N1}) -> {min(M0, M1), max(N0, N1)} end,
                States2,
                Acc)
      end,
      #{},
      lists:seq(1, 9));
eval(Prog, Insns, States) ->
    States1 =
        maps:fold(
          fun(State, {M, N}, StatesAcc) ->
                  case lists:foldr(fun eval_impl/2, State, Insns) of
                      false -> StatesAcc;
                      State1 ->
                          maps:update_with(
                            State1,
                            fun({M0, N0}) -> {min(M, M0), max(N, N0)} end,
                            {M, N},
                            StatesAcc)
                  end
          end,
          #{},
          States),
    io:format("After ~s, ~p possible states~n", [fmt(hd(Insns)), maps:size(States1)]),
    eval(Prog, [], States1).

eval_impl({_Line, Op, R, RI}, State) ->
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
