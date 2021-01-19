#!/usr/bin/perl 

use strict;
#use warnings;
use Asterisk::AGI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/get_value_from_msserver.pl';

my $AGI = new Asterisk::AGI;


my $log = 'consultas.log';
my %sdata = ();
&LogPrintLine("Iniciando consulta AGI",$log);



$sdata{'id'} = $AGI->get_variable('id');
$sdata{'nservice'} = $AGI->get_variable('nservice');
$sdata{'msserver_host'} = $AGI->get_variable('msserver_db_host');
$sdata{'msserver_user'} = $AGI->get_variable('msserver_db_user');
$sdata{'msserver_pwd'} = $AGI->get_variable('msserver_db_pwd');
$sdata{'consultas_unv'} = $AGI->get_variable('consultas_unv');
$sdata{'consultas_ntp'} = $AGI->get_variable('consultas_ntp');
$sdata{'consultas_colones'} = $AGI->get_variable('consultas_colones');
$sdata{'consultas_maced'} = $AGI->get_variable('consultas_maced');


if ( "$sdata{'nservice'}" eq "0" ) {

	$sdata{'context'} = "consultas-medidor-menu";
	$sdata{'value'} = &GetValueFromMsserver(0,$sdata{'id'},$sdata{'msserver_user'},
		$sdata{'msserver_pwd'},$sdata{'msserver_host'});
}


if ( "$sdata{'nservice'}" eq "1" ) {

	$sdata{'context'} = "consultas-cable-e-internet-menu"; 
    $sdata{'value'} = &GetValueFromMsserver(1,$sdata{'id'},$sdata{'msserver_user'},
		$sdata{'msserver_pwd'},$sdata{'msserver_host'});
}


&LogPrintHash(\%sdata,$log);



if ( "$sdata{'value'}" eq "error" ){

	$AGI->stream_file("custom/$sdata{'consultas_unv'}");
	$AGI->set_context("$sdata{'context'}");
	exit 0;

} 

if ( "$sdata{'value'}" eq "0" ){

    $AGI->stream_file("custom/$sdata{'consultas_ntp'}");
	exit 0;
}  


$AGI->stream_file("custom/$sdata{'consultas_maced'}");
$AGI->say_number($sdata{'value'});
$AGI->stream_file("custom/$sdata{'consultas_colones'}");     




