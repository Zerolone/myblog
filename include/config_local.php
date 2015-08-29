<?php
//计算花费时间 count cost time
$startime	= microtime();

//是否显示调试信息 show debug info 说明：1为显示，其他为不显示
define('SHOW_DEBUG', 1);

//数据库查询次数 query count
$query_count = 0;

//版本检测
if (version_compare(PHP_VERSION, '5.2.0', '<')) {
    die('本系统需要PHP版本为5.2以上，你的版本为：' . PHP_VERSION . "，请升级你的PHP版本。");
}
	
/**
 * 数据库定义 Database Define
 */
define('DB_TYPE',				'mysql5');
define('DB_USER',				'root');
define('DB_PASS',				'root');
define('DB_HOST',				'localhost');
define('DB_PORT',				'3333');
define('DB_NAME',				'MyBlogServer');
define('DB_LANG',				'UTF8');
define('DB_TABLE_PRE',	'');	
//-----------------------------------------------------------

//版本
//$site_version
$site_version = 'V4.0.0';

//网站物理路径 site dir
define('SITE_DIR',				'D:/wwwroot/wwwlee/');
define('SITE_URL',				'http://localhost/');

//网站目录， 如果为根目录， 则为空
define('SITE_FOLDER',			'');

//日志
define('SITE_LOG',	SITE_DIR . 'log.log');

//常规设置
//页面跳转时间(秒)
define('REFRESH_TIME',300);

/**
 * 文章用到的一些常量
 */
//图片路径
define('IMAGEURL',			'/article_pic/');
define('IMAGEPATH',			SITE_DIR.IMAGEURL);
//文章路径
define('ARTICLEURL',		'/article/');
define('ARTICLEPATH',		SITE_DIR.ARTICLEURL);
//模板路径
define('TEMPLATEURL',		'/template/');
define('TEMPLATEPATH',	SITE_DIR.TEMPLATEURL);
//专题路径
define('SPECIALURL',		'/special/');
define('SPECIALPATH',		SITE_DIR.SPECIALURL);

//相册路径
define('GALLERYURL',			'/gallery/');
define('GALLERYPATH',			SITE_DIR.GALLERYURL);
define('PIC_WIDTH',				240);
define('PIC_HEIGHT',			200);

//文章列表禁用文件夹
define('CANTDIR','ad|article|article_pic|images|css|include|js|manage|playbill|special|swf|template|vote');

//文章修改Flag设置
//修改后Flag
define('EDTFLAG',0);

//生成后Flag
define('HTMLFLAG',1);
//-----------------------------------------------------------

/**
 * 默认账号设置
 */
define('ADMINUSER','admin');
define('ADMINPASS','admin');

define('NAME', 'Zerolone');
define('PASS','Zerolone');

//默认组
define('GROUPID',13);
//默认权限
define('PERMISSION',524440);

//显示所有错误，警告提示
error_reporting(E_ALL);

//取消警告
//error_reporting(E_ALL & ~E_NOTICE);
//取消所有错误提示
//error_reporting(0);
?>