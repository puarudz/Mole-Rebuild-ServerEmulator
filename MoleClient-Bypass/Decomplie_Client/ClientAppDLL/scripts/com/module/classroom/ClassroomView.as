package com.module.classroom
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.classModule.MenberListManage;
   import com.module.classModule.classManage;
   import com.module.newHouse.newHouseView;
   import com.view.userPanelView.userPanelView;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ClassroomView extends MovieClip
   {
      
      public static var instance:ClassroomView;
      
      public static var hostID:uint;
      
      public static var ListUI:Sprite;
      
      public static var UserName:String;
      
      public static var ClassBGID:uint;
      
      public static var hotui:*;
      
      public static var listui:*;
      
      public static var InHome:Boolean;
      
      public static var isLeader:Boolean;
      
      public static var isJoin:Boolean;
      
      public static var ismyClass:Boolean;
      
      public static var hasAlert:Boolean = false;
      
      private var classeditview:ClassEditView;
      
      public var itemBookViews:*;
      
      public var loadBookEvent:*;
      
      public var RootMC:MovieClip;
      
      public var classUIMC:MovieClip;
      
      public var ClassObj:Object;
      
      public var ClassID:uint;
      
      private var mcloader:MCLoader;
      
      private var bgLoaderOver:Boolean = false;
      
      public var bgbmd:BitmapData;
      
      public var EditMode:Boolean;
      
      public var ChangeBGBool:Boolean;
      
      public var UIPosY:uint = 800;
      
      private var Kind:int = 0;
      
      private var Locked:Boolean;
      
      private var currentPage:uint = 1;
      
      private const NUM:uint = 10;
      
      private var depotGoodsArr:Array;
      
      public var backAlert:*;
      
      public var tempGoods:*;
      
      public var tempGoodsObj:*;
      
      public var classroomlogic:ClassroomLogic;
      
      public function ClassroomView()
      {
         super();
      }
      
      public static function getInstance() : ClassroomView
      {
         if(instance == null)
         {
            instance = new ClassroomView();
         }
         return instance;
      }
      
      public function setValue(tempObj:Loader, homeinfoObj:Object) : void
      {
         InHome = true;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.classroomlogic = ClassroomLogic.getInstance();
         this.ClassObj = homeinfoObj;
         this.classroomlogic.setValue(this.ClassObj);
         this.RootMC = tempObj.content as MovieClip;
         this.classUIMC = this.RootMC.classUIMC;
         this.classUIMC.y = this.UIPosY;
         BC.addEvent(this,this.classUIMC.close_btn,MouseEvent.CLICK,this.OpenClosedepot);
         this.RootMC.btnMC.save_btn.visible = false;
         GV.MapInfo_mapID = LocalUserInfo.getMapID();
         this.Locked = Boolean(this.ClassObj.Visit_flag);
         isLeader = GV.MapInfo_mapID == LocalUserInfo.getUserID();
         this.ClassID = GV.MapInfo_mapID;
         hostID = this.ClassID;
         UserName = this.ClassObj.Name;
         isJoin = this.ClassObj.memberArr.indexOf(LocalUserInfo.getUserID()) >= 0;
         this.classeditview = ClassEditView.getInstance();
         this.classeditview.setValue(this.ClassObj,this.RootMC);
         this.loadHomeground();
         this.initBtn();
         this.init();
      }
      
      public function init() : void
      {
         if(isLeader)
         {
            this.depotGoodsArr = [[],[],[],[],[]];
            BC.addEvent(this,GV.onlineSocket,"HomedepotAddGoods",this.moveHomeGoodsToDepot);
            BC.addEvent(this,this.classeditview,"change_Home_BG",this.changeHomeBG);
            BC.addEvent(this,this.classeditview,"HomeGoodsToDepot",this.moveHomeGoodsToDepot);
         }
      }
      
      public function initBtn() : void
      {
         this.RootMC.btnMC.msg_btn.visible = false;
         if(isLeader)
         {
            ismyClass = true;
            if(this.Locked)
            {
               this.RootMC.btnMC.lockmc.gotoAndStop(3);
            }
            else
            {
               this.RootMC.btnMC.lockmc.gotoAndStop(1);
            }
            this.RootMC.btnMC.save_btn.visible = false;
            this.RootMC.btnMC.join_btn.visible = false;
            this.RootMC.btnMC.msg_btn.visible = true;
            BC.addEvent(this,this.RootMC.btnMC.msg_btn,MouseEvent.CLICK,this.msgClassMate);
            BC.addEvent(this,this.RootMC.btnMC.book_btn,MouseEvent.CLICK,this.openBook);
            BC.addEvent(this,this.RootMC.btnMC.depot_btn,MouseEvent.CLICK,this.openDepot);
            BC.addEvent(this,this.RootMC.btnMC.save_btn,MouseEvent.CLICK,this.dosaveClass);
            BC.addEvent(this,this.RootMC.btnMC.lock_btn,MouseEvent.CLICK,this.LockClass);
            BC.addEvent(this,this.RootMC.btnMC.lock_btn,MouseEvent.MOUSE_OVER,this.LockClassOver);
            BC.addEvent(this,this.RootMC.btnMC.lock_btn,MouseEvent.MOUSE_OUT,this.LockClassOut);
         }
         else if(isJoin)
         {
            BC.addEvent(this,this.RootMC.btnMC.book_btn,MouseEvent.CLICK,this.openBook);
            this.RootMC.btnMC.join_btn.visible = false;
            this.RootMC.btnMC.lock_btn.visible = false;
            this.RootMC.btnMC.lockmc.visible = false;
            this.RootMC.btnMC.depot_btn.visible = false;
            this.RootMC.btnMC.save_btn.visible = false;
         }
         else
         {
            BC.addEvent(this,this.RootMC.btnMC.join_btn,MouseEvent.CLICK,this.JoinClass);
            this.RootMC.btnMC.join_btn.visible = true;
            this.RootMC.btnMC.lock_btn.visible = false;
            this.RootMC.btnMC.lockmc.visible = false;
            this.RootMC.btnMC.book_btn.visible = false;
            this.RootMC.btnMC.depot_btn.visible = false;
            this.RootMC.btnMC.save_btn.visible = false;
         }
         BC.addEvent(this,this.RootMC.btnMC.list_btn,MouseEvent.CLICK,this.ClassMan);
      }
      
      public function msgClassMate(e:Event) : void
      {
         var ld:Loader = new Loader();
         ld.load(VL.getURLRequest("module/classView/SendMailMain.swf"));
         GV.MC_AppLever.addChild(ld);
      }
      
      public function JoinClass(e:Event) : void
      {
         classManage.getInstance().joinClass(this.ClassID);
      }
      
      public function ClassMan(e:Event) : void
      {
         var ListUIClass:Class = null;
         if(!ListUI)
         {
            ListUIClass = GV.Lib_Map.getClass("list_UI");
            ListUI = new ListUIClass();
            MainManager.getAppLevel().addChild(ListUI);
            ListUI["drag_mc"].addEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
            ListUI["drag_mc"].addEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
            ListUI["drag_mc"].addEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
            ListUI["close_btn"].addEventListener(MouseEvent.CLICK,this.closeMC);
            ListUI["list_mc"].addChild(MenberListManage.getList(this.ClassID,7));
         }
         ListUI.x = 360;
         ListUI.y = 120;
      }
      
      public function drag_start(evt:MouseEvent) : void
      {
         ListUI.startDrag();
      }
      
      public function drag_stop(evt:MouseEvent) : void
      {
         ListUI.stopDrag();
      }
      
      public function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      public function closeMC(e:Event) : void
      {
         ListUI.y = 1000;
      }
      
      public function LockClass(e:Event) : void
      {
         if(isLeader)
         {
            if(this.Locked)
            {
               classSocket.class_unlock();
               this.Locked = false;
            }
            else
            {
               classSocket.class_lock();
               this.Locked = true;
            }
            this.LockClassOut();
         }
      }
      
      public function LockClassOver(e:Event) : void
      {
         if(this.Locked)
         {
            this.RootMC.btnMC.lockmc.gotoAndStop(4);
         }
         else
         {
            this.RootMC.btnMC.lockmc.gotoAndStop(2);
         }
      }
      
      public function LockClassOut(e:Event = null) : void
      {
         if(this.Locked)
         {
            this.RootMC.btnMC.lockmc.gotoAndStop(3);
         }
         else
         {
            this.RootMC.btnMC.lockmc.gotoAndStop(1);
         }
      }
      
      private function openBook(e:MouseEvent) : void
      {
         var bookView:MovieClip = null;
         if(isJoin)
         {
            if(!MainManager.getGameLevel().getChildByName("classbook"))
            {
               bookView = new MovieClip();
               bookView.name = "classbook";
               MainManager.getGameLevel().addChild(bookView);
               this.loadBookEvent = new MCLoader("module/homeBookView/classBookView.swf",bookView,1,"加載班級道具購買書");
               BC.addEvent(this,this.loadBookEvent,MCLoadEvent.ON_SUCCESS,this.loadItemBookHandler);
               this.loadBookEvent.doLoad();
            }
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","本期的班級物品只能由班長購買哦。大家下一期再來為班級購買物品吧！",Alert.IKNOW_ALERT);
         }
      }
      
      public function openDepot(e:Event) : void
      {
         if(isLeader)
         {
            if(!this.EditMode)
            {
               this.RootMC.classUIMC.y = 440;
               this.EditMode = !this.EditMode;
               ClassEditView.Editable = this.EditMode;
               this.RootMC.btnMC.save_btn.visible = this.EditMode;
               GF.clearPeoples();
               MainManager.getToolLevel().y = 1000;
               MoveTo.CanMove = false;
               BC.addEvent(this,this.classroomlogic,ClassroomLogic.GET_CLASS_DEPOT_GOODS,this.getDepotGoods);
               this.classroomlogic.ClassDepotReq();
            }
            else
            {
               this.OpenClosedepot();
            }
         }
      }
      
      public function dosaveClass(e:Event) : void
      {
         if(isLeader)
         {
            this.EditMode = false;
            ClassEditView.Editable = this.EditMode;
            this.RootMC.classUIMC.y = this.UIPosY;
            this.RootMC.btnMC.save_btn.visible = false;
            MainManager.getToolLevel().y = 0;
            MoveTo.CanMove = true;
            this.classroomlogic.showPeople();
            this.saveHome();
            MapDepthManageLogic.compositorMapDepth();
         }
      }
      
      public function changeHomeBG(e:Event) : void
      {
         this.ChangeBGBool = true;
         this.loadHomeground();
      }
      
      public function switchMap() : void
      {
         if(GV.Room_DefaultRoomID != GV.MyInfo_userID && !GV.isChangeMap)
         {
            GV.Room_DefaultRoomID = hostID;
            GF.switchMap(hostID);
         }
      }
      
      public function moveHomeGoodsToDepot(e:*) : void
      {
         var i:uint = 0;
         var tempObj:* = e.EventObj.obj;
         var temp:Object = new Object();
         temp.ID = Number(tempObj.ID);
         temp.Count = 1;
         var o:Object = GoodsInfo.getInfoById(temp.ID);
         temp.Layer = o.Layer;
         try
         {
            temp.name = o.name;
            temp.PosX = tempObj.PosX;
            temp.PosY = tempObj.PosY;
            temp.Direction = Number(tempObj.Direction);
            temp.Visible = Number(tempObj.Visible);
            temp.Other = tempObj.Other;
         }
         catch(e:Event)
         {
         }
         temp.Type = o.Type;
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
      
      private function addGoodsToDepot(temp:*) : void
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
      
      private function showCurrentGoods(temp:*) : void
      {
         if(temp.Type == this.Kind || this.Kind == 0)
         {
            this.showGoods(this.Kind,this.currentPage);
         }
      }
      
      public function loadHomeground() : void
      {
         ClassBGID = this.classroomlogic.classBGID;
         this.mcloader = new MCLoader("resource/classroom/swf/" + ClassBGID + ".swf",this.RootMC,1,"正在加載班級背景...");
         BC.addEvent(this,this.mcloader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.addEvent(this,this.mcloader,MCLoadEvent.ERROR,this.loadBGErr);
         LoaderList.getInstance().addItem(this.mcloader,null,LoaderList.HIGH);
      }
      
      private function loadBGErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function showHostInfo(e:MouseEvent) : void
      {
         userPanelView.showUserPanel(hostID);
      }
      
      private function loadBGSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         this.RootMC.type_mc.addChild(c["mc"]);
         this.RootMC.control_mc.addChild(c["out_btn"]);
         BC.addEvent(this,GV.onlineSocket,"HOME_HIT",this.outHomeORinHouse);
         if(Boolean(this.RootMC.bg_mc))
         {
            this.RootMC.bg_mc.addChild(c["bg"]);
         }
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.bgLoaderOver = true;
         trace(c["numChildren"]);
         GC.clearAllChildren(this.RootMC.hittest_mc);
         this.RootMC.hittest_mc.addChild(c["hitTestMC"]);
         classHitTest.getBMD(this.RootMC);
         if(this.ChangeBGBool)
         {
            MapManageLogic.addBackgroud(c["bg"]);
         }
         else
         {
            this.checkLoadedOver();
         }
      }
      
      private function checkLoadedOver(c:* = null) : void
      {
         if(this.bgLoaderOver)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("allClassGoodsLoaded"));
            MapDepthManageLogic.compositorMapDepth();
            GC.setGTimeout(function():void
            {
               MapDepthManageLogic.compositorMapDepth();
               MapDepthManageLogic.setAllPeopleDepth();
            },100);
         }
      }
      
      private function outHomeORinHouse(e:EventTaomee) : void
      {
         if(e.EventObj == 1)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            switchMapLogic.switchMapLogicHandler(GV.MyInfo_PrevMap);
         }
      }
      
      private function updateHomeDepot(e:EventTaomee) : void
      {
         var temp:* = undefined;
         for(var i:uint = 0; i < 10; i++)
         {
            temp = this.classUIMC["I" + i];
            if(temp.ID == e.EventObj.ID)
            {
               this.moveGoodsToHouse(temp);
               return;
            }
         }
      }
      
      private function loadItemBookHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = (MainManager.getStageWidth() - childMC.content.width) / 2;
         mainMC.y = (MainManager.getStageHeight() - childMC.content.height) / 2;
         this.itemBookViews = new classBookView(childMC.content.root);
         var mcloader:MCLoader = evt.target as MCLoader;
         BC.removeEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.loadItemBookHandler);
         mcloader.clear();
      }
      
      private function AutoSaveHome() : void
      {
         this.saveHome();
      }
      
      private function getDepotGoods(e:EventTaomee) : void
      {
         BC.removeEvent(this,this.classroomlogic,ClassroomLogic.GET_CLASS_DEPOT_GOODS,this.getDepotGoods);
         this.depotGoodsArr = e.EventObj.arr;
         this.initBtnEvent();
         this.showGoods(0,1);
      }
      
      private function initBtnEvent() : void
      {
         for(var i:uint = 0; i < 5; i++)
         {
            if(i != 0)
            {
               this.classUIMC["kind" + i].gotoAndStop(2);
            }
            BC.addEvent(this,this.classUIMC["kind" + i].btn,MouseEvent.CLICK,this.showKindGoods);
         }
         BC.addEvent(this,this.classUIMC.prev_btn,MouseEvent.CLICK,this.prevPage);
         BC.addEvent(this,this.classUIMC.next_btn,MouseEvent.CLICK,this.nextPage);
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
      
      public function saveHome() : void
      {
         this.classroomlogic.savehome(this.getHomeItem(),this.classeditview.getgoodsArr());
      }
      
      private function onBtnOver(e:MouseEvent) : void
      {
         e.target.parent.gotoAndStop(2);
         var goods:* = e.currentTarget.parent;
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
      
      private function showGoods(tempkind:uint, pagenum:uint) : void
      {
         var temp:* = undefined;
         var tempLoader:Loader = null;
         this.Kind = tempkind;
         this.currentPage = pagenum;
         try
         {
            this.clearItems();
         }
         catch(e:Error)
         {
         }
         for(var i:int = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
         {
            temp = this.classUIMC["I" + (i - (this.currentPage - 1) * this.NUM)];
            try
            {
               BC.removeEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
            }
            catch(e:Error)
            {
            }
            if(this.depotGoodsArr[this.Kind][i] != null)
            {
               temp.num = i;
               temp.ID = this.depotGoodsArr[this.Kind][i].ID;
               try
               {
                  temp.num_txt.text = this.depotGoodsArr[this.Kind][i].Count;
               }
               catch(e:Error)
               {
               }
               temp.obj = this.depotGoodsArr[this.Kind][i];
               temp.Type = this.depotGoodsArr[this.Kind][i].Type;
               temp.Name = this.depotGoodsArr[this.Kind][i].name;
               temp.Count = this.depotGoodsArr[this.Kind][i].Count;
               temp.Layer = this.depotGoodsArr[this.Kind][i].Layer;
               temp.Price = this.depotGoodsArr[this.Kind][i].price;
               temp.Class = this.depotGoodsArr[this.Kind][i].Class;
               temp.Grade = this.depotGoodsArr[this.Kind][i].Grade;
               temp.btn.visible = true;
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OVER,this.onBtnOver);
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OUT,this.onBtnOut);
               BC.addEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
               tempLoader = new Loader();
               trace("load ----" + this.depotGoodsArr[this.Kind][i].ID);
               tempLoader.load(VL.getURLRequest("resource/classroom/icon/" + this.depotGoodsArr[this.Kind][i].ID + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private function userPorp(E:MouseEvent) : void
      {
         if(!hasAlert)
         {
            if(this.classeditview.goodsNum <= 99 || E.target.parent.Layer == 6)
            {
               this.tempGoods = E.target.parent;
               this.tempGoodsObj = {
                  "ID":this.tempGoods.ID,
                  "PosX":0,
                  "PosY":0,
                  "Direction":1,
                  "Visible":0,
                  "Layer":this.tempGoods.Layer,
                  "Type":this.tempGoods.Type,
                  "Other":this.tempGoods.Other
               };
               if(this.tempGoodsObj.Layer != 6)
               {
                  if(this.getItemBool(this.tempGoods))
                  {
                     this.classeditview.loadNewGoods(this.tempGoodsObj);
                     this.moveGoodsToHouse(this.tempGoods);
                  }
               }
               else
               {
                  hasAlert = true;
                  this.backAlert = Alert.showAlert(MainManager.getAppLevel(),"","更換背景會把所有物品放回倉庫中，是否確定？",Alert.SELECT_ALERT);
                  BC.addEvent(this,this.backAlert,"CLICK" + 1,this.backAllGoods);
                  BC.addEvent(this,this.backAlert,"CLICK" + 2,this.removeinit);
               }
            }
            else
            {
               Alert.showAlert(MainManager.getAppLevel(),"","你的班級東西太多了，已經超過最大上限無法擺放了！",Alert.IKNOW_ALERT);
            }
         }
      }
      
      private function getItemBool(temp:*) : Boolean
      {
         var id:Object = temp.ID;
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:int = 0; i < thisKindLen; i++)
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
      
      private function backAllGoods(e:Event = null) : void
      {
         GF.clearPeoples();
         hasAlert = false;
         this.moveGoodsToHouse(this.tempGoods);
         this.classeditview.changeBG(this.tempGoodsObj);
      }
      
      private function removeinit(e:Event) : void
      {
         hasAlert = false;
         BC.removeEvent(this,this.backAlert,"CLICK" + 1,this.backAllGoods);
         BC.removeEvent(this,this.backAlert,"CLICK" + 2,this.removeinit);
      }
      
      private function moveGoodsToHouse(temp:Object) : void
      {
         var id:Object = temp.ID;
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:int = 0; i < thisKindLen; i++)
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
      
      private function getHomeItem() : Array
      {
         var arr:Array = new Array();
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         for(var i:int = 0; i < totalArrlen; i++)
         {
            if(this.depotGoodsArr[0][i].Type != 2)
            {
               arr.push(this.depotGoodsArr[0][i]);
            }
         }
         return arr;
      }
      
      private function removeOneInAll(id:Object) : void
      {
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         for(var i:int = 0; i < totalArrlen; i++)
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
            temp = this.classUIMC["I" + i];
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
      
      private function changeBtn(j:uint) : void
      {
         for(var i:uint = 0; i < 5; i++)
         {
            if(i == j)
            {
               this.classUIMC["kind" + i].gotoAndStop(1);
            }
            else
            {
               this.classUIMC["kind" + i].gotoAndStop(2);
            }
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         newHouseView.isMyHouse = false;
         ismyClass = false;
         this.ChangeBGBool = false;
         InHome = false;
         this.bgLoaderOver = false;
         ListUI = null;
         BC.removeEvent(this);
      }
      
      private function OpenClosedepot(e:Event = null) : void
      {
         if(this.RootMC.classUIMC.y < 500)
         {
            this.RootMC.classUIMC.y = this.UIPosY;
         }
         else
         {
            this.RootMC.classUIMC.y = 440;
         }
      }
   }
}

