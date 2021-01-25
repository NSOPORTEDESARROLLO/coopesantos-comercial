BEGIN { push(@INC, ".."); };
use WebminCore;
&init_config();



sub strip_key_spaces {
	# Returns a key or cert with spaces removed and lowercased, for comparison

	my ($key) = $_[0];
	$key =~ s/\s+//g;
	$key = lc($key);
	$key =~ s/[#\ñ;:><=^@!`~|.%&\$*+(),]//g;

	return $key;

}






sub GetRecordings {

	#Esta funcion recibe:
	#1 - Devulve un array con los nombres de los archivos solamente
	#0 - Devuelve un array con los hash de referencia de cada registro detallado


	my $con = $_[0];

	my $recdir = "/data/apps/shared/asterisk/sounds/custom";
	my @files = `ls $recdir`;

	map { s/^\s+|\s+$//g; } @files;

	my @filesnoext;


	my @return;


	foreach my $w (@files) {

		my $stat = `stat $recdir/$w |grep ^Change`;
		my @data = split(' ', $stat);
		
		my @hourformat = split('\\.', $data[2]);

		my $filename = $w; 
		#print $data[2];
		#print @hourformat;

		$w=~ s{\.[^.]+$}{};
		push (@filesnoext, $w);

		my %hash = (

			'name' => "$w",
			'file' => "$filename",
			'date' => "$data[1]",
			'hour' => "$hourformat[0]"

			);


		push (@return,\%hash);




	}


	if ( $con == 1 ) {
	
		return @filesnoext;

	} else { 

		return @return;
	}	



}