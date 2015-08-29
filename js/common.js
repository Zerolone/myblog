// Show/Hide Sidebar
function showHideSidebar(){
  try{
    var objSidebar=document.getElementById("sidebar");
    var objContent=document.getElementById("content");
    if(objSidebar.className!="sidebar-hide"){
      objSidebar.className="sidebar-hide";
      objSidebar.style.display="none";
      objContent.className="content-wide";
	  setCookie('sidebaroff', 1,null, null, null, false);
    }else{
      objSidebar.className="sidebar";
      objSidebar.style.display="block";
      objContent.className="content";
	  setCookie('sidebaroff', 0,null, null, null, false);
    }
  }catch(e){}
}

//Show/Hide a DIV
function showhidediv(id){
  try{
    var panel=document.getElementById(id);
    if(panel){
      if(panel.style.display=='none'){
        panel.style.display='block';
      }else{
        panel.style.display='none';
      }
    }
  }catch(e){}
}