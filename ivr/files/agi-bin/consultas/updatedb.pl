#!/usr/bin/perl 

use strict;
#use warnings;
use Asterisk::AGI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/insert_mysql.pl';

my $AGI = new Asterisk::AGI;

my $log = 'consultas.log';
my %sdata = ();

&LogPrintLine("Incia actualizacion de datos de consultas para el IVR");



$sdata{'mysql_db_host'} = $AGI->get_variable('mysql_db_host');
$sdata{'mysql_db_name'} = $AGI->get_variable('mysql_db_name');
$sdata{'mysql_db_user'} = $AGI->get_variable('mysql_db_user');
$sdata{'mysql_db_pwd'} = $AGI->get_variable('mysql_db_pwd');
$sdata{'nservice'} = $AGI->get_variable('nservice');
$sdata{'callerid'} = $AGI->get_variable('callerid');
$sdata{'uniqueid'} = $AGI->get_variable('uid');
$sdata{'date'} = $AGI->get_variable('date');
$sdata{'estado'} = $AGI->get_variable('status');
$sdata{'duration'} = $AGI->get_variable('time');

#Chequeo el identificador de llamadas para ver si el numero es privado
if ( "$sdata{'callerid'}" eq "" ){

	$sdata{'cid'} = "PRIVADO";

} else {

	$sdata{'cid'} = "$sdata{'callerid'}";
}


#Analizamos el servicio 
if ( "$sdata{'nservice'}" ne "" ) {
	
	
	if ( "$sdata{'nservice'}" eq "0" ){

		$sdata{'destino'} = "CONSULTA-MEDIDOR";

	} elsif ( "$sdata{'nservice'}" eq "1" ) {

		$sdata{'destino'} = "CONSULTA-CABLE-INTERNET";

	} elsif ( "$sdata{'nservice'}" eq "2" ) {

		$sdata{'destino'} = "CALLCENTER";
	}
}
		
&LogPrintLine("Hash sdata:",$log);	
&LogPrintHash(\%sdata,$log);

	
#Armo el Hash para insertar en el SQL
my %sqldata = (

	'fecha' => "$sdata{'date'}",
	'fuente' => "$sdata{'cid'}",
	'destino' => "$sdata{'destino'}",
	'troncal' => 'ivrconsultas',
	'estado' => 'ANSWERED',
	'duration' => "$sdata{'duration'}",
	'uniqueid' => "$sdata{'uniqueid'}"


	);

&LogPrintLine("Hash sqldata:",$log);	
&LogPrintHash(\%sqldata,$log);

&InsertMysql($sdata{'mysql_db_host'},$sdata{'mysql_db_name'},"reporte_ivr",
	$sdata{'mysql_db_user'},$sdata{'mysql_db_pwd'},\%sqldata);

