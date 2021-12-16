#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

-record(packet,
        {
         version :: integer(),
         operation :: atom(),
         payload :: integer() | [packet()]
        }).
-type packet() :: #packet{}.

main(_) ->
    {ok, File} = file:open("day16.txt", [read]),
    Packets = read_input(File),
    Part1 = lists:map(fun packet_version_sum/1, Packets),
    Part2 = lists:map(fun packet_value/1, Packets),
    io:format("~p ~p~n", [Part1, Part2]).

packet_version_sum(#packet{version=V, payload=P}) when is_list(P) ->
    V + lists:sum(lists:map(fun packet_version_sum/1, P));
packet_version_sum(#packet{version=V}) ->
    V.

packet_value(#packet{operation=literal, payload=N}) ->
    N;
packet_value(#packet{operation=sum, payload=Packets}) ->
    lists:sum(lists:map(fun packet_value/1, Packets));
packet_value(#packet{operation=product, payload=Packets}) ->
    lists:foldl(fun(N, Acc) -> N * Acc end, 1, lists:map(fun packet_value/1, Packets));
packet_value(#packet{operation=min, payload=Packets}) ->
    lists:min(lists:map(fun packet_value/1, Packets));
packet_value(#packet{operation=max, payload=Packets}) ->
    lists:max(lists:map(fun packet_value/1, Packets));
packet_value(#packet{operation=gt, payload=[PA,PB]}) ->
    case packet_value(PA) > packet_value(PB) of
        true -> 1;
        _ -> 0
    end;
packet_value(#packet{operation=lt, payload=[PA,PB]}) ->
    case packet_value(PA) < packet_value(PB) of
        true -> 1;
        _ -> 0
    end;
packet_value(#packet{operation=eq, payload=[PA,PB]}) ->
    case packet_value(PA) == packet_value(PB) of
        true -> 1;
        _ -> 0
    end.

read_input(File) ->
    lists:reverse(read_input(File, [])).

read_input(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            Line1 = string:chomp(Line),
            Num = list_to_integer(Line1, 16),
            Size = length(Line1),
            Bits = <<Num:(Size * 4)>>,
            {Packet, Trailer} = read_packet(Bits),
            <<0:(bit_size(Trailer))>> = Trailer,
            read_input(File, [Packet | Acc]);
        eof -> Acc
    end.

read_packet(_Packet = <<Version:3/integer, Type:3/integer, Rest/bitstring>>) ->
    read_payload(Type, #packet{version = Version}, Rest).

read_payload(4, Packet, Payload) ->
    {Literal, Rest1} = read_literal_payload(Payload, <<>>),
    {Packet#packet{operation = literal, payload = Literal}, Rest1};
read_payload(Type, Packet, <<0:1, Length:15, Rest/bitstring>>) ->
    <<Payload:Length/bitstring, Rest1/bitstring>> = Rest,
    {Packet#packet{operation = type_to_operator(Type), payload = read_packets(Payload)}, Rest1};
read_payload(Type, Packet, <<1:1, PacketCount:11, Payload/bitstring>>) ->
    {Packets, Rest} = read_n_packets(Payload, PacketCount),
    {Packet#packet{operation = type_to_operator(Type), payload = Packets}, Rest}.

type_to_operator(0) -> sum;
type_to_operator(1) -> product;
type_to_operator(2) -> min;
type_to_operator(3) -> max;
type_to_operator(5) -> gt;
type_to_operator(6) -> lt;
type_to_operator(7) -> eq.

read_literal_payload(<<1:1, B:4/bitstring, Rest/bitstring>>, Acc) ->
    read_literal_payload(Rest, <<Acc/bitstring, B/bitstring>>);
read_literal_payload(<<0:1, B:4, Rest/bitstring>>, Acc) ->
    <<N:(bit_size(Acc)+4)>> = <<Acc/bitstring, B:4>>,
    {N, Rest}.

read_packets(Binary) ->
    lists:reverse(read_packets(Binary, [])).
read_packets(<<>>, Acc) ->
    Acc;
read_packets(Binary, Acc) ->
    {Packet, Rest} = read_packet(Binary),
    read_packets(Rest, [Packet | Acc]).

read_n_packets(Binary, N) ->
    {Packets, Rest} = read_n_packets(Binary, N, []),
    {lists:reverse(Packets), Rest}.
read_n_packets(Binary, 0, Acc) ->
    {Acc, Binary};
read_n_packets(Binary, N, Acc) ->
    {Packet, Rest} = read_packet(Binary),
    read_n_packets(Rest, N-1, [Packet | Acc]).
