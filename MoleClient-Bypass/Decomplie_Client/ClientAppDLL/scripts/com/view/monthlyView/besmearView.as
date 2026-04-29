package com.view.monthlyView
{
   import com.core.info.LocalUserInfo;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.task.TaskClothReviewCtrl;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class besmearView extends MonthlyView
   {
      
      public function besmearView(container:Loader)
      {
         super(container);
      }
      
      override public function initEvent() : void
      {
         for(var i:int = 1; i < 100; i++)
         {
            if(main[["news"] + i] != null)
            {
               main[["news"] + i].mc.buttonMode = true;
               main[["news"] + i].mc.addEventListener(MouseEvent.CLICK,this.rootHandler);
               main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OVER,rootMouseOver);
               main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OUT,rootMouseOut);
            }
         }
         BC.addEvent(this,main.btn_2008Up,MouseEvent.CLICK,this.click2008Btn,false,0,true);
         BC.addEvent(this,main.btn_2014Up,MouseEvent.CLICK,this.click2014Btn,false,0,true);
         BC.addEvent(this,main.btn_fireAndmoling,MouseEvent.CLICK,this.clickfireBtn,false,0,true);
      }
      
      private function clickfireBtn(e:MouseEvent) : void
      {
         var str:String = "";
         BC.removeEvent(this);
         GC.clearAllChildren(main);
         main = null;
         if(!isMove)
         {
            MoveTo.CanMove = true;
         }
         str = "resource/besmearBook/other/" + 36 + ".swf";
         var loadInfo:String = "正在打開書刊......";
         loadMC(str,loadInfo);
      }
      
      private function click2014Btn(e:MouseEvent) : void
      {
         BC.removeEvent(this);
         GC.clearAllChildren(main);
         main = null;
         if(!isMove)
         {
            MoveTo.CanMove = true;
         }
         ModuleManager.openPanel("ZhuangYuanGoodPlayBookPanel");
      }
      
      private function click2008Btn(e:MouseEvent) : void
      {
         TaskClothReviewCtrl.inst.openPanel(ModuleType.CLOTH_REVIEW_2008_UP,2008001,2008027,null,true,[3,3,3,4,3,3,3,4,4,3,4,4,3,4,4,3,5,3,3,4,3,4,5,4,5,3,4]);
      }
      
      override public function removeBtnHandler() : void
      {
         for(var i:int = 1; i < 100; i++)
         {
            if(main[["news"] + i] != null)
            {
               main[["news"] + i].mc.removeEventListener(MouseEvent.CLICK,this.rootHandler);
               main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OVER,rootMouseOver);
               main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OUT,rootMouseOut);
            }
         }
         BC.removeEvent(this);
         GC.clearAllChildren(main);
         main = null;
         if(!isMove)
         {
            MoveTo.CanMove = true;
         }
      }
      
      override public function rootHandler(event:MouseEvent) : void
      {
         var str:String = "";
         var nameStr:String = event.currentTarget.parent.name;
         var tempStr:int = int(nameStr.substr(4));
         if(LocalUserInfo.getMapID() == 65)
         {
            str = "resource/besmearBook/" + tempStr + ".swf";
            if(tempStr == 26 || tempStr == 27 || tempStr == 28 || tempStr == 29)
            {
               BC.addEvent(this,GV.onlineSocket,"letutuVote",this.voteFun);
            }
         }
         else if(tempStr == 33)
         {
            str = "module/external/XihaBook.swf";
         }
         else if(tempStr == 34)
         {
            str = "module/external/heroWarBook.swf";
         }
         else if(tempStr == 35)
         {
            str = "module/external/tenYearsAgo.swf";
         }
         else
         {
            str = "resource/besmearBook/other/" + tempStr + ".swf";
         }
         var loadInfo:String = "正在打開書刊......";
         loadMC(str,loadInfo);
      }
      
      private function voteFun(e:*) : void
      {
         var urls:String = "http://bbs.61.com/frame.php?frameon=yes&referer=http%3A//bbs.61.com/forumdisplay.php%3Ffid%3D10";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
   }
}

