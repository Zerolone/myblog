<?php
//���ú���
if (strpos(' '.$_SERVER["HTTP_HOST"], 'localhost')){
	//���ص�����Config�ļ�
	require('include/config_local.php');
}
else 
{
	//������Config�ļ�
	require('include/config.php');	
}

//������ַ
require('include/function.php');

//�������ݿ�
require('class/'.DB_TYPE.'.php');
$MyDatabase=new Database();

//������
require('class/article.php');

//�����
require('class/ad.php');

//ר����
require('class/special.php');

//�������
require('class/highligther.php');
?>