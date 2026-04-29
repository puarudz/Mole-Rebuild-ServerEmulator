package com.common.comboBox
{
   import assets.comboBoxMC;
   import assets.comboBox_cb_list;
   import assets.comboBox_item_mc;
   import com.common.scrollBar.ScrollBar;
   import com.common.util.DisplayUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class ComboBox extends EventDispatcher
   {
      
      public static var EVENT_ON_CHANGE:String = "onChange";
      
      public static var EVENT_ON_OPEN_BEGIN:String = "onOpenBegin";
      
      public static var EVENT_ON_OPEN:String = "onOpen";
      
      public static var EVENT_ON_CLOSE:String = "onClose";
      
      public var targetMC:*;
      
      public var temp_txt:String;
      
      private var selected_txt:TextField;
      
      private var down_btn:MovieClip;
      
      private var selected_mc:MovieClip;
      
      private var combobox__list:*;
      
      private var myScrollBar:ScrollBar;
      
      private var showBool:Boolean;
      
      private var cb:Object;
      
      public var selectedItem:Object;
      
      public var index:Number;
      
      public var width:Number;
      
      public var spaceSize:Number;
      
      public var labels:Array;
      
      public var data:Array;
      
      public var rowCount:Number = 5;
      
      public var type:uint = 0;
      
      public function ComboBox(comboboxInstance:MovieClip, _width:Number = 100, _height:Number = 30, _rowCount:Number = 10, _labels:Array = null, _datum:Array = null, _type:uint = 0)
      {
         super();
         this.type = _type;
         if(!comboboxInstance)
         {
            this.targetMC = new comboBoxMC();
         }
         else
         {
            this.targetMC = comboboxInstance;
         }
         this.selectedItem = new Object();
         this.labels = new Array();
         this.data = new Array();
         this.cb = new Object();
         this.index = 0;
         this.selected_txt = this.targetMC.selected_txt;
         this.selected_txt.mouseEnabled = false;
         this.down_btn = this.targetMC.down_btn;
         this.selected_mc = this.targetMC.selected_mc;
         this.width = _width;
         this.spaceSize = _height;
         this.rowCount = _rowCount;
         if(_labels != null)
         {
            this.labels = _labels;
         }
         if(_datum != null)
         {
            this.data = _datum;
         }
         this.init();
      }
      
      private function init() : void
      {
         this.cb.locality = this.cb.locality != null ? new Number() : null;
         if(this.type == 0)
         {
            this.selected_txt.wordWrap = true;
         }
         else if(this.type == 1)
         {
            this.selected_txt.wordWrap = false;
         }
         this.selected_txt.autoSize = TextFieldAutoSize.LEFT;
         this.selected_txt.x = 2;
         this.selected_txt.y = (this.spaceSize - 12) / 2;
         this.selected_mc.width = this.width;
         this.selected_mc.height = this.spaceSize;
         this.down_btn.x = this.width - this.spaceSize;
         this.down_btn.y = 0;
         this.down_btn.width = this.spaceSize;
         this.down_btn.height = this.spaceSize;
         if(this.labels.length > 0)
         {
            this.selected_txt.text = this.labels[this.index];
            this.selectedItem.label = this.labels[this.index];
            this.selectedItem.data = this.data[this.index];
         }
         this.showBool = false;
         BC.addEvent(this,this.down_btn,MouseEvent.MOUSE_DOWN,this.open);
         BC.addEvent(this,this.selected_mc,MouseEvent.MOUSE_DOWN,this.open);
         BC.addEvent(this,this.targetMC,Event.REMOVED_FROM_STAGE,this.clearClass);
      }
      
      private function checklocality() : Boolean
      {
         var returnBool:Boolean = false;
         var list_height:Number = this.spaceSize * this.rowCount;
         if(this.labels.length * this.spaceSize < list_height)
         {
            list_height = this.labels.length * this.spaceSize;
         }
         if(this.type == 1)
         {
            if(Boolean(this.combobox__list))
            {
               this.targetMC.stage.removeChild(this.combobox__list);
               this.combobox__list = null;
            }
         }
         if(Boolean(this.combobox__list) && Boolean(this.combobox__list.parent))
         {
            this.combobox__list.visible = true;
         }
         else if(!this.combobox__list)
         {
            this.combobox__list = new comboBox_cb_list();
            this.targetMC.stage.addChild(this.combobox__list);
            returnBool = true;
         }
         var po:Point = this.targetMC.localToGlobal(new Point());
         if(po.y + list_height < GV.stageHeight)
         {
            this.cb.locality = 1;
         }
         else
         {
            this.cb.locality = 0;
            if(po.y - list_height < 0)
            {
               if(po.y > GV.stageHeight / 2)
               {
                  this.cb.locality = 0;
               }
               else
               {
                  this.cb.locality = 1;
               }
            }
         }
         if(Boolean(this.cb.locality))
         {
            this.combobox__list.x = po.x;
            this.combobox__list.y = po.y + this.spaceSize;
         }
         else
         {
            this.combobox__list.x = po.x;
            this.combobox__list.y = po.y - list_height;
         }
         this.selected_mc.width = this.width;
         this.selected_mc.height = this.spaceSize;
         this.down_btn.x = this.width - this.spaceSize;
         this.down_btn.width = this.spaceSize;
         this.down_btn.height = this.spaceSize;
         this.combobox__list.mask_mc.width = this.combobox__list.border_mc.width = this.combobox__list.borderLine_mc.width = this.width;
         this.combobox__list.mask_mc.height = this.combobox__list.border_mc.height = this.combobox__list.borderLine_mc.height = this.labels.length * this.spaceSize > list_height ? list_height : this.labels.length * this.spaceSize;
         if(returnBool)
         {
            return true;
         }
         return false;
      }
      
      private function checkClose(E:MouseEvent) : void
      {
         if(!this.targetMC.hitTestPoint(E.stageX,E.stageY,false) && !this.combobox__list.hitTestPoint(E.stageX,E.stageY,false))
         {
            this.close();
            BC.removeEvent(this,this.targetMC.stage,MouseEvent.MOUSE_DOWN,this.checkClose);
         }
      }
      
      private function open(E:MouseEvent) : void
      {
         if(this.type == 1)
         {
            dispatchEvent(new Event(EVENT_ON_OPEN_BEGIN));
            return;
         }
         this.showOpenUI(E);
      }
      
      public function showOpenUI(E:MouseEvent = null) : void
      {
         var _h:Number = NaN;
         var _le:uint = 0;
         var i:uint = 0;
         var temp:MovieClip = null;
         var txt:TextField = null;
         var arr:Array = null;
         var j:* = undefined;
         BC.addEvent(this,this.targetMC.stage,MouseEvent.MOUSE_DOWN,this.checkClose);
         if(!this.showBool)
         {
            if(!this.checklocality())
            {
               this.showBool = true;
               this.down_btn.gotoAndStop(2);
               dispatchEvent(new Event(EVENT_ON_OPEN));
               return;
            }
            if(this.labels != null)
            {
               DisplayUtil.removeAllChild(this.combobox__list["item_list"]);
               _h = this.spaceSize;
               _le = this.labels.length;
               for(i = 0; i < _le; i++)
               {
                  temp = new comboBox_item_mc();
                  this.combobox__list["item_list"].addChild(temp);
                  txt = temp.label_txt;
                  txt.autoSize = TextFieldAutoSize.LEFT;
                  txt.width = this.width;
                  temp.num = i;
                  temp.y = i * _h;
                  temp.bg_mc.width = this.width;
                  temp.bg_mc.height = _h;
                  temp.mouseChildren = false;
                  if(typeof this.labels[i] == "object")
                  {
                     if(this.labels[i]["label"] != null)
                     {
                        temp.label_txt.text = this.labels[i]["label"];
                     }
                     else
                     {
                        arr = new Array();
                        for(j in this.labels[i])
                        {
                           arr.push(this.labels[i][j]);
                        }
                        temp.label_txt.text = Boolean(arr) ? arr : "";
                     }
                  }
                  else
                  {
                     temp.label_txt.text = Boolean(this.labels[i]) ? this.labels[i] : "";
                  }
                  temp.label_txt.x = 2;
                  temp.label_txt.y = (temp.height - temp.label_txt.height) / 2;
                  BC.addEvent(this,temp,MouseEvent.MOUSE_OVER,this.onItemRollOver);
                  BC.addEvent(this,temp,MouseEvent.MOUSE_OUT,this.onItemRollOut);
                  BC.addEvent(this,temp,MouseEvent.CLICK,this.onItemClick);
               }
               if(this.labels.length > this.rowCount)
               {
                  this.combobox__list.mask = this.combobox__list.mask_mc;
                  this.myScrollBar = new ScrollBar(null,this.combobox__list.item_list,{
                     "size":this.spaceSize,
                     "length":this.spaceSize * this.rowCount,
                     "x":this.width - this.spaceSize,
                     "y":0
                  },ScrollBar.ENABLE_VISIBLE,ScrollBar.DIRECTION_VERTICAL,this.spaceSize);
                  this.myScrollBar.sendToTop();
               }
            }
            this.selected_txt.text = this.labels[this.index];
            this.temp_txt = this.selected_txt.text;
            this.selectedItem.label = this.labels[this.index];
            this.selectedItem.data = this.data[this.index];
            this.showBool = true;
            dispatchEvent(new Event(EVENT_ON_OPEN));
         }
         else
         {
            this.close();
         }
      }
      
      private function onItemRollOver(E:MouseEvent) : void
      {
         var temp:MovieClip = E.currentTarget as MovieClip;
         temp.bg_mc.gotoAndStop(2);
      }
      
      private function onItemRollOut(E:MouseEvent) : void
      {
         var temp:MovieClip = E.currentTarget as MovieClip;
         temp.bg_mc.gotoAndStop(1);
      }
      
      private function onItemClick(E:MouseEvent) : void
      {
         var temp:MovieClip = E.currentTarget as MovieClip;
         if(temp.label_txt.text != "")
         {
            this.index = temp.num;
            this.selected_txt.text = temp.label_txt.text;
            if(this.selectedItem.data == null)
            {
               this.selectedItem = temp.label_txt.text;
            }
            else
            {
               this.selectedItem.label = temp.label_txt.text;
               this.selectedItem.data = this.data[temp.num];
            }
            this.selected_txt.y = (this.spaceSize - this.selected_txt.height) / 2;
            this.selectedItem.label = this.labels[this.index];
            this.selectedItem.data = this.data[this.index];
            dispatchEvent(new Event(EVENT_ON_CHANGE));
            this.close();
         }
      }
      
      private function close() : void
      {
         this.down_btn.gotoAndStop(1);
         this.showBool = false;
         if(Boolean(this.combobox__list))
         {
            this.combobox__list.visible = false;
         }
         dispatchEvent(new Event(EVENT_ON_CLOSE));
      }
      
      public function dataProvider(obj:Array) : void
      {
         var temp1:Array = new Array();
         var temp2:Array = new Array();
         var _le:uint = obj.length;
         for(var i:uint = 0; i < _le; i++)
         {
            temp1[i] = obj[i].label;
            temp2[i] = obj[i].data;
         }
         this.labels = temp1;
         this.data = temp2;
         this.selected_txt.text = this.labels[this.index];
         this.selectedItem.label = this.labels[this.index];
         this.selectedItem.data = this.data[this.index];
      }
      
      public function setIndex(_index:uint = 0) : void
      {
         this.index = _index;
         this.selected_txt.text = this.labels[this.index];
         this.selectedItem.label = this.labels[this.index];
         this.selectedItem.data = this.data[this.index];
      }
      
      public function clearClass(E:* = null) : void
      {
         BC.removeEvent(this);
         this.targetMC = null;
         this.selected_txt = null;
         this.down_btn = null;
         this.selected_mc = null;
         this.combobox__list = null;
         if(Boolean(this.myScrollBar))
         {
            this.myScrollBar.clearClass();
         }
         this.myScrollBar = null;
         this.selectedItem = null;
         this.labels = null;
         this.data = null;
         this.cb = null;
      }
   }
}

