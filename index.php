<?php
/**
 * ��ҳ
 * 
 * @version 2010-1-7 14:35:11
 * @author Zerolone
 */

require('include/common.php');
define('PAGENAME','index.php');

$cateid			= Request('cateid',0);		//��ȡ����
$pagenum 		= Request('pagenum',1);		//��ȡҳ��
$searchkey	=	Request('searchkey');		//����
$pagesize 	= 5 ;										//ҳ���¼��

$SqlStr	= 'SELECT COUNT( * ) FROM `'.DB_TABLE_PRE.'mb_blog` ';
$SqlStr.= ' WHERE 1=1 ' ;
if ($cateid<>0) {
	$SqlStr.=	' AND `cateid` ='.$cateid ;
}

if($searchkey<>''){
	$SqlStr.= ' AND `title` like \'%'. $searchkey .'%\' ' ;
}

$MyDatabase->SqlStr = $SqlStr;
$recordcount	= 0;	//�ܼ�¼
if ($MyDatabase->Query ()) {
	$DB_Record = $MyDatabase->ResultArr [0];

	$recordcount	= $DB_Record[0];
}

//*/
//Blog�б�
//-------------------0------1---------2------------3----------4----------5
$SqlStr	= ' SELECT `id`, `title`, `posttime`, `catetitle`, `cateid`, `content` from `'.DB_TABLE_PRE.'mb_view_blog`';
$SqlStr.= ' WHERE 1=1 ';
if ($cateid<>0) {
	$SqlStr.=	' AND `cateid`='.$cateid;
}

if($searchkey<>''){
	$SqlStr.= ' AND `title` like \'%'. $searchkey .'%\' ' ;
}

$SqlStr.= ' ORDER BY `id` DESC';
$SqlStr.= ' LIMIT '. $pagesize * ($pagenum-1) .' ,'.$pagesize.';';
$MyDatabase->SqlStr = $SqlStr;
if ($MyDatabase->Query ()) {
	$DB_Record_Arr = $MyDatabase->ResultArr;
	foreach ( $DB_Record_Arr as $DB_Record ) {
		$str_content	= $DB_Record[5];

		$str_content	= str_replace('{html_and}','&',$str_content);

		$blog_list[] = array(
		'id' 					=> $DB_Record[0],
		'title'				=> $DB_Record[1],
		'posttime'		=> $DB_Record[2],
		'catetitle'		=> $DB_Record[3],
		'cateid'			=> $DB_Record[4],
		'content'			=> $str_content,
		);
	}
}

//��Ŀ�б�
//------------------0------1
$SqlStr	= 'SELECT `id`, `title` FROM `' .DB_TABLE_PRE. 'mb_cate` Order By `order`';
$MyDatabase->SqlStr = $SqlStr;
if ($MyDatabase->Query ()) {
	$DB_Record_Arr = $MyDatabase->ResultArr;
	foreach ( $DB_Record_Arr as $DB_Record ) {
		$cate_list[] = array(
		'id' 				=> $DB_Record[0],
		'title'			=> $DB_Record[1],
		);
	}
}

//ÿ������ͳ��
//------------------------------0----===========--1
$SqlStr	= 'SELECT COUNT(left(posttime,7)), left(posttime,7) as `sj` FROM `' .DB_TABLE_PRE. 'mb_blog` GROUP By `sj` Order By `posttime` DESC LIMIT 5;';
$MyDatabase->SqlStr = $SqlStr;
if ($MyDatabase->Query ()) {
	$DB_Record_Arr = $MyDatabase->ResultArr;
	foreach ( $DB_Record_Arr as $DB_Record ) {
		$posttime_list[] = array(
		'count' 		=> $DB_Record[0],
		'month'			=> $DB_Record[1],
		);
	}
}

//quick�б�
//-------------------0
$SqlStr	= ' SELECT `title` from `'.DB_TABLE_PRE.'mb_quick`';
$SqlStr.= ' ORDER BY `id` DESC';
$SqlStr.= ' LIMIT 5;';
$MyDatabase->SqlStr = $SqlStr;
if ($MyDatabase->Query ()) {
	$DB_Record_Arr = $MyDatabase->ResultArr;
	foreach ( $DB_Record_Arr as $DB_Record ) {
		$quick_list[] = array(
		'title_long'				=> $DB_Record[0],
//		'title'				=> subString($DB_Record[0],36),
		'title'				=> utf_substr($DB_Record[0],42),
		);
	}
}




//����Ա��־
$ThisPage='index.php';
$log_content			= 'Blog�б�';
require('include/log.php');

require(PAGENAME.'.php');
require('include/debug.php');
?>