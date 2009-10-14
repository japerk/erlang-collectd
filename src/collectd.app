{application, collectd,
 [{description, "collectd client"},
  {vsn, "0.0.2"},
  % modified by japerk to correctly specify modules and mod config
  {modules, [collectd, collectd_pkt, collectd_server, collectd_sup, collectd_values]},
  {registered, [collectd_sup]},
  {mod, {collectd, []}},
  {applications, [kernel, stdlib]},
  {env, [{servers, [{1, "localhost", 25826}]}]}
 ]
}