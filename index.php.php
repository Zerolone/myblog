<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Language" content="UTF-8" />
<meta content="all" name="robots" />
<meta name="author" content="Zerolone" />
<meta name="description" content="Monolith CMS, Blog, Article, Manual" />
<meta name="keywords" content="Monolith,Blog,Article,Manual,php,javascript" />
<link rel="stylesheet" rev="stylesheet" href="css/styles.css" type="text/css" media="all" />
<title>用原始的工具，构建完美的站点。</title>
<script type="text/javascript" src="js/common.js"></script>
</head>
<body id="pagelocation-?tem=neowin2">
<div id="wrapper">
  <div id="header">
    <div id="header-r">
      <div id="header-l">
        <div id="innerHeader">
          <div id="blogLogo"> </div>
          <div class="blog-header">
            <h1 class="blog-title"><a href="index.php">用原始的工具，构建完美的站点。</a></h1>
            <div class="blog-desc">程序员是魔术师，他把枯燥无味的代码变成丰富多彩的软件，我的双手只能将代码变成乱码</div>
          </div>
          <div id="header-search" style="display:none;">
            <form action="visit.php" method="post">
              <div id="header-search-box">
                <input type="hidden" value="search" name="job" />
                <input type="hidden" value="2" name="searchmethod" />
                <input type="text" name="keyword" value="搜索Blog" maxlength="255" size="31" onfocus="if(this.value=='搜索Blog') this.value='';" onblur="if(this.value=='') this.value='搜索Blog';" />
              </div>
            </form>
          </div>
          <div class="clear"></div>
        </div>
        <div id="header-bot">
          <div id="header-nav">
            <ul id="nav">
              <li><span id="nav__2F"><a href="index.php" ><span id="navitem__2F">首页</span></a></span></li>
							<!--
              <li><span id="nav_archive"><a href="archive" ><span id="navitem_archive">归档</span></a></span></li>
							-->
              <li><span id="nav_javascript_3AshowHideSidebar_28_29_3B"><a href="javascript:showHideSidebar();" ><span id="navitem_javascript_3AshowHideSidebar_28_29_3B">边栏</span></a></span></li>
							<!--
              <li id="nav-rss"><a href="feed.php" target="_blank"><span>RSS</span></a></li>
							-->
            </ul>
          </div>
          <div id="header-userbar"> </div>
          <div class="clear"></div>
        </div>
      </div>
    </div>
  </div>
  <div class="content-box-tbar">
    <div class="content-box-tbar-r">
      <div class="content-box-tbar-l"> <span class="right-links"></span> </div>
    </div>
  </div>
  <div id="mainWrapper">
    <div id="content" class="content">
      <div id="innerContent">
        <?php
				if(isset($blog_list)){
					foreach ($blog_list as $blog){
				?>
        <div class="textbox">
          <div class="textbox-title">
            <h4> <a href="JavaScript:"><?=$blog['title']?></a> </h4>
            <div class="textbox-label">
							<?=$blog['posttime']?>  , <a href="?cateid=<?=$blog['cateid']?>" title="查看分类：<?=$blog['catetitle']?>"><?=$blog['catetitle']?></a>
            </div>
          </div>
          <div class="textbox-content">
            <?=$blog['content']?>
            <div style="margin-top: 9px; display:none;" > <img src="images/readmore.gif" alt=""/><a href="view.php?id=<?=$blog['id']?>" title="点击阅读全文">阅读全文</a> </div>
          </div>
          <div class="textbox-bottom"> </div>
        </div>
        
        <?php
					}
				}
				?>

      <div class="article-bottom" style="display: block">
        <div class="pages">
<script language="JavaScript">
function goto(pagenum){
	article_list_frm.pagenum.value	= pagenum;
	article_list_frm.submit();
}
</script>
          <form method="get" action="" style="MARGIN-BOTTOM:0px" name="article_list_frm">
            <input type="hidden" name="cateid" value="<?=$cateid?>">
            <input type="hidden" name="searchkey" value="<?=$searchkey?>">
            <?=SplitPage($recordcount, $pagenum, $pagesize);?>
          </form>
        </div>
      </div>
    </div>
  </div>
  <div id="sidebar" class="sidebar">
    <div id="innerSidebar">
      <div id="innerSidebarOne">
        <div class="panel">
          <h5 onclick='showhidediv("sidebar_entries");'>最新快速发表</h5>
          <div class="panel-content" id="sidebar_entries" style="display: block">
            <ul>
						<?php
						if(isset($quick_list)){
							foreach ($quick_list as $quick){
						?>
              <li class='rowcouple'><a href="javascript:" title="<?=$quick['title_long']?>"> <?=$quick['title']?></a></li>
						<?php
							}
						}
						?>
              </ul>
            </div>
        </div>
        <div id='panelCategory' class="panel">
          <h5 style="cursor: pointer" onclick='showhidediv("sideblock_category");'>分类</h5>
          <div class="panel-content" id="sideblock_category" style="display: block">
            <ul>
            <?php
						if(isset($cate_list)){
							foreach ($cate_list as $cate){
						?>
              <li><a href="?cateid=<?=$cate['id']?>"><?=$cate['title']?></a><a href="javascript:"><img src="images/rss.png" border="0" alt="RSS" title="追踪这个分类的RSS" /></a></li>
            <?php
							}
						}
						?>
              </ul>
            </div>
        </div>
				<!--
        <div class="panel">
          <h5 onclick='showhidediv("sidebar_link");'>链接</h5>
          <div class="panel-content" id="sidebar_link" style="display: block">
            <ul>
              <li class="indent"><a href="javascript:" target="_blank" title="#">#</a></li>
              <li class="indent"><a href="javascript:" target="_blank" title="#">#</a></li>
              <li class="indent"><a href="javascript:" target="_blank" title="#">#</a></li>
              <li class="indent"><a href="javascript:" target="_blank" title="#">#</a></li>
              <li class="indent"><a href="javascript:" target="_blank" title="#">#</a></li>
            </ul>
          </div>
        </div>
				-->
        <div class="panel">
          <h5 onclick='showhidediv("sidebar_archive");'>归档</h5>
          <div class="panel-content" id="sidebar_archive" style="display: block">
            <ul>
            <?php
						if(isset($posttime_list)){
							foreach ($posttime_list as $posttime){
						?>
              <li><a href="archiver/1/2010/" rel="noindex,nofollow"><?=$posttime['month']?>[<?=$posttime['count']?>]</a></li>
            <?php
							}
						}
						?>
            </ul>
          </div>
        </div>
        <div class="panel">
          <h5 onclick='showhidediv("sidebar_statistics");'>统计</h5>
          <div class="panel-content" id="sidebar_statistics" style="display: block"> 
            日志数量 <?=$recordcount?>
            <br/>
          </div>
        </div>
      </div>
      <div class="clear"></div>
    </div>
  </div>
  <div class="clear"> </div>
</div>
<div class="content-box-b">
  <div class="content-box-b-r">
    <div class="content-box-b-l"></div>
  </div>
</div>
<div id="footer">
  <div id="footer-r">
    <div id="footer-l">
      <div id="footer-misc"> <a href="#top">到最顶上</a><br />
        Transplanted By <a href="http://blog.meiu.cn/" target="_blank">Lingter</a> </div>
      <div id="footer-copyright">磐石博客系统 Monolith Blog System<br />
        Version Beta <a href="javascript:">1.0 Release</a><span id="footer-security"></span><br />
				页面执行时间 <?=getprocesstime($startime)?> 秒 | 数据库查询次数 <?=$MyDatabase->QueryCount?> 次
      </div>
      <div class="clear"></div>
    </div>
  </div>
</div>
</div>
</html>