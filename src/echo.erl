-module(echo).
-export([start/1,process/2]).
-record(state,{
	  socket
	 }
       ).

start(Socket) ->
    send("Ok",#state{socket=Socket }).

process(Data, State ) ->
    error_logger:info_report("process."),
    send(Data,State).

send(Data,State ) ->
    Keep=case gen_tcp:send( State#state.socket, [Data,1] ) of
	     ok ->
		 keep_alive;
	     _ ->
		 shutdown
	 end,
    { ok ,Keep, State}.
