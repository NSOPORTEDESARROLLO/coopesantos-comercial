#!/usr/bin/perl

require './queries-lib.pl';

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

		print &ui_table_start($text{'index_issues_settings'},"width=100%",2);


			print ui_table_row($text{'index_consultas_unv'},
					&ui_select("consultas_unv",$data{'consultas_unv'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_consultas_ntp'},
					&ui_select("consultas_ntp",$data{'consultas_ntp'},\@recfiles, 1, 0, 0, 0, undef));
			

			print ui_table_row($text{'index_consultas_maced'},
					&ui_select("consultas_maced",$data{'consultas_maced'},\@recfiles, 1, 0, 0, 0, undef));


			print ui_table_row($text{'index_consultas_colones'},
					&ui_select("consultas_colones",$data{'consultas_colones'},\@recfiles, 1, 0, 0, 0, undef));


			print ui_table_row($text{'index_consultas_eoc'},
					&ui_select("consultas_eoc",$data{'consultas_eoc'},\@recfiles, 1, 0, 0, 0, undef));


			print ui_table_row($text{'index_consultas_lodei'},
					&ui_select("consultas_lodei",$data{'consultas_lodei'},\@recfiles, 1, 0, 0, 0, undef));


			print ui_table_row($text{'index_consultas_dndm'},
					&ui_select("consultas_dndm",$data{'consultas_dndm'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_consultas_dnds'},
					&ui_select("consultas_dnds",$data{'consultas_dnds'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_consultas_hoc'},
					&ui_select("consultas_hoc",$data{'consultas_hoc'},\@recfiles, 1, 0, 0, 0, undef));


			#print ui_table_row($text{'index_ivr_timeout'},
			#	&ui_textbox("averias_read_time", $data{'averias_read_time'}, 5));






		print &ui_table_end();


	print &ui_form_end([ ["save", $text{'index_save'}] ]);
	

&ui_print_footer("/", $text{'index'});
