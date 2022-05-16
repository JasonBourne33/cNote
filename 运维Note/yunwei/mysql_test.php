
<?php
$mysql_id=mysql_connect("192.168.174.130","root","123") or mysql_error();
if($mysql_id){
    echo "mysql connection successful";
}else{
    echo mysql_error();
}












