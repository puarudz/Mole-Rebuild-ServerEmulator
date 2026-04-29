package org.taomee.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class InvalidateDispatcher
   {
      
      private static var _mc:Shape = new Shape();
      
      private var _ed:IEventDispatcher;
      
      private var _list:Array = [];
      
      public function InvalidateDispatcher(ed:IEventDispatcher)
      {
         super();
         this._ed = ed;
      }
      
      public function destroy() : void
      {
         _mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._ed = null;
         this._list = null;
      }
      
      public function addEvent(e:Event) : void
      {
         this._list.push(e);
         _mc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var e:Event = null;
         _mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(Boolean(this._ed))
         {
            for each(e in this._list)
            {
               this._ed.dispatchEvent(e);
            }
         }
         this._list.length = 0;
      }
   }
}

