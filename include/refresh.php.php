<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="STYLESHEET" type="text/css" href="css/manage.css">
</head>

<script type="text/javascript">
var duration= <?=$refresh_time?>*1000 - 100;
var endTime = new Date().getTime() + duration + 100;
function interval()
{
	var n=(endTime-new Date().getTime())/1000;
	if(n<0) return;
	document.getElementById("timeout").innerHTML = n.toFixed(3);
	setTimeout(interval, 10);
}

window.onload=function()
{
	setTimeout("window.location.href='<?=$refresh_url?>'", duration);
	interval();
}
</script>

<body>
	<div align="center">
		<table border="0" width="100%" id="table1" height="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<div align="center">
					<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#666666" width="90%" height="90">
						<tr>
							<td bgcolor="#F7F7F7">
							<p align="center"><br><font color="blue">��ʾ��Ϣ : <?=$refresh_msg?></font><br><br>( <a href="<?=$refresh_url?>">�� <span id="timeout"><?=$refresh_time?>.000</span> ���,ҳ�潫�Զ���ת,����,��Ҳ���Ե������</a> )<br><br></td>
						</tr>
					</table>
				</div>
				</td>
			</tr>
		</table>
	</div>
</body>

</html>