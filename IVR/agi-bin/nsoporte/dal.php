<?php

class dal
{
    var $db;
    var $log;

    function __construct()
    {

        global $config;
        $this->db = new PDO("mysql:host={$config['db_host']};dbname={$config['db_name']}",
                $config['db_user'], $config['db_password']);

        $this->db->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

        $this->log = new KLogger ('oss_systems_database.log' , KLogger::ERROR );

    }
 
    function get_medidor_amount($medidor){
		return $this->_get_amount($medidor, 'medidores', 'medidor');
    }

    function get_asociado_amount($asociado){
		return $this->_get_amount($asociado, 'clientes_cable', 'cliente');
    }

    function _get_amount($number, $table, $idfield){
		$sql = "select monto from $table where $idfield = '$number';";	
		$ret = $this->get_one($sql);
		// print_r($ret);
		if($ret)
			return $ret->monto;
		return null;
	}

    function get_server_date()
    {
        $ret = $this->get_one('select now() as now');
        return $ret->now;
    }

    function get_one($sql)
    {
        $this->log->LogDebug('get_one(): $sql: ' . $sql);

        $result = $this->get_objects_array($sql);

        $this->log->LogDebug('get_one(): $result: ' . print_r($result, true));

		if(stripos($sql, 'count(*)')){
			$this->log->LogError('-->get_one(): $result: ' . print_r($result, true));
			$this->log->LogError("--->sql: $sql");
		}

        if(!empty($result)){
            return $result[0];
        }

        return null;
    }


    protected function get_objects_array($sql)
    {
        $statement = $this->db->query($sql);
        $result = $statement->setFetchMode(PDO::FETCH_OBJ);
        $results = array();
        while($obj = $statement->fetch())
        {
            $results[] = $obj;
        }
        return $results;
    }

}

