Erlang collectd application
---------------------------

You need a collectd configured to accept network connections.

Now with a custom ejabberd module.


Graphing
---------

	rrdtool graph /tmp/stanzas.png --lazy --imgformat PNG --end now --start end-200s --width 1200 \
	DEF:ds1=stanzas-message.rrd:value:AVERAGE \
	DEF:ds2=stanzas-iq.rrd:value:AVERAGE \
	DEF:ds0=stanzas-presence.rrd:value:AVERAGE \
	AREA:ds0#0000FF:"Presence" STACK:ds2#00FF00:"Iq" STACK:ds1#FF0000:"Message"

	rrdtool graph /tmp/users.png --lazy --imgformat PNG --end now --start end-200s --width 1200 \
	DEF:ds1=users-ejabberd.rrd:users:AVERAGE \
	LINE1:ds1#0000FF:"Online users" 
