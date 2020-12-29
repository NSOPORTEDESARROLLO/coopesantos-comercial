<?php

function getElect($id){
    $myServer = "172.28.130.49";
    $myUser = "userIVR";
    $myPass = "ivrU$3r";
    $myDB = "sfac";

    $dbhandle = mssql_connect($myServer, $myUser, $myPass)
      or die("Couldn't connect to SQL Server on $myServer"); 

    //select a database to work with
    $selected = mssql_select_db($myDB, $dbhandle)
      or die("Couldn't open database $myDB");

    $query = "SELECT sum(monto) as monto FROM [sfac].[dbo].[vi_pendiente_electricidad] WHERE convert(varchar, id_medidor)=$id";

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
