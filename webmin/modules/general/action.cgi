#!/usr/bin/perl

require './general-lib.pl';
ReadParse();

my %data = %in;
&foreign_require("issues");


#&ui_print_header(undef, $text{'index_title'}, "", undef,0,1);

if ( "$in{'save'}" ne "" ){

	delete($data{'save'});
	#&SaveVariableFile(\%data);
	&foreign_call("issues","SaveVariableFile","$config{'dir'}",\%data);

}




&redirect("index.cgi");
