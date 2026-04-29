package com.view.monthlyView
{
   import com.core.info.LocalUserInfo;
   import com.logic.FindPathLogic.MoveTo;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   
   public class smcBookView extends MonthlyView
   {
      
      public function smcBookView(container:Loader)
      {
         super(container);
      }
      
      override public function initEvent() : void
      {
         for(var i:int = 101; i < 109; i++)
         {
            if(main[["news"] + i] == null)
            {
               break;
            }
            main[["news"] + i].mc.buttonMode = true;
            main[["news"] + i].mc.addEventListener(MouseEvent.CLICK,this.rootHandler);
            main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OVER,rootMouseOver);
            main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OUT,rootMouseOut);
         }
      }
      
      override public function removeBtnHandler() : void
      {
         for(var i:int = 101; i < 109; i++)
         {
            if(main[["news"] + i] == null)
            {
               break;
            }
            main[["news"] + i].mc.removeEventListener(MouseEvent.CLICK,this.rootHandler);
            main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OVER,rootMouseOver);
            main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OUT,rootMouseOut);
         }
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
         if(tempStr == 10)
         {
            str = "module/external/myAtStar.swf";
         }
         else if(LocalUserInfo.getMapID() == 65)
         {
            str = "resource/besmearBook/" + tempStr + ".swf";
         }
         else
         {
            str = "resource/besmearBook/other/" + tempStr + ".swf";
         }
         var loadInfo:String = "正在打開書刊......";
         loadMC(str,loadInfo);
      }
   }
}

