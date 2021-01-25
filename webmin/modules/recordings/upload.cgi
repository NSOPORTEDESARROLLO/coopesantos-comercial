#!/usr/bin/perl

require './recordings-lib.pl';
&ReadParse();

if ( exists $in{'delete'} ) {

	my @d = split(/\0/, $in{'d'});

	#reviso la seleccion 
	@d || &error($text{'check_error'});


	#&ui_print_header(undef, $text{'index_title'}, "", undef,0,1);
	foreach (@d) {

		my $cmd_rm = 'rm -f ' . $config{'recordings_dir'} . '/' . $_;
		&execute_command("$cmd_rm"); 
	}


	&redirect("index.cgi");



} else {


&ui_print_header(undef, $text{'index_title'}, "", undef,0,1);


	&GetRecordings;

	@links = ( &select_all_link("d"),
		&select_invert_link("d"));

	my @tds = ( "width=5 valign=top", "valign=top", "valign=top", "valign=top" );

		
	print &ui_form_start("action.cgi", "form-data");
  
		print ui_table_start($text{'upload_recording'}, undef, 2);

			print ui_table_row($text{'recording_name'},
		    	ui_textbox("recording_name", "", 35) . "\n" .
		    	ui_upload("upload"));


		print ui_table_end();	


	
	print &ui_form_end([ ["create", $text{'index_create'}] ]);
		

&ui_print_footer("/", $text{'index'});

}
