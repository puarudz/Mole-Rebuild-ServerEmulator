package com.module.treasureHouse.view
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.treasureHouse.TreasureHouseEvent;
   import com.module.treasureHouse.TreasureHouseViewCtl;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   
   public class TreasureHouseToolView
   {
      
      private var _ui:MovieClip;
      
      private var _toolMC:MovieClip;
      
      private var _visitorListBtn:SimpleButton;
      
      private var _wareHouseBtn:SimpleButton;
      
      private var _backBtn:SimpleButton;
      
      private var _treasureBookBtn:SimpleButton;
      
      private var _wareHouseBar:TreasureHouseWarehouseView;
      
      private var _treasureBoxBtn:SimpleButton;
      
      private var _newTreasureMC:MovieClip;
      
      private var _newTreasureMCDate:String = "newTreasure_2011_6_23";
      
      public function TreasureHouseToolView(ui:MovieClip)
      {
         super();
         this._ui = ui;
         this._wareHouseBar = new TreasureHouseWarehouseView(this._ui.wareHouseBar_mc);
         BC.addEvent(this,this._wareHouseBar,TreasureHouseEvent.HIDE_WAREHOUSE_BAR,this.HideWareHouseBar);
         this.InitBtn();
      }
      
      private static function OpenMyTreasurePanel(e:MouseEvent) : void
      {
         OpenPanel("module/external/digTreasure/DigExchange.swf","正在打開我的寶藏...");
      }
      
      private static function OpenBookPanel(e:MouseEvent) : void
      {
         OpenPanel("module/external/digTreasure/TreasureCollections.swf","正在打開珍寶圖鑑...");
      }
      
      private static function OpenVisitorPanel(e:MouseEvent) : void
      {
         OpenPanel("module/external/digTreasure/TreasureHouseRankAndVisitorPanel.swf","打開藏寶閣訪客....");
      }
      
      private static function OpenPanel(url:String, msg:String) : void
      {
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
         loadGame = null;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function InitBtn() : void
      {
         var so:SharedObject = null;
         if(TreasureHouseViewCtl.isInMyHouse)
         {
            this._toolMC = this._ui.myHouseTool_mc;
            this._visitorListBtn = this._toolMC.visitor_btn;
            this._treasureBookBtn = this._toolMC.treasureBook_btn;
            this._wareHouseBtn = this._toolMC.wareHouse_btn;
            this._treasureBoxBtn = this._toolMC.treasureBox_btn;
            this._newTreasureMC = this._toolMC.new_mc;
         }
         else
         {
            this._toolMC = this._ui.otherHouseTool_mc;
            this._visitorListBtn = this._toolMC.visitor_btn;
            this._treasureBookBtn = this._toolMC.treasureBook_btn;
            this._backBtn = this._toolMC.back_btn;
         }
         this._toolMC.visible = true;
         if(Boolean(this._visitorListBtn))
         {
            if(TreasureHouseViewCtl.isInMyHouse)
            {
               tip.tipTailDisPlayObject(this._visitorListBtn,"好友列表");
            }
            else
            {
               tip.tipTailDisPlayObject(this._visitorListBtn,"藏寶閣訪客");
            }
            BC.addEvent(this,this._visitorListBtn,MouseEvent.CLICK,OpenVisitorPanel);
         }
         if(Boolean(this._wareHouseBtn))
         {
            tip.tipTailDisPlayObject(this._wareHouseBtn,"珍寶倉庫");
            BC.addEvent(this,this._wareHouseBtn,MouseEvent.CLICK,this.ShowWareHouseBar);
         }
         if(Boolean(this._treasureBookBtn))
         {
            tip.tipTailDisPlayObject(this._treasureBookBtn,"珍寶圖鑑");
            BC.addEvent(this,this._treasureBookBtn,MouseEvent.CLICK,OpenBookPanel);
         }
         if(Boolean(this._backBtn))
         {
            tip.tipTailDisPlayObject(this._backBtn,"返回自己的藏寶閣");
            BC.addEvent(this,this._backBtn,MouseEvent.CLICK,this.BackToMyTreasureHouse);
         }
         if(Boolean(this._treasureBoxBtn))
         {
            var _temp_4:* = BC;
            var _temp_3:* = this;
            var _temp_2:* = this._treasureBoxBtn;
            var _temp_1:* = MouseEvent.CLICK;
            with({})
            {
               
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function h(e:*):void
               {
                  OpenMyTreasurePanel(e);
                  _newTreasureMC.visible = false;
                  creatShareObject.getInstance().getShareObject().data[_newTreasureMCDate] = true;
                  creatShareObject.getInstance().getShareObject().flush();
               });
               so = creatShareObject.getInstance().getShareObject();
               if(so.data.hasOwnProperty(this._newTreasureMCDate) && so.data[this._newTreasureMCDate] == true)
               {
                  this._newTreasureMC.visible = false;
               }
               else
               {
                  this._newTreasureMC.visible = true;
               }
            }
         }
         
         public function ShowWareHouseBar(e:MouseEvent = null) : void
         {
            TreasureHouseViewCtl.instance.edit = true;
            this._toolMC.visible = false;
            this._wareHouseBar.visible = true;
            GV.MC_ToolView.y = 10000;
            this.HidePeople();
            MoveTo.CanMove = false;
         }
         
         private function HideWareHouseBar(e:Event = null) : void
         {
            TreasureHouseViewCtl.instance.edit = false;
            this._toolMC.visible = true;
            this._wareHouseBar.visible = false;
            GV.MC_ToolView.y = 340;
            this.ShowPeople();
            MoveTo.CanMove = true;
         }
         
         private function BackToMyTreasureHouse(e:MouseEvent) : void
         {
            GF.switchMap(LocalUserInfo.getUserID(),false,33);
         }
         
         public function ShowPeople() : void
         {
            GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
            GF.clearPeoples();
            GV.onlineClass.getUserListReq();
            MoveTo.CanMove = true;
         }
         
         private function getAllUserInfo(evt:EventTaomee) : void
         {
            GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
            var userArray:* = evt.EventObj.arr;
            var userObj:Object = {
               "data":userArray,
               "type":1
            };
            GV.PeopleCount.changeOnlinePeople(userObj);
            this.ReSetMolePoint();
         }
         
         private function ReSetMolePoint() : void
         {
            var tempitem:Object = null;
            var p:Point = null;
            var item:PeopleManageView = null;
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               p = MoveTo.getRandomFloorPoint();
               item = tempitem.Instance as PeopleManageView;
               if(!MoveCondition.hasRoad(item.x,item.y))
               {
                  item.x = p.x;
                  item.y = p.y;
                  item.moveTo(p.x,p.y);
               }
            }
         }
         
         public function HidePeople() : void
         {
            GF.clearPeoples();
            MoveTo.CanMove = false;
         }
         
         public function Clear() : void
         {
            GV.MC_ToolView.y = 340;
            MoveTo.CanMove = true;
            BC.removeEvent(this);
         }
      }
   }
   
   