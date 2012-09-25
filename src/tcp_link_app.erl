-module(tcp_link_app).
-behaviour(application).
-export([
	 start_server/1,
	 start/2,
	 stop/1,
	 init/1
	]).

-define(MAX_RESTART,5).
-define(MAX_TIME,60).
-define(LISTEN_PORT,8081).

start_server(Port) ->
    supervisor:start_child(tcp_server_sup,[Port]).

start(_Type, _StartArgs) ->
    error_logger:info_report("tcp application start."),
    supervisor:start_link( {local,?MODULE},
			   ?MODULE,
			   [?LISTEN_PORT ,tcp_server]
			 ).

stop(_State) ->
    ok.

init([Port,Module]) ->
    error_logger:info_report("tcp application init on ~p.",[Port]),
    { ok ,
      {_SupFlags = {one_for_one, ?MAX_RESTART , ?MAX_TIME } ,
       [
	{tcp_sup,
	 {tcp_acceptor, start_link, [self(), Port ,tcp_server] },
	 permanent,
	 2000,
	 worker,
	 [tcp_acceptor]
	}

	,
	{tcp_server_sup,
	 { supervisor, start_link, [{local,tcp_server_sup}, ?MODULE ,[Module] ] },
	 permanent,
	 infinity,
	 supervisor,
	 []
	}

       ]
      }
    };
init([Module]) ->
    {ok,
     {_SupFlags = {simple_one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
       %% TCP Client
       {undefined,
	{Module, start_link, []},
	temporary,
	2000,
	worker,
	[]
       }
      ]
     }
    }.
