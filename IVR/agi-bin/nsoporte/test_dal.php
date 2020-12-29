#!/usr/bin/php -q
<?
set_time_limit(30);
require_once 'KLogger.php';
require_once 'config.php';
require_once 'dal.php';

$dal = new dal();
echo $dal->get_asociado_amount("11111");
echo "\n";
echo $dal->get_asociado_amount("sgsfg");
echo "\n";


echo $dal->get_medidor_amount("12345");
echo "\n";
echo $dal->get_medidor_amount("cunts");
echo "\n";



 
/**
 *  Function:   get_amount_from_db
 *
 *  @string $asociado
 *
 *  @return number amount
 *
 */
function get_amount_from_db($asociado){
	$dal = new dal();
    return $dal->get_asociado_amount($asociado); 
}

