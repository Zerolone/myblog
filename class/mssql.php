<?php
/**
 * MSSQL数据库调用类，支持PHP4，理论上应该是兼容PHP5的，目前未测试
 * 
 * @version 	2009-3-8 21:48:25
 * @author 	Zerolone
 */

class Database {
	//连接标识
	var $ResID;
	
	//查询语句
	var $SqlStr = '';
	
	//返回数组
	var $ResultArr = '';
	
	//查询次数
	var $QueryCount = 0;
	
	//查询语句
	var $QueryStr = '';
	
	//总记录数
	var $RecordCount = 0;
	
	//页数
	var $PageNum = 1;
	
	//分页数
	var $PageSize = 16;
	
	/**
	 * 连接数据库
	 *
	 */
	
	function Database() {
		//建立数据链接
		if (! ($this->ResID = mssql_connect ( DB_HOST, DB_USER, DB_PASS ))) {
			$this->error_alert ( '数据库错误', DB_HOST, '不能连接数据库主机' );
		} else {
			//选择数据库
			if (! mssql_select_db ( DB_NAME, $this->ResID )) {
				error_alert ( '数据库错误', DB_NAME, '没有找到数据库' );
			}
		}		
	}
	
	/**
	 * 断开链接
	 *
	 *
//	function __destruct() {
		//mssqlServer会在脚本执行完毕后自动关闭，所以不用
	//mssql_close($this->ResID);
	}
	/*/
	
	/**
	 * 添加一条记录
	 * @param		TableName		表名				没有默认值，必须指定，不需要加表前缀，在/include/config.inc.php文件中已经指定
	 * @param		ArrField		字段数组		没有默认值，必须指定
	 * @param		ArrValue		数据数组		没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	function Insert($TableName, $ArrField, $ArrValue) {
		$SqlL = 'INSERT INTO [' . DB_TABLE_PRE . $TableName . '] (';
		$SqlR = 'values (';
		
		//数组长度
		$CountArr = count ( $ArrField );
		
		for($i = 0; $i < $CountArr - 1; $i ++) {
			$SqlL .= '[' . $ArrField [$i] . '],';
			$SqlR .= '\'' . $ArrValue [$i] . '\',';
		}
		
		$SqlL .= '[' . $ArrField [$i] . '])';
		$SqlR .= '\'' . $ArrValue [$i] . '\');';
		
		$this->SqlStr=$SqlL . $SqlR;
		
		$this->managesql();

		return mssql_query ( $this->SqlStr );
	}
	
	/**
	 * 获取最后插入的id编号
	 *
	 * @return id
	 */
	function Insert_id() {
//		return mssql_insert_id ( $this->ResID );
		
		$this->SqlStr='select SCOPE_IDENTITY();';
		return $this->Query();
	}
	
	/**
	 * 修改一条或多条记录
	 * @param		TableName			表名				不需要写前缀，没有默认值，必须指定
	 * @param		ArrField			字段数组		没有默认值，必须指定
	 * @param		ArrValue			数据数组		没有默认值，必须指定
	 * @param		WhereStr			条件语句		没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	function Update($TableName, $ArrField, $ArrValue, $WhereStr) {
		$SqlL = 'UPDATE [' . DB_TABLE_PRE . $TableName . '] SET ';		
		
		//数组长度
		$CountArr = count ( $ArrField );
		
		for($i = 0; $i < $CountArr - 1; $i ++) {
			$SqlL .= '[' . $ArrField [$i] . ']=';
			$SqlL .= '\'' . $ArrValue [$i] . '\',';
		}
		
		$SqlL .= '[' . $ArrField [$i] . ']=';
		$SqlL .= '\'' . $ArrValue [$i] . '\'';
		
		//WHERE语句
		$SqlL .= ' WHERE ' . $WhereStr . ';';
		
		$this->SqlStr=$SqlL;

		$this->managesql();
				
		return mssql_query ( $this->SqlStr );
	}
	
	/**
	 * 删除一条或多条记录
	 * @version  2008年11月13日15:15:52
	 * @param		TableName				表名						没有默认值，必须指定
	 * @param		WhereStr				条件语句				没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	function Delete($TableName, $WhereStr) {		
		$this->SqlStr = 'DELETE FROM [' . DB_TABLE_PRE . $TableName . '] WHERE ' . $WhereStr . ';';
				
		$this->managesql();
				
		return mssql_query ( $this->SqlStr );
	}
	
	/**
	 * 通过Sql语句查询， 返回数组
	 * @version  2008年11月13日11:55:59
	 * @param		SqlStr							SQL语句										没有默认值，必须指定
	 *  
	 */
	function Query() {
		$this->managesql();
		
		//查询Sql语句
		$temp_query = mssql_query ( $this->SqlStr, $this->ResID );
		
		//清空结果数组
		unset ( $this->ResultArr );
		$return_int=0;
		
		//返回结果数组
		while ( $row = mssql_fetch_array ( $temp_query ) ) {
			//			print_r($row);
			//			echo '<hr>';
			$this->ResultArr [] = $row;			
			$return_int=1;
		}
		
		if ($return_int) {
			return TRUE;
		} else {
			return FALSE;
		}
	}
	
	/**
	 * 执行SQL， 返回
	 * @version  2008年11月13日14:04:40
	 * @param		SqlStr							SQL语句										没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	function ExecuteQuery() {
		$this->managesql();
		
		//查询Sql语句
		return mssql_query ( $this->SqlStr, $this->ResID );
	}
	
	/**
	 * 显示调试信息
	 */
	function PrintDebug() {
		$variable_count = '--查询次数：' . $this->QueryCount . "\n";
		$variable_sql = $this->QueryStr . "\n";
		
		$ThisPage = $_SERVER ['PHP_SELF'];
		
		//变量调试信息
		$variable_log = "本页得到的_GET变量有:\n" . print_array ( $_GET );
		$variable_log .= "本页得到的_POST变量有:\n" . print_array ( $_POST );
		$variable_log .= "本页得到的_COOKIE变量有:\n" . print_array ( $_COOKIE );
		$variable_log .= "本页得到的_SESSION变量有:\n" . print_array ( @$_SESSION );
		
		//IIS不支持， 如果出错，请注释下面一行
		//$variable_log .= "HTTP头文件:\n" . print_array ( getallheaders () );
		
		return "当前页面为：$ThisPage [<a href=\"javascript:history.go(0);\">刷新该页面</a>]
	  <script language=\"javascript\" type=\"text/javascript\">
		function showdebug(span_show, span_source)
		{
			var TheImg;
			span_show	= eval(span_show);
	  		span_source	= eval(span_source)
		
			if(span_show.style.display == \"none\")
			{
				span_show.style.display = \"\";
	 			span_source.innerHTML	= \"<font color=\'blue\'>关闭</font>调试信息\"; 
			}
			else
			{
				span_show.style.display = \"none\";
	 			span_source.innerHTML	= \"<font color=\'red\'>打开</font>调试信息\"; 
			}
		}
	  </script>
	  <span align=left id=debug_source onClick=showdebug('debug_show','debug_source')><font color=\"red\">打开</font>调试信息</span><br>
	  <!-- <span id=debug_source onClick=showdebug('debug_show','debug_source')><font color=\"blue\">关闭</font>调试信息</span><br> -->
	  <div align=\"left\"><span id=debug_show style=\"display=none\">
				<textarea style='width=800;height=500' cols='100' rows='8'>$variable_count$variable_sql$variable_log</textarea>
	  </span>
	  </div>
	  ";
	}
	
	/**
	 * 错误提示
	 * @param	$ImagePath		错误类型
	 * @param	$ImageUrl			源
	 * @param  String  			错误信息
	 */
	function error_alert($Type, $Source, $Message) {
		$ThisPage = $_SERVER ['PHP_SELF'];
		
		$x = "
	页面执行问题类型：<font color=red>$Type</font>【<a href=\"javascript:history.go(0);\">刷新该页面</a>】【<a href=\"report_error_page.php?Page=$ThisPage&Source=$Source&Message=$Message\" target=_blank>联系系统管理员 报告管理员该页面出错</a>】<br>
	<br>错误信息： ($Source) $Message
	<hr color=blue size=1 width=100% align=left>
	";
		echo $x;
	}
	
	/**
	 * 函数调用错误提示
	 *
	 * @param 方法名 $n
	 * @param 参  数 $v
	 */
	function __call($n, $v) {
		echo '错误的方法名：' . $n;
		echo '<br>错误的参数：' . print_array ( $v );
		echo '<hr>';
	}
	
	/**
	 * MSSQL分页,PHP4不支持stripos函数， 和str_ireplace函数，请注意大小写，将来考虑采用preg_xxxx函数替代
	 * 
	 * @version 2009-3-9 0:18:31
	 * 
	 */
	function sqlLimit($sql, $count, $offset = 0) {
			$count = intval ( $count );
			if ($count <= 0) {
			}
			$offset = intval ( $offset );
			if ($offset < 0) {
			}
			$orderby = stristr ( $sql, 'ORDER BY' );
			if ($orderby !== false) {
				$sort = (strpos($orderby, 'DESC') !== false) ? 'DESC' : 'ASC';
//				$sort = (preg_match ( "/DESC/i", $orderby ) !== false) ? 'DESC' : 'ASC';
								
				$order = preg_replace ( '/ORDER BY/i', '', $orderby );
				$order = trim ( preg_replace ( '/ASC|DESC/i', '', $order ) );
			}
			
			$sql = preg_replace ( '/^SELECT\s/i', 'SELECT TOP ' . ($count + $offset) . ' ', $sql );
						
			$sql = 'SELECT * FROM (SELECT TOP ' . $count . ' * FROM (' . $sql . ') AS beging_sql';
			if ($orderby !== false) {
				$sql .= ' ORDER BY ' . $order . ' ';
				$sql .= (strpos ( $sort, 'ASC' ) !== false) ? 'DESC' : 'ASC';
//				$sql.= (preg_match ( "/ASC/i", $sort ) !== false) ? 'DESC' : 'ASC';
			}
			$sql .= ') AS end_sql';
			if ($orderby !== false) {
				$sql .= ' ORDER BY ' . $order . ' ' . $sort;
			}
			return $sql;
			break;
	}
	
	
	/**
	 * 处理Sql语句，并记录
	 * 
	 * @version 2009-3-9 8:56:09
	 */
	function managesql()
	{
		//处理Sql语句
		$i = 1;
		$SqlStr=$this->SqlStr;
		while ( strpos ( $SqlStr, '`' ) ) {
			if ($i == 1) {
				$SqlStr = preg_replace ( '/`/', '[', $SqlStr, 1 );
				$i ++;
			} else {
				$SqlStr = preg_replace ( '/`/', ']', $SqlStr, 1 );
				$i --;
			}
		}
		
		//处理length函数
		$SqlStr = preg_replace ( '/length\(/', 'len(', $SqlStr);
		
		//处理limit
		$str_preg_match="/limit/i";
		if (preg_match ($str_preg_match, $SqlStr)) {
			$SqlStr_arr=preg_split("/limit/i" ,$SqlStr);			
			
			$SqlStr			= $SqlStr_arr[0];
			
			$str_count=explode(',',$SqlStr_arr[1]);
			
			$offset=$str_count[0]+0;
			$count =$str_count[1]+0;

			$SqlStr=$this->sqlLimit($SqlStr,$count,$offset);
		}
		
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--第' . $this->QueryCount . '次--' . "\n";
		$this->QueryStr .= $SqlStr . "\n";
		
		$this->SqlStr=$SqlStr;
	}
	
}

?>