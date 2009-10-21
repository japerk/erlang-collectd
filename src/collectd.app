{application, collectd,
 [{description, "collectd client"},
  {vsn, "0.0.3"},
  % modified by japerk to correctly specify modules and mod config
  {modules, [collectd, collectd_pkt, collectd_server, collectd_sup, collectd_values, collectd_util]},
  {registered, [collectd_sup]},
  {mod, {collectd, []}},
  {applications, [kernel, stdlib]},
  {env, [{servers, [{10, "localhost", 25826}]}]}
 ]
}.