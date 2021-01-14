#!/usr/bin/perl


use strict;
use Asterisk::AGI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/insert_mysql.pl';

my $log = 'callcenter.log';
&LogPrintLine("Iniciando AGI para Callcenter", $log);


my $AGI = new Asterisk::AGI;
my %sdata = ();


$sdata{'fuente'} = $AGI->get_variable('callerid');
$sdata{'estado'} = $AGI->get_variable('estado');
$sdata{'uniqueid'} = $AGI->get_variable('uid');
$sdata{'fecha'} = $AGI->get_variable('fecha');
$sdata{'duration'} = $AGI->get_variable('duration');
$sdata{'global_update'} = $AGI->get_variable('global_update');
$sdata{'mysql_db_host'} = $AGI->get_variable('mysql_db_host');
$sdata{'mysql_db_name'} = $AGI->get_variable('mysql_db_name');
$sdata{'mysql_db_user'} = $AGI->get_variable('mysql_db_user');
$sdata{'mysql_db_pwd'} = $AGI->get_variable('mysql_db_pwd');

my %dbdata = (

	'fecha' => "$sdata{'fecha'}",
	'fuente' => "$sdata{'fuente'}",
	'destino' => "CALLCENTER",
	'troncal' => "ivrconsultas",
	'estado' => "$sdata{'estado'}",
	'duration' => "$sdata{'duration'}",
	'uniqueid' => "$sdata{'uniqueid'}"


	);


$sdata{'dbtable'} = "reporte_ivr";

&LogPrintHash(\%sdata,$log);


if ( "$sdata{'global_update'}" ne "0" ){
	&InsertMysql($sdata{'mysql_db_host'},$sdata{'mysql_db_name'},$sdata{'dbtable'},
		$sdata{'mysql_db_user'},$sdata{'mysql_db_pwd'},\%dbdata);
}
