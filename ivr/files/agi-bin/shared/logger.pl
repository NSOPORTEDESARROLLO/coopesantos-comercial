#!/usr/bin/perl 

use strict;
#use warnings;


my $LogPath = '/var/log/asterisk';



sub LogPrintArray {


	
	my $arraydata = $_[0];
	my $LogFile = $_[1];


	my $logfile =  $LogPath .  '/' . $LogFile;
	my $timestamp = localtime(time);
	my $counter = 0;
	


	open(my $fh, '>>', $logfile);

	print $fh "$timestamp .............................. Imprimiendo Array\n";

		foreach my $k (@{$arraydata}) {
  
		my $msg = '  		[' . $counter . ']  ------> ' . $k;
  		print $fh "$msg\n";
  		$counter ++;

		}



	close $fh;





}





sub LogPrintHash {


	my $hashdata = $_[0];
	my $LogFile = $_[1];


	my $logfile =  $LogPath .  '/' . $LogFile;
	my $timestamp = localtime(time);

	


	open(my $fh, '>>', $logfile);

	print $fh "$timestamp .............................. Imprimiendo Hash\n";

		foreach my $key (keys %{$hashdata}) {
  
		my $msg = '            ' . $key . ' => ' . ${$hashdata}{$key};
  		print $fh "$msg\n";

		}



	close $fh;


}




sub LogPrintLine {

		my $MSG = $_[0];
		my $LogFile = $_[1];

		my $logfile =  $LogPath .  '/' . $LogFile;
		my $timestamp = localtime(time);

		

		open(my $fh, '>>', $logfile);

			if ( "$MSG" ne "" ){
				print $fh "$timestamp ......................................... $MSG\n";
 			} else {
 				print $fh "\n\n";
 			}

		close $fh;





}

1;

