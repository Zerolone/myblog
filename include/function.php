<?php
/**
* 公共函数放置位置
* 文件名 function.inc.php
*
* @author Zerolone
* @update 2009-8-13 10:45:05
*/


/**
 * 打印空格
 *
 * @param 整数 $num
 * @return 一片空格
 */
function LoopNBSP($num=1){
	$thestr="";
	for($i=0;$i<$num;$i++){
		$thestr .= "&nbsp;";
	}
	return $thestr;
}

/**
 * 获取执行时间
 *
 * @param 时间 $start_time
 * @return 时间差距
 */
function getprocesstime($start_time="0 0"){
	list($start_usec, $start_sec, $end_usec, $end_sec) = explode(" ",$start_time . " " . microtime());
	$temp1	= ((float)$start_usec + (float)$start_sec)*1000;
	$temp2	= ((float)$end_usec + (float)$end_sec)*1000;
	$temp		= $temp2-$temp1 ;
	$temp	 /= 1000;
	return number_format($temp, 4, '.', '');
}

/**
 * 显示文字状态
 *
 * @param 整型 $flag
 * @return 状态字符串
 */
function printFlag ( $flag ){
	switch ( $flag ){
		case 0:
			return "<Font color=\"#FF0000\">未发布</Font>";
		case 1:
			return "<Font color=\"#009900\">已发布</Font>";
		case 2:
			return "<Font color=\"#009900\">已保存&nbsp;已生成</Font>&nbsp;<Font color=\"#FF0000\">未发布</Font>";
		case 3:
			return "<Font color=\"#009900\">已保存&nbsp;已生成&nbsp;已发布</Font>";
		default:
			return "未知状态";
	}
}

/**
 * 字符串截取
 *
 * @param 字符串 $string
 * @param 整型 $sublen
 * @param 整型 $showdot
 * @return 字符串
 */
function subString ($string,$sublen,$showdot=1){
	if($sublen>=strlen($string)){
		return $string;
	}
	$s="";
	for($i=0;$i<$sublen;$i++){
		if(ord($string{$i})>127){
			$s.=$string{$i}.$string{++$i};
			continue;
		}else{
			$s.=$string{$i};
			continue;
		}
	}
	if($showdot){
		return $s."...";
	}
	else{
		return $s;
	}
}

/******************************************************************
* PHP截取UTF-8字符串，解决半字符问题。
* 英文、数字（半角）为1字节（8位），中文（全角）为3字节
* @return 取出的字符串, 当$len小于等于0时, 会返回整个字符串
* @param $str 源字符串
* $len 左边的子串的长度
****************************************************************/
function utf_substr($str,$len){
	for($i=0;$i<$len;$i++){
		$temp_str=substr($str,0,1);
		if(ord($temp_str) > 127){
			$i++;
			if($i<$len){
				$new_str[]=substr($str,0,3);
				$str=substr($str,3);
			}
		}
		else{
			$new_str[]=substr($str,0,1);
			$str=substr($str,1);
		}
	}
	return join($new_str);
}

/**
 * 字符串编码
 *
 * @param 字符串 $str
 * @return 字符串
 */
function encode ( $str ){
	$str= ereg_replace("<", "&lt;", $str);
	$str= ereg_replace(">", "&gt;", $str);
	$str= ereg_replace("'", "‘", $str);
	$str= ereg_replace('"', '“', $str);
	return $str;
}

/**
 * 字符串编码
 *
 * @param 字符串 $str
 * @return 字符串
 */
function encode2 ( $str ){
	$str= ereg_replace("<", "&lt;", $str);
	$str= ereg_replace(">", "&gt;", $str);
	return $str;
}

/**
 * 字符串编码
 *
 * @param 字符串 $Content
 * @return 编码后的字符串
 */
function EnCodeStr($Content){
	//替换空格
	$Content	= str_replace(" ", "[z_space]", $Content);

	//替换换行
	$Content	= str_replace("\r\n", "[z_newline]", $Content);

	//替换<>
	$Content	= str_replace("<", "[z_l]", $Content);
	$Content	= str_replace(">", "[z_r]", $Content);

	//替换Tab
	$Content	= str_replace(chr(9), "[z_tab]", $Content);

	//替换单双引号
	$Content	= str_replace("'", "[z_sq]", $Content);
	$Content	= str_replace('"', "[z_dq]", $Content);
	
	return $Content;
}

/**
 * 字符串解码
 *
 * @param 字符串 $Content
 * @return 字符串
 */
function DeCodeStr($Content){
	//替换空格
	$Content	= str_replace("[z_space]", " ", $Content);

	//替换换行
	$Content	= str_replace("[z_newline]", "\r\n", $Content);

	//替换<>
	$Content	= str_replace("[z_l]", "<", $Content);
	$Content	= str_replace("[z_r]", ">", $Content);

	//替换Tab
	$Content	= str_replace("[z_tab]", chr(9), $Content);

	//替换单双引号
	$Content	= str_replace("[z_sq]", "'", $Content);
	$Content	= str_replace('[z_dq]', '"', $Content);
	
	return $Content;
}

/**
 * 字符串解码
 *
 * @param 字符串 $Content
 * @return 字符串
 */
function DeCodeStr2($Content){
	//替换空格
	$Content	= str_replace("[z_space]", " ", $Content);

	//替换换行
	$Content	= str_replace("[z_newline]", "\r\n", $Content);

	//替换<>
	$Content	= str_replace("[z_l]", "&lt;", $Content);
	$Content	= str_replace("[z_r]", "&gt;", $Content);
	
	//替换<br>
	$Content	= str_replace("&ltbr;&gt;", "<br>", $Content);

	//替换Tab
	$Content	= str_replace("[z_tab]", chr(9), $Content);

	//替换单双引号
	$Content	= str_replace("[z_sq]", "'", $Content);
	$Content	= str_replace('[z_dq]', '"', $Content);
	
	return $Content;
}

/**
 * 字符串剪切
 *
 * @param 字符串 $Content
 * @param 字符串 $StartFlag
 * @param 字符串 $EndFlag
 * @param 整型 $Code
 * @return $TheContent
 */
function CutStr($Content, $StartFlag, $EndFlag, $Code=0){
	//echo "<hr size=1 color=blue> 内 容 长 度 ：".strlen($Content);

	$pos1 = strpos($Content, $StartFlag);
	$pos2 = strpos($Content, $EndFlag, $pos1);
	$StartFlag_Len	= strlen($StartFlag);
	$TheContent		= substr($Content, $pos1+$StartFlag_Len, $pos2-$pos1-$StartFlag_Len);
	
	if ($Code==1){
		$TheContent = str_replace($StartFlag.$TheContent.$EndFlag, '', $Content);
		//$TheContent	= 1;
	}

	/*/
	echo "<br>开始标志位置：".$pos1;
	echo "<br>开始标志长度：".$StartFlag_Len;
	echo "<br>结束标志位置：".$pos2;
	echo "<br>结束标志长度：".$EndFlag_Len;
	echo "<br>起始截取位置：".($pos1+$StartFlag_Len);
	echo "<br>总共截取长度：".($pos2-$pos1-$EndFlag_Len-$StartFlag_Len+1);
	echo "<hr size=1 color=black>内容为：".$TheContent;
	echo "<hr size=1 color=blue>";
	//*/	
	
	return $TheContent;

}

/**
 * 字符串解码
 *
 * @param 字符串 $str
 * @return 字符串
 */
function decode ( $str ){
	$str= ereg_replace("&lt;", "<", $str);
	$str= ereg_replace("&gt;", ">", $str);
	//	$str= ereg_replace("`", "'", $str);
	$str= ereg_replace('“', '"', $str);

	return $str;
}

/**
 * 保存文件
 *
 * @author   Zerolone
 * @version  2006-10-28
 * @param String 文件名
 * @param String 保存路径
 * @param String 远程路径
 */
function saveFile( $fileName ,$ImagePath, $ImageUrl){
	$s_filename = basename( $fileName );
	$ext_name = strtolower( strrchr( $s_filename, "." ) );

	if( ( ".jpg" && ".gif" && ".png" && ".bmp" ) != strtolower( $ext_name ) )	{
		return "";
	}

	$url='';
	if( 0 == strpos( $fileName, "/" ) )	{
		preg_match( "@http://(.*?)/@i", $this->URL, $url );
		$url = $url[0];
	}

	$contents = file_get_contents( $url . $fileName );
	$s_filename = date( "His", time() ) . rand( 1000, 9999 ) . $ext_name;

	//file_put_contents( $this->saveImagePath.$s_filename, $contents );

	$handle = fopen ( $ImagePath.$s_filename, "w" );
	fwrite( $handle, $contents );
	fclose($handle);
	
	$ArrField=array('urlold','url');
	$ArrValue=array($fileName, $ImageUrl.$s_filename);
	
	$MyDatabase=new Database();
	
	$MyDatabase->Insert('article_pic', $ArrField, $ArrValue);	

	return $s_filename;
}

/**
 * 保存本地文件，并是否打水印
 * @author   Zerolone
 * @version  2008年11月28日16:15:56
 * @param		$fileName				文件名				没有默认值，必须指定
 * @param		$ImagePath			保存路径			没有默认值
 * @param		$ext_name				后缀名				没有默认值
 * @param		$watermark			是否打水印		默认值为1，打水印
 *  
 * @return 文件路径
 */
function saveFilelocal( $fileName ,$ImagePath, $ext_name, $watermark=0){
	$s_filename = basename( $fileName );
	//	$ext_name = strtolower( strrchr( $s_filename, "." ) );

	if( ( ".jpg" && ".gif" && ".png" && ".bmp" ) != strtolower( $ext_name ) )	{
		return "";
	}

	/*
	if( 0 == strpos( $fileName, "/" ) )
	{
//		preg_match( "@http://(.*?)/@i", $this->URL, $url );
		$url = $url[0];
	}
	//*/

//	$contents = file_get_contents( $url . $fileName );
	$contents = file_get_contents( $fileName );
	$s_filename = date( "His", time() ) . rand( 1000, 9999 ) . $ext_name;

	//file_put_contents( $this->saveImagePath.$s_filename, $contents );

	$handle = fopen ( $ImagePath.$s_filename, "w" );
	fwrite( $handle, $contents );
	fclose($handle);

//  imageWaterMark($ImagePath.$s_filename,9,"","http://www.Goidia.cn/",5,"#FF0000"); 

	if ($watermark) 	{
		$waterImage="../../images/logo-b.png";
		imageWaterMark($ImagePath.$s_filename, 9, $waterImage);
	}
	
	return $s_filename;
}
	
/**
 * 计算字符串的总值
 *
 * @author   Zerolone
 * @version  2008-9-19 23:31:24
 * @param String 字符串
 * @return   Integer 整数
 */
function count_string($string){
	$string_len=strlen($string);
	$count=0;
	for($i=0;$i<$string_len;$i++)	{
		$count+=substr($string, $i, 1);
	}
	return $count;
}

/**
* 远程抓取图片，保存到本地服务器
* @param  $content 			需要转换的内容
* @return  String  			返回图片替换后的数据
*/		
function getContent ($Content){
	$Content	= stripslashes($Content);
//	echo $Content;
	
	//获取图片路径
//	preg_match_all( " <img[^>]*src=[\"|']?(^>+)[\"|']?[^>]*>", $Content, $temp );
//	preg_match_all( "/src=(\"|')(.*?)(\"|')/i", DeCodeStr($Content), $temp );
	preg_match_all( "/src=(\"|')(.*?)(\"|')/i", $Content, $temp );
	$imageList = $temp[2];

//	echo '<hr>'. print_r($imageList) . '<hr>';
//*/	

	//建立文件夹
	if (!is_dir(IMAGEPATH)) {
		mkdir(IMAGEPATH);
	}
	
	$ImagePath=IMAGEPATH.'/'. date("ym",time());
	if (!is_dir($ImagePath)) {
		mkdir($ImagePath);
	}

	$ImagePath.='/'. date("d",time()) . '/';
	if (!is_dir($ImagePath)) {
		mkdir($ImagePath);
	}
	
	//网页上面的路径
	$ImageUrl			=IMAGEURL. date("ym",time()).'/'.date("d",time()).'/';
	
	for ( $i = 0; $i < count( $imageList ); $i++ )	{
		$fName = saveFile( $imageList[$i], $ImagePath, $ImageUrl);
		if( !empty( $fName ) )		{
			$filename[$i] = $fName;
		}
	}
	
	for ( $i = 0; $i < count( $imageList ); $i++ )	{
		$Content = str_replace( $imageList[$i], $ImageUrl.$filename[$i], $Content );
	}
	
	/*
	echo '<hr>';
	echo $Content;
	echo '<hr>';
	exit();
	//*/

	/*
	//去掉无用的页面脚本
	//去掉js	
	$cp = preg_replace( "@\<script(.*?)\</script\>@is", "", $cp );

	//去掉HTML
	//去Table
	$cp = preg_replace( "@\<table(.*?)\</table\>@is", "", $cp );
	//去Tr
	$cp = preg_replace( "@\<tr(.*?)\</tr\>@is", "", $cp );
	//去Td
	$cp = preg_replace( "@\<td(.*?)\</td\>@is", "", $cp );
	//去div
	$cp = preg_replace( "@\<div(.*?)\</div\>@is", "", $cp );

	//去iframe
	$cp = preg_replace( "@\<iframe(.*?)\</iframe\>@is", "", $cp );

	//去掉css
	//$cp = preg_replace( "@\<style(.*?)\</style\>@is", "", $cp );
	*/

	//去掉超连接
	$Content = preg_replace( EnCodeStr("@\<a(.*?)\>@is"), "", $Content );

	//去<!-- -->
	$Content = preg_replace( EnCodeStr("@\<!--(.*?)\--\>@is"), "", $Content );
	return $Content;
}

/**
 * 删除文件
 *
 * @author   Zerolone
 * @version  2008年10月1日22:13:24
 * @param Filename 文件名， 物理路径 字符串
 */
function deleteFile($Filename){
	//如果文件存在
	if(file_exists($Filename)){
		//删除文件
		unlink($Filename);
	}
}

/**
 * 生成文件夹
 *
 * @author   Zerolone
 * @version  2008年10月1日22:22:46
 * @param baseFolder 基础文件夹，这个文件夹必须存在，省的重复判断
 * @param Filename 文件名， 物理路径 字符串
 */
function createFolder($baseFolder, $Filename){
	if(file_exists($baseFolder.$Filename))	{
		//文件夹、文件存在
	}else{
		//创建文件夹
		$Filename_str='';
		$Filename_arr=explode('/', $Filename);
		for ($i=0;$i<count($Filename_arr)-2;$i++){
			$Filename_str.='/'.$Filename_arr[$i];
			mkdir($baseFolder.'/'.$Filename_str);
		}
	}
}

/**
 * 生成文件夹II，避免以前的冲突
 *
 * @author   Zerolone
 * @version  2008年10月20日16:25:35
 * @param baseFolder 基础文件夹，这个文件夹必须存在，省的重复判断
 * @param Filename 文件名， 物理路径 字符串
 */
function createFolderII($baseFolder, $Filename){
	if(file_exists($baseFolder.$Filename))	{
		//文件夹、文件存在
	}	else	{
		//创建文件夹
		$Filename_str='';
		$Filename_arr=explode('/', $Filename);
		for ($i=1;$i<count($Filename_arr)-1;$i++)		{
			$Filename_str.='/'.$Filename_arr[$i];
			$Folder				=$baseFolder.'/'.$Filename_str;
			if (!file_exists($Folder)){
				mkdir($Folder);			
			}
		}
	}
}

/**
 * 生成文件夹III，也是避免以前的冲突
 *
 * @author   Zerolone
 * @version  时间
 * @param baseFolder 基础文件夹，这个文件夹必须存在，省的重复判断
 * @param Filename 文件名， 物理路径 字符串
 */
function createFolderIII($baseFolder, $Filename){
	if(file_exists($baseFolder.$Filename))	{
		//文件夹、文件存在
	}	else	{
		//创建文件夹
		$Filename_str='';
		$Filename_arr=explode('/', $Filename);
		for ($i=1;$i<count($Filename_arr)-1;$i++)	{
			$Filename_str.='/'.$Filename_arr[$i];
			$Folder				=$baseFolder.'/'.$Filename_str;
			if (!file_exists($Folder)) 			{
				mkdir($Folder);			
			}
		}
	}
}

/**
 * 获取IP
 *
 * @author   Zerolone
 * @version  2008年10月7日16:39:11
 * @return IP字符串
 */
function GetIP(){
   if (getenv("HTTP_CLIENT_IP") && strcasecmp(getenv("HTTP_CLIENT_IP"), "unknown"))
           $ip = getenv("HTTP_CLIENT_IP");
       else if (getenv("HTTP_X_FORWARDED_FOR") && strcasecmp(getenv("HTTP_X_FORWARDED_FOR"), "unknown"))
           $ip = getenv("HTTP_X_FORWARDED_FOR");
       else if (getenv("REMOTE_ADDR") && strcasecmp(getenv("REMOTE_ADDR"), "unknown"))
           $ip = getenv("REMOTE_ADDR");
       else if (isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], "unknown"))
           $ip = $_SERVER['REMOTE_ADDR'];
       else
           $ip = "unknown";
   return($ip);
}

/**
 * 将模块数转换成一个字符串
 *
 * @author   Zerolone
 * @version  2008年10月17日15:01:32
 * @param TheString 字符串
 * @param Filename 文件名， 物理路径 字符串
 * @return 
 */
function tostr($TheString){
	$TheString			= decbin($TheString);
	$TheString_len	= strlen($TheString);
	$TheString_num	= 32;
	
	for($i=0;$i<$TheString_num-$TheString_len;$i++)
		$TheString= '0'.$TheString;
	return($TheString);
}

/**
 * 返回文章列表
 * 
 * @version	2009-5-19 9:50:36
 * @author   Zerolone
 * @param		cateid			栏目编号				默认为0， 可以为一个栏目编号， 或者多个栏目。例如：12, 或者12,13
 * @param		count				记录数					默认为10
 * @param		titlecount 	文字显示数			默认为20
 * @param		orderby			排序方式				默认为id
 * @param		ordersort		排序顺序				默认为DESC
 * @param		area				显示区域				默认为0，全部显示
 * @param		flag				显示文章状态		默认为3，
 * @param		showli			显示li					默认为1，1为显示，0为不显示
 * @param		begincount	起始记录数			默认为0
 * @param		showhits		显示点击数			默认为0，1为显示，0为不显示
 * @param		showdot			显示点					默认为0，1为显示，0为不显示
 * @param		showcate		显示分类标题		默认为0，1为显示，0为不显示
 * @param		showbracket	显示括号				默认为0，1为显示，0为不显示
 * @param		showdate		显示日期				默认为0，1为显示，0为不显示
 * @param 	showtitle2	显示二级标题		默认为0，1为显示，0为不显示
 * @return 列表字符串
 */
function getArticleList($cateid=0, $count=10, $titlecount=20, $orderby='id', $ordersort='DESC', $area=0, $flag=3, $showli=1, $begincount=0, $showhits=0, $showdot=0, $showcate=0, $showbracket=0, $showdate=0, $showtitle2=0){
	$TempString		= '';
	$ReturnString	= '';
	
	//文章列表
	//-------------------0---------1------------2---------------3------------4-----------5-----------6------------7-------------8
	$SqlStr	= 'SELECT `a`.`id`, `a`.`title`, `a`.`posttime`, `a`.`reurl`, `a`.`html`, `a`.`hits`, `c`.`title`, `a`.`title2`, `a`.`titlecolor`  from `'.DB_TABLE_PRE.'article` `a`, `'.DB_TABLE_PRE.'article_cate` `c`';
	$SqlStr.= ' WHERE 1=1';
	$SqlStr.=' AND `a`.`cateid`=`c`.`id`';
	$SqlStr.=' AND `a`.`notshowlist` = 0';
	
	//栏目编号
	if (strpos($cateid, ',')) {
		$SqlStr.=' AND `a`.`cateid` in ('.$cateid.')';		
	}	elseif ($cateid>0)	{
		$cateid+=0;
		$SqlStr.=' AND `a`.`cateid` ='.$cateid;		
	}
	
	//显示区域
	if ($area>0) 	{
		$area+=0;
		$SqlStr.= ' AND `a`.`area'.$area.'` =1';
	}

	//状态
	$flag+=0;
	$SqlStr.= ' AND `a`.`flag` = '. $flag;

	//排序
	$orderby=trim($orderby);
	$orderby=str_replace('(', '', $orderby);
	$orderby=str_replace(')', '', $orderby);
	$ordersort=trim($ordersort);
	$ordersort=str_replace('(', '', $ordersort);
	$ordersort=str_replace(')', '', $ordersort);
	
	$SqlStr.= ' ORDER BY `a`.`'.$orderby.'` '.$ordersort;
	
	//显示个数
	$begincount+=0;
	$count+=0;
	
	$SqlStr.= ' LIMIT '.$begincount.', '.$count.';';
	$MyDatabase=new Database();
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$DB_Record_Arr = $MyDatabase->ResultArr;
		foreach ( $DB_Record_Arr as $DB_Record ) {
			$title			= subString($DB_Record[1],$titlecount);
			$posttime		= $DB_Record[2];
			$reurl			= $DB_Record[3];
			$url				= $DB_Record[4];
			$hits				= $DB_Record[5];
			$catetitle	= $DB_Record[6];
			$title2			= $DB_Record[7];
			$titlecolor	= $DB_Record[8];
			
			if ($showtitle2 && $title2<>''){
				$title			= $title2;
			}
			
			if ($reurl<>''){
				$url=$reurl;
			}
			
			if ($titlecolor<>''){
				$title			= '<font color="'.$titlecolor.'">'.$title.'</font>';
			}
			
			if ($showdot){
				$title='·'.$title;
			}
			
			$TempString='<a title="'.$DB_Record[1].'" href="'.$url.'">'.$title.'</a>';
			
			if ($showcate){
				$TempString='<span>'.$catetitle.' | </span>'.$TempString;
			}
			
			if ($showhits){
				$TempString.=	'('.$hits.')';
			}
	
			if ($showdate){
				$TempString.='<span>'.$posttime.'</span>';
			}
			
			if ($showli){
				$TempString	=	'<li>'.$TempString.'</li>';
			}
	
			if ($showbracket){
				$TempString	=	'['.$TempString.'] ';
			}
			
			$ReturnString.=$TempString;
		}
	}
	
	return($ReturnString);
}

/**
 * 返回文章列表
 * @author   Zerolone
 * @version  2008年12月18日10:06:02
 * @param		cateid			栏目编号				默认为0， 可以为一个栏目编号， 或者多个栏目。例如：12, 或者12,13
 * @param		count				记录数					默认为10
 * @param		titlecount 	文字显示数			默认为20
 * @param		orderby			排序方式				默认为id
 * @param		ordersort		排序顺序				默认为DESC
 * @param		area				显示区域				默认为0，全部显示
 * @param		flag				显示文章状态		默认为3，
 * @param		showli			显示li					默认为1，1为显示，0为不显示
 * @param		begincount	起始记录数			默认为0
 * @param		showhits		显示点击数			默认为0，1为显示，0为不显示
 * @param		showdot			显示点					默认为0，1为显示，0为不显示
 * @param		showcate		显示分类标题		默认为0，1为显示，0为不显示
 * @param		showbracket	显示括号				默认为0，1为显示，0为不显示
 * @param		showdate		显示日期				默认为0，1为显示，0为不显示
 * @param 	showtitle2	显示二级标题		默认为0，1为显示，0为不显示
 * @return 列表字符串
 */
function getArticleContent($cateid=0, $count=10, $titlecount=20, $orderby='id', $ordersort='DESC', $area=0, $flag=3, $showli=1, $begincount=0, $showhits=0, $showdot=0, $showcate=0, $showbracket=0, $showdate=0, $showtitle2=0){
	$TempString		= '';
	$ReturnString	= '';
	
	//文章列表
	//-------------------0---------1------------2---------------3------------4-----------5-----------6------------7----------------8
	$SqlStr	= 'SELECT `a`.`id`, `a`.`title`, `a`.`posttime`, `a`.`reurl`, `a`.`html`, `a`.`hits`, `c`.`title`, `a`.`memo`, `a`.`title2` from `'.DB_TABLE_PRE.'article` `a`, `'.DB_TABLE_PRE.'article_cate` `c`';
	$SqlStr.= ' WHERE 1=1';
	$SqlStr.=' AND `a`.`cateid`=`c`.`id`';
	
	//栏目编号
	if (strpos($cateid, ',')){
		$SqlStr.=' AND `a`.`cateid` in ('.$cateid.')';		
	}elseif ($cateid>0){
		$cateid+=0;
		$SqlStr.=' AND `a`.`cateid` ='.$cateid;		
	}
	
	//显示区域
	if ($area>0){
		$area+=0;
		$SqlStr.= ' AND `a`.`area'.$area.'` =1';
	}

	//状态
	$flag+=0;
	$SqlStr.= ' AND `a`.`flag` = '. $flag;

	//排序
	$orderby=trim($orderby);
	$orderby=str_replace('(', '', $orderby);
	$orderby=str_replace(')', '', $orderby);
	$ordersort=trim($ordersort);
	$ordersort=str_replace('(', '', $ordersort);
	$ordersort=str_replace(')', '', $ordersort);
	
	$SqlStr.= ' ORDER BY `a`.`'.$orderby.'` '.$ordersort;
	
	//显示个数
	$begincount+=0;
	$count+=0;
	
	$SqlStr.= ' LIMIT '.$begincount.', '.$count.';';
//	echo $SqlStr;
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$DB_Record_Arr = $MyDatabase->ResultArr;
		foreach ( $DB_Record_Arr as $DB_Record ) {
			$title			= subString($DB_Record[1],$titlecount);
			$posttime		= $DB_Record[2];
			$reurl			= $DB_Record[3];
			$url				= $DB_Record[4];
			$hits				= $DB_Record[5];
			$catetitle	= $DB_Record[6];
			$memo				= $DB_Record[7];
			$title2			= $DB_Record[8];
			
			if ($showtitle2 && $title2<>''){
				$title			= $title2;
			}
			
			if ($reurl<>''){
				$url=$reurl;
			}
			
			if ($showdot){
				$title='·'.$title;
			}
			
			$TempString='<a title="'.$DB_Record[1].'" href="'.$url.'">'.$memo.'</a>';
			
			if ($showcate){
				$TempString='<span>'.$catetitle.' | </span>'.$TempString;
			}
			
			if ($showhits){
				$TempString.=	'('.$hits.')';
			}
	
			if ($showdate){
				$TempString.='<span>'.$posttime.'</span>';
			}
			
			if ($showli){
				$TempString	=	'<li>'.$TempString.'</li>';
			}
	
			if ($showbracket){
				$TempString	=	'['.$TempString.'] ';
			}
			
			$ReturnString.=$TempString;
		}
	}
	
	return($ReturnString);
}

/**
 * 返回图文列表
 * @author   Zerolone
 * @version  2008年10月27日11:27:44
 * @param		cateid			栏目编号 				默认为0， 可以为一个栏目编号， 或者多个栏目。例如：12, 或者12,13
 * @param		count				记录数					默认为10
 * @param		titlecount 	文字显示数			默认为20
 * @param		orderby			排序方式				默认为id
 * @param		ordersort		排序顺序				默认为DESC
 * @param		width				
 * @param		height
 * @param		showdate		是否显示日期		默认为1，1为显示，0为不显示
 * @param		area				显示区域				默认为0，全部显示
 * @param		flag				显示文章状态		默认为3
 * @param		showli			显示li					默认为0，1为显示，0为不显示
 * @param		showtd			显示td					默认为1
 * @param		begincount	起始记录数			默认为0
 * @param 	showtitle2	显示二级标题		默认为0，1为显示，0为不显示
 * @param 	showvideo		显示视频图标		默认为0，1为显示，0为不显示
  *  
 * @return 列表字符串
 */
function getArticlePicList($cateid=0, $count=10, $titlecount=20, $orderby='id', $ordersort='DESC', $width=80, $height=60, $showdate=1, $area=0, $flag=3, $showli=0, $showtd=1, $begincount=0, $showtitle2=0, $showvideo=0){
	$ReturnString	= '';
	
	//文章列表
	//------------------0------1---------2---------3--------4------5--------6---------7----------8----------9
	$SqlStr	= 'SELECT `id`, `title`, `posttime`, `reurl`, `html`, `pic1`, `pic2`, `posttime`, `title2`, `isvideo` from `'.DB_TABLE_PRE.'article`';
	$SqlStr.= ' WHERE 1=1';
	$SqlStr.= ' AND (`pic1`<>"" OR `pic2`<>"")';
	
	//栏目编号
	if (strpos($cateid, ',')){
		$SqlStr.=' AND `cateid` in ('.$cateid.')';		
	}elseif ($cateid>0){
		$SqlStr.=' AND `cateid` ='.$cateid;		
	}
	
	//显示区域
	if ($area>0){
		$SqlStr.= ' AND `area'.$area.'` =1';
	}

	//状态
	$SqlStr.= ' AND `flag` = '. $flag;

	//排序
	$SqlStr.= ' ORDER BY `'.$orderby.'` '.$ordersort;
	
	//显示个数
	$SqlStr.= ' LIMIT '.$begincount.', '.$count.';';	
	
	//echo $SqlStr;
	$MyDatabase=new Database();
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$DB_Record_Arr = $MyDatabase->ResultArr;
		foreach ( $DB_Record_Arr as $DB_Record ) {
//			$isvideo	=$DB_Record[9];
			$title = subString($DB_Record[1], $titlecount);	
			if ($showvideo){
				$title = subString($DB_Record[1],$titlecount-2);	
			}
	
			$reurl	= $DB_Record[3];
			$url		= $DB_Record[4];
			$pic1		= $DB_Record[5];
			$pic		= $DB_Record[6];
			$title2	= $DB_Record[8];
			
			if ($showtitle2 && $title2<>''){
				$title			= $title2;
			}
			
			if ($reurl<>''){
				$url=$reurl;
			}
			
			if ($pic==''){
				$pic=$pic1;
			}
			
			$TempString='<a title="'.$DB_Record[1].'" href="'.$url.'"><img src="'.$pic.'" width="'.$width.'" height="'.$height.'" border="0" /></a><br />';
	
			if ($showvideo){
				$TempString.= '<img src="/images/dot_video.gif" border="0">';
			}
			
			$TempString.='<a title="'.$DB_Record[1].'" href="'.$url.'">'.$title.'</a>';
			
			if ($showdate){
				$TempString.='<br />'.$DB_Record[7];
			}
			
			if ($showli){
				$TempString='<li>'.$TempString.'</li>';			
			}
	
			if ($showtd){
				$TempString='<td>'.$TempString.'</td>';			
			}
			
			$ReturnString.=$TempString;
		}
	}
	return($ReturnString);
}

/**
 * 文章排行
 * @author   Zerolone
 * @version  2008年10月27日11:27:44
 * @param		cateid			栏目编号				默认为0， 可以为一个栏目编号， 或者多个栏目。例如：12, 或者12,13
 * @param		count				记录数					默认为10
 * @param		titlecount 	文字显示数			默认为20
 * @return 列表字符串
 */
function getArticleRightRank($cateid=0, $count=10, $titlecount=44){
	$i=1;
	$ReturnString	= '';

	//-------------------0--------1--------2---------3
	$SqlStr	= ' SELECT `title`, `html`, `reurl`, `title2` ';
	$SqlStr.= ' FROM `'.DB_TABLE_PRE.'article` ';
	$SqlStr.= ' WHERE `flag`= 3 ';
	//栏目编号
	if (strpos($cateid, ',')){
		$SqlStr.=' AND `cateid` in ('.$cateid.')';		
	}elseif ($cateid>0){
		$SqlStr.=' AND `cateid` ='.$cateid;		
	}
	
	$SqlStr.= ' ORDER BY `hits` DESC';
	$SqlStr.= ' LIMIT '. $count;
	
	$MyDatabase=new Database();
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$DB_Record_Arr = $MyDatabase->ResultArr;
		foreach ( $DB_Record_Arr as $DB_Record ) {
			$title	= subString($DB_Record[0], $titlecount);
			$title2	= $DB_Record[3];
				
			if ($title2<>''){
				$title			= $title2;
			}
						
			$url		= $DB_Record[1];
			$reurl	= $DB_Record[2];
			if ($reurl){
				$url	= $reurl;
			}
				
			$ReturnString.='<li class="rank'.$i.'"><a title="'.$DB_Record[0].'" href="'.$url.'">'.$title.'</a></li>';
			
			$i++;
		}
	}
	
	return($ReturnString);
}

/**
 * 获取文章的URL
 * @author   Zerolone
 * @version  2008年10月29日14:24:09
 * @param		id					文章编号 				没有默认值
 * 
 * @return 一个地址
 */
function getArticleUrl($id){
	$url	= '';
	
	//文章列表
	//-------------------0--------1
	$SqlStr	= 'SELECT `reurl`, `html` from `'.DB_TABLE_PRE.'article`';
	$SqlStr.= ' WHERE `id`='.$id;
	
	//显示个数
	$SqlStr.= ' LIMIT 1;';
	//echo $SqlStr;
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$DB_Record = $MyDatabase->ResultArr [0];
		$reurl	= $DB_Record[0];
		$url		= $DB_Record[1];
		
		if ($reurl<>''){
			$url=$reurl;
		}
	}
	return($url);
}

/**
 * 返回是否可以创建文件夹
 * @author   Zerolone
 * @version  2008年10月31日9:48:38
 * @param		dir					文件夹 									没有默认值
 * @param		cantdir			系统自定义禁用文件夹 		没有默认值
 * @param		cateid			分类编号								没有默认值
 *  
 * @return 0或者1
 */
function canCreateDir($dir, $cantdir, $cateid){
	$can=1;
	
	//文件夹为空， 肯定不能添加的
	if ($dir==''){
		$can=0;
	}
	
	//系统定义不能创建的目录
	if (strpos($cantdir, '|'. $dir . '|')){
		$can=0;
	}

	//文件夹分类中是否已存在该文件夹
	//-------------------0
	$SqlStr	= 'SELECT `dir` ';
	$SqlStr.= ' FROM 	`'.DB_TABLE_PRE.'article_cate` ';
	$SqlStr.= ' WHERE `dir`=\''  . $dir . '\'';
	$SqlStr.= ' AND 	`id`<>\'' . $cateid . '\'';
	$MyDatabase=new Database();
	$MyDatabase->SqlStr = $SqlStr;
	if ($MyDatabase->Query ()) {
		$can=0;
	}
//	echo "<hr>$can<hr>";
	
	return($can);
}

/**
 * 根据编号，显示选定值
 * 
 * @author   Zerolone
 * @version  2008年11月3日10:18:59
 * @param		 order		选定的顺序 		默认为0
 *  
 * @return 一个字符串
 */
function getOrderList($order=0){
	$RetrunStr='';
	
	unset($order_list);
	//列表
	for ($i=1;$i<=99;$i++){
		$RetrunStr.='<option value="'.$i . '"';
		if ($order==$i){
			$RetrunStr.=' selected';
		}

		$RetrunStr.= '>' . $i . '</option>';
	}
	
	//如果默认的order大于循环数，则显示一个
	if ($order>$i){
		$RetrunStr.='<option value="'.$order . '" selected >' . $order . '</option>';
	}
	
	return $RetrunStr;
}

/**
 * 分页
 * 
 * @author   Zerolone
 * @version  2008年11月3日11:28:11
 * @param			recordcount			总记录数
 * @param			pagesize				页面记录数 默认为20
 * @param			showrs					显示翻页数
 * @param			pagenum					当前页
 * @param			maxpagelimit		最大翻页数
 * 
 * @return 分页数组
 */
function SplitPage($recordcount=100, $pagenum=1, $pagesize=20, $showrs=10, $maxpagelimit=50 ){
	//返回值
	$ReturnString='';
	
	//总页数
	$pagecount = ceil($recordcount / $pagesize);		
	
	//最大移动数
	$pagend	= $pagenum+$maxpagelimit;
	if($pagend > $pagecount){
		$pagend	= $pagecount;
	}

	//如果为第一页， 则第一页的上一页也是第一页
	if($pagenum==1){
		$pagenum_up	= 1;
	}else{
		$pagenum_up = $pagenum-1;
	}

	//下一页， 如果下一页大于等于当前页，则下一页也是当前页
	$pagenum_down	= $pagenum+1;
	if ($pagenum_down > $pagecount){
		$pagenum_down	= $pagecount;
	}
	
	//前显记录数， 用舍余方式
	$showrs_begin	=	floor($showrs/2);
	
	//后显记录数，减掉前显记录数，再减掉当前记录数
	$showrs_end		=	$showrs-$showrs_begin-1;	

	//起始页数
	$pagenum_begin 	= $pagenum-$showrs_begin;
	if ($pagenum_begin<=1){
		$pagenum_begin=1;
	}
	
	//结束页数
	$pagenum_end		= $pagenum+$showrs_end;
	if ($pagenum_end>$pagecount){
		$pagenum_end=$pagecount;
	}
	
	//如果翻页数小于$showrs，则补全， 除非总的记录数小于$showrs
	$cutrs = $showrs-($pagenum_end-$pagenum_begin+1);
	if ($cutrs>0){
		if (($pagenum_begin-$cutrs)>0){
			$pagenum_begin=$pagenum_begin-$cutrs;
		}else{
			$pagenum_begin=1;
			$pagenum_end=$showrs;
			if ($pagenum_end>=$pagecount){
				$pagenum_end=$pagecount;
			}
		}
	}
	
	//第一页
	$ReturnString='<a href="javascript:goto(\'1\');" title="第一页"><b>|&lt;</b></a>  ';

	//上一页
	$ReturnString.='<a href="javascript:goto(\''. $pagenum_up .'\');" title="上一页"><b>&lt;</b></a>  ';
	
	for ($i=$pagenum_begin;$i<=$pagenum_end;$i++){
		if ($i==$pagenum){
			$ReturnString.='[<font color="red">'.$i.'</font>] ';
		}else{
			$ReturnString.='[<a href="javascript:goto(\''.$i.'\');" title="第'.$i.'页">'.$i.'</a>] ';
		}
	}
	
	$ReturnString.='<a href="javascript:goto(\''.$pagenum_down.'\');" title="下一页"><b>&gt;</b></a> ';
	$ReturnString.='<a href="javascript:goto(\''.$pagend.'\');" title="第'.$pagend.'页"><b>&gt;|</b></a> ';
	$ReturnString.='<strong><font color=red>'.$pagenum.'</font>/'.$pagecount.'</strong>页&nbsp;';
	$ReturnString.='<b><font color="#FF0000">'.$recordcount.'</font></b>条记录&nbsp;<b>'.$pagesize.'</b>条/页&nbsp;';
	$ReturnString.='转到：<input type="text" name="pagenum1" size=2 maxlength=10 class="InputBox"> <input class="inputbox" type="submit"  value="Go"  name="cndok">';
	$ReturnString.='<input type="hidden" name="pagenum" value="'.$pagenum.'">';
	
	return $ReturnString;
}

/**
 * 前台文章分页
 * 
 * @author   Zerolone
 * @version  2008年11月3日15:03:17
 * @param			recordcount			总记录数
 * @param			pagesize				页面记录数 默认为20
 * @param			showrs					显示翻页数
 * @param			pagenum					当前页
 * @param			maxpagelimit		最大翻页数
 * 
 * @return 分页数组
 */
function SplitPageFront($recordcount=100, $pagenum=1, $pagesize=20, $showrs=10, $maxpagelimit=50 ){
	//总页数
	$pagecount = ceil($recordcount / $pagesize);		
	
	//最大移动数
	$pagend	= $pagenum+$maxpagelimit;
	if($pagend > $pagecount){
		$pagend	= $pagecount;
	}

	//如果为第一页， 则第一页的上一页也是第一页
	/*
	if($pagenum==1){
		$pagenum_up	= 1;
	}else{
		$pagenum_up = $pagenum-1;
	}
	*/

	//下一页， 如果下一页大于等于当前页，则下一页也是当前页
	$pagenum_down	= $pagenum+1;
	if ($pagenum_down > $pagecount){
		$pagenum_down	= $pagecount;
	}
	
	//前显记录数， 用舍余方式
	$showrs_begin	=	floor($showrs/2);
	
	//后显记录数，减掉前显记录数，再减掉当前记录数
	$showrs_end		=	$showrs-$showrs_begin-1;	

	//起始页数
	$pagenum_begin 	= $pagenum-$showrs_begin;
	if ($pagenum_begin<=1){
		$pagenum_begin=1;
	}
	
	//结束页数
	$pagenum_end		= $pagenum+$showrs_end;
	if ($pagenum_end>$pagecount){
		$pagenum_end=$pagecount;
	}
	
	//如果翻页数小于$showrs，则补全， 除非总的记录数小于$showrs
	$cutrs = $showrs-($pagenum_end-$pagenum_begin+1);
	if ($cutrs>0){
		if (($pagenum_begin-$cutrs)>0){
			$pagenum_begin=$pagenum_begin-$cutrs;
		}else{
			$pagenum_begin=1;
			$pagenum_end=$showrs;
			if ($pagenum_end>=$pagecount){
				$pagenum_end=$pagecount;
			}
		}
	}
	
	//返回值
	$ReturnString='';
	
	for ($i=$pagenum_begin;$i<=$pagenum_end;$i++){
		if ($i==$pagenum){
//			$ReturnString.='<a href="#" class="activePage">'.$i.'</a> ';
			
			$ReturnString.='<td class="activePage"><strong>'.$i.'</strong></td>';
			
		}else{
			$TheUrl='index.html';
			if ($i>1){
				$TheUrl= 'index_'.$i.'.html';
			}
			//$ReturnString.='<a href="'.$TheUrl.'" title="第'.$i.'页">'.$i.'</a> ';
			$ReturnString.='<td class="inactivePage"><a href="'.$TheUrl.'">'.$i.'</a></td>';
		}
	}
		
	return $ReturnString;
}

/**
 * 前台文章动态分页
 * 
 * @version  2009年1月12日14:28:00
 * @param			recordcount			总记录数
 * @param			pagesize				页面记录数 默认为20
 * @param			showrs					显示翻页数
 * @param			pagenum					当前页
 * @param			maxpagelimit		最大翻页数
 * 
 * @return 分页数组
 */
function SplitPageActive($recordcount=100, $pagenum=1, $pagesize=20, $showrs=10, $maxpagelimit=50 ){
	//返回值
	$ReturnString='';
		
	//总页数
	$pagecount = ceil($recordcount / $pagesize);		
	
	//最大移动数
	$pagend	= $pagenum+$maxpagelimit;
	if($pagend > $pagecount){
		$pagend	= $pagecount;
	}

	//如果为第一页， 则第一页的上一页也是第一页
	/*
	if($pagenum==1){
		$pagenum_up	= 1;
	}else{
		$pagenum_up = $pagenum-1;
	}
	*/

	//下一页， 如果下一页大于等于当前页，则下一页也是当前页
	$pagenum_down	= $pagenum+1;
	if ($pagenum_down > $pagecount){
		$pagenum_down	= $pagecount;
	}
	
	//前显记录数， 用舍余方式
	$showrs_begin	=	floor($showrs/2);
	
	//后显记录数，减掉前显记录数，再减掉当前记录数
	$showrs_end		=	$showrs-$showrs_begin-1;	

	//起始页数
	$pagenum_begin 	= $pagenum-$showrs_begin;
	if ($pagenum_begin<=1) {
		$pagenum_begin=1;
	}
	
	//结束页数
	$pagenum_end		= $pagenum+$showrs_end;
	if ($pagenum_end>$pagecount) {
		$pagenum_end=$pagecount;
	}
	
	//如果翻页数小于$showrs，则补全， 除非总的记录数小于$showrs
	$cutrs = $showrs-($pagenum_end-$pagenum_begin+1);
	if ($cutrs>0) {
		if (($pagenum_begin-$cutrs)>0){
			$pagenum_begin=$pagenum_begin-$cutrs;
		}else{
			$pagenum_begin=1;
			$pagenum_end=$showrs;
			if ($pagenum_end>=$pagecount){
				$pagenum_end=$pagecount;
			}
		}
	}
	
	for ($i=$pagenum_begin;$i<=$pagenum_end;$i++){
		if($pagenum==$i){	
			$ReturnString.='<a href="javascript:goto(\''.$i.'\');" title="第'.$i.'页" class="cur">'.$i.'</a> ';
		}else{
			$ReturnString.='<a href="javascript:goto(\''.$i.'\');" title="第'.$i.'页">'.$i.'</a> ';
		}
	}
	
	return $ReturnString;
}

/**
 * 更新HTML文件名
 * @author   Zerolone
 * @version  2009-8-14 14:09:24
 * @param		id							所属id									没有默认值，必须指定
 * @param		posttime				提交时间								默认值为当前
 *  
 * @return String
 */
function UpdateHTML($id, $posttime){
	//建立文件夹
	if (!is_dir(ARTICLEPATH)){
		mkdir(ARTICLEPATH);
	}
	
	if ($posttime==''){
		$posttime=time();
	}else{
		$posttime=strtotime($posttime);
	}
	
// echo '<hr>'.	$posttime.'<hr>';
	
	
	$ArticlePath=ARTICLEPATH .'/'. date("ym",$posttime);
	$html=ARTICLEURL.'/'. date("ym",$posttime);
	if (!is_dir($ArticlePath)){
		mkdir($ArticlePath);
	}
			
	$ArticlePath.='/'. date("d",$posttime) . '/';
	$html.='/'. date("d",$posttime);
	if (!is_dir($ArticlePath)) {
		mkdir($ArticlePath);
	}
			
	$html .= '/' . date( "His", time() ) . rand( 1000, 9999 ) . '.html';
	
	//更新html文件到
	$MyDatabase=new Database();
	$ArrField=array('html');
	$ArrValue=array($html);
	$MyDatabase->Update('article',$ArrField,$ArrValue,'`id`='.$id);

	return($html);
}

/**
 * 获取上一级页面提交的参数
 * 
 * @version 	2009-3-2 20:21:44
 * @param 需要获取的参数 $value
 * @param 默认返回值 $default
 * 
 * @return 	获取的参数值
 */
function Request($value, $default='') {
	if (isset ( $_POST [$value] )) {
		return $_POST [$value];
	} elseif (isset ( $_GET [$value] )) {
		return $_GET [$value];
	} else {
		return $default;
	}
}

/**
 * 打印数组，也是为了调试信息用.
 *
 * @param Array $TheArray
 * @return Array
 */
function print_array($TheArray) {
	$TmpStr = '';
	$TmpStr .= "Array\n{\n";
	if (isset ( $TheArray )) {
		foreach ( $TheArray as $Key => $value ) {
			$TmpStr .= '    [' . $Key . ']	=> ' . $value . "\n";
		}
	}
	$TmpStr .= "}\n";
	return $TmpStr;
}

/**
 * 替换掉通用链接
 * 
 * @param $contents 内容
 * @return String
 */
function ReplaceCommonUrl($contents){
	//各个超链接
	$MyArticle=new Article();
	$MyArticle->Flag = 1;
	$MyArticle->Count=100;
	$MyArticle->TitleCount=100;
	$MyArticle->OrderBy = 'order';
	$MyArticle->OrderSort = 'ASC';
	
	
	//顶部链接
	$MyArticle->CateId = TOPURL;
	$topurl = $MyArticle->getArticleList ();
	
	$MyArticle->CateId = FOOT01;
	
	//底部链接01
	$foot01 = $MyArticle->getArticleList ();
	$foot01_title = $MyArticle->getCateTitle ();
	
	$MyArticle->CateId = FOOT02;
	//底部链接02
	$foot02 = $MyArticle->getArticleList ();
	$foot02_title = $MyArticle->getCateTitle ();
	
	$MyArticle->CateId = FOOT03;
	//底部链接03
	$foot03 = $MyArticle->getArticleList ();
	$foot03_title = $MyArticle->getCateTitle ();
	
	$MyArticle->CateId = FOOT04;
	//底部链接04
	$foot04 = $MyArticle->getArticleList ();
	$foot04_title = $MyArticle->getCateTitle ();
	
	//顶部链接
	$contents=str_replace("{topurl}", 			$topurl, 					$contents);
					
	//底部连接01-04
	$contents=str_replace("{foot01}", 			$foot01, 					$contents);
	$contents=str_replace("{foot01_title}", $foot01_title,		$contents);
	$contents=str_replace("{foot02}", 			$foot02, 					$contents);
	$contents=str_replace("{foot02_title}", $foot02_title,		$contents);
	$contents=str_replace("{foot03}", 			$foot03, 					$contents);
	$contents=str_replace("{foot03_title}", $foot03_title,		$contents);
	$contents=str_replace("{foot04}", 			$foot04, 					$contents);
	$contents=str_replace("{foot04_title}", $foot04_title,		$contents);	
	
	return $contents;
}


?>
