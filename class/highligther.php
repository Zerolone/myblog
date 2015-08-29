<?php
/**
 * 字符串高亮  
 * 高亮的内容为<code></code>包围的字符串
 * 字符串一般为从数据空中取出的字符串
 * 
 * @version 2010-1-3
 * @author Zerolone
 */

//highlight_string($str_test);


/*
 * 高亮显示字符串
 * 
 * @version 2010-1-3 21:48:30
 * @author Zerolone
 */

class Highlighter{
	/*
	 * 加亮字符串，返回字符串
	 * 
	 * @param $Content 		加亮的内容
	 * @param $PerLine 		区分的行数，默认为每5行
	 * @param $PerLineCss 区分的行数Css，默认为cb
	 * @param $str_begin 	起始字符串，默认为{hightlight}
	 * @param $str_end 		起始字符串，默认为{/hightlight}
	 */
	public function Str($Content, $PerLine=5, $PerLineCss='cb', $str_begin='<CODE>', $str_end='</CODE>'){
		//原Content
		$Content_Old=$Content;
		
		//获取需要切割的
		
		$pos1 = strpos($Content, $str_begin);
		$pos2 = strpos($Content, $str_end, $pos1);		
		$str_begin_Len	= strlen($str_begin);
		
		//需要处理的内容
//		$Content		= substr($Content, $pos1+$StartFlag_Len, $pos2-$pos1-$StartFlag_Len);
		$Content		= substr($Content, $pos1+$str_begin_Len, $pos2-$pos1-$str_begin_Len);
		
		//需要替换掉的部分Content
		$Content_Replace = $Content;
		
		//行数
		$i=0;
		
		//每几行的效果
		$str_perline='';
		
		//输出字符串
		$str_return='<div class="php"><ol>';
		
		//临时字符串
		$str_tmp='';
		
		//切割字符串，Content由字符串变成了数组
		$Content=explode("\n", $Content);
		
		//计算代码行数
		$Content_Len=count($Content);
		
		//每行输出
		foreach ($Content as $Content){
			//加亮当前行
			$str_tmp=highlight_string('<?'. $Content, 1);
			
			//替换掉<?一次
			//$str_tmp=str_replace('&lt;?', '', $str_tmp , 1);			
			
			$str_tmp = preg_replace('(&lt;\?)', '', $str_tmp, 1);
						
			//每$PerLine行，行号加粗
			$i++;
			$str_perline='';
			if ($i % $PerLine==0){
				$str_perline= 'class='.$PerLineCss;
			}
			
			$str_return.='<li '.$str_perline.'><div>'.$str_tmp.'</div></li>';
		}
		
		//输出字符串
		$str_return.='</ol></div>';
		
		//替换		
		$str_return=str_replace($str_begin.$Content_Replace.$str_end, $str_return, $Content_Old);
				
		//返回
		return $str_return;
	}
}
?>