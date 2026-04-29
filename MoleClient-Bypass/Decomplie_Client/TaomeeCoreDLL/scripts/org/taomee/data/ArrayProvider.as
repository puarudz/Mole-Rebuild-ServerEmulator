package org.taomee.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   [Event(name="dataChange",type="fl.events.DataChangeEvent")]
   [Event(name="preDataChange",type="fl.events.DataChangeEvent")]
   public class ArrayProvider extends EventDispatcher
   {
      
      private var _data:Array = [];
      
      public var autoUpdate:Boolean = true;
      
      public function ArrayProvider(data:Array = null)
      {
         super();
         if(Boolean(data))
         {
            this._data = data.concat();
         }
      }
      
      public function get length() : uint
      {
         return this._data.length;
      }
      
      public function refresh() : void
      {
         this.dispatchChangeEvent(DataChangeType.RESET,this._data.concat(),0,this._data.length - 1);
      }
      
      public function dispatchSelect(ed:IEventDispatcher, item:*) : void
      {
         var index:int = int(this._data.push(item));
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,[item],index,index));
      }
      
      public function dispatchSelectMulti(ed:IEventDispatcher, items:Array) : void
      {
         var len:int = this._data.length - 1;
         this._data.splice(len,0,items);
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,items,len,this._data.length - 1));
      }
      
      public function add(item:*) : void
      {
         var index:int = int(this._data.push(item));
         this.dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
      }
      
      public function addAt(item:*, index:uint) : void
      {
         this.checkIndex(index);
         this._data.splice(index,0,item);
         this.dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
      }
      
      public function addMulti(items:Array) : void
      {
         this.addMultiAt(items,this._data.length - 1);
      }
      
      public function addMultiAt(items:Array, index:uint) : void
      {
         this.checkIndex(index);
         this._data.splice(index,0,items);
         this.dispatchChangeEvent(DataChangeType.ADD,items.concat(),index,index + items.length - 1);
      }
      
      public function getItemAt(index:uint) : *
      {
         this.checkIndex(index);
         return this._data[index];
      }
      
      public function getItemIndex(item:*) : int
      {
         return this._data.indexOf(item);
      }
      
      public function contains(item:*) : Boolean
      {
         if(this._data.indexOf(item) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function remove(item:*) : *
      {
         var index:int = this._data.indexOf(item);
         if(index != -1)
         {
            return this.removeAt(index)[0];
         }
         return null;
      }
      
      public function removeAt(index:uint, count:uint = 1) : Array
      {
         this.checkIndex(index);
         var arr:Array = this._data.splice(index,count);
         this.dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),index,index + arr.length - 1);
         return arr;
      }
      
      public function removeAll() : void
      {
         var arr:Array = this._data.concat();
         this._data.length = 0;
         this.dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length - 1);
      }
      
      public function removeMulti(items:Array) : Array
      {
         var arr:Array = null;
         arr = [];
         this._data = this._data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(items.indexOf(item) == -1)
            {
               return true;
            }
            arr.push(item);
            return false;
         },this);
         if(arr.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function removeMultiIndex(indexs:Array) : Array
      {
         var arr:Array = null;
         arr = [];
         this._data = this._data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(indexs.indexOf(index) == -1)
            {
               return true;
            }
            arr.push(item);
            return false;
         },this);
         if(arr.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function removeForProperty(p:String, value:*) : *
      {
         var _item:* = undefined;
         var _index:int = 0;
         var b:Boolean = this._data.some(function(item:*, index:int, array:Array):Boolean
         {
            if(item[p] == value)
            {
               _item = item;
               _index = index;
               return true;
            }
            return false;
         },this);
         if(b)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,[_item],_index,_index);
         }
         return _item;
      }
      
      public function removeMultiForProperty(p:String, value:*) : Array
      {
         var arr:Array = null;
         arr = [];
         this._data = this._data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(item[p] == value)
            {
               arr.push(item);
               return false;
            }
            return true;
         },this);
         if(arr.length == 0)
         {
            return arr;
         }
         this.dispatchChangeEvent(DataChangeType.REMOVE,arr,0,arr.length - 1);
         return arr;
      }
      
      public function upDateItem(oldItem:*, newItem:*) : *
      {
         var index:int = this._data.indexOf(oldItem);
         if(index != -1)
         {
            return this.upDateItemAt(index,newItem);
         }
         return null;
      }
      
      public function upDateItemAt(index:uint, newItem:*) : *
      {
         this.checkIndex(index);
         var oldItem:* = this._data[index];
         this.dispatchPreChangeEvent(DataChangeType.UPDATE,[oldItem],index,index);
         this._data[index] = newItem;
         this.dispatchChangeEvent(DataChangeType.UPDATE,[newItem],index,index);
         return oldItem;
      }
      
      public function setItemIndex(item:*, newIndex:int) : void
      {
         this.checkIndex(newIndex);
         var index:int = this._data.indexOf(item);
         if(index == -1)
         {
            return;
         }
         this.setItemIndexAt(index,newIndex);
      }
      
      public function setItemIndexAt(index:int, newIndex:int) : void
      {
         this.checkIndex(index);
         this.checkIndex(newIndex);
         var arr:Array = this._data.splice(index,1);
         this._data.splice(newIndex,0,arr);
         this.dispatchChangeEvent(DataChangeType.MOVE,arr,index,newIndex);
      }
      
      public function swapItemAt(item1:*, item2:*) : void
      {
         var index1:int = this._data.indexOf(item1);
         if(index1 == -1)
         {
            return;
         }
         var index2:int = this._data.indexOf(item2);
         if(index2 == -1)
         {
            return;
         }
         this.swapIndexAt(index1,index2);
      }
      
      public function swapIndexAt(index1:int, index2:int) : void
      {
         var arr1:Array = null;
         var arr2:Array = null;
         if(index1 == index2)
         {
            return;
         }
         this.checkIndex(index1);
         this.checkIndex(index2);
         if(index1 < index2)
         {
            arr2 = this._data.splice(index2,1);
            arr1 = this._data.splice(index1,1,arr2);
            this._data.splice(index2,1,arr1);
            this.dispatchChangeEvent(DataChangeType.SWAP,arr2.concat(arr1),index1,index2);
         }
         else
         {
            arr1 = this._data.splice(index1,1);
            arr2 = this._data.splice(index2,1);
            this._data.splice(index1,1,arr2);
            this.dispatchChangeEvent(DataChangeType.SWAP,arr1.concat(arr2),index2,index1);
         }
      }
      
      public function sort(... args) : Array
      {
         this.dispatchPreChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         var arr:Array = this._data.sort(args);
         this.dispatchChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         return arr;
      }
      
      public function sortOn(fieldName:Object, options:Object = null) : Array
      {
         this.dispatchPreChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         var arr:Array = this._data.sortOn(fieldName,options);
         this.dispatchChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         return arr;
      }
      
      public function pop() : *
      {
         var item:* = this._data.pop();
         var len:int = int(this._data.length);
         this.dispatchChangeEvent(DataChangeType.REMOVE,[item],len,len);
         return item;
      }
      
      public function shift() : *
      {
         var item:* = this._data.shift();
         this.dispatchChangeEvent(DataChangeType.REMOVE,[item],0,0);
         return item;
      }
      
      public function toArray() : Array
      {
         return this._data.concat();
      }
      
      override public function toString() : String
      {
         return "ArrayProvider [" + this._data.join(" , ") + "]";
      }
      
      protected function checkIndex(index:int) : void
      {
         if(index > this._data.length - 1 || index < 0)
         {
            throw new RangeError("ArrayProvider index (" + index.toString() + ") is not in acceptable range (0 - " + (this._data.length - 1).toString() + ")");
         }
      }
      
      public function forEach(callback:Function, thisObject:* = null) : void
      {
         this._data.forEach(callback,thisObject);
      }
      
      public function filter(callback:Function, thisObject:* = null) : Array
      {
         return this._data.filter(callback,thisObject);
      }
      
      public function some(callback:Function, thisObject:* = null) : Boolean
      {
         return this._data.some(callback,thisObject);
      }
      
      public function every(callback:Function, thisObject:* = null) : Boolean
      {
         return this._data.every(callback,thisObject);
      }
      
      public function map(callback:Function, thisObject:* = null) : Array
      {
         return this._data.map(callback,thisObject);
      }
      
      protected function dispatchChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
         }
      }
      
      protected function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE,evtType,items,startIndex,endIndex));
         }
      }
   }
}

