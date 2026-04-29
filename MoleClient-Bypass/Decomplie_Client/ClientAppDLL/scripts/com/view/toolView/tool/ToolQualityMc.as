package com.view.toolView.tool
{
   import com.view.MapManageView.ImageLevelManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.StageQuality;
   import flash.events.MouseEvent;
   
   public class ToolQualityMc
   {
      
      private var _mainMc:MovieClip;
      
      private var _yesBtn:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      private var _btnList:Vector.<MovieClip>;
      
      public function ToolQualityMc(_menuCon:MovieClip)
      {
         super();
         this._mainMc = _menuCon;
         this._mainMc.visible = false;
         this._yesBtn = this._mainMc["yes_btn"];
         this._closeBtn = this._mainMc["close_btn"];
         this._btnList = new Vector.<MovieClip>();
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._yesBtn.addEventListener(MouseEvent.CLICK,this.onYes);
         this.init();
      }
      
      private function init() : void
      {
         var mc:MovieClip = null;
         for(var i:uint = 0; i < 3; i++)
         {
            mc = this._mainMc["mc_" + i.toString()];
            mc.gotoAndStop(1);
            this._btnList.push(mc);
            mc.addEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      public function set setVisible(bool:Boolean) : void
      {
         this._mainMc.visible = bool;
      }
      
      public function get setVisible() : Boolean
      {
         return this._mainMc.visible;
      }
      
      private function onClose(e:MouseEvent) : void
      {
         this._mainMc.visible = false;
         this._mainMc.x = -287;
         this._mainMc.y = 117;
      }
      
      private function onYes(e:MouseEvent) : void
      {
         this._mainMc.visible = false;
         this._mainMc.x = -287;
         this._mainMc.y = 117;
      }
      
      private function onClick(event:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var queType:String = null;
         var index:int = this._btnList.indexOf(event.currentTarget as MovieClip);
         for each(mc in this._btnList)
         {
            mc.gotoAndStop(1);
         }
         this._btnList[index].gotoAndStop(3);
         switch(index)
         {
            case 0:
               queType = StageQuality.LOW;
               break;
            case 1:
               queType = StageQuality.MEDIUM;
               break;
            case 2:
               queType = StageQuality.HIGH;
         }
         ImageLevelManager.setImageLevel(queType);
      }
   }
}

