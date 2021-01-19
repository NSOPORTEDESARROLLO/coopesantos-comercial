#!/usr/bin/perl


use strict;
use DBI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/get_value_from_msserver.pl';


my $mode = 0;
my $id = 100810000000000;
my $user = 'userIVR';
my $pwd = 'ivrU$3r';
my $host = '172.28.130.49';



my $value = &GetValueFromMsserver($mode,$id,$user,$pwd,$host);


print "$value";