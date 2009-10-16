-module(collectd_util).

-export([send_erlang_stats/0, send_mnesia_system_stats/0, send_mnesia_table_stats/1]).

send_erlang_stats() ->
	% TODO: later version of erlang can use erlang:system_info(schedulers_online)
	PSVals = [erlang:system_info(process_count), erlang:system_info(schedulers)],
	collectd:set_gauge(ps_count, erlang, PSVals),
	% erlang:memory
	M = fun({Type, Size}) -> collectd:set_gauge(memory, Type, [Size]) end,
	lists:foreach(M, erlang:memory()),
	% erlang:statistics
	{RunTime, _} = erlang:statistics(runtime),
	collectd:set_counter(cpu, runtime, [RunTime]),
	collectd:set_gauge(ps_state, run_queue, [erlang:statistics(run_queue)]),
	{{input, Rx}, {output, Tx}} = erlang:statistics(io),
	collectd:set_gauge(io_octets, ports, [Rx, Tx]).

%% @doc Requires custom mnesia_types.db
send_mnesia_system_stats() ->
	LockQueue = length(mnesia:system_info(lock_queue)),
	HeldLocks = length(mnesia:system_info(held_locks)),
	Transactions = length(mnesia:system_info(transactions)),
	collectd:set_gauge(locks, mnesia, [LockQueue, HeldLocks, Transactions]),
	Failures = mnesia:system_info(transaction_failures),
	Restarts = mnesia:system_info(transaction_restarts),
	Commits = mnesia:system_info(transaction_commits),
	collectd:set_counter(transactions, mnesia, [Failures, Restarts, Commits]).

%% @doc Requires custom mnesia_types.db
send_mnesia_table_stats(Tab) ->
	Wordsize = erlang:system_info(wordsize),
	Mem = mnesia:table_info(Tab, memory) / Wordsize,
	collectd:set_gauge(memory, Tab, [Mem]),
	collectd:set_gauge(size, Tab, [mnesia:table_info(Tab, size)]).