package com.module.newAngel
{
   import com.core.manager.LevelManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NewAngelAlert
   {
      
      private var _mc:Sprite;
      
      public function NewAngelAlert()
      {
         super();
      }
      
      public static function show(msg:String) : void
      {
         var alert:NewAngelAlert = new NewAngelAlert();
         alert.setMsg(msg);
      }
      
      public function setMsg(msg:String) : void
      {
         this._mc = new NewAngelParkView.alertClassRef();
         this._mc["info_text"].text = msg;
         this._mc["close_btn"].addEventListener(MouseEvent.CLICK,this.closeHandle);
         LevelManager.alertLevel.addChild(this._mc);
      }
      
      private function closeHandle(e:MouseEvent) : void
      {
         LevelManager.alertLevel.removeChild(this._mc);
         this._mc = null;
      }
   }
}

