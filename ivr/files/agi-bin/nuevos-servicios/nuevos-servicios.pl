#!/usr/bin/perl


use strict;
use Asterisk::AGI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/insert_mysql.pl';

my $log = 'nuevos-servicios.log';
&LogPrintLine("Iniciando AGI para Nuevos Servicios", $log);


my $AGI = new Asterisk::AGI;
my %sdata = ();


$sdata{'fuente'} = $AGI->get_variable('callerid');
$sdata{'estado'} = $AGI->get_variable('estado');
$sdata{'uniqueid'} = $AGI->get_variable('uid');
$sdata{'fecha'} = $AGI->get_variable('fecha');
$sdata{'duration'} = $AGI->get_variable('duration');
$sdata{'dest'} = $AGI->get_variable('dest');
$sdata{'nservicio'} = $AGI->get_variable('nservicio');
$sdata{'mysql_db_host'} = $AGI->get_variable('mysql_db_host');
$sdata{'mysql_db_name'} = $AGI->get_variable('mysql_db_name');
$sdata{'mysql_db_user'} = $AGI->get_variable('mysql_db_user');
$sdata{'mysql_db_pwd'} = $AGI->get_variable('mysql_db_pwd');


my %dbivr = (

	'fecha' => "$sdata{'fecha'}",
	'fuente' => "$sdata{'fuente'}",
	'destino' => "NUEVOS-SERVICIOS",
	'troncal' => "ivrconsultas",
	'estado' => "ANSWERED",
	'duration' => "$sdata{'duration'}",
	'uniqueid' => "$sdata{'uniqueid'}"


	);

#Reviso el servicio de la llamada
if ( "$sdata{'nservicio'}" eq "0" ) {

	$sdata{'servicio'} = "ELECTRICIDAD";

} elsif ( "$sdata{'nservicio'}" eq "1" ) {

	$sdata{'servicio'} = "CABLE E INTERNET";

}




#Reviso el destino de la llamada 
if ("$sdata{'dest'}" eq "0" ){

	$sdata{'ruta_destino'} = "CALLCENTER";

} elsif  ("$sdata{'dest'}" eq "1" ) {

	$sdata{'ruta_destino'} = "DEVOLUCION LLAMADA";

}


my %dbnservicios = (

	'fecha' => "$sdata{'fecha'}",
	'numero' => "$sdata{'fuente'}",
	'destino' => "$sdata{'ruta_destino'}",
	'servicio' => "$sdata{'servicio'}"

	);



$sdata{'ivrtable'} = "reporte_ivr";
$sdata{'nstable'} = "nservicios";

&LogPrintHash(\%dbivr,$log);
&LogPrintHash(\%dbnservicios,$log);


#Solo si hay destino se inserta en la DB
if ( "$sdata{'dest'}" ne "" ) {
	&InsertMysql($sdata{'mysql_db_host'},$sdata{'mysql_db_name'},$sdata{'ivrtable'},
		$sdata{'mysql_db_user'},$sdata{'mysql_db_pwd'},\%dbivr);



	#Insertar en reporte de servicios nuevos

	&InsertMysql($sdata{'mysql_db_host'},$sdata{'mysql_db_name'},$sdata{'nstable'},
		$sdata{'mysql_db_user'},$sdata{'mysql_db_pwd'},\%dbnservicios);


}