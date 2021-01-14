#!/usr/bin/perl


use strict;
use Net::SMTPS;
use MIME::Lite;
use Asterisk::AGI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/sent_mail.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/insert_mysql.pl';
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';

my $log = 'ast2ticket.log';
&LogPrintLine("Iniciando Script",$log);

my $AGI = new Asterisk::AGI;
my %sdata = ();




$sdata{'filename'} = $AGI->get_variable('FILENAME');
$sdata{'servicio'} = $AGI->get_variable('SERVICIO');
$sdata{'numero'} = $AGI->get_variable('numero');
$sdata{'fecha'} = $AGI->get_variable('ast2ticket_fecha');
$sdata{'pbxurl'} = $AGI->get_variable('ast2ticket_pbxurl');
$sdata{'mailstr'} = $AGI->get_variable('ast2ticket_mails');
$sdata{'USER'} = $AGI->get_variable('ast2ticket_mailuser');
$sdata{'PWD'} = $AGI->get_variable('ast2ticket_mailpwd');
$sdata{'ivrservice'} = $AGI->get_variable('ivr_service');
$sdata{'nservicio'} = $AGI->get_variable('nservicio');
$sdata{'mysql_db_host'} = $AGI->get_variable('mysql_db_host');
$sdata{'mysql_db_name'} = $AGI->get_variable('mysql_db_name');
$sdata{'mysql_db_user'} = $AGI->get_variable('mysql_db_user');
$sdata{'mysql_db_pwd'} = $AGI->get_variable('mysql_db_pwd');

my @mails = split(',', $sdata{'mailstr'});

#Codigo para nuevos servicios
if ( "$sdata{'ivrservice'}" eq "2" ) {


	$sdata{'title'} = "Nuevo Servicio - ";
	$sdata{'class'} = "NUEVO SERVICIO";
	

	if ( "$sdata{'nservicio'}" eq "0" ){

		$sdata{'title'} = $sdata{'title'} . "Electricidad";
		$sdata{'classservice'} = "ELECTRICIDAD";

	} elsif ( "$sdata{'nservicio'}" eq "1" ){

		$sdata{'title'} = $sdata{'title'} . "Cable Internet";
		$sdata{'classservice'} = "CABLE E INTERNET";

	}  
} elsif ( "$sdata{'ivrservice'}" eq "" ){

	$sdata{'title'} = "Nueva llamada agendada"; 
	$sdata{'class'} = "PETICION DE LLAMADA";

	if ( "$sdata{'nservicio'}" eq "0" ){

		$sdata{'servicetext'} =  'para el servicio de: Electricidad: ' . $sdata{'servicio'};
		$sdata{'classservice'} = "ELECTRICIDAD";

	} elsif ( "$sdata{'nservicio'}" eq "1" ) {

		$sdata{'servicetext'} =  'para el servicio de: Cable e Internet: ' . $sdata{'servicio'};
		$sdata{'classservice'} = "CABLE E INTERNET";
	}


} elsif ( "$sdata{'ivrservice'}" eq "3" ) {

	$sdata{'title'} = "Reporte Averia - ";
	$sdata{'servicetext'} =  'para el servicio de: ' . $sdata{'servicio'};
	$sdata{'class'} = "AVERIAS";

	if ( "$sdata{'nservicio'}" eq "0" ) {

		$sdata{'title'} = sdata{'$title'} . "Electricidad";
		$sdata{'classservice'} = "ELECTRICIDAD";

	} elsif ("$sdata{'nservicio'}" eq "1"){

		$sdata{'title'} = $sdata{'title'} . "Cable";
		$sdata{'classservice'} = "CABLE";

	} elsif ("$sdata{'nservicio'}" eq "2"){

		$sdata{'title'} = $sdata{'title'} . "Internet";
		$sdata{'classservice'} = "INTERNET";

	}	elsif ("$sdata{'nservicio'}" eq "3"){

		$sdata{'title'} = $sdata{'title'} . "Cable e Internet";
		$sdata{'classservice'} = "CABLE E INTERNET";

	}	

}



#Tabla DB
$sdata{'dbtable'} = "ast2ticket";

#Full URL de la grabacion
$sdata{'fullurl'} = $sdata{'pbxurl'} . '/' . $sdata{'filename'};


#Cuerpo del correo 
$sdata{'mailbody'} = '<p>Peticion de devolucion de llamada ' . $sdata{'servicetext'} . 
					', con el numero telefonico: ' . $sdata{'numero'} . 
					'&nbsp;</p><p>Para escuchar la llamada:</p><p><a href="' . $sdata{'fullurl'} . '">' . 
					$sdata{'fullurl'} . '</a></p>';





&LogPrintHash(\%sdata,$log);



#Insertando en DB
my %dbdata = (

	'fecha' => "$sdata{'fecha'}",
	'numero' => "$sdata{'numero'}",
	'ivrservice' => "$sdata{'class'}",
	'nservicio' => "$sdata{'classservice'}",
	'cliente' => "$sdata{'servicio'}",
	'grabacion' => "$sdata{'fullurl'}"

	);


&InsertMysql($sdata{'mysql_db_host'},$sdata{'mysql_db_name'},$sdata{'dbtable'},
	$sdata{'mysql_db_user'},$sdata{'mysql_db_pwd'},\%dbdata);


&LogPrintHash(\%dbdata,$log);

#Envio de Correo a las direcciones solicitadas
foreach my $e (@mails) {

 	$e =~ s/^\s+|\s+$//g;
 	&LogPrintLine("Enviando correo a $e",$log);
	&SentMail($sdata{'USER'},$sdata{'PWD'},$e,$sdata{'title'},$sdata{'mailbody'});

}	