package com.taomee.component
{
   import com.taomee.component.event.LoadPaneEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   [Event(name="onLoadContent",type="com.taomee.component.event.LoadPaneEvent")]
   public class MLoadPane extends Component
   {
      
      public static const ADJUST_WIDTH:int = 0;
      
      public static const ADJUST_HEIGHT:int = 1;
      
      public static const ADJUST_WIDTH_AND_HEIGHT:int = 2;
      
      public static const ADJUST_NONE:int = -1;
      
      public static const H_CENTER:int = 0;
      
      public static const H_LEFT:int = 1;
      
      public static const H_RIGHT:int = 2;
      
      public static const V_CENTER:int = 0;
      
      public static const V_TOP:int = 1;
      
      public static const V_BOTTOM:int = 2;
      
      private var adjustType:int;
      
      private var H_AlineType:int;
      
      private var V_AlineType:int;
      
      private var image:DisplayObject;
      
      private var icon:*;
      
      public function MLoadPane(icon:*, adjustType:int = 2, H_AlineType:int = 0, V_AlineType:int = 0)
      {
         super();
         this.adjustType = adjustType;
         this.H_AlineType = H_AlineType;
         this.V_AlineType = V_AlineType;
         this.icon = icon;
         this.setChildMouseEnabled(false);
         this.getImageInstance(icon);
      }
      
      public function setContentScale(scalex:Number = 1, scaley:Number = 1) : void
      {
         this.image.scaleX = scalex;
         this.image.scaleY = scaley;
         this.h_AlineImage(this.H_AlineType);
         this.v_AlineImage(this.V_AlineType);
      }
      
      public function reLoad() : void
      {
         if(this.icon is String)
         {
            if(Boolean(this.image))
            {
               this.image.parent.removeChild(this.image);
            }
            this.getImageInstance(this.icon + "?" + Math.random());
         }
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.image))
         {
            containSprite.removeChild(this.image);
         }
         this.image = null;
         super.destroy();
      }
      
      public function setChildMouseEnabled(bl:Boolean) : void
      {
         containSprite.mouseEnabled = bl;
         containSprite.mouseChildren = bl;
      }
      
      override public function updateView() : void
      {
         super.updateView();
         if(!this.image)
         {
            return;
         }
         this.adjustImageSize(this.adjustType);
      }
      
      public function setAdjustType(at:int) : void
      {
         this.adjustType = at;
      }
      
      public function getAdjustType() : int
      {
         return this.adjustType;
      }
      
      public function setHAlineType(halt:int) : void
      {
         this.H_AlineType = halt;
      }
      
      public function getHAlineType() : int
      {
         return this.H_AlineType;
      }
      
      public function setVAlineType(valt:int) : void
      {
         this.V_AlineType = valt;
      }
      
      public function getVAlineType() : int
      {
         return this.V_AlineType;
      }
      
      public function setImage(image:*) : void
      {
         this.getImageInstance(image);
      }
      
      public function getImage() : DisplayObject
      {
         return this.image;
      }
      
      private function getImageInstance(im:*) : void
      {
         if(Boolean(this.image))
         {
            if(Boolean(this.image.parent))
            {
               this.image.parent.removeChild(this.image);
            }
         }
         if(im is String)
         {
            this.loadImage(im);
         }
         else if(im is DisplayObject)
         {
            this.image = im;
            containSprite.addChild(this.image);
            this.image.cacheAsBitmap = true;
            this.updateView();
            dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,this.image));
         }
      }
      
      private function adjustImageSize(adjustType:int) : void
      {
         switch(adjustType)
         {
            case MLoadPane.ADJUST_HEIGHT:
               this.image.width *= this.height / this.image.height;
               this.image.height = this.height;
               break;
            case MLoadPane.ADJUST_WIDTH:
               this.image.height *= this.width / this.image.width;
               this.image.width = this.width;
               break;
            case MLoadPane.ADJUST_WIDTH_AND_HEIGHT:
               this.image.height = this.height;
               this.image.width = this.width;
               break;
            case MLoadPane.ADJUST_NONE:
         }
         this.h_AlineImage(this.H_AlineType);
         this.v_AlineImage(this.V_AlineType);
      }
      
      private function h_AlineImage(H_AlineType:int) : void
      {
         switch(H_AlineType)
         {
            case MLoadPane.H_LEFT:
               this.image.x = 0;
               break;
            case MLoadPane.H_RIGHT:
               this.image.x = this.width - this.image.width;
               break;
            case MLoadPane.H_CENTER:
            default:
               this.image.x = (this.width - this.image.width) / 2;
         }
      }
      
      private function v_AlineImage(V_AlineType:int) : void
      {
         switch(V_AlineType)
         {
            case MLoadPane.V_TOP:
               this.image.y = 0;
               break;
            case MLoadPane.V_BOTTOM:
               this.image.y = this.height - this.image.height;
               break;
            case MLoadPane.V_CENTER:
            default:
               this.image.y = (this.height - this.image.height) / 2;
         }
      }
      
      private function loadImage(im:String) : void
      {
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadTitleIcon);
         loader.load(new URLRequest(im));
      }
      
      private function onLoadTitleIcon(event:Event) : void
      {
         this.image = LoaderInfo(event.target).content;
         this.image.cacheAsBitmap = true;
         containSprite.addChild(this.image);
         this.updateView();
         dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,this.image));
      }
   }
}

