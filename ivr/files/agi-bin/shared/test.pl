#!/usr/bin/perl


use strict;
use DBI;

require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/insert_mysql.pl';


my $numero = "88976529";
my $class = "AVERIAS";
my $classservice = "ELECTRICIDAD";
my $nservicio = "6";
my $cliente = "345";
my $servicio = "3";
my $filename = "kdfjhkjdfgh/fjhdfkjgh"; 
my $ivrservice = "4";

my %data = (

	 'fecha' => 'hoy',
	'numero' => $numero,
	'ivrservice' => $class,
	'nservicio' => $classservice,
	'cliente' => $servicio,
	'grabacion' => $filename



	);




&InsertMysql("172.17.0.1","osssystems","ast2ticket","asteriskuser","055Admintmp123.",\%data);
