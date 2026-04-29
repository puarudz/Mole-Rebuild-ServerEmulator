package org.taomee.core
{
   public class DragSource
   {
      
      private var _dataHolder:Object = {};
      
      private var _formatHandlers:Object = {};
      
      private var _formats:Array = [];
      
      public function DragSource()
      {
         super();
      }
      
      public function get formats() : Array
      {
         return this._formats;
      }
      
      public function addData(data:*, format:String) : void
      {
         this._formats.push(format);
         this._dataHolder[format] = data;
      }
      
      public function addHandler(handler:Function, format:String) : void
      {
         this._formats.push(format);
         this._formatHandlers[format] = handler;
      }
      
      public function dataForFormat(format:String) : *
      {
         var data:Object = this._dataHolder[format];
         if(Boolean(data))
         {
            return data;
         }
         if(Boolean(this._formatHandlers[format]))
         {
            return this._formatHandlers[format]();
         }
         return null;
      }
      
      public function hasFormat(format:String) : Boolean
      {
         var b:Boolean = this._formats.some(function(item:String, index:int, array:Array):Boolean
         {
            if(item == format)
            {
               return true;
            }
            return false;
         });
         return b;
      }
   }
}

