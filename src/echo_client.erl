-module(echo_client).
-export([start/1, start/2]).

start(Max) ->
    for(1,Max, fun test/1 ).

test(I)->
    io:format("spawn client ~p~n",[I]),
    spawn(fun() -> start("127.0.0.1",8081)  end   ).

start(IP,Port) ->
    { ok ,Socket }=gen_tcp:connect( IP , Port , [binary,{packet,0},{active,true}]),
    talk(Socket).

talk(Socket) ->
    receive after 1000 -> 1000 end,
    ok=gen_tcp:send(Socket,"good"),
    recv(Socket),
    talk(Socket).

recv(Socket) ->
    receive
	{tcp ,Socket,_Bin} ->
	    io:format("~p~n",[_Bin]);
	{tcp_closed ,Socket } ->
	    io:format("close~n")
    end.


for(N,N,F) ->
    [ F(N) ];

for(I,N,F) -> [ F(I) | for(I+1,N,F) ].
