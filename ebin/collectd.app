{application, collectd, [
	{description, "collectd client"},
	{vsn, "0.0.4"},
	{modules, [
		collectd, collectd_pkt, collectd_server, collectd_sup,
		collectd_values,mod_collectd,collectd_util
	]},
	{registered, [collectd_sup]},
	{mod, {collectd, []}},
	{applications, [kernel, stdlib]},
	{env, []}
]}.
