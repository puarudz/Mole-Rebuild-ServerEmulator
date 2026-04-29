package com.view.JobView.ChildNPCModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseNPCModule extends Sprite
   {
      
      public static var SHOWNPCBTN:String = "show_npc_btn";
      
      public var npc_obj:Object;
      
      public function BaseNPCModule()
      {
         super();
      }
      
      public function setInfo(obj:Object) : void
      {
         this.npc_obj = obj;
      }
      
      public function npcClientFun(a:* = null) : void
      {
         var url:String = this.npc_obj.url;
         var msg:String = this.npc_obj.msg;
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      public function removeEventFun() : void
      {
         BC.removeEvent(this);
      }
   }
}

