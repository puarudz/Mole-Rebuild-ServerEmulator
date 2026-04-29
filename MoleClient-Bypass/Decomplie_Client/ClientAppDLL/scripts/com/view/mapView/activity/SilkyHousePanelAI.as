package com.view.mapView.activity
{
   import com.core.info.LocalUserInfo;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SilkyHousePanelAI
   {
      
      private static var _instanse:SilkyHousePanelAI;
      
      private var content:*;
      
      public function SilkyHousePanelAI()
      {
         super();
      }
      
      public static function getInstanse() : SilkyHousePanelAI
      {
         if(_instanse == null)
         {
            _instanse = new SilkyHousePanelAI();
         }
         return _instanse;
      }
      
      public function setContent(c:*) : void
      {
         if(this.content == null)
         {
            this.content = c;
            BC.addEvent(this,this.content.close_btn,MouseEvent.CLICK,this.closeHandler);
            BC.addEvent(this,this.content.yes_btn,MouseEvent.CLICK,this.yesHandler);
            BC.addEvent(this,this.content.no_btn,MouseEvent.CLICK,this.closeHandler);
            this.content.nameContent.text = "    親愛的" + LocalUserInfo.getNickName() + "，接下來就看我的吧，念出魔咒：一手遮天，讓我們一起來完成。";
         }
         this.content.txt.text = "";
      }
      
      public function getContent() : *
      {
         return this.content;
      }
      
      private function closeHandler(e:MouseEvent) : void
      {
         this.content.visible = false;
      }
      
      private function yesHandler(e:MouseEvent) : void
      {
         var str:String = this.content.txt.text;
         str = str.replace(/\s/g,"");
         if(str == "一手遮天")
         {
            this.content.dispatchEvent(new Event("START_POWER"));
         }
         else
         {
            this.content.dispatchEvent(new Event("WRIGHT_POWER"));
         }
      }
      
      public function clear() : void
      {
         _instanse = null;
         BC.removeEvent(this);
         if(Boolean(this.content))
         {
            this.content.parent.removeChild(this.content);
         }
         this.content = null;
      }
   }
}

