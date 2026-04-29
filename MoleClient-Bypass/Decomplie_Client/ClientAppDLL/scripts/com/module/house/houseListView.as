package com.module.house
{
   import com.common.view.MCScrollBar.MCScrollBar;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.manager.UIManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.getRoomInfo.GetRoomListReq;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.house.vipHouse.VipHouseManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.SharedObject;
   import flash.system.*;
   import flash.text.*;
   
   public class houseListView extends MovieClip
   {
      
      public static var VIP_HOUSE_URL:String = "module/vipHouseList/vipHouseList.swf";
      
      public var tempClass:*;
      
      public var addClass:*;
      
      public var addClasstwo:*;
      
      public var type:int = 1;
      
      public var targetMC:MovieClip;
      
      private var scroll_Bar:MCScrollBar;
      
      private var scroll_Bars:MCScrollBar;
      
      public var all_arr:Array;
      
      public var here_arr:Array;
      
      private var vipHouseManager:VipHouseManager;
      
      private var nameArr:Array = ["日排行榜","週排行榜","總排行榜"];
      
      public function houseListView()
      {
         super();
         this.vipHouseManager = new VipHouseManager();
      }
      
      public function info() : void
      {
         this.here_arr = new Array();
         this.here_arr = homehotXML.AllChang_arr;
         this.chartFun();
      }
      
      public function chartFun() : void
      {
         try
         {
            GV.onlineSocket.removeEventListener(GetRoomListReq.GET_VIP_HOME_LIST,this.getListFun);
         }
         catch(e:*)
         {
         }
         GV.onlineSocket.addEventListener(GetRoomListReq.GET_VIP_HOME_LIST,this.getListFun);
         GetRoomListReq.requestVipHomeList();
      }
      
      public function getListFun(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetRoomListReq.GET_VIP_HOME_LIST,this.getListFun);
         this.all_arr = new Array();
         this.all_arr = e.EventObj.arr;
         var vipArray:Array = e.EventObj.vipArray;
         this.addUIFun();
         this.vipHouseManager.setHouseDataArray(this.all_arr,vipArray);
      }
      
      public function addUIFun() : void
      {
         var loader:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("homeListUI") && !GV.isChangeMap)
         {
            loader = new MCLoader(VIP_HOUSE_URL,MainManager.getAppLevel(),Loading.TITLE_AND_PERCENT,"正在打開熱門小屋");
            loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.addListMC);
            loader.doLoad();
         }
         else
         {
            this.clearNowUI();
            this.showNowUI();
         }
      }
      
      private function addListMC(event:MCLoadEvent) : void
      {
         var mc:Loader = null;
         mc = event.getLoader();
         mc.name = "homeListUI";
         this.vipHouseManager.setHouseRoot(event.getLoader());
         this.addClass = UIManager.getClass("homeList_addmc");
         this.addClasstwo = UIManager.getClass("homeList_addmcTwo");
         this.tempClass = UIManager.getClass("homeList_UI");
         this.targetMC = new this.tempClass();
         this.targetMC.x = 635;
         this.targetMC.y = 75;
         DisplayObjectContainer(mc.content).addChild(this.targetMC);
         SimpleButton(event.getLoader().content["closeBtn"]).addEventListener(MouseEvent.CLICK,this.closeFun);
         MainManager.getAppLevel().addChild(mc);
         this.UIinfo();
      }
      
      public function UIinfo() : void
      {
         MainManager.centerObj(this.targetMC.parent);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         this.targetMC.list_btn.addEventListener(MouseEvent.CLICK,this.showBtnMC,false,0,true);
         this.targetMC.hot_btn.addEventListener(MouseEvent.CLICK,this.showBtnMC,false,0,true);
         this.targetMC.scroll_mc.visible = false;
         this.targetMC.bg_mc.visible = false;
         this.scroll_Bar = new MCScrollBar(this.targetMC.scroll_mc,this.targetMC.emp_mc,200,220);
         this.scroll_Bars = new MCScrollBar(this.targetMC.scroll_mcs,this.targetMC.emp_mcs,200,220);
         this.showNowUI();
         this.vipHouseManager.showRandomHouse();
      }
      
      public function showNowUI() : void
      {
         if(this.type == 2)
         {
            this.targetMC.nameUI_mc.gotoAndStop(2);
            this.targetMC.list_mc.gotoAndStop(2);
            this.targetMC.hot_mc.gotoAndStop(1);
            this.targetMC.scroll_mc.visible = false;
            this.targetMC.scroll_mcs.visible = true;
            this.getFirendHot();
         }
         else
         {
            this.targetMC.nameUI_mc.gotoAndStop(1);
            this.targetMC.list_mc.gotoAndStop(1);
            this.targetMC.hot_mc.gotoAndStop(2);
            this.targetMC.scroll_mc.visible = true;
            this.targetMC.scroll_mcs.visible = false;
            this.showHomeList();
         }
      }
      
      public function showBtnMC(e:*) : void
      {
         var msg:String = e.target.name;
         if(msg == "list_btn")
         {
            this.type = 1;
            this.chartFun();
         }
         else
         {
            this.type = 2;
            this.clearNowUI();
            this.showNowUI();
         }
      }
      
      public function clearNowUI() : void
      {
         var tempsss:* = undefined;
         var llgg:uint = uint(this.targetMC.emp_mc.numChildren);
         for(var lgh:uint = 0; lgh < llgg; lgh++)
         {
            tempsss = this.targetMC.emp_mc.getChildAt(lgh);
            if(Boolean(tempsss as MovieClip))
            {
               tempsss.ID = null;
               tempsss.btn.removeEventListener(MouseEvent.CLICK,this.gotoHomeFun);
            }
         }
         GC.clearChildren(this.targetMC.emp_mc);
         GC.clearChildren(this.targetMC.emp_mcs);
      }
      
      public function gotoHomeFun(e:MouseEvent) : void
      {
         MainManager.getAppLevel().removeChild(this.targetMC.parent.parent);
         var map:int = int(e.target.parent.ID);
         if(map + GV.TwentyBillion != LocalUserInfo.getMapID())
         {
            if(GV.MapInfo_mapID < 1000)
            {
               GV.MyInfo_PrevMap = GV.MapInfo_mapID;
            }
            LocalUserInfo.setMapID(0);
            GV.Room_DefaultRoomID = map + GV.TwentyBillion;
            switchMapLogic.switchMapLogicHandler(map + GV.TwentyBillion);
         }
      }
      
      public function showHomeList() : void
      {
         var i:Object = null;
         var mc:MovieClip = null;
         var lg:uint = this.all_arr.length;
         var lastY:int = -1;
         for(i in this.all_arr)
         {
            mc = new this.addClass();
            if(lastY == -1)
            {
               mc.y = 0;
            }
            else
            {
               mc.y = mc.height + 6 + lastY;
            }
            mc.ID = this.all_arr[i].id;
            mc.name_txt.text = this.all_arr[i].name;
            mc.id_txt.text = this.all_arr[i].id;
            mc.num_txt.text = this.all_arr[i].num;
            mc.btn.addEventListener(MouseEvent.CLICK,this.gotoHomeFun);
            this.targetMC.emp_mc.addChild(mc);
            lastY = mc.y;
         }
         if(this.targetMC.emp_mc.height > 220)
         {
            this.scroll_Bar.reSet();
            this.targetMC.scroll_mc.visible = true;
            this.targetMC.bg_mc.visible = true;
         }
         else
         {
            this.targetMC.scroll_mc.visible = false;
            this.targetMC.bg_mc.visible = false;
         }
      }
      
      public function getFirendHot() : void
      {
         var so:SharedObject = MainManager.getGlobalObject();
         var serverFriendsList:Array = so.data.ServerFriendsList;
         GV.onlineSocket.addEventListener("read_1456",this.getFirendHotSucc);
         GetHomeInfoReq.getFriendHot(serverFriendsList);
      }
      
      public function getFirendHotSucc(e:EventTaomee) : void
      {
         var j:uint = 0;
         var i:uint = 0;
         GV.onlineSocket.removeEventListener("read_1456",this.getFirendHotSucc);
         var arr:Array = e.EventObj.arr;
         arr = arr.sortOn("hot",16);
         arr = arr.reverse();
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.FriendsList;
         if(arr.length > 20)
         {
            arr = arr.slice(0,20);
         }
         if(Boolean(friendsList))
         {
            for(j = 0; j < arr.length; j++)
            {
               for(i = 0; i < friendsList.length; i++)
               {
                  if(friendsList[i].UserID == arr[j].id)
                  {
                     arr[j].Nick = friendsList[i].Nick;
                     break;
                  }
               }
            }
         }
         this.showHotList(arr);
      }
      
      public function showHotList(arr:Array) : void
      {
         var i:Object = null;
         var mc:MovieClip = null;
         var temarr:Array = arr;
         var lg:uint = temarr.length;
         var lastY:int = -1;
         for(i in temarr)
         {
            mc = new this.addClasstwo();
            if(lastY == -1)
            {
               mc.y = 0;
            }
            else
            {
               mc.y = mc.height + 6 + lastY;
            }
            mc.ID = temarr[i].id;
            mc.name_txt.text = Boolean(temarr[i].Nick) ? temarr[i].Nick : temarr[i].id;
            mc.num_txt.text = temarr[i].hot;
            mc.btn.addEventListener(MouseEvent.CLICK,this.gotoHomeFun);
            this.targetMC.emp_mcs.addChild(mc);
            lastY = mc.y;
         }
         if(this.targetMC.emp_mcs.height > 220)
         {
            this.scroll_Bars.reSet();
            this.targetMC.scroll_mcs.visible = true;
            this.targetMC.bg_mc.visible = true;
         }
         else
         {
            this.targetMC.scroll_mcs.visible = false;
            this.targetMC.bg_mc.visible = false;
         }
      }
      
      public function dragFun(event:MouseEvent = null) : void
      {
         event.currentTarget.parent.startDrag();
      }
      
      public function movedrag(event:MouseEvent = null) : void
      {
         event.updateAfterEvent();
      }
      
      public function stopdrag(event:MouseEvent = null) : void
      {
         event.currentTarget.parent.parent.stopDrag();
      }
      
      public function closeFun(e:MouseEvent = null) : void
      {
         this.vipHouseManager.destroy();
         MainManager.getAppLevel().removeChild(this.targetMC.parent.parent);
      }
      
      public function removeEvent(eve:*) : void
      {
         this.scroll_Bar.removeHandler();
         this.scroll_Bars.removeHandler();
         this.scroll_Bar = null;
         this.scroll_Bars = null;
         var MC:Object = this.targetMC.drag_mc.parent;
         MC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragFun);
         MC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopdrag);
         MC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.movedrag);
         MC.list_btn.removeEventListener(MouseEvent.CLICK,this.showBtnMC);
         MC.hot_btn.removeEventListener(MouseEvent.CLICK,this.showBtnMC);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         GC.stopAllMC(MC);
      }
   }
}

