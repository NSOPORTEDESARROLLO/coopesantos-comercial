#!/usr/bin/perl

require './call2ticket-lib.pl';

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

		print &ui_table_start($text{'index_settings'},"width=100%",2);


			## Mail Settings

			#print &ui_table_row("",&ui_table_hr(),2);

			print &ui_table_span("<H2 align='center'>$text{'index_mail_settings'}</H2");


			print ui_table_row($text{'index_ast2ticket_mails'},
				&ui_textbox("ast2ticket_mails", $data{'ast2ticket_mails'}, 100));


			print ui_table_row($text{'index_ast2ticket_mailuser'},
				&ui_textbox("ast2ticket_mailuser", $data{'ast2ticket_mailuser'}, 30));

			print ui_table_row($text{'index_ast2ticket_mailpwd'},
				&ui_textbox("ast2ticket_mailpwd", $data{'ast2ticket_mailpwd'}, 30));


			## Audio Settings

			print &ui_table_row("",&ui_table_hr(),2);

			print &ui_table_span("<H2 align='center'>$text{'index_audio_selector'}</H2");

			print ui_table_row($text{'index_ast2ticket_ient'},
					&ui_select("ast2ticket_ient",$data{'ast2ticket_ient'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_ast2ticket_ene'},
					&ui_select("ast2ticket_ene",$data{'ast2ticket_ene'},\@recfiles, 1, 0, 0, 0, undef));
			

			print ui_table_row($text{'index_ast2ticket_ct'},
					&ui_select("ast2ticket_ct",$data{'ast2ticket_ct'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_ast2ticket_eoc'},
					&ui_select("ast2ticket_eoc",$data{'ast2ticket_eoc'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_ast2ticket_gm'},
					&ui_select("ast2ticket_gm",$data{'ast2ticket_gm'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_ast2ticket_cf'},
					&ui_select("ast2ticket_cf",$data{'ast2ticket_cf'},\@recfiles, 1, 0, 0, 0, undef));

			print ui_table_row($text{'index_ast2ticket_nccu'},
					&ui_select("ast2ticket_nccu",$data{'ast2ticket_nccu'},\@recfiles, 1, 0, 0, 0, undef));


			## Timing

			print &ui_table_row("",&ui_table_hr(),2);

			print &ui_table_span("<H2 align='center'>$text{'index_ivr_settings'}</H2");

			print ui_table_row($text{'index_ast2ticket_message_time'},
				&ui_textbox("ast2ticket_message_time", $data{'ast2ticket_message_time'}, 30));

			
			print ui_table_row($text{'index_ast2ticket_read_time'},
				&ui_textbox("ast2ticket_read_time", $data{'ast2ticket_read_time'}, 30));


			print ui_table_row($text{'index_ast2ticket_pbxurl'},
				&ui_textbox("ast2ticket_pbxurl", $data{'ast2ticket_pbxurl'}, 30));




		print &ui_table_end();


	print &ui_form_end([ ["save", $text{'index_save'}] ]);
	

&ui_print_footer("/", $text{'index'});
