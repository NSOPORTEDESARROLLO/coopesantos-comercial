<?php
  /* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version {ISSBEL_VERSION}                                               |
  | http://www.issabel.org                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2017 Issabel Foundation                                |
  | Copyright (c) 2006 Palosanto Solutions S. A.                         |
  +----------------------------------------------------------------------+
  | The contents of this file are subject to the General Public License  |
  | (GPL) Version 2 (the "License"); you may not use this file except in |
  | compliance with the License. You may obtain a copy of the License at |
  | http://www.opensource.org/licenses/gpl-license.php                   |
  |                                                                      |
  | Software distributed under the License is distributed on an "AS IS"  |
  | basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  |
  | the License for the specific language governing rights and           |
  | limitations under the License.                                       |
  +----------------------------------------------------------------------+
  | The Initial Developer of the Original Code is PaloSanto Solutions    |
  +----------------------------------------------------------------------+
  $Id: paloSantoIVR_REPORT.class.php,v 1.1 2017-12-10 06:12:32 allan campos nosallan@gmail.com Exp $ */
class paloSantoIVR_REPORT{
    var $_DB;
    var $errMsg;

    function paloSantoIVR_REPORT(&$pDB)
    {
        // Se recibe como parámetro una referencia a una conexión paloDB
        if (is_object($pDB)) {
            $this->_DB =& $pDB;
            $this->errMsg = $this->_DB->errMsg;
        } else {
            $dsn = (string)$pDB;
            $this->_DB = new paloDB($dsn);

            if (!$this->_DB->connStatus) {
                $this->errMsg = $this->_DB->errMsg;
                // debo llenar alguna variable de error
            } else {
                // debo llenar alguna variable de error
            }
        }
    }

    /*HERE YOUR FUNCTIONS*/

    function getNumIVR_REPORT($date_start, $date_end, $filter_field, $filter_value)
    {
        $where    = "";
        $arrParam = array();
        if(isset($filter_field) & $filter_field !="" ){
            $where    = " AND $filter_field like ?";
            $arrParam = array("%$filter_value%");
        }
		$dates = array($date_start, $date_end);
		$arrParam = array_merge($dates,$arrParam);
        $query   = "select COUNT(*) from averias where fecha >= ? AND fecha <= ? $where order by fecha desc;";
        $result=$this->_DB->getFirstRowQuery($query, false, $arrParam);
		if($result==FALSE){
            $this->errMsg = $this->_DB->errMsg;
            return 0;
        }
        return $result[0];
    }

    function getIVR_REPORT($date_start, $date_end, $filter_field, $filter_value)
    {
		$where    = "";
        $arrParam = array();
        if(isset($filter_field) & $filter_field !="" ){
            $where    = " AND $filter_field like ?";
            $arrParam = array("%$filter_value%");
        }
		$dates = array($date_start, $date_end);
		$arrParam = array_merge($dates,$arrParam);
 		$query   = "select * from averias where fecha >= ? AND fecha <= ?  $where order by fecha desc;";
        $result=$this->_DB->fetchTable($query, false, $arrParam);
        if($result==FALSE){
            $this->errMsg = $this->_DB->errMsg;
            return null;
        }
        return $result;
    }
	function getDataByPagination($arrData, $limit, $offset)
    {
		$arrResult = array();
		$limitInferior = "";
		$limitSuperior = "";
		if($offset == 0){
			$limitInferior = $offset;
			$limitSuperior = $offset + $limit -1;
		}else{
			$limitInferior = $offset + 1;
			$limitSuperior = $offset + $limit +1;
		}
		$cont = 0;
		foreach($arrData as $key => $value){
			if($key > $limitSuperior){
			$cont = 0;
			break;
			}
			if($key >= $limitInferior & $key <= $limitSuperior){
			$arrResult[]=$arrData[$key]; //echo $key."<br />";
			}

		}
		//echo "limit: $limit , offset $offset , $limitInferior-$limitSuperior   ";
		//echo count($arrResult);
		return $arrResult;
    }
}
