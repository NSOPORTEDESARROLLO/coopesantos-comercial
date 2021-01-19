#!/usr/bin/perl


use strict;
use Asterisk::AGI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/get_value_from_msserver.pl';

my $log = 'averias.log';
&LogPrintLine("Iniciando AGI para consultar si el usuario tiene pendientes", $log);


my $AGI = new Asterisk::AGI;
my %sdata = ();



$sdata{'msserver_host'} = $AGI->get_variable('msserver_db_host');
$sdata{'msserver_user'} = $AGI->get_variable('msserver_db_user');
$sdata{'msserver_pwd'} = $AGI->get_variable('msserver_db_pwd');
$sdata{'nservicio'} = $AGI->get_variable('nservicio');
$sdata{'servicio'} = $AGI->get_variable('SERVICIO');
$sdata{'audio_registro_error'} = $AGI->get_variable('averias_rnv');
$sdata{'audio_monto_pendiente'} = $AGI->get_variable('averias_mp');


#Consulto el valor en la DB
$sdata{'value'} = &GetValueFromMsserver($sdata{'nservicio'},$sdata{'servicio'},
	$sdata{'msserver_user'},$sdata{'msserver_pwd'},$sdata{'msserver_host'});


#Necesito poner correctamente el contexto de vuelta en caso de un acceso invalido
if ( "$sdata{'nservicio'}" eq "0" ){

	$sdata{'context'} = 'averias-medidor';

} else {

	$sdata{'context'} = 'averias-cable-e-internet';

}



#Si me devuelve error debo volver a pedir el usuario o reproducir montos pendientes 
if ( "$sdata{'value'}" eq "error" ) {

	$AGI->stream_file("custom/$sdata{'audio_registro_error'}");
	$AGI->set_context($sdata{'context'});
	exit 0;

} 

if ( "$sdata{'value'}" ne "0" ) {

	$AGI->stream_file("custom/$sdata{'audio_monto_pendiente'}");

} 


&LogPrintHash(\%sdata,$log);