package com.module.LocusWork
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LocusModule extends Sprite
   {
      
      private var _close_btn:SimpleButton;
      
      private var _music_btn:MovieClip;
      
      private var playFlag:Boolean;
      
      public var isLoader:Boolean;
      
      public function LocusModule()
      {
         super();
         this.init(true,false);
      }
      
      protected function init(... args) : void
      {
         var closeFlag:Boolean = false;
         var musicFlag:Boolean = Boolean(args[1]);
         closeFlag = Boolean(args[0]);
         if(args[0] == null)
         {
            closeFlag = true;
         }
         if(closeFlag)
         {
            this._close_btn = this.getChildByName("close_btn") as SimpleButton;
         }
         if(musicFlag)
         {
            this._music_btn = this.getChildByName("music_btn") as MovieClip;
         }
         if(this._close_btn == null)
         {
            trace("關閉按鈕未定義");
         }
         else
         {
            BC.addEvent(this,this._close_btn,MouseEvent.CLICK,this.closeHandler);
         }
         if(musicFlag)
         {
            if(!Boolean(this._music_btn))
            {
               trace("音樂按鈕未定義");
            }
         }
         BC.addEvent(this,this,Event.ADDED_TO_STAGE,this.added);
      }
      
      protected function added(e:Event) : void
      {
         BC.removeEvent(this,this,Event.ADDED_TO_STAGE,this.added);
         if(parent is Loader)
         {
            this.isLoader = true;
         }
         else
         {
            this.isLoader = false;
         }
      }
      
      public function closeHandler(e:* = null) : void
      {
         this.removeSlef();
         BC.removeEvent(this);
         GC.clearAllChildren(this);
      }
      
      protected function removeSlef() : void
      {
      }
      
      public function removeChildByName(str:String) : DisplayObject
      {
         return this.removeChild(this.getChildByName(str));
      }
      
      public function addChildToBottom(mc:DisplayObject, parent:DisplayObjectContainer = null) : void
      {
         var main:DisplayObjectContainer = null;
         var i:int = 0;
         if(parent == null)
         {
            parent = this;
         }
         if(mc is DisplayObjectContainer)
         {
            main = mc as DisplayObjectContainer;
            for(i = main.numChildren - 1; i >= 0; i--)
            {
               parent.addChild(main.getChildAt(0));
            }
         }
         else
         {
            parent.addChild(mc);
         }
         if(parent == this)
         {
            if(Boolean(getChildByName("close_btn")))
            {
               setChildIndex(getChildByName("close_btn"),numChildren - 1);
            }
            if(Boolean(getChildByName("music_btn")))
            {
               setChildIndex(getChildByName("music_btn"),numChildren - 1);
            }
         }
      }
      
      public function removeExe(exception:String = "", isAll:Boolean = false) : void
      {
         var arr:Array = null;
         var i:int = 0;
         var d:DisplayObject = null;
         var t:int = 0;
         if(exception != "")
         {
            arr = exception.split(",");
         }
         loop0:
         for(i = numChildren - 1; i >= 0; i--)
         {
            d = getChildAt(i);
            if(!isAll)
            {
               if(d.name == "close_btn" || d.name == "music_btn")
               {
                  continue;
               }
            }
            if(Boolean(arr))
            {
               t = 0;
               while(true)
               {
                  if(t < arr.length)
                  {
                     if(arr[t] == d.name)
                     {
                        continue loop0;
                     }
                     continue;
                  }
                  t++;
               }
               continue;
            }
            removeChild(d);
         }
      }
      
      public function removeDisplayEvent(c:DisplayObject) : void
      {
         var main:* = undefined;
         main = this;
         BC.addEvent(this,c,Event.REMOVED_FROM_STAGE,function():void
         {
            BC.removeEvent(main,c);
         });
      }
   }
}

