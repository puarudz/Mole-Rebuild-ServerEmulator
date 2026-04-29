package com.module.bookItem
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.AssetsManage;
   import com.core.manager.LevelManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.logic.socket.award.QuGameSockte;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.logic.socket.session.BringTagoutLoginSocket;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.logic.task.TaskDiceCurse;
   import com.module.activityModule.superPetLogin;
   import com.module.clothBuyBook.OpenClothBuyBook;
   import com.module.coin.SutraBookModule;
   import com.module.deal.Deal;
   import com.module.ninePicGame.ninePicGame;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.ui.LoadingPanel;
   import com.view.mapView.activity.Task83.AgentClass;
   import com.view.mapView.activity.Task83.Anniversary;
   import com.view.mapView.activity.Task83.DownMp3ToLocal;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.mapView.activity.Task83.SuperPrivilegeCtl;
   import com.view.mapView.activity.Task83.SwitchMapToAngelPark;
   import com.view.noticeView.postcardLogic;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   
   public class newsPagerBook extends Sprite
   {
      
      private static var _newsPage:String;
      
      private static var allPage:int = 18;
      
      public var nowFrame:int;
      
      public var targetMC:MovieClip;
      
      public var sandType:int = 0;
      
      private var AlertMC:*;
      
      private var _bln:Boolean = false;
      
      private var _last:uint = 0;
      
      private var shoesFlag_item:uint = 0;
      
      private var BuyItem:BuyItemReq;
      
      private var buyBool:Boolean = false;
      
      private var itemID:uint;
      
      private var ninePicGameC:ninePicGame;
      
      private var hasPushfoodPan:Boolean = false;
      
      private var ld:Loader;
      
      private var bookView:MovieClip;
      
      private var loadBookEvent:MCLoader;
      
      private var haveChoose:int = 0;
      
      private var createShopAssets:AssetsManage;
      
      private var mcArr:Array;
      
      private var k:uint = 1;
      
      private var stringBrith:Number = 0;
      
      private var newTitle:String = "";
      
      public function newsPagerBook(url:String = "")
      {
         super();
         if(url == "")
         {
            url = "module/external/BooksUI/newspaperBook.swf";
         }
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在打開摩爾時報");
         DownLoadManager.addEvent(resID,this.onLoaderNewsPagerSucc);
         LoadingPanel.addRes(resID);
      }
      
      public static function get newsPage() : String
      {
         return _newsPage;
      }
      
      public static function set newsPage(value:String) : void
      {
         _newsPage = value;
      }
      
      private static function B2S(b:ByteArray) : String
      {
         var t:String = null;
         var s:String = "";
         var op:uint = b.position;
         b.position = 0;
         while(Boolean(b.bytesAvailable))
         {
            t = b.readUnsignedByte().toString(16);
            s += t.length == 1 ? "0" + t : t;
         }
         b.position = op;
         return s;
      }
      
      private function onLoaderNewsPagerSucc(e:DownLoadEvent) : void
      {
         this.targetMC = e.data as MovieClip;
         this.targetMC.x = this.targetMC.y = 0;
         if(Boolean(_newsPage))
         {
            MovieClipUtil.gotoAndStop(this.targetMC,_newsPage);
         }
         else
         {
            this.targetMC.gotoAndStop(1);
         }
         addChild(this.targetMC);
         this.nowFrame = 1;
         this.AlertMC = new MovieClip();
         this.AlertMC.name = "newspagerAlt";
         addChild(this.AlertMC);
         this.BuyItem = new BuyItemReq();
         this.bookViewInit();
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),13375,2,13400);
         if(Boolean(this.targetMC.oldPage))
         {
            BC.addEvent(this,this.targetMC.oldPage,MouseEvent.CLICK,this.openPrevNewsPageBook);
         }
         BC.addEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.onClosePrevNewsPageBook);
      }
      
      private function bookViewInit() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.removeEvent);
         BC.addEvent(this,GV.onlineSocket,"nowPage_newsbook",this.pageOneInit);
         BC.addEvent(this,GV.onlineSocket,"removeMC_newsbook",this.removeEvent);
         BC.addEvent(this,GV.onlineSocket,"danZhu",this.sendFun);
         BC.addEvent(this,GV.onlineSocket,"ITEMID_BUY_TEMP",this.itemEvent);
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         dispatchEvent(new Event(Event.CLOSE));
         DisplayUtil.removeForParent(this);
      }
      
      public function removeEvent(e:* = null) : void
      {
         this.destroy();
      }
      
      private function openPrevNewsPageBook(e:MouseEvent) : void
      {
         this.destroy();
         var newsPager:newsPagerBook = new newsPagerBook("resource/monthly/9/5.swf");
         LevelManager.appLevel.addChild(newsPager);
         BC.addEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.onClosePrevNewsPageBook);
      }
      
      private function onClosePrevNewsPageBook(e:Event) : void
      {
         this.destroy();
      }
      
      public function createShop() : void
      {
         if(!this.createShopAssets)
         {
            this.createShopAssets = new AssetsManage();
         }
         this.createShopAssets.IncludeLib("createShop_Lib","module/external/BooksUI/petShopBook.swf","正在打開...",true);
         MainManager.getGameLevel().addChild(this.createShopAssets.getLoader());
         this.hasPushfoodPan = true;
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.addEventListener("close",this.onCloseShopBook);
      }
      
      private function onCloseShopBook(E:*) : void
      {
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("close",this.onCloseShopBook);
         this.hasPushfoodPan = false;
         DisplayUtil.removeForParent(this.createShopAssets.getLoader());
         this.createShopAssets = null;
      }
      
      private function getPayNumHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         if(evt.EventObj.obj.Count >= 1)
         {
            this.buyBool = true;
         }
         else
         {
            this.buyBool = false;
         }
      }
      
      private function itemEvent(evt:EventTaomee) : void
      {
         var tit:String = null;
         var msg:String = null;
         var myAlert:* = undefined;
         this.itemID = evt.EventObj.itemId;
         if(this.buyBool)
         {
            Alert.smileAlart("    你已經領取過禮物了，每個小摩爾只能擁有一件哦！");
         }
         else
         {
            tit = "resource/cloth/icon/" + this.itemID + ".swf";
            msg = "  你確定要把" + GoodsInfo.getItemNameByID(this.itemID) + "放到百寶箱中嗎？每個小摩爾只能擁有一種款式哦！";
            myAlert = Alert.showAlert(MainManager.getTopLevel(),tit,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            myAlert.addEventListener(Alert.CLICK_ + "1",this.confirmHander);
         }
      }
      
      private function confirmHander(evt:*) : void
      {
         evt.target.removeEventListener(Alert.CLICK_ + "1",this.confirmHander);
         Deal.BuyItem(this.itemID,1,function(ItemnID:uint):void
         {
            buyBool = true;
            Alert.getIconByID_Alart(itemID,"    恭喜你獲得" + GoodsInfo.getItemNameByID(itemID) + "，已放入你的百寶箱中！");
         },function(E:*):void
         {
            Alert.getIconByID_Alart(itemID,"你已經有" + GoodsInfo.getItemNameByID(itemID) + "，每個小摩爾只能擁有一件哦!");
         });
      }
      
      public function pageOneInit(e:*) : void
      {
         StatisticsClass.getInstance().init(67566723,"http://e.cn.miaozhen.com/r.gif?k=1001445&p=3xdTt0&o=");
         this.nowFrame = this.targetMC.currentFrame;
         switch(this.nowFrame)
         {
            case 4:
               BC.addEvent(this,this.targetMC.go_seaPanel,MouseEvent.CLICK,this.onSeaPanel);
               break;
            case 7:
               BC.addEvent(this,this.targetMC.btn01,MouseEvent.CLICK,this.supeStar);
               BC.addEvent(this,this.targetMC.btn02,MouseEvent.CLICK,this.onOpenSuperLamuPrivilege);
               break;
            case 8:
               BC.addEvent(this,this.targetMC.sand_msgs,MouseEvent.CLICK,this.showSandUIFun);
         }
      }
      
      private function onVote(event:EventTaomee) : void
      {
         var arr:Array = event.EventObj as Array;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1327,this.read1327Event);
         QuGameSockte.quGame_create(11,arr);
      }
      
      private function read1327Event(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1327,this.read1327Event);
         Alert.smileAlart("    非常感謝你參加投票活動，送你1個蘋果、1個胡蘿蔔、1個草莓！");
      }
      
      public function onOpenPostCard(event:MouseEvent) : void
      {
         this.destroy();
         var postcartLogic:postcardLogic = new postcardLogic();
         postcartLogic.addCardUI();
      }
      
      private function onOpenGoldCompass(event:MouseEvent) : void
      {
         this.destroy();
         ModuleManager.openPanel(ModuleType.VIP_COMPASS_PANEL);
      }
      
      public function onOpenSuperLamuGift(event:MouseEvent) : void
      {
         this.destroy();
         SuperPrivilegeCtl.getInstance().onOpenSuperLamuGift();
      }
      
      public function onOpenSuperLamuPrivilege(event:MouseEvent) : void
      {
         this.destroy();
         SuperPrivilegeCtl.getInstance().onOpenSuperPrivilegeBook();
      }
      
      public function onOpenSuperGoGo(event:MouseEvent) : void
      {
         this.destroy();
         ModuleManager.openPanel("SuperGoGoPanel");
      }
      
      private function onOpenShop(event:MouseEvent) : void
      {
         this.destroy();
         Anniversary.getInstance().openMoleShop();
      }
      
      private function onGetSignet(event:MouseEvent) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("get_2011_11_change_Pig_item_1"));
      }
      
      private function switchMapOnTimer(event:MouseEvent) : void
      {
         var date:Date = ServerUpTime.getInstance().date;
         if(date.getHours() == 19)
         {
            if(GV.MapInfo_mapID != 14)
            {
               MapManager.enterMap(14);
            }
         }
         else
         {
            Alert.smileAlart("    迷宮洞穴只有每天的19:00—20:00才會開放哦！");
         }
      }
      
      private function openWebHandler(evt:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67744919);
         var url:String = "http://nanjing.tthonghuo.com/jijieling";
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      private function joinDouGameFun(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 426,this.joinHeroGame);
         BringTagoutLoginSocket.get_GameSID(9);
      }
      
      private function joinHeroGame(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 426,this.joinHeroGame);
         var byte:ByteArray = new ByteArray();
         ByteArray(e.EventObj).position = 0;
         ByteArray(e.EventObj).readBytes(byte);
         byte.position = 0;
         var url:String = "http://bus.61.com/sign/?session=" + B2S(byte) + "&uid=" + LocalUserInfo.getUserID() + "&target_app=11&game=mole";
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      private function urlBtnFun(evt:MouseEvent) : void
      {
         var urls:String = "http://account.61.com/haoma?gid=1";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function gotoAngelParkFun(e:MouseEvent) : void
      {
         SwitchMapToAngelPark.instance.gotoAngelFun();
      }
      
      private function switchToPigHouse(event:MouseEvent) : void
      {
         GF.switchToPigHouse(LocalUserInfo.getUserID());
      }
      
      private function switchToPigBeautyHouse(event:MouseEvent) : void
      {
         GF.switchToBeautyHouse(LocalUserInfo.getUserID());
      }
      
      private function goHomeFun(e:MouseEvent) : void
      {
         switchMapLogic.GoHomeMap(LocalUserInfo.getUserID());
      }
      
      private function goFarmFun(e:MouseEvent) : void
      {
         GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
         GF.switchMap(LocalUserInfo.getUserID(),false,2);
      }
      
      private function toDownMusic(e:MouseEvent) : void
      {
         DownMp3ToLocal.getInstance().onDownMusic();
      }
      
      private function showPanelFun(e:Event) : void
      {
         BC.addEvent(this,this.targetMC.MC.btn1,MouseEvent.CLICK,this.showSandUIFun);
         BC.addEvent(this,this.targetMC.MC.btn2,MouseEvent.CLICK,this.showSandUIFun);
         BC.addEvent(this,this.targetMC.MC.btn3,MouseEvent.CLICK,this.showSandUIFun);
      }
      
      private function openBook(evt:MouseEvent) : void
      {
         var url:String = "module/external/CoinBookUI/sutraHomeBook.swf";
         var str:String = "正在加載摩爾裝潢特別版......";
         var mcName:String = "houseBookMC";
         SutraBookModule.getInstance().initView(url,str,mcName);
      }
      
      private function loaCBook(e:Event) : void
      {
         var url:String = "module/external/CoinBookUI/CClothBuyBook.swf";
         var str:String = "正在加載摩爾時尚絕版冊......";
         var mcName:String = "CoinClothBookMC";
         SutraBookModule.getInstance().initView(url,str,mcName);
      }
      
      private function openSSBook(evt:MouseEvent = null) : void
      {
         OpenClothBuyBook.getInstance().openBookEvent();
      }
      
      private function openMoBook(evt:MouseEvent) : void
      {
         this.createShop();
      }
      
      private function confirmSend(e:MouseEvent) : void
      {
         var oneChoose:Number = NaN;
         var twoChoose:Number = NaN;
         GV.onlineSocket.dispatchEvent(new Event("danZhu"));
         var arrNew:Array = new Array();
         arrNew = [];
         var three1Choose:Number = 1;
         var three2Choose:Number = 1;
         var three3Choose:Number = 1;
         var three4Choose:Number = 1;
         var three5Choose:Number = 1;
         var three6Choose:Number = 1;
         var four1Choose:Number = 1;
         var four2Choose:Number = 1;
         var four3Choose:Number = 1;
         var four4Choose:Number = 1;
         var four5Choose:Number = 1;
         var four6Choose:Number = 1;
         var four7Choose:Number = 1;
         var four8Choose:Number = 1;
      }
      
      private function toShibo(e:MouseEvent) : void
      {
         var urls:String = "http://bbs.61.com/frame.php?frameon=yes&referer=http%3A//bbs.61.com/forumdisplay.php%3Ffid%3D10";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function toQuestionnaire(e:MouseEvent) : void
      {
         var urls:String = "http://event.2125.com/survey/mole";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function toMoleDou(e:MouseEvent) : void
      {
         var urls:String = "http://app.61.com/dou/ ";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function toPay61Fun(e:MouseEvent) : void
      {
         AgentClass.instance.AgentRegistration(10000,"pay61");
      }
      
      private function to2125treasure(e:MouseEvent) : void
      {
         var urls:String = "http://event.2125.com/treasure";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onGotoHaoma(e:MouseEvent) : void
      {
         var urls:String = "http://account.61.com/haoma?tmcid=29";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onGotoM61(e:MouseEvent) : void
      {
         var urls:String = "http://m.61.com";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onTaoBao(e:MouseEvent) : void
      {
         var urls:String = "http://bus.61.com/diary/read?uid=99993&id=920";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onYayale(e:MouseEvent) : void
      {
         var urls:String = "http://yayale.cnnice.com/newyear";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onMoleKadingChe(e:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67748609);
         var urls:String = "http://m.61.com/car/index";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onTongyiku(e:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67748629);
         var urls:String = "http://www.tongyiku.com";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function onAppStone(event:MouseEvent) : void
      {
         var urls:String = "http://itunes.apple.com/cn/app//id468988417?mt=8";
         var targetURL:URLRequest = new URLRequest(urls);
         navigateToURL(targetURL,"_blank");
      }
      
      private function openNew(e:MouseEvent) : void
      {
         superPetLogin.cardSaleAddress();
      }
      
      private function supeStar(e:MouseEvent) : void
      {
         superPetLogin.gotoPay();
      }
      
      public function showSandUIFun(e:*) : void
      {
         var btns:String = e.target.name;
         this.newTitle = "";
         switch(btns)
         {
            case "sand_other":
               this.sandType = 1009;
               break;
            case "sand_english":
               this.sandType = 1006;
               break;
            case "sand_here":
               this.sandType = 1010;
               break;
            case "sand_result":
               this.sandType = 1012;
               break;
            case "sand_result1":
               this.sandType = 1012;
               ++this.stringBrith;
               break;
            case "last_mc.enter_btn":
               this.sandType = 1012;
               break;
            case "sand_msg":
               this.sandType = 1004;
               break;
            case "sand_msgs":
               this.sandType = 1003;
               break;
            case "sand_happy":
               this.sandType = 1004;
               break;
            case "sand_message":
               this.sandType = 1003;
               break;
            case "sand_mastRes":
               this.sandType = 1003;
               break;
            case "sand_guide":
               this.sandType = 1011;
               break;
            case "sand_brains":
               this.sandType = 1015;
               break;
            case "sand_ask":
               this.sandType = 1016;
               break;
            case "btn1":
               this.sandType = 1004;
               this.newTitle = "name:夜幕下的隱形客";
               break;
            case "btn2":
               this.sandType = 1004;
               this.newTitle = "name:骰子的魔力";
               break;
            case "btn3":
               this.sandType = 1004;
               this.newTitle = "name:呼喚鴨媽媽大行動";
               break;
            case "sand_elaine":
               this.sandType = 1010;
         }
         this.showSandUI(btns);
      }
      
      public function showSandUI(btns:String) : void
      {
         var myAle:* = undefined;
         if(!this.AlertMC.getChildByName("changAlert_sandUIMC"))
         {
            myAle = Alert.showAlert(this.AlertMC,"","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI","400,300");
            BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.next);
         }
      }
      
      private function next(e:*) : void
      {
         var info:String = null;
         var pp:sandMsgReq = new sandMsgReq();
         var msg:String = Alert.back_msg;
         var tit:String = Alert.back_tit;
         if(msg != "" && tit != "")
         {
            switch(this.nowFrame)
            {
               case 2:
                  tit += "name:勇闖南瓜迷宮";
                  break;
               case 3:
                  tit += "name:莊園保衛戰";
                  break;
               case 5:
                  tit += "name:我的課堂故事";
                  break;
               case 6:
                  tit += "name:秋日的美味我知道";
                  break;
               case 12:
                  tit += "name:絲米信箱";
            }
            if(Boolean(this.newTitle.length))
            {
               tit += this.newTitle;
            }
            if(msg == "")
            {
               this.showsandTitFool();
               return;
            }
            pp.sandFun(this.sandType,tit,msg);
            BC.addEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         }
         else
         {
            info = "";
            info = "一定要填寫標題和內容才可以哦~";
            --this.stringBrith;
            this.showLastTipUI(info);
         }
      }
      
      private function showsandTit(e:* = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         var info:String = "太好了！投稿成功\r摩爾雜志社感謝你的參與";
         this.showLastTipUI(info);
      }
      
      private function showsandTitFool() : void
      {
         var info:String = "太好了！投稿成功\r摩爾雜志社感謝你的參與";
      }
      
      private function showLastTipUI(info:String) : void
      {
         var myAle:* = undefined;
         myAle = Alert.showAlert(this.AlertMC,info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
      }
      
      private function startDragFun(eve:MouseEvent) : void
      {
         var temp:* = eve.currentTarget;
         temp.startDrag();
      }
      
      private function openBuyURL(event:MouseEvent) : void
      {
         superPetLogin.bookBuy();
      }
      
      public function openHeroBook(e:*) : void
      {
         ModuleManager.openPanel(ModuleType.NEWS_PAPER_PANEL);
      }
      
      public function sendFun2(e:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkMarblesFun2);
         finishSomethingReq.sendReq(38);
      }
      
      public function checkMarblesFun2(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkMarblesFun2);
         if(e.EventObj.Type == 38)
         {
            if(e.EventObj.Done == 0)
            {
               BC.addEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.sendMarblesFun2);
               finishedSomethingReq.sendReq(38);
            }
            else
            {
               Alert.smileAlart("    你已經領取過拉姆能量星啦！");
            }
         }
      }
      
      public function sendMarblesFun2(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.sendMarblesFun2);
         Alert.smileAlart("    哈哈！恭喜你獲得1個拉姆能量星，已經放入你的拉姆背包中！");
      }
      
      public function sendFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"danZhu",this.sendFun);
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkMarblesFun);
         finishSomethingReq.sendReq(33);
      }
      
      public function checkMarblesFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkMarblesFun);
         if(e.EventObj.Type == 33)
         {
            if(e.EventObj.Done == 0)
            {
               BC.addEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.sendMarblesFun);
               finishedSomethingReq.sendReq(33);
            }
            else
            {
               Alert.smileAlart("    你已經領取過拉姆彈珠啦！");
            }
         }
      }
      
      public function sendMarblesFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.sendMarblesFun);
         Alert.smileAlart("    哈哈！恭喜你獲得5個拉姆彈珠，已經放入你的百寶箱中！");
      }
      
      public function onSeaPanel(e:MouseEvent) : void
      {
         this.removeEvent();
         TaskDiceCurse.inst.openSystem();
      }
   }
}

