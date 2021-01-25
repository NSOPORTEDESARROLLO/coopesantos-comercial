#!/usr/bin/perl

require './recordings-lib.pl';
#ReadParse();
&ReadParseMime();


#&ui_print_header(undef, $text{'index_title'}, "", undef,0,1);

	$in{'upload'} || &error($text{'upload_error'});
	$in{'recording_name'} || &error($text{'name_error'});

	my $tmpfile = &tempname();


	&open_tempfile(KEY, ">$tmpfile");
	&print_tempfile(KEY, $in{'upload'});
	&close_tempfile(KEY);

	my $filename = &strip_key_spaces($in{'recording_name'});
	my $CMD = $config{'ffmpeg_path'} . ' -i ' . $tmpfile . ' ' . $config{'ffmpeg_options'} .
		' ' . $config{'recordings_dir'} . '/' . $filename . '.sln';

	&execute_command($CMD);
	&execute_command("chown -R asterisk.asterisk $config{'recordings_dir'}");

	&execute_command("rm -f $tmpfile");
	

&redirect("index.cgi");