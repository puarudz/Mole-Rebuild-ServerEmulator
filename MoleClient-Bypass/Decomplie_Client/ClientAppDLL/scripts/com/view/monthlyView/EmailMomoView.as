package com.view.monthlyView
{
   import com.logic.FindPathLogic.MoveTo;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   
   public class EmailMomoView extends MonthlyView
   {
      
      public function EmailMomoView(container:Loader)
      {
         super(container);
         MoveTo.CanMove = false;
      }
      
      override public function initEvent() : void
      {
         for(var i:int = 1; i < 12; i++)
         {
            main[["news"] + i].addEventListener(MouseEvent.CLICK,this.rootHandler);
         }
      }
      
      override public function removeBtnHandler() : void
      {
         for(var i:int = 1; i < 12; i++)
         {
            main[["news"] + i].removeEventListener(MouseEvent.CLICK,this.rootHandler);
         }
         GC.clearAllChildren(main);
         main = null;
         MoveTo.CanMove = true;
      }
      
      override public function rootHandler(event:MouseEvent) : void
      {
         var nameStr:String = event.currentTarget.name;
         var tempStr:int = int(nameStr.substr(4));
         var str:String = "resource/email/" + tempStr + ".swf";
         var loadInfo:String = "正在打開麼麼公主的日記......";
         loadMC(str,loadInfo);
      }
   }
}

