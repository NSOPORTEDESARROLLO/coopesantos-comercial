#!/usr/bin/php -q
<?
set_time_limit(30);
require_once 'phpagi.php';
require_once 'KLogger.php';
require_once 'dal.php';
require_once 'config.php';
include 'script-elect.php';

error_reporting(E_ALL);

$log = new KLogger ( __FILE__.".log" , $config['customer-ivr_log-level'] );
//$log->LogDebug('config: ' . print_r($config, true));

try
{
    $agi = new AGI();

    $log->LogDebug('agi request: ' . print_r($agi->request, true));

	$medidor = _get_var('medidor');
    $amount = get_amount_from_db($medidor);
    $log->LogDebug('final amount: ' . $amount);

   if($amount === null){
        $log->LogWarn('error getting the amount, exiting script');
        $agi->stream_file("custom/osssystems/8-num-incorrecto");
    } else if ($amount == 0) {
        $agi->stream_file("custom/osssystems/no-hay-montos-pendientes");
	

    } else {
        $agi->stream_file("custom/osssystems/montoacancelar-corto");
        $agi->say_number($amount);
        $agi->stream_file("custom/osssystems/colones");
    }
//    $agi->stream_file("custom/osssystems/muchasgracias");

} catch(Exception $e) {
    $log->LogFatal(" something went wrong " . print_r($e, true));
}

/**
 *  Function:   get_amount_from_db
 *
 *  @string $medidor
 *
 *  @return number amount
 *
 */
function get_amount_from_db($medidor){
    return getElect($medidor);
}

/**
 *  Function:   _get_var($varname)
 *
 *  Description:
 *  - get varaible using agi and parses the value
 *
 *  @string $varname
 *
 *  @return variable value
 *
 */
function _get_var($varname){

    global $log, $agi;

    $result = $agi->get_variable($varname);
    $log->LogDebug($varname.'_result: ' . print_r($result, true));

    $result_data = $result['data'];
    $log->LogDebug($varname.': ' . $result_data);

    return $result_data;

}

?>

