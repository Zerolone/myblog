<?php
//配置函数
if (strpos(' '.$_SERVER["HTTP_HOST"], 'localhost')){
	//本地调试用Config文件
	require('include/config_local.php');
}
else 
{
	//网络用Config文件
	require('include/config.php');	
}

//函数地址
require('include/function.php');

//连接数据库
require('class/'.DB_TYPE.'.php');
$MyDatabase=new Database();

//文章类
require('class/article.php');

//广告类
require('class/ad.php');

//专题类
require('class/special.php');

//代码高亮
require('class/highligther.php');
?>