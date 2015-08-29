<?php
if (!isset($_SESSION['user']))
{
	$_SESSION['user']='Unknow';
}

$ArrField=array('ip',			'user',							'url',			'content');
$ArrValue=array(GetIP(), 	$_SESSION['user'], 	$ThisPage, 	$log_content);

$MyDatabase->Insert('log', $ArrField, $ArrValue);
?>