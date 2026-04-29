package com.module.newHouse
{
   import com.common.Alert.*;
   import com.common.Alert.type.AlertType;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.BitArray;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.socket.savaRoomItem.SavaRoomItemReq;
   import com.logic.socket.summerAct.CheckSwapStateProtocol;
   import com.module.house.houseLogic;
   import com.module.house.houseXML;
   import com.module.pet.petPanel;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.events.SocketEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   
   public class newHouseView extends MovieClip
   {
      
      public static var houseName:String;
      
      public static var houseID:int;
      
      public static var hostOnline:int;
      
      private static var instance:newHouseView;
      
      public static var isMyHouse:Boolean = false;
      
      public static var hasAlert:Boolean = false;
      
      public var moleaction:moleActionReq;
      
      public var myhouseLogic:houseLogic;
      
      private var myeditHouseView:newEditHouseView;
      
      private var houseMapArr:Array;
      
      private var _depotGoodsArr:Array;
      
      private var houseGoodsArr:Array;
      
      private var floorMode:Boolean = false;
      
      public var editMode:Boolean = false;
      
      public var RootMC:MovieClip;
      
      private var houseUIMC:MovieClip;
      
      private var loadObj:*;
      
      private var houseUI:*;
      
      private var Kind:int = 0;
      
      private var currentPage:uint = 1;
      
      private const NUM:uint = 10;
      
      public var houseObj:*;
      
      public var Mode:uint = 0;
      
      public var oldMap:String;
      
      private var UIPosY:Number = 8000;
      
      public var backAlert:*;
      
      public var tempGoods:Object;
      
      public var tempGoodsObj:Object;
      
      public var CandyNum:int = -1;
      
      public var alreadycandy:Boolean;
      
      private var movie:PlayMovie;
      
      public function newHouseView()
      {
         super();
         trace("進入小屋了");
      }
      
      public static function getInstance() : newHouseView
      {
         if(instance == null)
         {
            instance = new newHouseView();
         }
         return instance;
      }
      
      public function setValue(tempObj:Loader, houseInfoObj:*) : void
      {
         this.CandyNum = -1;
         this.alreadycandy = false;
         this.loadObj = tempObj;
         this.RootMC = tempObj.content as MovieClip;
         this.RootMC.box_mc.visible = false;
         this.RootMC.candy_txt.visible = false;
         this.houseUIMC = this.RootMC.houseUIMC;
         this.houseObj = houseInfoObj;
         houseID = this.houseObj.UserID;
         hostOnline = this.houseObj.Online;
         houseName = String(this.houseObj.Name);
         LocalUserInfo.setMapID(this.houseObj.UserID);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.init();
         var task:Task = TaskManager.getTask(382);
         if(task.state == 1 && task.buffer.step == 2)
         {
            ModuleManager.openPanel("Task382Flag_1",{"URL":"newTaskHouseMC"});
            return;
         }
         if(Boolean(ActivityTmpDataManager.task382OverPanel_obj))
         {
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 5)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 3)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":5});
               }
            }
         }
      }
      
      public function have13010() : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.dohave13010);
         GetItemCountReq.getItemCount(houseID,13010,2);
      }
      
      public function dohave13010(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.dohave13010);
         var obj:Object = e.EventObj.obj;
         if(obj.Count > 0)
         {
            this.RootMC.box_mc.visible = true;
            this.RootMC.candy_txt.visible = true;
            this.getCandyNum();
         }
         else
         {
            this.init();
         }
      }
      
      public function getCandyNum() : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         GetItemCountReq.getItemCount(houseID,190441,2);
      }
      
      public function getItemCountLogic(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         trace(e);
         var obj:Object = e.EventObj.obj;
         if(obj.Count > 0)
         {
            this.RootMC.box_mc.visible = true;
            this.RootMC.candy_txt.visible = true;
            this.CandyNum = obj.arr[0].itemCount;
            this.RootMC.candy_txt.text = this.CandyNum;
         }
         else
         {
            this.CandyNum = 0;
         }
         this.init();
      }
      
      public function showCandy(e:MouseEvent) : void
      {
         if(isMyHouse)
         {
            if(this.CandyNum > 0)
            {
               Alert.showAlert(MainManager.getAppLevel(),"","    目前你的糖果盒裡有" + this.CandyNum + "顆糖果，記得要儲存足夠的糖果來招待你的朋友哦，否則可會被搗亂哦！",Alert.IKNOW_ALERT);
            }
            else
            {
               Alert.showAlert(MainManager.getAppLevel(),"","    你的糖果盒裡沒有糖果啦！記得要儲存足夠的糖果來招待你的朋友哦，否則可會被搗亂哦！",Alert.IKNOW_ALERT);
            }
         }
         else if(GF.isMyFriend(houseID))
         {
            if(this.CandyNum > 0)
            {
               if(this.alreadycandy)
               {
                  Alert.showAlert(MainManager.getAppLevel(),"","    你已經在這小屋中拿過糖果了！",Alert.IKNOW_ALERT);
                  return;
               }
               this.RootMC.candyui.y = 60;
               this.RootMC.candyui.mmc.gotoAndStop(1);
               this.RootMC.candyui.tmc.visible = false;
               this.RootMC.candyui.stop_btn.visible = false;
               this.RootMC.candyui.iknow_btn.visible = false;
            }
            else
            {
               Alert.showAlert(MainManager.getAppLevel(),"","    啊呀呀，這個小屋的主人太忙，可能沒有準備糖果，記得叫他準備多一點的糖果招待大家哦！",Alert.IKNOW_ALERT);
            }
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","    小屋主人的糖果有限，隻招待好友哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public function removeHandler(e:Event) : void
      {
         MainManager.getToolLevel().y = 0;
         SoundMixer.stopAll();
         isMyHouse = false;
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         try
         {
            GV.onlineSocket.removeEventListener("MOLE_SLIDE",this.moveMolePos);
         }
         catch(e:Error)
         {
         }
         try
         {
            GV.onlineSocket.removeEventListener("depotAddGoods",this.buyGoodsSuccess);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.myeditHouseView.removeEventListener("dispatchReloadGoods",this.reloadDepotGoods);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.myeditHouseView.removeEventListener("dispatchEditMode",this.changeEditMode);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.myeditHouseView.removeEventListener("dispatchGoodsToDepot",this.moveGoodsToDepot);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.myhouseLogic.removeEventListener("dispatchDepotGoods",this.getDepotGoods);
         }
         catch(e:Error)
         {
         }
         try
         {
            houseXML.removeEventListener("dispatchLocalArr",this.getFullArr);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.houseUIMC.prev_btn.removeEventListener(MouseEvent.CLICK,this.prevPage);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.houseUIMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextPage);
         }
         catch(e:Error)
         {
         }
      }
      
      public function init() : void
      {
         this.RootMC.houseTool.depot_mc.visible = false;
         houseXML.getXMLFromData();
         this.depotGoodsArr = [[],[],[],[],[],[],[],[]];
         this.myhouseLogic = new houseLogic();
         this.showHouseMap();
         OnlineManager.addCmdListener(CommandID.CHECK_SWAP_STATE,this.onCheckState);
         OnlineManager.send(CommandID.CHECK_SWAP_STATE,404);
      }
      
      private function onCheckState(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.CHECK_SWAP_STATE,this.onCheckState);
         var statePro:CheckSwapStateProtocol = e.bodyInfo;
         var bitArr:BitArray = statePro.stateBit;
      }
      
      private function backFun3() : void
      {
         if(Boolean(this.movie))
         {
            this.movie.destroy();
            this.movie = null;
            if(this.movie == null)
            {
               Alert.smileAlart("剛剛發生什麼事了？那個可疑的黑影是誰？",function():void
               {
                  ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,535);
               });
            }
         }
      }
      
      public function initCandy() : void
      {
         GV.MC_AppLever.addChild(this.RootMC.candyui);
         this.RootMC.candyui.visible = false;
         this.RootMC.candyui.start_btn.addEventListener(MouseEvent.CLICK,this.candystart);
         this.RootMC.candyui.iknow_btn.addEventListener(MouseEvent.CLICK,this.candyiknow);
         this.RootMC.candyui.stop_btn.addEventListener(MouseEvent.CLICK,this.candystop);
         this.RootMC.candyui.close_btn.addEventListener(MouseEvent.CLICK,this.candyclose);
      }
      
      public function candyclose(e:MouseEvent) : void
      {
         this.RootMC.candyui.y = -1000;
      }
      
      public function candystart(e:MouseEvent) : void
      {
         this.RootMC.candyui.start_btn.visible = false;
         this.RootMC.candyui.stop_btn.visible = true;
         this.RootMC.candyui.rmc.play();
         this.RootMC.candyui.mmc.gotoAndStop(2);
      }
      
      public function candyiknow(e:MouseEvent) : void
      {
         this.RootMC.candyui.y = -1000;
      }
      
      public function getcandysucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1856,this.getcandysucc);
         this.CandyNum -= e.EventObj.count;
         this.RootMC.candy_txt.text = this.CandyNum;
         this.RootMC.candyui.mmc.gotoAndStop(3);
         this.RootMC.candyui.tmc.visible = true;
         this.RootMC.candyui.rmc.visible = false;
         this.RootMC.candyui.tmc.gotoAndStop(e.EventObj.count);
         Alert.showAlert(MainManager.getAppLevel(),"","    恭喜你獲得了" + e.EventObj.count + "顆糖果，已經放入你的百寶箱中了！",Alert.IKNOW_ALERT);
      }
      
      public function candystop(e:MouseEvent) : void
      {
         this.alreadycandy = true;
         var ran:int = int(Math.random() * 6);
         if(ran > this.CandyNum)
         {
            ran = 0;
            this.RootMC.candyui.mmc.gotoAndStop(4);
            this.RootMC.candyui.rmc.visible = false;
         }
         else if(ran != 0)
         {
            GV.onlineSocket.addEventListener("read_" + 1856,this.getcandysucc);
            farmSocket.getcandy(houseID,ran);
         }
         else
         {
            this.RootMC.candyui.mmc.gotoAndStop(4);
            this.RootMC.candyui.rmc.visible = false;
         }
         this.RootMC.candyui.rmc.gotoAndStop("h" + ran);
         this.RootMC.candyui.stop_btn.visible = false;
         this.RootMC.candyui.iknow_btn.visible = true;
      }
      
      public function removeHouseViewEvent() : void
      {
         try
         {
            GV.onlineSocket.removeEventListener("MOLE_SLIDE",this.moveMolePos);
         }
         catch(err:Error)
         {
         }
      }
      
      private function changeEditMode(e:EventTaomee) : void
      {
         this.editMode = e.EventObj.Mode;
         if(this.editMode)
         {
            petPanel.closePetPanel();
            this.RootMC.houseUIMC.y = this.UIPosY;
            this.loadDepotGoods();
         }
         else
         {
            this.RootMC.houseUIMC.y = this.UIPosY;
            if(this.myeditHouseView.changed)
            {
               this.myeditHouseView.changed = false;
            }
            else
            {
               this.myhouseLogic.saveItemSuccess();
            }
            if(newEditHouseView.floorSign == 1)
            {
               this.moleaction.sendAction(3,440,440);
            }
            else
            {
               this.moleaction.sendAction(3,440,840);
            }
         }
      }
      
      public function moveMolePos(e:EventTaomee) : void
      {
         if(e.EventObj.Action == 3)
         {
            this.myhouseLogic.doSaveGoods();
         }
      }
      
      public function showHouseMap() : void
      {
         if(this.houseObj.UserID == LocalUserInfo.getUserID())
         {
            isMyHouse = true;
            this.moleaction = new moleActionReq();
            GV.onlineSocket.addEventListener("MOLE_SLIDE",this.moveMolePos);
            this.myeditHouseView = new newEditHouseView(this.houseObj,this.RootMC);
            this.initUI();
         }
         else
         {
            isMyHouse = false;
            this.myeditHouseView = new newEditHouseView(this.houseObj,this.RootMC);
            this.RootMC.houseTool.visible = false;
            this.RootMC.houseUIMC.y = this.UIPosY;
         }
         SpecialGoodsBasic.init();
      }
      
      public function initUI() : void
      {
         this.RootMC.houseTool.visible = true;
         this.RootMC.houseUIMC.y = this.UIPosY;
         GV.onlineSocket.addEventListener("read_" + 415,this.changeBGsucc);
         GV.onlineSocket.addEventListener("depotAddGoods",this.buyGoodsSuccess);
         this.myeditHouseView.addEventListener("dispatchReloadGoods",this.reloadDepotGoods);
         this.myeditHouseView.addEventListener("dispatchEditMode",this.changeEditMode);
         this.myeditHouseView.addEventListener("dispatchGoodsToDepot",this.moveGoodsToDepot);
      }
      
      public function changeBGsucc(e:EventTaomee) : void
      {
      }
      
      public function buyGoodsSuccess(e:EventTaomee) : void
      {
         this.moveGoodsToDepot(e);
      }
      
      private function moveGoodsToDepot(e:EventTaomee) : void
      {
         var i:uint = 0;
         var tempObj:Object = e.EventObj.obj;
         tempObj = Boolean(tempObj) ? tempObj : GoodsInfo.getInfoById(160030);
         var temp:Object = new Object();
         temp.ID = Number(tempObj.ID);
         temp.Count = 1;
         var o:Object = GoodsInfo.getInfoById(temp.ID);
         try
         {
            temp.Name = o.name;
            temp.PosX = tempObj.PosX;
            temp.PosY = tempObj.PosY;
            temp.Direction = Number(tempObj.Direction);
            temp.Visible = Number(tempObj.Visible);
            temp.Layer = tempObj.Layer;
            temp.Reserved = tempObj.Reserved;
         }
         catch(err:Error)
         {
         }
         temp.Layer = GoodsInfo.getInfoById(temp.ID).Layer;
         temp.Type = GoodsInfo.getInfoById(temp.ID).Type;
         if(temp.Type < 0)
         {
            trace("-------------------xml.中沒這樣物品");
            return;
         }
         var id:Number = Number(temp.ID);
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         if(thisKindLen > 0)
         {
            for(i = 0; i < thisKindLen; i++)
            {
               if(this.depotGoodsArr[objkind][i].ID == id)
               {
                  ++this.depotGoodsArr[objkind][i].Count;
                  this.showCurrentGoods(temp);
                  break;
               }
               if(i == thisKindLen - 1)
               {
                  this.addGoodsToDepot(temp);
               }
            }
         }
         else
         {
            this.addGoodsToDepot(temp);
         }
      }
      
      private function showDepotUI(e:Event) : void
      {
         this.RootMC.houseUIMC.y = this.UIPosY;
      }
      
      private function reloadDepotGoods(e:Event) : void
      {
         this.loadDepotGoods();
      }
      
      private function loadDepotGoods() : void
      {
         this.myhouseLogic.showDepotGoods();
         this.myhouseLogic.addEventListener("dispatchDepotGoods",this.getDepotGoods);
      }
      
      private function getDepotGoods(e:EventTaomee) : void
      {
         var simGoods:Array = e.EventObj.DepotGoods;
         for(var i:uint = 0; i < simGoods.length; i++)
         {
            trace("簡單di:",simGoods[i].id,"  itemCount:",simGoods[i].itemCount);
         }
         trace("得到倉庫中的物品(簡單列表)");
         houseXML.addEventListener("dispatchLocalArr",this.getFullArr);
         houseXML.getArr(e.EventObj.DepotGoods);
      }
      
      private function showKindGoods(e:MouseEvent) : void
      {
         var tempkind:Number = Number(e.target.parent.name.slice(4,5));
         if(this.Kind != tempkind)
         {
            this.Kind = tempkind;
            this.changeBtn(this.Kind);
            this.showGoods(this.Kind,1);
         }
      }
      
      public function getFullArr(evt:EventTaomee) : void
      {
         this.depotGoodsArr = evt.EventObj.arr;
         this.initBtnEvent();
         this.showGoods(0,1);
         this.RootMC.houseUIMC.y = 440 - GV.MC_mapFrame.y;
      }
      
      private function showGoods(tempkind:int, pagenum:uint) : void
      {
         var temp:Object = null;
         var o:* = undefined;
         var tempLoader:Loader = null;
         this.Kind = tempkind;
         this.currentPage = pagenum;
         try
         {
            this.clearItems();
         }
         catch(err:Error)
         {
         }
         for(var i:int = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
         {
            temp = this.houseUIMC["I" + (i - (this.currentPage - 1) * this.NUM)];
            if(Boolean(temp))
            {
               temp.btn.removeEventListener(MouseEvent.CLICK,this.userPorp);
               DisplayUtil.removeAllChild(temp.loading);
               o = this.depotGoodsArr[this.Kind][i];
               if(this.depotGoodsArr[this.Kind][i] != null)
               {
                  temp.num = i;
                  temp.ID = this.depotGoodsArr[this.Kind][i].ID;
                  try
                  {
                     temp.num_txt.text = this.depotGoodsArr[this.Kind][i].Count;
                  }
                  catch(err:Error)
                  {
                  }
                  temp.Type = this.depotGoodsArr[this.Kind][i].Type;
                  temp.Name = this.depotGoodsArr[this.Kind][i].Name;
                  temp.Count = this.depotGoodsArr[this.Kind][i].Count;
                  temp.Layer = this.depotGoodsArr[this.Kind][i].Layer;
                  temp.Price = this.depotGoodsArr[this.Kind][i].Price;
                  temp.Desc = this.depotGoodsArr[this.Kind][i].Desc;
                  temp.Grade = this.depotGoodsArr[this.Kind][i].Grade;
                  temp.btn.visible = true;
                  temp.btn.addEventListener(MouseEvent.MOUSE_OVER,this.onBtnOver);
                  temp.btn.addEventListener(MouseEvent.MOUSE_OUT,this.onBtnOut);
                  temp.btn.addEventListener(MouseEvent.CLICK,this.userPorp);
                  tempLoader = new Loader();
                  tempLoader.load(VL.getURLRequest("resource/goods/icon/" + this.depotGoodsArr[this.Kind][i].ID + ".swf"));
                  temp.loadimg.addChild(tempLoader);
               }
               else
               {
                  temp.btn.enabled = false;
               }
            }
         }
      }
      
      private function getItemBool(temp:Object) : Boolean
      {
         var id:Object = temp.ID;
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:uint = 0; i < thisKindLen; i++)
         {
            if(this.depotGoodsArr[objkind][i].ID == id)
            {
               if(this.depotGoodsArr[objkind][i].Count >= 1)
               {
                  return true;
               }
               return false;
            }
         }
         return false;
      }
      
      private function userPorp(E:MouseEvent) : void
      {
         if(!hasAlert)
         {
            if(this.myeditHouseView.goodsNum <= 99 || E.target.parent.Layer == 6)
            {
               this.tempGoods = E.target.parent;
               this.tempGoodsObj = {
                  "ID":this.tempGoods.ID,
                  "PosX":0,
                  "PosY":0,
                  "Direction":1,
                  "Visible":0,
                  "Layer":this.tempGoods.Layer,
                  "Reserved":this.tempGoods.Reserved
               };
               if(this.tempGoodsObj.Layer != 6)
               {
                  if(this.getItemBool(this.tempGoods))
                  {
                     this.myeditHouseView.loadNewGoods(this.tempGoodsObj);
                     this.moveGoodsToHouse(this.tempGoods);
                  }
               }
               else
               {
                  if(LocalUserInfo.getMapType() != 0)
                  {
                     Alert.smileAlart("    只能在第一層的房間裡才能換其他房型哦！");
                     return;
                  }
                  hasAlert = true;
                  this.backAlert = Alert.smileAlart("    換小屋會把所有物品放回倉庫中的，是否確定？",this.backAllGoods,AlertType.SURE + "," + AlertType.CANCEL);
                  this.backAlert.addEventListener("CLICK" + 2,this.removeinit);
               }
            }
            else
            {
               Alert.smileAlart("    你的小屋東西太多了，已經超過最大上限無法擺放了！");
            }
         }
      }
      
      private function backAllGoods(e:Event = null) : void
      {
         GF.clearPeoples();
         hasAlert = false;
         this.moveGoodsToHouse(this.tempGoods);
         this.myeditHouseView.changeBG(this.tempGoodsObj);
         SavaRoomItemReq.saveRoomBG(this.tempGoodsObj.ID);
         this.myeditHouseView.setOldXY();
         this.myeditHouseView.showEditorUI(true);
      }
      
      private function removeinit(e:Event) : void
      {
         hasAlert = false;
         this.backAlert.removeEventListener("CLICK" + 1,this.backAllGoods);
         this.backAlert.removeEventListener("CLICK" + 2,this.removeinit);
      }
      
      private function addGoodsToDepot(temp:Object) : void
      {
         if(temp.ID != 160144)
         {
            this.depotGoodsArr[0].push(temp);
            this.depotGoodsArr[temp.Type].push(temp);
         }
         else
         {
            this.depotGoodsArr[0].unshift(temp);
            this.depotGoodsArr[temp.Type].unshift(temp);
         }
         this.showCurrentGoods(temp);
      }
      
      private function showCurrentGoods(temp:Object) : void
      {
         if(temp.Type == this.Kind || this.Kind == 0)
         {
            this.showGoods(this.Kind,this.currentPage);
         }
      }
      
      private function moveGoodsToHouse(temp:Object) : void
      {
         var id:Object = temp.ID;
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:uint = 0; i < thisKindLen; i++)
         {
            if(this.depotGoodsArr[objkind][i].ID == id)
            {
               --this.depotGoodsArr[objkind][i].Count;
               temp.Count = this.depotGoodsArr[objkind][i].Count;
               if(this.depotGoodsArr[objkind][i].Count < 1)
               {
                  this.depotGoodsArr[objkind].splice(i,1);
                  this.removeOneInAll(id);
                  if(this.depotGoodsArr[this.Kind].length % this.NUM != 0)
                  {
                     this.showGoods(this.Kind,this.currentPage);
                  }
                  else
                  {
                     if(this.currentPage > 1)
                     {
                        --this.currentPage;
                     }
                     this.showGoods(this.Kind,this.currentPage);
                  }
               }
               else
               {
                  temp.num_txt.text = this.depotGoodsArr[objkind][i].Count;
               }
               break;
            }
         }
      }
      
      private function removeOneInAll(id:Object) : void
      {
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         for(var i:uint = 0; i < totalArrlen; i++)
         {
            if(id == this.depotGoodsArr[0][i].ID)
            {
               this.depotGoodsArr[0].splice(i,1);
               break;
            }
         }
      }
      
      private function clearItems() : void
      {
         var temp:Object = null;
         for(var i:uint = 0; i < this.NUM; i++)
         {
            temp = this.houseUIMC["I" + i];
            if(temp.num != null)
            {
               temp.loadimg.removeChildAt(0);
               temp.num = null;
               temp.type = null;
               temp.btn.visible = false;
               temp.num_txt.text = "";
            }
         }
      }
      
      public function saveGoods(e:*) : void
      {
         this.myhouseLogic.saveGoods(this.myeditHouseView.goodsArr);
      }
      
      private function onBtnOver(E:MouseEvent) : void
      {
         E.target.parent.gotoAndStop(2);
         var goods:Object = E.currentTarget.parent;
         GF.showTip(goods.Name,{
            "noDelay":true,
            "x":goods.x + 64,
            "y":goods.y + 430
         });
      }
      
      private function onBtnOut(E:MouseEvent) : void
      {
         E.target.parent.gotoAndStop(1);
      }
      
      private function prevPage(E:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.showGoods(this.Kind,--this.currentPage);
         }
      }
      
      private function nextPage(E:MouseEvent) : void
      {
         if(this.depotGoodsArr[this.Kind].length > this.currentPage * this.NUM)
         {
            this.showGoods(this.Kind,++this.currentPage);
         }
      }
      
      private function initBtnEvent() : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            if(i != 0)
            {
               this.houseUIMC["kind" + i].gotoAndStop(2);
            }
            this.houseUIMC["kind" + i].btn.addEventListener(MouseEvent.CLICK,this.showKindGoods);
         }
         this.houseUIMC.prev_btn.addEventListener(MouseEvent.CLICK,this.prevPage);
         this.houseUIMC.next_btn.addEventListener(MouseEvent.CLICK,this.nextPage);
      }
      
      private function removeBtnEvent() : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            this.houseUIMC["kind" + i].btn.removeEventListener(MouseEvent.CLICK,this.showKindGoods);
         }
      }
      
      private function changeBtn(j:uint) : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            if(i == j)
            {
               this.houseUIMC["kind" + i].gotoAndStop(1);
            }
            else
            {
               this.houseUIMC["kind" + i].gotoAndStop(2);
            }
         }
      }
      
      public function showHouseHot(num:Object) : void
      {
         this.RootMC.hotHouse.hot.text = num;
      }
      
      public function get depotGoodsArr() : Array
      {
         return this._depotGoodsArr;
      }
      
      public function set depotGoodsArr(value:Array) : void
      {
         this._depotGoodsArr = value;
      }
   }
}

