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
  $Id: index.php,v 1.1 2017-12-10 06:12:32 allan campos nosallan@gmail.com Exp $ */
//include issabel framework
include_once "libs/paloSantoGrid.class.php";
include_once "libs/paloSantoForm.class.php";
include_once "libs/paloSantoConfig.class.php";
require_once "libs/misc.lib.php";

function _moduleContent(&$smarty, $module_name)
{
    //include module files
    include_once "modules/$module_name/configs/default.conf.php";
    include_once "modules/$module_name/libs/paloSantoIVR_REPORT.class.php";

	$base_dir=dirname($_SERVER['SCRIPT_FILENAME']);
	
	load_language_module($module_name);
	
	//global variables
    global $arrConf;
    global $arrConfModule;
	$arrConf = array_merge($arrConf,$arrConfModule);
	
    //folder path for custom templates
    $templates_dir=(isset($arrConf['templates_dir']))?$arrConf['templates_dir']:'themes';
    $local_templates_dir="$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    //conexion resource
    $pDB = new paloDB($arrConf['dsn_conn_database']);
	if (!is_object($pDB->conn) || $pDB->errMsg!="") {
        $smarty->assign("mb_title", _tr("Error"));
        $smarty->assign("mb_message", _tr("Error when connecting to database")." ".$pDB->errMsg);
        return NULL;
    }

    //actions
    $action = getAction();
    $content = "";

    switch($action){
        default:
            $content = reportIVR_REPORT($smarty, $module_name, $local_templates_dir, $pDB, $arrConf);
            break;
    }
    return $content;
}

function reportIVR_REPORT($smarty, $module_name, $local_templates_dir, &$pDB, $arrConf)
{
	ini_set('max_execution_time', 3600);
	
    $pIVR_REPORT = new paloSantoIVR_REPORT($pDB);
	$oFilterForm  = new paloForm($smarty, createFieldFilter());
    $filter_field = getParameter("filter_field");
    $filter_value = getParameter("filter_value");
	$date_start   = getParameter("date_start");
    $date_end     = getParameter("date_end");
	
    //begin grid parameters
    $oGrid  = new paloSantoGrid($smarty);
    $oGrid->setTitle(_tr("Ivr Report"));
    $oGrid->pagingShow(true); // show paging section.
    $oGrid->enableExport();   // enable export.
    $oGrid->setNameFile_Export(_tr("Ivr Report"));

    $url = array(
        "menu"         =>  $module_name,
        "filter_field" =>  $filter_field,
        "filter_value" =>  $filter_value
	);
	
	$date_start = (isset($date_start))?$date_start:date("d M Y").' 00:00';
    $date_end   = (isset($date_end))?$date_end:date("d M Y").' 23:59';
    $_POST['date_start'] = $date_start;
    $_POST['date_end']   = $date_end;
	
	$parmFilter = array(
        "date_start" => $date_start,
        "date_end" => $date_end
    );
	
	if (!$oFilterForm->validateForm($parmFilter)) {
        $smarty->assign(array(
            'mb_title'      =>  _tr('Validation Error'),
            'mb_message'    =>  '<b>'._tr('The following fields contain errors').':</b><br/>'.
                                implode(', ', array_keys($oFilterForm->arrErroresValidacion)),
        ));
        $date_start = date("d M Y").' 00:00';
        $date_end   = date("d M Y").' 23:59';
    }

    $url = array_merge($url, array('date_start' => $date_start,'date_end' => $date_end));

    $oGrid->setURL($url);
	$arrData = null;
	$date_start_format = date('Y-m-d H:i:s',strtotime($date_start.":00"));
	$date_end_format   = date('Y-m-d H:i:s',strtotime($date_end.":59"));
	$total   = $pIVR_REPORT->getNumIVR_REPORT($date_start_format, $date_end_format,
        $filter_field, $filter_value);
	$arrColumns = array(_tr("Date"),_tr("Source"),_tr("Destination"),_tr("Trunk"),_tr("State"),_tr("Duration"));
	//$arrColumns = array($total ,$date_start_format,$date_end_format,_tr("Trunk"),_tr("State"),_tr("Duration"));
    $oGrid->setColumns($arrColumns);
	
	$arrResult =$pIVR_REPORT->getIVR_REPORT($date_start_format, $date_end_format,$filter_field, $filter_value);
    if(is_array($arrResult) && $total>0){
        foreach($arrResult as $key => $value){ 
	    $arrTmp[0] = $value[0];
	    $arrTmp[1] = $value[1];
		$arrTmp[2] = $value[2];
	    $arrTmp[3] = $value[3];
		$arrTmp[4] = $value[4];
	    $arrTmp[5] = $value[5];
            $arrData[] = $arrTmp;
        }
    }
	
    
    if($oGrid->isExportAction()){
        $limit  = $total; // max number of rows.
        $offset = 0;      // since the start.
		$size = count($arrData);
        $oGrid->setData($arrData);
    }
    else{
        $limit  = 20;
		$oGrid->setLimit($limit);
		$oGrid->setTotal($total);
		$offset = $oGrid->calculateOffset(); 
		$arrResult = $pIVR_REPORT->getDataByPagination($arrData, $limit, $offset);
		$oGrid->setData($arrResult);
    }

    

    //begin section filter
    $smarty->assign("SHOW", _tr("Show"));
    $htmlFilter  = $oFilterForm->fetchForm("$local_templates_dir/filter.tpl","",$_POST);
    //end section filter

    $oGrid->showFilter(trim($htmlFilter));
    $content = $oGrid->fetchGrid();
    //end grid parameters

    return $content;
}


function createFieldFilter(){
    $arrFilter = array(
            "destino" => _tr("Destination"),
            "fuente" => _tr("Source"),
                    );

    $arrFormElements = array(
            "filter_field" => array("LABEL"                  => _tr("Search"),
                                    "REQUIRED"               => "no",
                                    "INPUT_TYPE"             => "SELECT",
                                    "INPUT_EXTRA_PARAM"      => $arrFilter,
                                    "VALIDATION_TYPE"        => "text",
                                    "VALIDATION_EXTRA_PARAM" => ""),
            "filter_value" => array("LABEL"                  => "",
                                    "REQUIRED"               => "no",
                                    "INPUT_TYPE"             => "TEXT",
                                    "INPUT_EXTRA_PARAM"      => "",
                                    "VALIDATION_TYPE"        => "text",
                                    "VALIDATION_EXTRA_PARAM" => ""),
            "date_start"  => array("LABEL"                  => _tr("Start Date"),
                                    "REQUIRED"               => "yes",
                                    "INPUT_TYPE"             => "DATE",
                                    "INPUT_EXTRA_PARAM"      => array("TIME" => true, "FORMAT" => "%d %b %Y %H:%M"),
                                    "VALIDATION_TYPE"        => "",
                                    "VALIDATION_EXTRA_PARAM" => "^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}[[:space:]]+[[:digit:]]{1,2}:[[:digit:]]{1,2}$"),
            "date_end"    => array("LABEL"                  => _tr("End Date"),
                                    "REQUIRED"               => "yes",
                                    "INPUT_TYPE"             => "DATE",
                                    "INPUT_EXTRA_PARAM"      => array("TIME" => true, "FORMAT" => "%d %b %Y %H:%M"),
                                    "VALIDATION_TYPE"        => "ereg",
                                    "VALIDATION_EXTRA_PARAM" => "^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}[[:space:]]+[[:digit:]]{1,2}:[[:digit:]]{1,2}$"),
                    );
    return $arrFormElements;
}


function getAction()
{
    if(getParameter("save_new")) //Get parameter by POST (submit)
        return "save_new";
    else if(getParameter("save_edit"))
        return "save_edit";
    else if(getParameter("delete"))
        return "delete";
    else if(getParameter("new_open"))
        return "view_form";
    else if(getParameter("action")=="view")      //Get parameter by GET (command pattern, links)
        return "view_form";
    else if(getParameter("action")=="view_edit")
        return "view_form";
    else
        return "report"; //cancel
}
?>