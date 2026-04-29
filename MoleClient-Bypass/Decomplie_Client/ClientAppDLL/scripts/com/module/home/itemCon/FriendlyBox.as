package com.module.home.itemCon
{
   import com.common.Alert.*;
   import com.common.view.MCScrollBar.MCScrollBar;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.friendBox.FriendBoxSocket;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.module.home.HomeView;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.userPanelView.userPanelView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.setTimeout;
   
   public class FriendlyBox
   {
      
      private static var instance:FriendlyBox = null;
      
      public var Obj:Object;
      
      public var MeAlert:*;
      
      private var targetMC:MovieClip;
      
      private var isMe:Boolean;
      
      private var buyItemReq:*;
      
      private var buyItemRes:*;
      
      public var ListUIClass:Class;
      
      public var ListUI:Sprite;
      
      public var Man:Class;
      
      public var visitorPanel:*;
      
      private var len:uint;
      
      private var arrMC:Array = new Array();
      
      private var ScrollBar:*;
      
      private var myTimeout:*;
      
      private var MC:MovieClip;
      
      private var Panel:MovieClip;
      
      public var VisitorArr:Array;
      
      public var GoodsName:String = "友誼小樹葉";
      
      public function FriendlyBox()
      {
         super();
      }
      
      public static function getInstance() : FriendlyBox
      {
         return instance = instance || new FriendlyBox();
      }
      
      public function init(_targetMC:MovieClip) : void
      {
         this.arrMC = new Array();
         this.isMe = HomeView.ismyhome;
         this.targetMC = _targetMC;
         setTimeout(this.isHaveGift,500);
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.ClickBox);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function isHaveGift() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1249",this.setBoxInfoFun);
         FriendBoxSocket.getFriendBoxInfoRequest(HomeView.hostID);
      }
      
      private function setBoxInfoFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1249",this.setBoxInfoFun);
         if(Boolean(evt.EventObj.arr))
         {
            if(evt.EventObj.arr.length > 0)
            {
               if(Boolean(this.targetMC.mc2) && Boolean(this.targetMC.mc2.mc.mc))
               {
                  this.targetMC.mc2.mc.mc.gotoAndStop(2);
               }
            }
         }
      }
      
      private function ClickBox(e:MouseEvent) : void
      {
         var so:Object = null;
         var serverFriendsList:Array = null;
         var isFriend:Boolean = false;
         var j:int = 0;
         var msg:String = null;
         if(!HomeView.getInstance().EditMode)
         {
            if(!this.isMe)
            {
               so = MainManager.getGlobalObject();
               serverFriendsList = new Array();
               serverFriendsList = so.data.ServerFriendsList;
               isFriend = false;
               for(j = 0; j < serverFriendsList.length; j++)
               {
                  if(serverFriendsList[j].friend == HomeView.hostID)
                  {
                     isFriend = true;
                  }
               }
               if(isFriend)
               {
                  this.loadUI({
                     "swf":"module/external/FriendBoxMain.swf",
                     "tip":"正在打開友誼..."
                  });
               }
               else
               {
                  msg = "   你還不是小屋主人的好友！";
                  GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               }
            }
            else
            {
               this.loadUI({
                  "swf":"module/external/FriendBoxMain.swf",
                  "tip":"正在打開友誼..."
               });
            }
         }
      }
      
      private function loadUI(Obj:Object) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/FriendBoxMain.swf","正在打開......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         MainManager.getTopLevel().addChild(c);
         trace("loadSucc",c.name);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      private function closePanel(e:Event) : void
      {
         this.Panel.x = 4800;
      }
      
      private function getItemReq(e:Event) : void
      {
         if(this.isMe)
         {
            this.getMyGoods();
         }
         else
         {
            this.getGoods();
         }
      }
      
      private function getItemNumSucc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemNumSucc);
         this.Obj = e.EventObj.obj;
         if(this.isMe)
         {
            if(this.Obj.arr.length == 0)
            {
               this.Panel.num_txt.text = "";
               this.Panel.iknow_btn.visible = true;
               this.Panel.goods_mc.gotoAndStop(25);
               this.Panel.txt.text = "    我是神奇的友誼寶盒，我肚子裡的友誼小樹葉全被其他小摩爾領走了，你趕快去漿果叢林再撿一些吧！";
            }
            else
            {
               this.Panel.goods_mc.gotoAndStop(1);
               this.Panel.num_txt.text = this.Obj.arr[0].itemCount;
               this.Panel.txt.text = "    我是神奇的友誼寶盒，在我肚子裡有" + this.Obj.arr[0].itemCount + "片友誼小樹葉，你可以自己領取，也可以叫其他小摩爾來領取哦！";
            }
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_FLAG_SUCC,this.isVip);
            GetHomeInfoReq.UserFlag(HomeView.hostID);
         }
      }
      
      private function showSimpleAlert(msg:String) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
      }
      
      private function isVip(e:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_FLAG_SUCC,this.isVip);
         var Flag:uint = uint(e.EventObj.Flag);
         if(GF.BT(Flag,1))
         {
            if(this.Obj.arr.length == 0)
            {
               if(Boolean(this.Panel))
               {
                  this.Panel.num_txt.text = "";
               }
               url = "resource/allJob/AlertPic/etiquetteBox/01.swf";
               msg = "    非常抱歉，現在我肚子裡沒有友誼小樹葉了，所以不能送給你。你去其他超級拉姆的家園看看吧！";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"SMCUI");
            }
            else
            {
               this.Panel.goods_mc.gotoAndStop(1);
               this.Panel.num_txt.text = this.Obj.arr[0].itemCount;
               this.Panel.txt.text = "    我是神奇的友誼寶盒，在我肚子裡有" + this.Obj.arr[0].itemCount + "片友誼小樹葉，你要領取一片嗎？";
            }
            return;
         }
         this.showSimpleAlert("    非常抱歉，友誼寶盒已經失去魔力了。你去其他超級拉姆的家園看看吧。");
      }
      
      private function getMyGoods() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemNumInBag);
         GetItemCountReq.getItemCount(HomeView.hostID,190190,0);
      }
      
      private function getGoods(E:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemNumInBag);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190190,0);
      }
      
      private function getItemNumInBag(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemNumInBag);
         if(e.EventObj.obj.Count == 0)
         {
            GetHomeInfoReq.getgoodsinbox(HomeView.hostID,190190);
         }
         else
         {
            this.showSimpleAlert("    你的百寶箱中已經有這件寶貝，所以不能再領取哦！");
         }
      }
      
      private function buySucc(e:EventTaomee) : void
      {
         this.showSimpleAlert("    恭喜你！1片友誼小樹葉已經放入你的百寶箱中，趕快去漿果叢林找毛毛頭兌換禮物吧！");
      }
      
      private function showList(E:Event) : void
      {
         this.ScrollBar = null;
         this.ListUIClass = GV.Lib_Map.getClass("list_UI");
         this.Man = GV.Lib_Map.getClass("man");
         this.ListUI = new this.ListUIClass();
         if(!this.visitorPanel)
         {
            GV.onlineSocket.addEventListener(GetHomeInfoRes.GET_FRIENDBOX_LIST,this.showVisitor);
            GetHomeInfoReq.FriendBoxList();
         }
         else
         {
            this.visitorPanel.x = this.Panel.x + this.Panel.width / 2;
            this.visitorPanel.y = this.Panel.y - this.Panel.height / 2;
         }
      }
      
      public function showVisitor(e:EventTaomee) : void
      {
         var i:uint = 0;
         GV.onlineSocket.removeEventListener(GetHomeInfoRes.GET_FRIENDBOX_LIST,this.showVisitor);
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
         this.visitorPanel.x = this.Panel.x + this.Panel.width / 2;
         this.visitorPanel.y = this.Panel.y - this.Panel.height / 2;
      }
      
      public function closeMC(e:MouseEvent) : void
      {
         this.visitorPanel.x = -1000;
      }
      
      public function initMan(manInfo:*, bool:Boolean) : void
      {
         var temp:* = new this.Man();
         temp.visible = false;
         temp.prev_pet.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         temp.water_muck.gotoAndStop(manInfo.Flag + 1);
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
      
      public function drag_box_start(evt:MouseEvent) : void
      {
         this.Panel.startDrag();
      }
      
      public function drag_box_stop(evt:MouseEvent) : void
      {
         this.Panel.stopDrag();
      }
      
      public function drag_box_move(evt:MouseEvent) : void
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
      
      private function removeEventHandler(E:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         this.visitorPanel = null;
         this.Panel = null;
         BC.removeEvent(this);
      }
   }
}

