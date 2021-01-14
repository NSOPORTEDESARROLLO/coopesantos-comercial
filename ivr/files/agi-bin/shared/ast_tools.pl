#!/usr/bin/perl


use strict;
use Asterisk::AGI;

#Recibe un hash y lo imprime en el CLI de asterisk 
sub AstPrintHash {


	my %hashdata = %{$_[0]};

	my $AGI = new Asterisk::AGI;

	foreach my $key (keys %hashdata) {
  
		my $msg = $key . ' => ' . $hashdata{$key};
  		$AGI->verbose($msg,1);
	

	}


}





1;