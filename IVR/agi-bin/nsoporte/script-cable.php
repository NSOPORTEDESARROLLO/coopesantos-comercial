<?php

function getCable($id){
    $myServer = "172.28.130.49";
    $myUser = "userIVR";
    $myPass = "ivrU$3r";
    $myDB = "infodb"; 

    $dbhandle = mssql_connect($myServer, $myUser, $myPass)
      or die("Couldn't connect to SQL Server on $myServer"); 

    $selected = mssql_select_db($myDB, $dbhandle)
      or die("Couldn't open database $myDB");

    $query = "SELECT sum(monto) as monto FROM [infodb].[dbo].[vi_pendiente_infocomunicaciones] WHERE convert(varchar,Suscriptor)=$id";

    $result = mssql_query($query);

    if($result !== false){
      $row = mssql_fetch_array($result); 
      if($row["monto"] === NULL)
        return $row["monto"];
      else
        return intval ($row["monto"]);  
    }
    else{
        return null;
    }


    mssql_close($dbhandle);
}
?>
