/**/

<style>
.php  {border: 1px dotted #a0a0a0; font-size: 12px; background-color: #f0f0f0; margin: 0; line-height: 110%; color: #0000bb;}
.php .cb {font-weight: bold; color:#FF0000;}
.php li{MARGIN:0px 0;PADDING:0 0 0 5px;BORDER-LEFT: 3px solid #666;}
.php div{font-weight: normal;}

</style>

<?php

$str_test='sad中文《br》fsa<hr>dfsafsdafsdfsa<code><?
$url_begin	= "http://browse.deviantart.com/?catpath=designs/web/&order=9&alltime=yes&offset=";
$url_end		= "";
$url_step		= 24;
for($i=0;$i<2090;$i++){
	echo $url_begin . $i*$url_step . $url_end;
	echo "中文<br>";
}

 				/**
         * 函数调用错误提示
         *
         * @param 方法名 $n
         * @param 参  数 $v
         */
         	function getCateTitle(){
		$CateTitle=\'\';
		//-------------------0
		$SqlStr	= \'SELECT `title` FROM `\'.DB_TABLE_PRE.\'article_cate`\';
		$SqlStr.= \' WHERE 1=1\';
				
		//栏目
		$SqlStr.=$this->SqlCateTitleId;
		
		$MyDatabase=new Database();
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record = $MyDatabase->ResultArr [0];
			
			$CateTitle= $DB_Record[0];
		}
		return $CateTitle;
	}
?>

<script language=javascript>
alert("as中文dfdsaf");
</script>
<?php
	phpinfo();
?></code>
asdfdsafsadfd<br>saa中文fsafsaf
';

echo Highlighter::Str($str_test);
echo "<hr>";
highlight_string($str_test);

/**/