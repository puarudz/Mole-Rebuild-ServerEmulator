package com.taomee.component
{
   import fl.motion.Color;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   
   public class MButton extends Component
   {
      
      public static const RED:String = "red";
      
      public static const BLUE:String = "blue";
      
      public static const GREEN:String = "green";
      
      public static const FLAG_iKnow:String = "iKnow";
      
      public static const FLAG_ok:String = "ok";
      
      public static const FLAG_cancel:String = "cancel";
      
      public static const FLAG_goNow:String = "goNow";
      
      public static const FLAG_nextTime:String = "nextTime";
      
      public static const FLAG_beginMission:String = "beginMission";
      
      public static const FLAG_forgetPsw:String = "forgetPsw";
      
      private static const RED_COLOR:uint = 10027008;
      
      private static const BLUE_COLOR:uint = 102;
      
      private static const GREEN_COLOR:uint = 26112;
      
      private static const PERCENT:Number = 145.5 / 60;
      
      private var colorStr:String;
      
      private var redBGClass:Class = MButton_redBGClass;
      
      private var blueBGClass:Class = MButton_blueBGClass;
      
      private var greenBGClass:Class = MButton_greenBGClass;
      
      private var iKnowBtn:Class = MButton_iKnowBtn;
      
      private var okBtn:Class = MButton_okBtn;
      
      private var cancelBtn:Class = MButton_cancelBtn;
      
      private var goNowBtn:Class = MButton_goNowBtn;
      
      private var nextTimeBtn:Class = MButton_nextTimeBtn;
      
      private var beginMissionBtn:Class = MButton_beginMissionBtn;
      
      private var forgetPswBtn:Class = MButton_forgetPswBtn;
      
      private var buttonBG:MovieClip;
      
      private var titleMC:DisplayObject;
      
      private var iconOldW:Number;
      
      private var iconOldH:Number;
      
      private var newScale:Number;
      
      private var filter:GlowFilter;
      
      private var currentColor:uint;
      
      private var isDefault:Boolean = true;
      
      private var bgWidth:Number;
      
      private var bgHeight:Number;
      
      public function MButton(titileIcon:* = null, colorType:String = "red", icon:* = null)
      {
         super();
         this.colorStr = colorType;
         if(this.colorStr == RED)
         {
            this.currentColor = RED_COLOR;
         }
         else if(this.colorStr == BLUE)
         {
            this.currentColor = BLUE_COLOR;
         }
         else if(this.colorStr == GREEN)
         {
            this.currentColor = GREEN_COLOR;
         }
         this.filter = new GlowFilter(this.currentColor,1,3.2,3.2,10);
         this.initUI();
         this.initHandler();
         this.initTitleIcon(titileIcon);
      }
      
      public function setIsDefaultEffect(i:Boolean) : void
      {
         this.isDefault = i;
      }
      
      override public function destroy() : void
      {
         containSprite.removeChild(this.buttonBG);
         this.buttonBG = null;
         this.titleMC.parent.removeChild(this.titleMC);
         this.titleMC = null;
         this.filter = null;
         this.removeHandler();
         super.destroy();
      }
      
      override public function setSizeWH(w:int, h:int) : void
      {
      }
      
      override public function setWidth(i:int) : void
      {
         if(i == width)
         {
            return;
         }
         width = i;
         this.buttonBG.width = this.width;
         this.height = this.buttonBG.height = this.buttonBG.width / PERCENT;
         updateView();
      }
      
      override public function setHeight(i:int) : void
      {
         if(i == height)
         {
            return;
         }
         height = i;
         this.buttonBG.height = this.height;
         this.width = this.buttonBG.width = PERCENT * this.buttonBG.height;
         updateView();
      }
      
      public function setIcon(icon:*) : void
      {
         this.initTitleIcon(icon);
      }
      
      public function setColorMode(str:String) : void
      {
         this.colorStr = str;
         containSprite.removeChild(this.buttonBG);
         switch(this.colorStr)
         {
            case RED:
               this.buttonBG = new this.redBGClass() as MovieClip;
               break;
            case BLUE:
               this.buttonBG = new this.blueBGClass() as MovieClip;
               break;
            case GREEN:
               this.buttonBG = new this.greenBGClass() as MovieClip;
               break;
            default:
               this.buttonBG = new this.redBGClass() as MovieClip;
         }
         this.buttonBG.cacheAsBitmap = true;
         this.buttonBG.gotoAndStop(1);
         this.buttonBG.width = this.width;
         this.buttonBG.height = this.height;
         if(Boolean(this.titleMC))
         {
            this.buttonBG.addChild(this.titleMC);
         }
         this.refreshIconColor();
         containSprite.addChild(this.buttonBG);
      }
      
      private function initUI() : void
      {
         switch(this.colorStr)
         {
            case RED:
               this.buttonBG = new this.redBGClass() as MovieClip;
               break;
            case BLUE:
               this.buttonBG = new this.blueBGClass() as MovieClip;
               break;
            case GREEN:
               this.buttonBG = new this.greenBGClass() as MovieClip;
               break;
            default:
               this.buttonBG = new this.redBGClass() as MovieClip;
         }
         this.buttonBG.cacheAsBitmap = true;
         this.buttonBG.gotoAndStop(1);
         containSprite.addChild(this.buttonBG);
         this.bgWidth = this.buttonBG.width;
         this.bgHeight = this.buttonBG.height;
      }
      
      private function refreshIconColor() : void
      {
         var c:Color = null;
         if(this.titleMC is DisplayObjectContainer && this.isDefault)
         {
            this.titleMC.filters = null;
            if(this.colorStr == RED)
            {
               this.currentColor = RED_COLOR;
            }
            else if(this.colorStr == BLUE)
            {
               this.currentColor = BLUE_COLOR;
            }
            else if(this.colorStr == GREEN)
            {
               this.currentColor = GREEN_COLOR;
            }
            c = new Color();
            c.tintColor = this.currentColor;
            c.tintMultiplier = 1;
            DisplayObjectContainer(this.titleMC).getChildAt(0).transform.colorTransform = c;
            this.filter = new GlowFilter(this.currentColor,1,3.2,3.2,10);
         }
      }
      
      private function initHandler() : void
      {
         containSprite.addEventListener(MouseEvent.CLICK,this.doClick);
         containSprite.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         containSprite.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         containSprite.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         containSprite.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function removeHandler() : void
      {
         containSprite.removeEventListener(MouseEvent.CLICK,this.doClick);
         containSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         containSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         containSprite.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         containSprite.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function initTitleIcon(icon:*) : void
      {
         var cls:Class = null;
         var sprite:Sprite = null;
         if(!icon)
         {
            icon = FLAG_iKnow;
         }
         if(icon is String)
         {
            try
            {
               cls = getDefinitionByName("com.taomee.component::MButton_" + icon + "Btn") as Class;
               if(Boolean(cls))
               {
                  this.isDefault = true;
                  if(Boolean(this.titleMC))
                  {
                     if(Boolean(this.titleMC.parent))
                     {
                        this.titleMC.parent.removeChild(this.titleMC);
                     }
                  }
                  this.titleMC = new cls() as DisplayObject;
                  this.titleMC.cacheAsBitmap = true;
                  this.iconOldW = this.titleMC.width;
                  this.iconOldH = this.titleMC.height;
                  this.addTitleIcon();
               }
            }
            catch(e:Error)
            {
               isDefault = false;
               loadIcon(icon);
            }
         }
         else if(icon is DisplayObject)
         {
            this.isDefault = false;
            sprite = new Sprite();
            icon.x = -icon.width / 2;
            icon.y = -icon.height / 2;
            sprite.addChild(icon);
            if(Boolean(this.titleMC))
            {
               if(Boolean(this.titleMC.parent))
               {
                  this.titleMC.parent.removeChild(this.titleMC);
               }
            }
            this.titleMC = sprite;
            this.titleMC.cacheAsBitmap = true;
            this.iconOldW = this.titleMC.width;
            this.iconOldH = this.titleMC.height;
            this.addTitleIcon();
         }
      }
      
      private function addTitleIcon() : void
      {
         var percent:Number = NaN;
         this.refreshIconColor();
         if(this.titleMC is InteractiveObject)
         {
            InteractiveObject(this.titleMC).mouseEnabled = false;
         }
         if(this.titleMC is DisplayObjectContainer)
         {
            DisplayObjectContainer(this.titleMC).mouseChildren = false;
         }
         var PH:Number = 1.3 / 3;
         var PW:Number = 2.1 / 3;
         this.titleMC.width *= this.bgHeight / this.iconOldH;
         this.titleMC.height = this.bgHeight * PH;
         percent = this.titleMC.height / this.bgHeight;
         this.titleMC.width *= percent;
         if(this.titleMC.width > this.bgWidth * PW)
         {
            this.titleMC.height = this.iconOldH * (this.bgWidth / this.iconOldW);
            this.titleMC.width = this.bgWidth * PW;
            percent = this.titleMC.width / this.bgWidth;
            this.titleMC.height *= percent;
         }
         this.titleMC.x = this.bgWidth / 2 + this.buttonBG.x;
         this.titleMC.y = this.bgHeight / 2 - this.bgHeight / 18 + this.buttonBG.y;
         this.buttonBG.addChild(this.titleMC);
         this.newScale = this.titleMC.scaleX;
      }
      
      private function loadIcon(icon:String) : void
      {
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadTitleIcon);
         loader.load(new URLRequest(icon));
      }
      
      private function onLoadTitleIcon(event:Event) : void
      {
         var icon:DisplayObject = event.target.content;
         this.initTitleIcon(icon);
      }
      
      private function doClick(event:MouseEvent) : void
      {
         event.stopPropagation();
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(this.isDefault)
         {
            this.titleMC.scaleX = this.titleMC.scaleY = this.newScale;
         }
         else
         {
            this.titleMC.scaleX = this.titleMC.scaleY = this.newScale * 1.05;
         }
         this.iconOverEffect();
         this.buttonBG.gotoAndStop(2);
         event.stopPropagation();
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         this.titleMC.scaleX = this.titleMC.scaleY = this.newScale;
         this.iconOutEffect();
         this.buttonBG.gotoAndStop(1);
         event.stopPropagation();
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this.titleMC.scaleX = this.titleMC.scaleY = this.newScale * 0.93;
         this.iconOverEffect();
         this.buttonBG.gotoAndStop(3);
         event.stopPropagation();
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         this.titleMC.scaleX = this.titleMC.scaleY = this.newScale;
         if(!this.isDefault)
         {
            this.titleMC.scaleX = this.titleMC.scaleY = this.newScale * 1.05;
         }
         this.iconOverEffect();
         this.buttonBG.gotoAndStop(2);
         event.stopPropagation();
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
      }
      
      private function iconOverEffect() : void
      {
         var color:Color = null;
         if(this.titleMC is DisplayObjectContainer && this.isDefault)
         {
            this.titleMC.filters = [this.filter];
            color = new Color();
            color.brightness = 1;
            DisplayObjectContainer(this.titleMC).getChildAt(0).transform.colorTransform = color;
         }
      }
      
      private function iconOutEffect() : void
      {
         var color:Color = null;
         if(this.titleMC is DisplayObjectContainer && this.isDefault)
         {
            this.titleMC.filters = null;
            color = new Color();
            color.tintColor = this.currentColor;
            color.tintMultiplier = 1;
            DisplayObjectContainer(this.titleMC).getChildAt(0).transform.colorTransform = color;
         }
      }
   }
}

