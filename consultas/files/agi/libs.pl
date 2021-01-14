#!/usr/bin/perl

use strict;
#use warnings;
use DBI;



sub Logger {

		my $MSG = $_[0];
		my $logfile = "/var/log/asterisk/consultas_ivr.log";
		my $timestamp = localtime(time);

		

		open(my $fh, '>>', $logfile);

			if ( "$MSG" ne "" ){
				print $fh "$timestamp ......................................... $MSG\n";
 			} else {
 				print $fh "\n\n";
 			}

		close $fh;





}

sub GetValueFromDB {
	my $mode = $_[0];  #0 - electricidad, 1 - Cable e internet
	my $id = $_[1];
	my $user = 'userIVR';
	my $password = 'ivrU$3r';
	my $server = '172.28.130.49';
	my $driverpath = '/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.6.so.1.1';

	my $return;
	my $dbh;
	my $sth;

	if ($mode == 0 ) {

		#print "Elec\n";
		$dbh = DBI->connect("dbi:ODBC:Driver={$driverpath};Server=$server;Database=sfac;UID=$user;PWD=$password");
		$sth = $dbh->prepare("SELECT sum(monto) as monto FROM [sfac].[dbo].[vi_pendiente_electricidad] WHERE convert(varchar, id_medidor)=$id");

	} 

	if ($mode == 1 ) {

		#print "Cable\n";
		$dbh = DBI->connect("dbi:ODBC:Driver={$driverpath};Server=$server;Database=infodb;UID=$user;PWD=$password");
        	$sth = $dbh->prepare("SELECT sum(monto) as monto FROM [infodb].[dbo].[vi_pendiente_infocomunicaciones] WHERE convert(varchar,Suscriptor)=$id");

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
