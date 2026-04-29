package com.module.cutMapModule
{
   import com.core.MainManager;
   import com.logic.FindPathLogic.MoveTo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class getCutMapByRect extends getCutMap
   {
      
      public static var ON_SAVE_SUCCESS:String = "onSaveSuccess";
      
      public static var ON_SAVE_FAIL:String = "onSaveFail";
      
      public static var ON_CUTMAP_SUCCESS:String = "onSuccess";
      
      public static var ON_CUTMAP_CANCEL:String = "onCancel";
      
      private var rect:Rectangle;
      
      public function getCutMapByRect(r:Rectangle)
      {
         super();
         this.rect = r;
      }
      
      override protected function showCutMapBox(E:Event) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.ADDED_CLASS,this.showCutMapBox);
         var myClass:* = SaveCutMap.getLibClass("CutMap");
         cupMapClass = new myClass();
         cupMapClass.visible = false;
         BC.addEvent(this,cupMapClass,Event.OPEN,this.setPostion);
         BC.addEvent(this,cupMapClass,Event.COMPLETE,onSuccess);
         BC.addEvent(this,cupMapClass,Event.CLOSE,onCancel);
         setmouseEnabled(false);
         MoveTo.CanMove = false;
         MainManager.getRootMC().addChild(cupMapClass);
      }
      
      private function setPostion(E:Event) : void
      {
         cupMapClass.setPosition(this.rect);
         cupMapClass.saveCupMap();
      }
   }
}

