<?php
/**
 * 专题类
 * 仅支持PHP5
 * 
 * @author Zerolone
 * @version 2009-8-17 22:28:23
 */
class Special {
	//专题编号				默认为0，整形
	public $id = 0;
	
	//专题连接1-5
	public $url1,$url2,$url3,$url4,$url5;
	
	//专题HTML地址
	public $html;

	//调试用
	public  $SqlStr='';
	
	
	/**
	 * 初始化
	 *
	 */
	public function __construct() {
		//
	}
	
	
	/**
	 * 销毁
	 *
	 */
	public function __destruct() {
		//不需要
	}

	/**
	 * 初始化Sql语句
	 *
	 */
	function InitSql(){
		//栏目编号
		$CateId=$this->CateId;		
		if (strpos($CateId, ',')) {
			$this->SqlCateId=' AND `a`.`cateid` in ('.$CateId.')';		
		}	elseif ($CateId>0)	{
			$this->SqlCateId=' AND `a`.`cateid` ='.$CateId;		
		}
		
		$CateId=$this->CateId;		
		$this->SqlCateTitleId=' AND `id` ='.$CateId;		
		
		//显示区域
		$Area=$this->Area;
		if ($Area>0) 	{
			$Area+=0;
			$this->SqlArea= ' AND `a`.`area'.$Area.'` =1';
		}

		//状态
		$this->SqlFlag= ' AND `a`.`flag` = '. $this->Flag;
			
		//排序
		$this->SqlOrder= ' ORDER BY `a`.`'.$this->OrderBy.'` '.$this->OrderSort;
		
		//显示个数		
		$this->SqlLimit= ' LIMIT '.$this->BeginCount.', '.$this->Count.';';
	}
	
	
	/**
	 * 返回文章列表
	 *
	 * @return string
	 */
	function getArticleList(){
		//Sql语句生成
		$this->InitSql();
		
		$TempString		= '';
		$ReturnString	= '';
		
		//文章列表
		//-------------------0---------1------------2---------------3------------4-----------5-----------6------------7-------------8
		$SqlStr	= 'SELECT `a`.`id`, `a`.`title`, `a`.`posttime`, `a`.`reurl`, `a`.`html`, `a`.`hits`, `c`.`title`, `a`.`title2`, `a`.`titlecolor`  from `'.DB_TABLE_PRE.'article` `a`, `'.DB_TABLE_PRE.'article_cate` `c`';
		$SqlStr.= ' WHERE 1=1';
		$SqlStr.=' AND `a`.`cateid`=`c`.`id`';
		$SqlStr.=' AND `a`.`notshowlist` = 0';		
				
		//栏目
		$SqlStr.=$this->SqlCateId;

		//区域
		$SqlStr.=$this->SqlArea;
		
		//状态
		$SqlStr.=$this->SqlFlag;
		
		//排序
		$SqlStr.=$this->SqlOrder;
		
		//显示个数
		$SqlStr.=$this->SqlLimit;

		$this->SqlStr=$SqlStr;
		/*
		echo $SqlStr;
		echo $this->LiClassId;
		*/
		$MyDatabase=new Database();
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record_Arr = $MyDatabase->ResultArr;
			foreach ( $DB_Record_Arr as $DB_Record ) {
				$id					= $DB_Record[0];
				$title			= subString($DB_Record[1],$this->TitleCount);
				$posttime		= $DB_Record[2];
				$reurl			= $DB_Record[3];
				$url				= $DB_Record[4];
				$hits				= $DB_Record[5];
				$catetitle	= $DB_Record[6];
				$title2			= $DB_Record[7];
				$titlecolor	= $DB_Record[8];
				
				//如果设置为Title2显示并且存在Title2，则title为title2
				if ($this->ShowTitle2 && $title2<>''){
					$title			= $title2;
				}
				
				//跳转链接，如果存在，则文章链接为跳转链接
				if ($reurl<>''){
					$url=$reurl;
				}
				
				//文章标题颜色
				if ($titlecolor<>''){
					$title			= '<font color="'.$titlecolor.'">'.$title.'</font>';
				}
				
				//文章标题是否显示一个Dot
				if ($this->ShowDot){
					$title='·'.$title;
				}
				
				//产生一个链接
				$TempString='<a title="'.$DB_Record[1].'" href="'.$url.'">'.$title.'</a>';
				
				if ($this->ShowCate){
					$TempString='<span>'.$catetitle.' | </span>'.$TempString;
				}
				
				if ($this->ShowHits){
					$TempString.=	'('.$hits.')';
				}
		
				if ($this->ShowDate){
					$TempString.='<span>'.$posttime.'</span>';
				}
				
				if ($this->ShowLi){
					if($this->LiClass && $this->LiClassId && $this->LiClassId==$id){
							$TempString='<li class="'.$this->LiClass.'">'.$TempString.'</li>';
					}else{
						$TempString	=	'<li>'.$TempString.'</li>';
					}
				}
		
				if ($this->ShowBracket){
					$TempString	=	'['.$TempString.'] ';
				}
				
				$ReturnString.=$TempString;
			}
		}
		
		return $ReturnString;
	}
	
	/**
	 * 返回栏目里面的html
	 *
	 */
	function DefaultHtml(){
		$html='';
		//Sql语句生成
		$this->InitSql();

		//-------------------0
		$SqlStr	= 'SELECT `html` FROM `'.DB_TABLE_PRE.'article` a';
		$SqlStr.= ' WHERE 1=1';
				
		//栏目
		$SqlStr.=$this->SqlCateId;
		
		//状态
		$SqlStr.=$this->SqlFlag;
		
		//排序
		$SqlStr.=$this->SqlOrder;
		
		//显示个数
		$SqlStr.=$this->SqlLimit;

//		echo $SqlStr;

		$MyDatabase=new Database();
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record = $MyDatabase->ResultArr [0];
			
			$html= $DB_Record[0];
		}
		return $html;		
	}
	
	/**
	 * 返回5个链接和专题地址
	 *
	 */
	function getURLById() {
		//-------------------0
		$SqlStr = 'SELECT `url1`,`url2`,`url3`,`url4`,`url5`, `html` FROM `' . DB_TABLE_PRE . 'special`';
		$SqlStr.= ' WHERE `id`='.$this->id;
		$SqlStr.= ' LIMIT 1;';
		
		$MyDatabase = new Database ( );
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record = $MyDatabase->ResultArr [0];
			
			$this->url1 = $DB_Record [0];
			$this->url2 = $DB_Record [1];
			$this->url3 = $DB_Record [2];
			$this->url4 = $DB_Record [3];
			$this->url5 = $DB_Record [4];
			$this->html = $DB_Record [5];
		}
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