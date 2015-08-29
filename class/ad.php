<?php
/**
 * 广告类，方便广告列表、内容的调用
 * 仅支持PHP5
 * 
 * @author Zerolone
 * @version 2009-12-4 9:41:26
 */
class Ad {		
	//起始记录数			默认为0
	public $BeginCount = 0;
	
	//记录数					默认为10
	public $Count = 1;

	//文字显示数			默认为20
	public $TitleCount = 20;
	
	//排序方式				默认为id
	public $OrderBy = 'id';
	
	//排序顺序				默认为DESC
	public $OrderSort = 'DESC';
		
	//显示li					默认为1，1为显示，0为不显示
	public $ShowLi = 1;
	
	//显示点击数			默认为0，1为显示，0为不显示
	public $ShowHits = 0;
	
	//显示点					默认为0，1为显示，0为不显示
	public $ShowDot = 0;
	
	//显示分类标题		默认为0，1为显示，0为不显示
	public $ShowCate = 0;
	
	//显示括号				默认为0，1为显示，0为不显示
	public $ShowBracket = 0;
	
	//显示日期				默认为0，1为显示，0为不显示
	public $ShowDate = 0;
	
	//显示二级标题		默认为0，1为显示，0为不显示
	public $ShowTitle2 = 0;
	
	//显示选定LiClass	默认为空
	public $LiClass = '';
	
	//显示选定LiClass的ID，默认为0
	public $LiClassId = 0;
	
	//内部使用的变量
	//栏目Sql语句
	protected $SqlCateId='';
	
	//栏目Sql语句
	protected $SqlCateTitleId='';
	
	//显示区域Sql语句
	protected $SqlArea='';
	
	//状态
	protected $SqlFlag='';
	
	//排序
	protected $SqlOrder='';
	
	//显示个数
	protected $SqlLimit='';
	
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
	 * 返回栏目标题
	 *
	 */
	function getCateTitle(){
		$CateTitle='';
		//-------------------0
		$SqlStr	= 'SELECT `title` FROM `'.DB_TABLE_PRE.'article_cate`';
		$SqlStr.= ' WHERE 1=1';
				
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
		
	/**
	 * 获取文章日期，生成一个列表
	 * 
	 * @return String
	 */
	function getArticListDate(){
		//栏目编号
		$CateId=$this->CateId;		
		if (strpos($CateId, ',')) {
			$this->SqlCateId=' AND `cateid` in ('.$CateId.')';		
		}	elseif ($CateId>0)	{
			$this->SqlCateId=' AND `cateid` ='.$CateId;		
		}
		
		$cateList='';
		
		$intCount=0;
		
		$MyDatabase=new Database();
		
		//搜索年月
		$strSearch='';
		
		//月名
		$strMonth='';
		
		//获取今天的年-月
		$year=date("Y",time());
		$month=date("m",time());
		
		//今年
		$SqlStr	= 'SELECT COUNT( * ) from `'.DB_TABLE_PRE.'article`  WHERE DATE_FORMAT(`posttime`, \'%Y\')=\''.$year.'\'';
		//栏目
		$SqlStr.=$this->SqlCateId;

		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record = $MyDatabase->ResultArr [0];
			
			$intCount = $DB_Record[0];
			
			$cateList.=' <li class="lev1"><a href="#" class="year">'.$year.' ('.$intCount.')</a></li>';
		}

		//循环今年
		for($i=$month;$i>0;$i--){
			if (strlen($i)==1){
				$strSearch= $year . '-0' . $i; 
			}else{
				$strSearch= $year . '-' . $i; 
			}
			
			switch ($i) {
	    case 1:
	        $strMonth='一月';
	        break;
	    case 2:
	        $strMonth='二月';
	    	  break;
	    case 3:
	        $strMonth='三月';
	        break;
	    case 4:
	        $strMonth='四月';
	        break;
	    case 5:
	        $strMonth='五月';
	    	  break;
	    case 6:
	        $strMonth='六月';
	        break;	     
	    case 7:
	        $strMonth='七月';
	        break;
	    case 8:
	        $strMonth='八月';
	    	  break;
	    case 9:
	        $strMonth='九月';
	        break;	 
	    case 10:
	        $strMonth='十月';
	        break;
	    case 11:
	        $strMonth='十一月';
	    	  break;
	    case 12:
	        $strMonth='十二月';
	        break;          
			}
						
			$SqlStr	= 'SELECT COUNT( * ) from `'.DB_TABLE_PRE.'article`  WHERE DATE_FORMAT(`posttime`, \'%Y-%m\')=\''.$strSearch.'\'';
			//栏目
			$SqlStr.=$this->SqlCateId;
			$MyDatabase->SqlStr = $SqlStr;
			
			if ($MyDatabase->Query () ) {
				$DB_Record = $MyDatabase->ResultArr [0];
				
				$intCount = $DB_Record[0];
				if($intCount>0){
					$cateList.=' <li class="lev2"><a href="#" class="year">'.$strMonth.' ('.$intCount.')</a></li>';				
				}
			}
		}
		
		//最近9年循环
		for($i=$year-1;$i>$year-10;$i--){
			$SqlStr	= 'SELECT COUNT( * ) from `'.DB_TABLE_PRE.'article`  WHERE DATE_FORMAT(`posttime`, \'%Y\')=\''.$i.'\'';
			//栏目
			$SqlStr.=$this->SqlCateId;
			
			$MyDatabase->SqlStr = $SqlStr;
			if ($MyDatabase->Query () ) {
				$DB_Record = $MyDatabase->ResultArr [0];
				
				$intCount = $DB_Record[0];
				if($intCount>0){
					$cateList.=' <li class="lev1"><a href="#" class="year">'.$i.' ('.$intCount.')</a></li>';				
				}
			}
		}
				
		return $cateList;
	}
	
	/**
	 * 根据上级栏目编号， 返回栏目标题列表。
	 * 
	 * @param 上级编号 $parentid
	 *
	 */
	function getTitleListByCateId($parentid){
		$CateTitleList='';
		//-------------------0------1
		$SqlStr	= 'SELECT `title`, `id` FROM `'.DB_TABLE_PRE.'article_cate`';
		$SqlStr.= ' WHERE parentid=' . $parentid;
		$SqlStr.= ' ORDER BY `level` ASC;';
		
//		echo $SqlStr;
						
		$MyDatabase=new Database();
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record_Arr = $MyDatabase->ResultArr;
			foreach ( $DB_Record_Arr as $DB_Record ) {
				$CateTitleList.= '<a href="article.php?id='.$DB_Record[1].'">'.$DB_Record[0].'</a>';
			}
		}
		return $CateTitleList;
	}
	
	
	/**
	 * 根据Order， 返回广告内容。
	 * 
	 * @param 编号 $Order
	 *
	 */
	function getContentByOrder($Order){
		$ReturnContent='';
		//------------------0-------1--------2--------3
		$SqlStr	= 'SELECT `pic`, `width`, `height`, `url` FROM `'.DB_TABLE_PRE.'ad`';
		$SqlStr.= ' WHERE `Order`=' . $Order;
		$SqlStr.= ' LIMIT 1';
		//		echo $SqlStr;
						
		$MyDatabase=new Database();
		$MyDatabase->SqlStr = $SqlStr;
		if ($MyDatabase->Query ()) {
			$DB_Record = $MyDatabase->ResultArr [0];
			
			$FileName = $DB_Record[0];
			$Width 		= $DB_Record[1];
			$Height 	= $DB_Record[2];
			$Url			= $DB_Record[3];
		}
		
		//判断类型
		$FileName_Ext=strtoupper(pathinfo($FileName, PATHINFO_EXTENSION));
		
		if ($FileName_Ext=='SWF'){
			$ReturnContent = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="'.$Width.'" height="'.$Height.'">
  <param name="movie" value="'.$FileName.'">
  <param name="quality" value="high">
  <embed src="'.$FileName.'" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="'.$Width.'" height="'.$Height.'"></embed>
</object>';
		}else{
			$ReturnContent = '<img src="'.$FileName.'" width="'.$Width.'" height="'.$Height.'" />';
		}
		
		if($Order==1){
			$ReturnContent = '<a class="subad_a mr5" href="'.$Url.'">' . $ReturnContent . '</a>';			
		}elseif ($Order==2){
			$ReturnContent = '<a class="subad_b mr5" href="'.$Url.'">' . $ReturnContent . '</a>';			
		}elseif ($Order==3){
			$ReturnContent = '<a class="subad_c" href="'.$Url.'">' . $ReturnContent . '</a>';			
		}
		
		return $ReturnContent;
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