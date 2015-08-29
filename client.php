<?php
/*
 * 客户端连接用接口
 *
 * @version 2010-1-15 15:55:46
 * @author	Zerolone
 *
 */
require('include/common.php');

$id				= Request('id',0);					//编号
$cateid		=	Request('cateid',0);			//栏目编号
$title		= Request('title');					//标题
$title		= stripslashes($title);
$content	= Request('content');				//文章内容
$posttime	= Request('posttime');			//提交时间
$update		=	Request('update');				//更新状态
$order		= Request('order');
$mode			= Request('mode');					//提交方式， add为添加， edit为修改

$checkconnect=Request('checkconnect');
if ($checkconnect=='true'){
	echo 'true';
	exit();
}

//echo $title;

if($mode=='add'){
	//---------------编号--栏目编号--标题------内容--------修改时间----状态
	$ArrField=array('id',	'cateid',	'title',	'content',	'posttime',	'update');
	$ArrValue=array($id,	$cateid,	$title,		$content,		$posttime,	$update);

	if ($MyDatabase->Insert('mb_blog',$ArrField,$ArrValue))	{
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：添加失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

if($mode=='edit'){
	//---------------栏目编号--标题------内容--------状态
	$ArrField=array('cateid',	'title',	'content',	'update');
	$ArrValue=array($cateid,	$title,		$content,		$update);

	if ($MyDatabase->Update('mb_blog',$ArrField,$ArrValue, '`id`='.$id))	{
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：修改失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

if($mode=='del'){
	//---------------栏目编号--标题------内容--------状态
	$ArrField=array('cateid',	'title',	'content',	'update');
	$ArrValue=array($cateid,	$title,		$content,		$update);

	if ($MyDatabase->Delete('mb_blog', '`id`='. $id)){
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：删除失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

/////////////
///分类处理//
/////////////
$refresh_txt = '';

if($mode=='addcate'){
	//---------------编号--标题------顺序------状态
	$ArrField=array('id',	'title',	'order',	'update');
	$ArrValue=array($id,	$title,		$order,		$update);

	if ($MyDatabase->Insert('mb_cate',$ArrField,$ArrValue))	{
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：添加失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

//分类修改
if($mode=='editcate'){
	//---------------栏目编号--顺序------状态
	$ArrField=array('title',	'order',	'update');
	$ArrValue=array($title,		$order,		$update);

	if ($MyDatabase->Update('mb_cate',$ArrField,$ArrValue, '`id`='.$id))	{
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：添加失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

//分类删除
if($mode=='delcate'){
	if ($MyDatabase->Delete('mb_blog', '`cateid`='. $id) && $MyDatabase->Delete('mb_cate', '`id`='. $id)){
		$refresh_txt = 'true';	
	}else{
		$refresh_txt = $title + '：删除失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

//快速发布
if($mode=='quick'){
	//---------------标题
	$ArrField=array('title');
	$ArrValue=array($title);

	if ($MyDatabase->Insert('mb_quick',$ArrField,$ArrValue))	{
		$refresh_txt = 'true';
	}else{
		$refresh_txt = $title + '：提交失败，Sql语句：' . $MyDatabase->SqlStr;	
	}
	echo $refresh_txt;
}

echo print_array($_POST);
//echo $MyDatabase->PrintDebug();
?>