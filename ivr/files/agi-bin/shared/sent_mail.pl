#!/usr/bin/perl


use strict;
use Net::SMTPS;
use MIME::Lite;


#Envia un correo electronico mediante office 365 recibe:
#Usuario,$password,destinatario,titulo,cuerpo del mensaje 


sub SentMail {

	my $USERNAME = $_[0];
	my $PASSWORD = $_[1];
	my $TO = $_[2];
	my $SUB = $_[3];
	my $TEXT = $_[4];


	my $msg = MIME::Lite ->new (  
	From => $USERNAME,
	To => $TO,
	Subject => $SUB,  
	Data => $TEXT,  
	Type => 'text/html'  
	);  
	
	my $smtps = Net::SMTPS->new("smtp.office365.com", Port => 587,  doSSL => 'starttls');
 
	$smtps->auth ( $USERNAME, $PASSWORD ) or DIE("Could not authenticate with office365.\n");
 
	$smtps ->mail($USERNAME);  
	$smtps->to($TO);
	$smtps->data(); 
	$smtps->datasend( $msg->as_string() );  
	$smtps->dataend();  
	$smtps->quit;

}


1;