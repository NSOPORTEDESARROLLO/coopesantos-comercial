#!/usr/bin/perl

use strict;
#use warnings;
use DBI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';

my $log = 'msserver.log';


#Funcion devuelve:
#error = no encuentra el registro, 0 = no hay montos, string = valor pendiente
#Necesita:
#0-> electricidad 1-> Internet cable, id digitado, usurio DB, password DB, host DB

sub GetValueFromMsserver {

	&LogPrintArray(\@_,$log);
	my $mode = $_[0];  #0 - electricidad, 1 - Cable e internet
	my $id = $_[1];
	my $user = $_[2];
	my $password = $_[3];
	my $server = $_[4];
	my $driverpath = '/opt/microsoft/msodbcsql17/lib64/libmsodbcsql.so';

	my $return;
	my $dbh;
	my $sth;
	my $SQL_CMD;

	if ($mode == 0 ) {

		#print "Elec\n";
		$dbh = DBI->connect("dbi:ODBC:Driver={$driverpath};Server=$server;Database=sfac;UID=$user;PWD=$password");
		$SQL_CMD = "SELECT sum(monto) as monto FROM [sfac].[dbo].[vi_pendiente_electricidad] WHERE convert(varchar, id_medidor)=$id";
		&LogPrintLine("$SQL_CMD",$log);
		$sth = $dbh->prepare($SQL_CMD);

	} 

	if ($mode == 1 ) {

		#print "Cable\n";
		$dbh = DBI->connect("dbi:ODBC:Driver={$driverpath};Server=$server;Database=infodb;UID=$user;PWD=$password");
        $SQL_CMD = "SELECT sum(monto) as monto FROM [infodb].[dbo].[vi_pendiente_infocomunicaciones] WHERE convert(varchar,Suscriptor)=$id";
        &LogPrintLine("$SQL_CMD",$log);
        $sth = $dbh->prepare($SQL_CMD);

	}


	$sth->execute();
	my @row = $sth->fetchrow_array;

	
	if ( "$row[0]" eq "" ){
		$return = "error";
	} else {

		$return = int($row[0]);

	}

	return $return;
}

1;