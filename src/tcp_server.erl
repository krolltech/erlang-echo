-module(tcp_server).
-behavior(gen_server).

-export([start_link/1, stop/1, set_socket/2]).
-export([init/1, handle_call/3, handle_cast/2,
	 handle_info/2, terminate/2, code_change/3]).
-record(state, {
	  port,
	  socket,
	  transport,
	  state
	 }).

set_socket(Ref,Sock) ->
    gen_server:cast(Ref, { set_socket, Sock } ).

start_link(Port)
  when is_integer(Port) ->
    gen_server:start_link( ?MODULE, [Port], [] ).

stop(Ref) ->
    gen_server:cast(Ref,stop).

init([Port]) ->
    process_flag(trap_exit,true),
    { ok,  #state{port=Port , transport=echo } }.

handle_cast({set_socket,Socket} ,State) ->
    inet:setopts(Socket ,[{ active,once },
			  { packet,0 },
			  binary
			 ]),
    {ok, Keep,Ref} =(State#state.transport):start(Socket),
    keep_alive_or_close(Keep,State#state{socket=Socket,state=Ref} );

handle_cast(stop,State) ->
    error_logger:info_report("cast stop state."),
    {stop, normal ,State};

handle_cast(Event,State) ->
    error_logger:info_report("cast event state."),
    {stop, {unknow,Event} ,State}.

handle_call(Event,From,State) ->
    error_logger:info_report("call event from state."),
    {stop, {unknow,From,Event} ,State}.

handle_info({tcp_closed ,Socket},State)
  when Socket == State#state.socket ->
    {stop ,normal ,State};

handle_info({tcp , Socket ,Bin} ,State)
  when Socket == State#state.socket ->
    error_logger:info_report("handle info."),
    inet:setopts(Socket, [ {active, once}]),
    dispatch(Bin,echo,State).

dispatch(Data, Mod ,State = #state{ transport = Mod } ) ->
    { ok , Keep , _NewState } = Mod:process( Data,State#state.state ),
    keep_alive_or_close( Keep , State).

keep_alive_or_close(Keep , State) ->
    if
	Keep /= keep_alive ->
	    gen_tcp:close(State#state.socket),
	    error_logger:info_report("close socket."),
	    { stop ,normal ,State };
	true  ->
	    { noreply ,State }
    end.

code_change(_OldVsn,State,_Extra) ->
    error_logger:info_report("code _Change.."),
    { ok ,State }.

terminate(_Reason, _State) ->
    error_logger:info_report("terimnate"),
    ok.
