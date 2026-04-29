package com.module.farm
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FishPanel extends FieldPanel
   {
      
      public static var instance:FishPanel;
      
      public function FishPanel()
      {
         super();
         URL = "resource/farm/fish/";
         classLink = "fish_UI";
      }
      
      public static function getInstance() : FishPanel
      {
         if(instance == null)
         {
            instance = new FishPanel();
         }
         return instance;
      }
      
      override public function userPorp(e:MouseEvent) : void
      {
      }
      
      public function catchANM(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1363,this.catchANM);
         this.dupFish();
         trace(e);
      }
      
      public function dupFish() : void
      {
      }
      
      override public function onBtnOver(e:MouseEvent) : void
      {
         e.target.parent.tip_mc.visible = true;
         trace("----");
      }
      
      override public function onBtnOut(e:MouseEvent) : void
      {
         e.target.parent.tip_mc.visible = false;
      }
   }
}

