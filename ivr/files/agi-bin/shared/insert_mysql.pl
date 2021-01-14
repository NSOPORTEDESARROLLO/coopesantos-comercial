#!/usr/bin/perl


use strict;
use DBI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/shared/logger.pl';

#### Inserta valores de un hash a una BD MYSQL, requiere:
#host,Nombre de la DB,tabla,usuario,password,referencia del hash

my $log = 'mysql.log';

sub InsertMysql {

	&LogPrintLine("Funcion de MYSQL",$log);
	my $host = "$_[0]"; 
	my $dbname = "$_[1]";
	my $dbtable = "$_[2]"; 	 
	my $username = "$_[3]";
	my $password = "$_[4]";
	my $data = $_[5];


	my %hashdata = %{$data};

	my $SQL_KEYS;
	my $SQL_VALUES;

	foreach my $key (keys %hashdata ){

		$SQL_KEYS = $SQL_KEYS . ", `" . $key . "`";
		$SQL_VALUES = $SQL_VALUES . ", '" . $hashdata{$key}. "'";


	}



	my $SQL_CMD = 'INSERT INTO ' . $dbtable . ' ( ' . substr($SQL_KEYS, 2) . ' ) VALUES ( '
					. substr($SQL_VALUES, 2) . ' )' ;
	

	&LogPrintLine("$SQL_CMD",$log);				

	my $dsn = "DBI:mysql:database=$dbname;host=$host";

	# connect to MySQL database
	my %attr = ( PrintError=>0,  # turn off error reporting via warn()
         	    RaiseError=>1   # report error via die()
           	);

	my $dbh = DBI->connect($dsn, $username, $password, \%attr) 
    		or die "Can't connect to database: $DBI::errstr";



	my $SQL = $dbh->prepare($SQL_CMD);
	$SQL->execute();
	$SQL->finish();


	$dbh->disconnect();



}



1;