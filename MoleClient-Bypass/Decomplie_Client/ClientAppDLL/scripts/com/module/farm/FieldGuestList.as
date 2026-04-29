package com.module.farm
{
   import com.common.view.MCScrollBar.MCScrollBar;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.farm.farmSocket;
   import com.view.userPanelView.userPanelView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class FieldGuestList
   {
      
      private static var instance:FieldGuestList = null;
      
      public var ID:*;
      
      public var ListUI:*;
      
      public var HotUIClass:Class;
      
      public var ListUIClass:Class;
      
      public var HotNum:Number = 0;
      
      public var FlowerNum:Number;
      
      public var MudNum:Number;
      
      public var sendBool:Boolean;
      
      private var sendtype:uint;
      
      public var visitorPanel:MovieClip;
      
      private var Man:Class;
      
      private var len:uint;
      
      private var arrMC:Array = new Array();
      
      private var ScrollBar:*;
      
      private var myTimeout:*;
      
      private var MC:MovieClip;
      
      public var Obj:Object;
      
      public var VisitorArr:Array;
      
      private var mcloader:MCLoader;
      
      public function FieldGuestList()
      {
         super();
      }
      
      public static function getInstance() : FieldGuestList
      {
         return instance = instance || new FieldGuestList();
      }
      
      public function showPanel() : void
      {
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         if(!this.ListUI)
         {
            this.mcloader = new MCLoader("module/farm/GuestList.swf",MainManager.getGameLevel(),1,"正在打開牧場動態...");
            this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
            this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
            this.mcloader.doLoad();
         }
         else
         {
            this.ListUI.x = 615;
            this.ListUI.y = 80;
         }
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         this.arrMC = new Array();
         this.ScrollBar = null;
         this.VisitorArr = new Array();
         this.sendBool = false;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         this.ListUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("list_UI") as Class;
         this.Man = b.contentLoaderInfo.applicationDomain.getDefinition("man") as Class;
         this.ListUI = new this.ListUIClass();
         this.ListUI.y = 1000;
         MainManager.getAppLevel().addChild(this.ListUI);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.showGuest();
      }
      
      public function showGuest(e:MouseEvent = null) : void
      {
         if(!this.visitorPanel)
         {
            GV.onlineSocket.addEventListener("read_" + 1368,this.showVisitor);
            farmSocket.farmGuest(FieldView.hostID);
         }
         else
         {
            this.visitorPanel.x = 615;
         }
      }
      
      public function showVisitor(e:EventTaomee) : void
      {
         var i:uint = 0;
         GV.onlineSocket.removeEventListener("read_" + 1368,this.showVisitor);
         this.visitorPanel = this.ListUI;
         MainManager.getAppLevel().addChild(this.visitorPanel);
         this.visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.visitorPanel.close_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.visitorPanel.bg_mc.height = 265;
         this.MC = this.visitorPanel.visitorUI;
         this.VisitorArr = e.EventObj.arr;
         this.len = this.VisitorArr.length;
         if(this.len > 7)
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar();
         }
         else
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar();
         }
         this.visitorPanel.x = 615;
         this.visitorPanel.y = 80;
      }
      
      public function closeMC(e:MouseEvent) : void
      {
         this.visitorPanel.x = -1000;
      }
      
      public function initMan(manInfo:Object, bool:*) : void
      {
         var temp:* = new this.Man();
         temp.visible = false;
         temp.prev_pet.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         if(GF.BT(manInfo.Flag,1))
         {
            temp.water_muck.gotoAndStop(2);
         }
         else if(GF.BT(manInfo.Flag,2))
         {
            temp.water_muck.gotoAndStop(3);
         }
         else if(GF.BT(manInfo.Flag,3))
         {
            temp.water_muck.gotoAndStop(4);
         }
         else if(GF.BT(manInfo.Flag,4))
         {
            temp.water_muck.gotoAndStop(5);
         }
         var date:Date = new Date(manInfo.Time * 1000);
         temp.time.text = String(date.getFullYear()).substr(2,2) + "/" + int(date.getMonth() + 1) + "/" + date.getDate();
         date = null;
         temp.head_btn.addEventListener(MouseEvent.CLICK,this.showFriendPanel);
         temp.Color = Number(manInfo.Color);
         var colorObj:Array = GF.getPrimitiveColors(temp.Color.toString(16));
         temp.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         this.arrMC.push(temp);
         this.MC.manMC.addChild(temp);
      }
      
      private function showFriendPanel(evt:MouseEvent) : void
      {
         userPanelView.showUserPanel(evt.target.parent.id);
      }
      
      public function initScrollBar() : void
      {
         var i:int = 0;
         if(this.len > 7)
         {
            this.arrange(this.arrMC);
            this.MC.scroll_mc.visible = true;
            if(!this.ScrollBar)
            {
               this.ScrollBar = new MCScrollBar(this.MC.scroll_mc,this.MC.manMC,178,253);
            }
            else
            {
               this.ScrollBar.reSet();
            }
            this.MC.scroll_mc.drag_mc.visible = true;
            this.MC.scroll_mc.line_mc.visible = true;
         }
         else
         {
            for(i = int(this.len); i < 7; i++)
            {
               this.addBG();
            }
            this.MC.scroll_mc.drag_mc.visible = false;
            this.MC.scroll_mc.line_mc.visible = false;
            this.arrange(this.arrMC);
         }
      }
      
      public function addBG() : void
      {
         var temp:* = new this.Man();
         temp.time.visible = false;
         temp.userName.text = "";
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         temp.water_muck.visible = false;
         this.arrMC.push(temp);
         this.MC.manMC.addChild(temp);
      }
      
      public function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      public function drag_start(evt:MouseEvent) : void
      {
         this.visitorPanel.startDrag();
      }
      
      public function drag_stop(evt:MouseEvent) : void
      {
         this.visitorPanel.stopDrag();
      }
      
      public function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      public function goto2(e:Event) : void
      {
         e.target.parent.gotoAndStop(2);
      }
      
      public function goto1(e:Event) : void
      {
         e.target.parent.gotoAndStop(1);
      }
      
      public function removeEvent(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         this.visitorPanel = null;
         this.ListUI = null;
      }
   }
}

