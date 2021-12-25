#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

-record(state, {height :: integer(), width :: integer(), map :: #{}}).

main(_) ->
    {ok, File} = file:open("day25.txt", [read]),
    State = read_input(File),
    StopSteps = progress(State),
    io:format("~p~n", [StopSteps]).

progress(State) ->
    progress(1, State).

progress(Steps, State) ->
    State1 = progress_impl(State, e),
    State2 = progress_impl(State1, s),
    case State2 of
        State -> Steps;
        _-> progress(Steps + 1, State2)
    end.

progress_impl(State = #state{map = Map}, Who) ->
    PosList = maps:to_list(Map),
    Moved = [try_move(P, State) || P = {_, Type} <- PosList, Type == Who],
    Unmoved = [P || P = {_, Type} <- PosList, Type =/= Who],
    State#state{map = maps:from_list(Moved ++ Unmoved)}.

try_move(P = {Old, Who}, State = #state{map = Map}) ->
    Target = target(Old, Who, State),
    case Map of
        #{Target := _} -> P;
        _ -> {Target, Who}
    end.

target({X, Y}, e, #state{width = W}) ->
    { (X+1) rem W, Y };
target({X, Y}, s, #state{height = H}) ->
    { X, (Y+1) rem H }.


read_input(File) ->
    read_input(File, 0, 0, #{}).

read_input(File, Row, Width, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            W = length(Line) - 1,
            Acc1 =
                lists:foldl(
                  fun({Col, $>}, M) -> M#{{Col, Row} => e};
                     ({Col, $v}, M) -> M#{{Col, Row} => s};
                     (_, M) -> M
                  end,
                  Acc,
                  lists:zip(lists:seq(0, W), Line)),
            read_input(File, Row+1, W, Acc1);
        eof -> #state{height = Row, width = Width, map = Acc}
    end.
