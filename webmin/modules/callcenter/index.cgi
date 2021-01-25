#!/usr/bin/perl

require './callcenter-lib.pl';

my @tds = ( "width=100 valign=top", "valign=top", "valign=top", "valign=top" );
my $variablefile = $config{'dir'} . '/variables.dlp';


&foreign_require("recordings");
my @recfiles = &foreign_call("recordings","GetRecordings",1);
push (@recfiles, "");
my %data = ();
&read_file($variablefile, \%data);





&ui_print_header(undef, $text{'index_title'}, "", undef,1,1);

#print %data;

	print &ui_form_start("action.cgi");

		print &ui_table_start($text{'index_callcenter_settings'},"width=100%",2);


			

			print ui_table_row($text{'index_callcenter_route_dest'},
				&ui_textbox("callcenter_route_dest", $data{'callcenter_route_dest'}, 20));


			print ui_table_row($text{'index_callcenter_pbxtrunk'},
				&ui_textbox("callcenter_pbxtrunk", $data{'callcenter_pbxtrunk'}, 20));




		print &ui_table_end();


	print &ui_form_end([ ["save", $text{'index_save'}] ]);
	

&ui_print_footer("/", $text{'index'});
