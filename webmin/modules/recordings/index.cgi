#!/usr/bin/perl

require './recordings-lib.pl';




&ui_print_header(undef, $text{'index_title'}, "", undef,1,1);


	&GetRecordings;

	@links = ( &select_all_link("d"),
		&select_invert_link("d"));

	push(@links,&ui_link("ca_create.cgi",$text{'ca_create'}));
	my @tds = ( "width=5 valign=top", "valign=top", "valign=top", "valign=top" );

		
	print &ui_form_start("upload.cgi");
	print &ui_links_row(\@links);
			
		print &ui_columns_start([ "",$text{'index_recording_name'},
								$text{'index_recording_date'},
								$text{'index_recording_hour'}], 100, 0, \@tds,undef,1);


			my $count = 0;
			foreach my $w (&GetRecordings()) {;
			
				print &ui_checked_columns_row([$w->{'name'},
					$w->{'date'},$w->{'hour'}],undef, "d",$w->{'file'});

			$count++;	

			}
		

			
	    print &ui_columns_end();
	    
	print &ui_links_row(\@links);   

	
	print &ui_form_end([ ["delete", $text{'index_delete'}], ["create", $text{'index_create'}] ]);
		

&ui_print_footer("/", $text{'index'});
