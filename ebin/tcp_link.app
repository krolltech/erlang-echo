%% -*- mode: Erlang; fill-column: 75; comment-column: 50; -*-
{application, tcp_link,
 [{description, "a tcp model."},
  {vsn, "0.1.0"},
  {modules, [
		  tcp_acceptor
		 ]},
  {registered, [tcp_acceptor]},
  {applications, [kernel, stdlib]},
  {mod, {tcp_link_app, []}}
 ]}.
