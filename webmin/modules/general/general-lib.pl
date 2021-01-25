BEGIN { push(@INC, ".."); };
use WebminCore;
&init_config();


sub ReloadAsterisk {


	my $CMD = '/usr/local/bin/docker exec -t ' . $config{'astname'} . ' asterisk -rx "dialplan reload"';
	&execute_command($CMD);



}