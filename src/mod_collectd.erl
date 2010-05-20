-module (mod_collectd).
-behaviour(gen_mod).

-include("ejabberd.hrl").
-include("jlib.hrl").

-export([start/2,
		stop/1]).
-export ([stats/1]).
% Hooks
-export([user_send_packet/3]).

start(Host, Options)->
  application:start(collectd),
  {ok, Address} = case gen_mod:get_opt(server, Options, {127,0,0,1}) of
    IP when is_list(IP) ->
      inet_parse:address(IP);
    IP -> {ok, IP}
  end,
  collectd:add_server(1, Address),
  timer:apply_interval(1000, ?MODULE, stats, [Host]),
  ejabberd_hooks:add(user_send_packet, Host, ?MODULE, user_send_packet, 100),
  ok.

stats(Host)->
  N = erlang:length(ejabberd_sm:get_vh_session_list(Host)),
  collectd:set_gauge(users, ejabberd, [N]),
  collectd:set_gauge(ps_count, erlang,
	       [erlang:system_info(process_count), erlang:system_info(schedulers_online)]),
  lists:foreach(fun({Type, Size}) ->
		  collectd:set_gauge(memory, Type, [Size])
	  end, erlang:memory()),
  {Reductions, _} = erlang:statistics(reductions),
  collectd:set_counter(counter, reductions, [Reductions]),
  collectd:set_gauge(queue_length, run_queue, [erlang:statistics(run_queue)]).
    
stop(Host)->
  ejabberd_hooks:remove(user_send_packet, Host, ?MODULE, user_send_packet, 100),
  application:stop(collectd).
  
user_send_packet(_From, _To, {xmlelement, Type, _Attr, _Subel} = _Packet) ->
  collectd:inc_counter(stanzas, Type, [1]),
  ok.