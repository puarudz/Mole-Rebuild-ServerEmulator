package com.module.newHouse
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.waterTub.WaterTupReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.logic.task.TaskClothReviewCtrl;
   import com.module.activityModule.superPetLogin;
   import com.module.classroom.ClassAward;
   import com.module.classroom.ClassroomView;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.newHouse.ModelShowCloths.ModelShowCloths;
   import com.module.specialGoods.FootPrintsLogic;
   import com.module.specialGoods.GuestBookLogic;
   import com.module.specialGoods.HanqinBook;
   import com.module.specialGoods.HotCupLogic;
   import com.module.specialGoods.LilyPondLogic;
   import com.module.specialGoods.MaoMaoTreeLogic;
   import com.module.specialGoods.MyCardsLogic;
   import com.module.specialGoods.SpecialGoodsLoader;
   import com.module.specialGoods.TuyaBookLogic;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class GoodsLogic
   {
      
      private static var instance:GoodsLogic;
      
      public static var reshow_guest_book:String = "reshow_guest_book";
      
      public static var reshow_maomao_tree:String = "reshow_maomao_tree";
      
      public static var reshow_lilypond:String = "reshow_lilypond";
      
      public static var reshow_foot_prints:String = "reshow_foot_prints";
      
      public static var reshow_card:String = "reshow_card";
      
      public static var reshow_tuya_book:String = "reshow_tuya_book";
      
      public static var reshow_blessing:String = "reshow_blessing";
      
      private static var canotNew:Boolean = true;
      
      public var guestbook:GuestBookLogic;
      
      public var dailybook:SpecialGoodsLoader;
      
      public var bigbook:*;
      
      public var maomaotree:MaoMaoTreeLogic;
      
      public var lilypond:LilyPondLogic;
      
      public var footprints:FootPrintsLogic;
      
      public var blessing:SpecialGoodsLoader;
      
      public var mycard:MyCardsLogic;
      
      public var myprintbook:TuyaBookLogic;
      
      public var unite:*;
      
      public var goldHotCup:HotCupLogic;
      
      public var silverHotCup:HotCupLogic;
      
      public var copperHotCup:HotCupLogic;
      
      private var goodsObj:Object;
      
      private var usingGoodS:Object;
      
      private var maomaoloadGame:LoadGame;
      
      public function GoodsLogic()
      {
         super();
         if(canotNew)
         {
            throw new Error("GoodsLogic不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : GoodsLogic
      {
         if(!instance)
         {
            canotNew = false;
            instance = new GoodsLogic();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         GV.onlineSocket.addEventListener("Show_Special_Goods",this.ShowSpecialGoods);
      }
      
      public function ShowSpecialGoods(e:EventTaomee) : void
      {
         var goodsId:uint = 0;
         var movie:PlayMovie = null;
         var arr:Array = null;
         var tempNum:int = 0;
         var msg:String = null;
         this.goodsObj = e.EventObj.goodsObj;
         goodsId = uint(this.goodsObj.currentTarget.ID);
         switch(goodsId)
         {
            case 161440:
               if(!newHouseView.getInstance().editMode)
               {
                  ModuleManager.openPanel(ModuleType.BOOK_PANEL,{"swf":"MoeSecretPanel"});
               }
               break;
            case 161438:
               if(!newHouseView.getInstance().editMode)
               {
                  SimpleIntrPanelManager.show("unMesona");
               }
               break;
            case 160765:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160753:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160744:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160737:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/myAtStar.swf","正在加載我在星星上",MainManager.getGameLevel());
               }
               break;
            case 160725:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160695:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160864:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/FootPrints2011Main.swf","正在加載2011腳印",MainManager.getGameLevel());
               }
               break;
            case 160626:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/FootPrints2010Main.swf","正在加載2010腳印",MainManager.getGameLevel());
               }
               break;
            case 161022:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/FootPrints2012Main.swf","正在加載2012腳印",MainManager.getGameLevel());
               }
               break;
            case 161161:
               if(!newHouseView.getInstance().editMode)
               {
                  ModuleManager.openPanel(ModuleType.FOOT_PRINT_PANEL,2013,"正在加載2013腳印",MainManager.getGameLevel());
               }
               break;
            case 160633:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/GetBigGroupPhotoMain.swf","正在加載元旦合影動畫",MainManager.getGameLevel());
               }
               break;
            case 160617:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160618:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160619:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160549:
               if(!newHouseView.getInstance().editMode)
               {
                  ModelShowCloths.getInstance().showBtnPanel(this.goodsObj);
               }
               break;
            case 160525:
               if(!newHouseView.getInstance().editMode)
               {
                  this.ShowGoodSFunction(e.EventObj.goodsObj);
               }
               break;
            case 160540:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/GetmomoPhotoMain.swf","正在加載momo合影動畫",MainManager.getGameLevel());
               }
               break;
            case 161070:
               if(!newHouseView.getInstance().editMode)
               {
                  ModuleManager.openPanel(ModuleType.MOMO_PHOTO_PANEL);
               }
               break;
            case 160495:
               if(!newHouseView.getInstance().editMode && newEditHouseView.owner.BG.ID == 160497)
               {
                  GV.Room_DefaultRoomID = newHouseView.houseID;
                  switchMapLogic.switchMapLogicHandler(newHouseView.houseID,false,11);
               }
               break;
            case 161463:
               if(!newHouseView.getInstance().editMode && newEditHouseView.owner.BG.ID == 161462)
               {
                  GV.Room_DefaultRoomID = newHouseView.houseID;
                  switchMapLogic.switchMapLogicHandler(newHouseView.houseID,false,11);
               }
               break;
            case 160485:
               if(!newHouseView.getInstance().editMode)
               {
                  GV.Room_DefaultRoomID = 0;
                  LocalUserInfo.setMapID(0);
                  GF.switchMap(96);
               }
               break;
            case 160440:
               if(!newHouseView.getInstance().editMode)
               {
                  GF.switchMap(82,true);
               }
               break;
            case 160283:
               if(!newHouseView.getInstance().editMode)
               {
                  arr = [14,18,22,33,34,50];
                  tempNum = Math.floor(Math.random() * 6);
                  GV.Room_DefaultRoomID = 0;
                  LocalUserInfo.setMapID(0);
                  switchMapLogic.switchMapLogicHandler(arr[tempNum]);
               }
               break;
            case 1260014:
               if(!ClassroomView.getInstance().EditMode)
               {
                  if(!this.guestbook)
                  {
                     this.guestbook = new GuestBookLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_guest_book));
                  }
               }
               break;
            case 1260076:
               if(!ClassroomView.getInstance().EditMode)
               {
                  ClassAward.init(false);
               }
               break;
            case 1260067:
               if(!ClassroomView.getInstance().EditMode)
               {
                  new LoadGame("module/external/ClassTopMain.swf","正在加載班級榮譽榜。",MainManager.getGameLevel());
               }
               break;
            case 160131:
               if(!newHouseView.getInstance().editMode)
               {
                  if(!this.guestbook)
                  {
                     this.guestbook = new GuestBookLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_guest_book));
                  }
               }
               break;
            case 160424:
               if(!newHouseView.getInstance().editMode)
               {
                  if(GV.MAN_PEOPLE.address != "120000")
                  {
                     if(GV.MAN_PEOPLE.Petlevel > 0)
                     {
                        GV.MAN_PEOPLE.lamu_say("哇！魔法鏡的能量把主人變大啦！");
                        WaterTupReq.waterTub();
                     }
                     else
                     {
                        msg = "　　這是一面神奇的魔法鏡，帶著你的小拉姆一起來感受神奇的魔力吧！";
                        Alert.smileAlart(msg);
                     }
                  }
               }
               break;
            case 160426:
               if(!newHouseView.getInstance().editMode && newHouseView.isMyHouse)
               {
                  new SpecialGoodsLoader({
                     "swf":"module/external/ClothHouseBox.swf",
                     "tip":"正在打開拉姆魔法小衣櫃..."
                  });
               }
               break;
            case 160410:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------DiaryBook-----");
                  if(!this.dailybook)
                  {
                     this.dailybook = new SpecialGoodsLoader({
                        "swf":"module/external/DiaryBook.swf",
                        "tip":"正在打開日記本..."
                     });
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_daily_book"));
                  }
               }
               break;
            case 160142:
               if(!newHouseView.getInstance().editMode)
               {
                  if(!this.maomaotree)
                  {
                     this.maomaotree = new MaoMaoTreeLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_maomao_tree));
                  }
               }
               break;
            case 161102:
               if(!newHouseView.getInstance().editMode)
               {
                  if(!this.lilypond)
                  {
                     this.lilypond = new LilyPondLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_lilypond));
                  }
               }
               break;
            case 160144:
               if(!newHouseView.getInstance().editMode)
               {
                  if(newHouseView.isMyHouse)
                  {
                     superPetLogin.SatetyBoxReq();
                  }
               }
               break;
            case 160148:
               if(!newHouseView.getInstance().editMode)
               {
                  userPanelView.showUserPanel(newHouseView.houseID);
               }
               break;
            case 160168:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------FootPrints-----");
                  if(!this.footprints)
                  {
                     this.footprints = new FootPrintsLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_foot_prints));
                  }
               }
               break;
            case 160182:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------對聯-----linc");
                  new LoadGame("module/external/Unite.swf","正在打開對聯",MainManager.getGameLevel());
               }
               break;
            case 160185:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------福-----");
                  if(!this.blessing)
                  {
                     this.blessing = new SpecialGoodsLoader({
                        "swf":"module/external/Blessing.swf",
                        "tip":"正在打開福字面板..."
                     });
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_blessing));
                  }
               }
               break;
            case 160191:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------MyCards-----");
                  if(!this.mycard)
                  {
                     this.mycard = new MyCardsLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_card));
                  }
               }
               break;
            case 160192:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------mole tuya book-----");
                  if(!this.myprintbook)
                  {
                     this.myprintbook = new TuyaBookLogic();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee(reshow_tuya_book));
                  }
               }
               break;
            case 160795:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------火神金杯-----");
                  if(!this.goldHotCup)
                  {
                     this.goldHotCup = new HotCupLogic(goodsId);
                  }
                  else
                  {
                     this.goldHotCup.ShowCup();
                  }
               }
               break;
            case 160796:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------火神銀杯-----");
                  if(!this.silverHotCup)
                  {
                     this.silverHotCup = new HotCupLogic(goodsId);
                  }
                  else
                  {
                     this.silverHotCup.ShowCup();
                  }
               }
               break;
            case 160797:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("----------火神銅杯-----");
                  if(!this.copperHotCup)
                  {
                     this.copperHotCup = new HotCupLogic(goodsId);
                  }
                  else
                  {
                     this.copperHotCup.ShowCup();
                  }
               }
               break;
            case HanqinBook.ITEM_ID:
               if(!newHouseView.getInstance().editMode)
               {
                  trace("---------漢青莊園遊記-----");
                  new HanqinBook();
               }
               break;
            case 160865:
               if(!newHouseView.getInstance().editMode)
               {
                  new LoadGame("module/external/XihaBook.swf","正在加載2010嘻哈手冊",MainManager.getAppLevel());
               }
               break;
            case 160925:
               if(!newHouseView.getInstance().editMode)
               {
                  StatisticsClass.getInstance().init(67679175);
                  new LoadGame("module/external/CoolCard.swf","正在加載...",MainManager.getAppLevel());
               }
               break;
            case 160965:
               if(!newHouseView.getInstance().editMode)
               {
                  ModuleManager.openModule(ModuleType.INCREDIBLE_BOOKSHELF_PANEL);
               }
               break;
            case 161046:
               TaskClothReviewCtrl.inst.openPanel(ModuleType.CLOTH_REVIEW_2008_UP,2008001,2008027,null,true,[3,3,3,4,3,3,3,4,4,3,4,4,3,4,4,3,5,3,3,4,3,4,5,4,5,3,4]);
               break;
            case 161100:
               ModuleManager.openPanel(ModuleType.DA_BADGES_PANEL,newHouseView.houseID);
               break;
            case 161212:
               ModuleManager.openPanel("GeLiErBookpanel");
               break;
            case 161233:
               ModuleManager.openPanel("FirePlateGetPanel",1);
               break;
            case 161235:
               ModuleManager.openPanel("FirePlateGetPanel",2);
               break;
            case 161236:
               ModuleManager.openPanel("FirePlateGetPanel",3);
               break;
            case 1220335:
               MapManager.enterMap(336);
               break;
            case 161248:
               ModuleManager.openPanel("AlinaBookPanel");
               break;
            case 161249:
               ModuleManager.openPanel("MoLiYaBookPanel");
               break;
            case 161347:
            case 161348:
            case 161349:
            case 161350:
            case 161351:
            case 161352:
               movie = PlayMovie.play("resource/map/goodsLogic/" + goodsId + ".swf",null,null,function():void
               {
                  movie.destroy();
               });
         }
      }
      
      private function ShowGoodSFunction(tempObj:Object) : void
      {
         var tempMc:MovieClip = null;
         if(this.usingGoodS == null)
         {
            if(this.goodsObj.currentTarget.mc2.getChildAt(0).currentFrame == 1)
            {
               GV.MAN_PEOPLE.visible = true;
               this.usingGoodS = null;
            }
            else
            {
               this.usingGoodS = this.goodsObj;
               GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
               GV.MAN_PEOPLE.visible = false;
               tempMc = this.usingGoodS.currentTarget.mc2.getChildAt(0).getChildAt(0).mole;
               this.changMcColor(tempMc);
            }
         }
         else if(this.usingGoodS.currentTarget.name != this.goodsObj.currentTarget.name)
         {
            if(this.goodsObj.currentTarget.mc2.getChildAt(0).currentFrame == this.goodsObj.currentTarget.mc2.getChildAt(0).totalFrames)
            {
               this.usingGoodS.currentTarget.mc2.getChildAt(0).gotoAndStop(1);
               this.usingGoodS = this.goodsObj;
               GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
               GV.MAN_PEOPLE.visible = false;
               tempMc = this.goodsObj.currentTarget.mc2.getChildAt(0).getChildAt(0).mole;
               this.changMcColor(tempMc);
            }
         }
         else if(this.usingGoodS.currentTarget.name == this.goodsObj.currentTarget.name)
         {
            this.kaddishEndHandler(new EventTaomee("iskaddish"));
         }
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         this.usingGoodS.currentTarget.mc2.getChildAt(0).gotoAndStop(1);
         GV.MAN_PEOPLE.visible = true;
         this.usingGoodS = null;
      }
      
      private function changMcColor(tempMc:MovieClip) : void
      {
         var myColor:Object = GV.myInfo_Color;
         tempMc.transform.colorTransform = new ColorTransform(myColor.red / 256,myColor.green / 256,myColor.blue / 256,1);
      }
      
      public function BigBookSucc(e:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         GV.onlineSocket.removeEventListener("read_" + 5400,this.BigBookSucc);
         if(e.EventObj.result == 0)
         {
            loadGame = new LoadGame("module/external/QuestionAndAnswer.swf","正在打開試卷",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"    聰明的小摩爾，今天你已經回答了30道題目了，好好休息一下，明天再來吧。","",6,"E");
         }
      }
      
      public function removeHandler(e:Event) : void
      {
         this.guestbook = null;
         this.dailybook = null;
         this.usingGoodS = null;
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         GV.onlineSocket.removeEventListener("Show_Special_Goods",this.ShowSpecialGoods);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
      }
   }
}

