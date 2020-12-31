#!/usr/bin/perl 

use strict;
#use warnings;
use Asterisk::AGI;
require '/opt/asterisk/var/lib/asterisk/agi-bin/libs.pl';

my $AGI = new Asterisk::AGI;

my $id = $AGI->get_variable('id');
my $mode = $AGI->get_variable('mode');

&Logger("ID: $id");
&Logger("mode: $mode");

my $value;



if ( $mode eq 0 ) {

	$value = &GetValueFromDB(0,$id);
}


if ( $mode eq 1 ) {

        $value = &GetValueFromDB(1,$id);
}


&Logger("value: $value");


if ( $value eq "error" ){

	$AGI->stream_file("custom/8-num-incorrecto");
	&Logger("Numero incorrecto");
	&Logger();
	exit 0;

} 

if ( $value eq 0 ){

        $AGI->stream_file("custom/no-hay-montos-pendientes");
	&Logger("No hay montos pendientes");
	&Logger();
	exit 0;
}  


$AGI->stream_file("custom/montoacancelar-corto");
$AGI->say_number($value);
$AGI->stream_file("custom/colones");


&Logger();
exit 0;
