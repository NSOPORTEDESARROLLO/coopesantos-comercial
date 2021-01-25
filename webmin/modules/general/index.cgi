#!/usr/bin/perl

require './general-lib.pl';

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



			print ui_table_row($text{'index_mysql_db_host'},
				&ui_textbox("mysql_db_host", $data{'mysql_db_host'}, 45));


			print ui_table_row($text{'index_mysql_db_name'},
				&ui_textbox("mysql_db_name", $data{'mysql_db_name'}, 45));


			print ui_table_row($text{'index_mysql_db_user'},
				&ui_textbox("mysql_db_user", $data{'mysql_db_user'}, 45));


			print ui_table_row($text{'index_mysql_db_pwd'},
				&ui_textbox("mysql_db_pwd", $data{'mysql_db_pwd'}, 45));


			
			print ui_table_row($text{'index_msserver_db_host'},
				&ui_textbox("msserver_db_host", $data{'msserver_db_host'}, 45));

			
			print ui_table_row($text{'index_msserver_db_name'},
				&ui_textbox("msserver_db_name", $data{'msserver_db_name'}, 45));


			print ui_table_row($text{'index_msserver_db_user'},
				&ui_textbox("msserver_db_user", $data{'msserver_db_user'}, 45));


			
			print ui_table_row($text{'index_msserver_db_pwd'},
				&ui_textbox("msserver_db_pwd", $data{'msserver_db_pwd'}, 45));






			#print ui_table_row($text{'index_msserver_db_pwd'},
			#		&ui_select("msserver_db_pwd",$data{'msserver_db_pwd'},\@recfiles, 1, 0, 0, 0, undef));



			#print ui_table_row($text{'index_ivr_timeout'},
			#	&ui_textbox("averias_read_time", $data{'averias_read_time'}, 5));






		print &ui_table_end();


	print &ui_form_end([ ["save", $text{'index_save'}] ]);
	

&ui_print_footer("/", $text{'index'});
