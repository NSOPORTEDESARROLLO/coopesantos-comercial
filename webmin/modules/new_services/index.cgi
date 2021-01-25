#!/usr/bin/perl

require './new_services-lib.pl';

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

		print &ui_table_start($text{'index_nservicios_settings'},"width=100%",2);


			#print &ui_table_row("",&ui_table_hr(),2);

			print &ui_table_span("<H2 align='center'>$text{'index_audio_selector'}</H2");


			print ui_table_row($text{'index_nservicios_eoc'},
					&ui_select("nservicios_eoc",$data{'nservicios_eoc'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_nservicios_doa'},
					&ui_select("nservicios_doa",$data{'nservicios_doa'},\@recfiles, 1, 0, 0, 0, undef));
			

			print ui_table_row($text{'index_nservicios_lodei'},
					&ui_select("nservicios_lodei",$data{'nservicios_lodei'},\@recfiles, 1, 0, 0, 0, undef));


			print &ui_table_row("",&ui_table_hr(),2);

			print &ui_table_span("<H2 align='center'>$text{'index_ivr_settings'}</H2");


			print ui_table_row($text{'index_nservicios_read_time'},
				&ui_textbox("nservicios_read_time", $data{'nservicios_read_time'}, 5));






		print &ui_table_end();


	print &ui_form_end([ ["save", $text{'index_save'}] ]);
	

&ui_print_footer("/", $text{'index'});
