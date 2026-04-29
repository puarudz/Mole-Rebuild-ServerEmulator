package com.logic.mapEvent
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class MapObj extends EventDispatcher
   {
      
      public static const MAP_ROLL_OVER:String = "map_roll_over";
      
      public static const MAP_ROLL_OUT:String = "map_roll_out";
      
      public static const MAP_Click:String = "map_click";
      
      public static const IMG_WIDTH:uint = 20;
      
      public static const IMG_HEIGHT:uint = 20;
      
      public static const IMG_DIS:uint = 5;
      
      public var _isLockMove:uint = 0;
      
      public var id:uint = 0;
      
      public var name:String = "";
      
      public var _hotValue:uint = 0;
      
      public var _btn:MovieClip = new MovieClip();
      
      private var _isActive:Boolean = false;
      
      public var tipObj:MapTipObj = new MapTipObj();
      
      private var _imgArr:Array;
      
      private var imgHolder:Sprite = new Sprite();
      
      public function MapObj()
      {
         super();
         this.imgHolder.mouseChildren = false;
         this.imgHolder.mouseEnabled = false;
      }
      
      public function init(Cid:uint, Cname:String, ChotValue:uint, CisActive:Boolean, CtipObj:MapTipObj = null, CimgArr:Array = null, isLockMove:int = 0) : void
      {
         this.id = Cid;
         this.name = Cname;
         this.hotValue = ChotValue;
         this.active = CisActive;
         this.tipObj = CtipObj;
         this._isLockMove = isLockMove;
         this.imgArr = CimgArr;
      }
      
      private function configListener(Cadd:Boolean = true) : void
      {
         if(Cadd)
         {
            this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
            this._btn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._btn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
         else
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            this._btn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._btn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(MAP_Click));
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(MAP_ROLL_OVER));
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(MAP_ROLL_OUT));
      }
      
      public function set active(Cactive:Boolean) : void
      {
         this._isActive = Cactive;
         if(this._isActive)
         {
            this._btn.mouseEnabled = true;
            this._btn.enabled = true;
            this.configListener();
         }
         else
         {
            this._btn.mouseEnabled = false;
            this._btn.enabled = false;
            this.configListener(false);
         }
      }
      
      public function get active() : Boolean
      {
         return this._isActive;
      }
      
      public function set hotValue(ChotValue:uint) : void
      {
         this._hotValue = ChotValue;
      }
      
      public function get hotValue() : uint
      {
         return this._hotValue;
      }
      
      public function set imgArr(CimgArr:Array) : void
      {
         this._imgArr = CimgArr;
         this.loadImg();
      }
      
      public function get imgArr() : Array
      {
         return this._imgArr;
      }
      
      public function loadImg() : void
      {
         var i:uint;
         var tempPath:String = null;
         var cls:* = undefined;
         var ti:int = 0;
         var t:MovieClip = null;
         while(this.imgHolder.numChildren > 0)
         {
            this.imgHolder.removeChildAt(this.imgHolder.numChildren - 1);
         }
         if(this._imgArr == null || this._imgArr.length == 0)
         {
            return;
         }
         for(i = 0; i < this._imgArr.length; i++)
         {
            tempPath = this._imgArr[i];
            if(tempPath == "")
            {
               break;
            }
            ti = int(tempPath);
            try
            {
               cls = WordMapLogic.mapMC["cls_new_mc" + ti];
            }
            catch(e:ErrorEvent)
            {
               cls = WordMapLogic_MLD.mapMC["cls_new_mc" + ti];
            }
            if(Boolean(cls))
            {
               t = new cls();
               this.imgHolder.addChild(t);
               t.x = i * (IMG_WIDTH + IMG_DIS);
            }
         }
      }
      
      public function set btn(Cbtn:MovieClip) : void
      {
         this._btn = Cbtn;
         this.active = this._isActive;
         if(Boolean(this._btn.parent))
         {
            this._btn.addChild(this.imgHolder);
            this.imgHolder.x = -20;
            this.imgHolder.y = 10;
         }
      }
      
      public function get btn() : MovieClip
      {
         return this._btn;
      }
   }
}

