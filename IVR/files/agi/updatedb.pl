#!/usr/bin/perl


use strict;
use DBI;
use Asterisk::AGI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/libs.pl';

my $AGI = new Asterisk::AGI;

my $callerid = $AGI->get_variable('callerid');
my $mode = $AGI->get_variable('mode');
my $uniqueid = $AGI->get_variable('uid');
my $date = $AGI->get_variable('date');
my $estado = $AGI->get_variable('status');
my $duration = $AGI->get_variable('time');


&Logger("Inicia la insercion de datos al MYSQL");
&Logger("CallerID: $callerid");
&Logger("mode: $mode");
&Logger("uniqueid: $uniqueid");
&Logger("date: $date");
&Logger("Estado: $estado");
&Logger("duracion: $duration");


my $cid;

if ( $callerid eq "" ){
	$cid = "PRIVADO";
} else {
	$cid = $callerid;
}


my $destino;

if ( $mode ne "" ) {
	
	
	if ($mode eq 0){
		$destino = "CONSULTA-MEDIDOR";

	} elsif ($mode eq 1) {
		$destino = "CONSULTA-CABLE";
	} elsif ($mode = 2) {
		$destino = "CALLCENTER";
	}
		
	&Logger("destino: $destino");


	my $dsn = "DBI:mysql:database=osssystems;host=172.17.0.1";
	my $username = "asteriskuser";
	my $password = "055Admintmp123.";

	# connect to MySQL database
	my %attr = ( PrintError=>0,  # turn off error reporting via warn()
         	    RaiseError=>1   # report error via die()
           	);

	my $dbh = DBI->connect($dsn, $username, $password, \%attr) 
    		or die "Can't connect to database: $DBI::errstr";


	my $SQL_CMD = "INSERT INTO reporte_ivr (fecha, fuente, destino, troncal, estado, duration, uniqueid) VALUES ( '$date', '$cid', '$destino', 'ivrconsultas', '$estado', '$duration', '$uniqueid')";


	&Logger("SQL: $SQL_CMD");

	my $SQL = $dbh->prepare($SQL_CMD);
	$SQL->execute();
	$SQL->finish();


	$dbh->disconnect();
}

&Logger();
