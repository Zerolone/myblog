<?php
/**
 * MySQL数据库调用类，仅支持PHP5
 * 
 * @version 	2009年1月5日17:13:37
 * @author 	Zerolone
 */

//class Db_MySQL{
class Database {
	//连接标识
	protected $ResID;
	
	//查询语句
	public $SqlStr = '';
	
	//返回数组
	public $ResultArr = '';
	
	//查询次数
	public $QueryCount = 0;
	
	//查询语句
	public $QueryStr = '';
	
	//总记录数
	public $RecordCount = 0;
	
	//页数
	public $PageNum = 1;
	
	//分页数
	public $PageSize = 16;
	
	//当前页
	public $Thispage = '';
	
	/**
	 * 连接数据库
	 *
	 */
	public function __construct() {
		//建立数据链接
		if (! ($this->ResID = mysql_connect ( DB_HOST.':'.DB_PORT, DB_USER, DB_PASS ))) {
			$this->error_alert ( '数据库错误', DB_HOST, '不能连接数据库主机' );
		} else {
			//选择数据库
			if (! mysql_select_db ( DB_NAME, $this->ResID )) {
				$this->error_alert ( '数据库错误', DB_NAME, '没有找到数据库' );
			}
		}
		
		//判断MySQL的版本信息
		if (version_compare($this->version (), '5.0', '<')) {
	    die('本系统需要MySQL版本为5.0以上，你的版本为：' . $this->version () . "，请升级你的MySQL版本。");
		}
		
		//指定数据库编码，避免字符出错。		
		mysql_query ( 'SET NAMES "' . DB_LANG . '"' );
	}
	
	/**
	 * 断开链接
	 *
	 */
	public function __destruct() {
		//MysqlServer会在脚本执行完毕后自动关闭，所以不用
	//mysql_close($this->ResID);
	}
	
	/**
	 * 添加一条记录
	 * @param		TableName		表名				没有默认值，必须指定，不需要加表前缀，在/include/config.inc.php文件中已经指定
	 * @param		ArrField		字段数组		没有默认值，必须指定
	 * @param		ArrValue		数据数组		没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	public function Insert($TableName, $ArrField, $ArrValue) {
		$SqlL = 'INSERT INTO `' . DB_TABLE_PRE . $TableName . '` (';
		$SqlR = 'values (';
		
		//数组长度
		$CountArr = count ( $ArrField );
		
		for($i = 0; $i < $CountArr - 1; $i ++) {
			$SqlL .= '`' . $ArrField [$i] . '`,';
			$SqlR .= '\'' . $ArrValue [$i] . '\',';
		}
		
		$SqlL .= '`' . $ArrField [$i] . '`)';
		$SqlR .= '\'' . $ArrValue [$i] . '\');';
		
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--' . $this->QueryCount . '--' . "\n";
		$this->QueryStr .= $SqlL . $SqlR . "\n";
		
		return mysql_query ( $SqlL . $SqlR );
	}
	
	/**
	 * 获取最后插入的id编号
	 *
	 * @return id
	 */
	public function Insert_id() {
		return mysql_insert_id ( $this->ResID );
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
	public function Update($TableName, $ArrField, $ArrValue, $WhereStr) {
		$SqlL = 'UPDATE `' . DB_TABLE_PRE . $TableName . '` SET ';
		
		//数组长度
		$CountArr = count ( $ArrField );
		
		for($i = 0; $i < $CountArr - 1; $i ++) {
			$SqlL .= '`' . $ArrField [$i] . '`=';
			$SqlL .= '\'' . $ArrValue [$i] . '\',';
		}
		
		$SqlL .= '`' . $ArrField [$i] . '`=';
		$SqlL .= '\'' . $ArrValue [$i] . '\'';
		
		//WHERE语句
		$SqlL .= ' WHERE ' . $WhereStr . ';';
		
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--' . $this->QueryCount . '--' . "\n";
		$this->QueryStr .= $SqlL . "\n";
		
		return mysql_query ( $SqlL );
	}
	
	/**
	 * 删除一条或多条记录
	 * @version  2008年11月13日15:15:52
	 * @param		TableName				表名						没有默认值，必须指定
	 * @param		WhereStr				条件语句				没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	public function Delete($TableName, $WhereStr) {
		$SqlL = 'DELETE FROM `' . DB_TABLE_PRE . $TableName . '` WHERE ' . $WhereStr . ';';
		
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--' . $this->QueryCount . '--' . "\n";
		$this->QueryStr .= $SqlL . "\n";
		
		return mysql_query ( $SqlL );
	}
	
	/**
	 * 通过Sql语句查询， 返回数组
	 * @version  2008年11月13日11:55:59
	 * @param		SqlStr							SQL语句										没有默认值，必须指定
	 *  
	 */
	public function Query() {
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--' . $this->QueryCount . '--' . "\n";
		$this->QueryStr .= $this->SqlStr . "\n";
		
		//查询Sql语句
		$temp_query = mysql_query ( $this->SqlStr, $this->ResID );
		
		//清空结果数组
		unset ( $this->ResultArr );
		$return_int=0;
		
		//返回结果数组
		while ( $row = mysql_fetch_array ( $temp_query ) ) {
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
	 * 获取版本信息
	 *
	 * @return 版本号
	 */
	public function version() {
		return mysql_get_server_info ( $this->ResID );
	}
	
	/**
	 * 执行SQL， 返回
	 * @version  2008年11月13日14:04:40
	 * @param		SqlStr							SQL语句										没有默认值，必须指定
	 *  
	 * @return 0或者1， 0 为失败， 1为成功
	 */
	public function ExecuteQuery() {
		//记录
		$this->QueryCount ++;
		$this->QueryStr .= '--' . $this->QueryCount . '--' . "\n";
		$this->QueryStr .= $this->SqlStr . "\n";
		
		//查询Sql语句
		return mysql_query ( $this->SqlStr, $this->ResID );
	}
	
	/**
	 * 显示调试信息
	 */
	public function PrintDebug() {
		$variable_count = '--查询次数：' . $this->QueryCount . "\n";
		$variable_sql = $this->QueryStr . "\n";
		
		$this->Thispage=$_SERVER ['PHP_SELF'];
	
		//变量调试信息
		$variable_log = "本页得到的_GET变量有:\n" . print_array ( $_GET );
		$variable_log .= "本页得到的_POST变量有:\n" . print_array ( $_POST );
		$variable_log .= "本页得到的_COOKIE变量有:\n" . print_array ( $_COOKIE );
		$variable_log .= "本页得到的_SESSION变量有:\n" . print_array ( @$_SESSION );
		
		//IIS不支持， 如果出错，请注释下面一行
		//$variable_log .= "HTTP头文件:\n" . print_array ( getallheaders () );
		
		return "$this->Thispage [<a href=\"javascript:history.go(0);\">刷新</a>]
	  <script language=\"javascript\" type=\"text/javascript\">
		function showdebug(span_show, span_source)
		{
			var TheImg;
			span_show	= eval(span_show);
	  		span_source	= eval(span_source)
		
			if(span_show.style.display == \"none\")
			{
				span_show.style.display = \"\";
	 			span_source.innerHTML	= \"<font color='blue'>关闭</font>调试信息\"; 
			}
			else
			{
				span_show.style.display = \"none\";
	 			span_source.innerHTML	= \"<font color='red'>打开</font>调试信息\"; 
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
	 * 显示调试信息
	 */
	public function PrintDebug2() {
		return $this->QueryStr;
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
	public function __call($n, $v) {
		echo '错误的方法名：' . $n;
		echo '<br>错误的参数：' . print_array ( $v );
		echo '<hr>';
	}
}

?>