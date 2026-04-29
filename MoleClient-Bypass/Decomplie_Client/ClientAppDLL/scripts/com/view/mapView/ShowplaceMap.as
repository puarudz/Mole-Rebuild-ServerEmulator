package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.coin.CoinBuyModle;
   import com.module.coin.ScatteredBookModule;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.sendBirthdayCard.ChargeBuyItem;
   import com.module.superPetModule.petItemModule;
   import com.view.mapView.activity.Task83.DownMp3ToLocal;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.net.URLRequest;
   import flash.utils.setTimeout;
   
   public class ShowplaceMap
   {
      
      private var CoinBuyModles:CoinBuyModle;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var bg_mc:MovieClip;
      
      private var goods:MovieClip;
      
      private var goodsBookMC:MovieClip;
      
      private var dramaBookMC:MovieClip;
      
      private var childMC:Loader;
      
      public var BC_List:Object;
      
      private var danceMusic:Sound;
      
      private var musicHand:SoundChannel;
      
      private var clothArray:Array = [100021,100023,100022];
      
      private var GoodsArray:Array = [12334,12333,12335,12338];
      
      private var tempLoader:Loader;
      
      private var loadMovieBool:Boolean;
      
      private var Movie:Sprite;
      
      public function ShowplaceMap()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         setTimeout(this.init,100);
      }
      
      private function init() : void
      {
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         this.CoinBuyModles = new CoinBuyModle();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,this.target_mc.footBtn,MouseEvent.CLICK,this.footClickHandler);
         BC.addEvent(this,this.target_mc.clothMC,MouseEvent.CLICK,this.goodItemHandler);
         BC.addEvent(this,this.target_mc.playMovie_btn,MouseEvent.CLICK,this.PlayMovie);
         BC.addEvent(this,this.target_mc.goodMC,MouseEvent.CLICK,this.goodBookHandler);
         BC.addEvent(this,this.target_mc.juben,MouseEvent.CLICK,this.jubenHandler);
         BC.addEvent(this,this.target_mc.getBookBtn,MouseEvent.CLICK,this.showBookHandler);
         BC.addEvent(this,this.top_mc.super_Btn,MouseEvent.CLICK,this.superBuy);
         BC.addEvent(this,this.top_mc.stage,Event.RESIZE,this.resizeHandler);
         BC.addEvent(this,this.target_mc.sand_btn,MouseEvent.CLICK,this.beginSandFun);
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.top_mc.super_Btn.visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
         this.target_mc.down_mp3.buttonMode = true;
         DownMp3ToLocal.getInstance().addEventFun(this.target_mc.down_mp3);
      }
      
      private function beginSandFun(eve:MouseEvent) : void
      {
         var myAle:* = undefined;
         myAle = Alert.showAlert(MainManager.getAppLevel(),"劇院","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI","400,300");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.nextSandFun);
      }
      
      private function nextSandFun(e:*) : void
      {
         var myAle:* = undefined;
         var info:String = null;
         BC.removeEvent(this,e.target,Alert.CLICK_ + "1",this.nextSandFun);
         var pp:sandMsgReq = new sandMsgReq();
         var sandType:int = 1029;
         var msg:* = Alert.back_msg;
         var tit:* = Alert.back_tit;
         if(msg != "" && tit != "")
         {
            pp.sandFun(sandType,tit,msg);
            GV.onlineSocket.addEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         }
         else
         {
            info = "一定要填寫標題和內容才可以哦~";
            myAle = Alert.showAlert(MainManager.getAppLevel(),info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         }
      }
      
      private function showsandTit(e:*) : void
      {
         var myAle:* = undefined;
         GV.onlineSocket.removeEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         var info:String = "太好了！投稿成功\r摩爾莊園管理處感謝您的參與";
         myAle = Alert.showAlert(MainManager.getAppLevel(),info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
      }
      
      private function footClickHandler(event:MouseEvent) : void
      {
         var chargeBuyItem:ChargeBuyItem = new ChargeBuyItem();
         chargeBuyItem.itemCount = 1;
         chargeBuyItem.itemID = 190100;
         chargeBuyItem.panle = 0;
         chargeBuyItem.msg = "    一個腳印已經放入你的百寶箱!";
         chargeBuyItem.url = "resource/allJob/icon/190100.swf";
         chargeBuyItem.checkHaveItem();
      }
      
      public function resizeHandler(E:Event) : void
      {
         if(this.top_mc.stage.displayState == "fullScreen")
         {
            MainManager.getRootMC().parent.addChild(this.Movie);
            MainManager.getRootMC().visible = false;
         }
         else
         {
            this.target_mc.movie_mc.addChild(this.Movie);
            MainManager.getRootMC().visible = true;
         }
      }
      
      private function superBuy(evt:MouseEvent) : void
      {
         petItemModule.setPetEffectHandler();
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 12618;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function PlayMovie(evt:MouseEvent) : void
      {
         if(!this.tempLoader)
         {
            this.target_mc.down_mp3.buttonMode = false;
            DownMp3ToLocal.getInstance().removeEventFun();
            this.depth_mc.play_mc.light.play();
            this.target_mc.mask1_mc.gotoAndStop(2);
            this.target_mc.mask2_mc.gotoAndStop(2);
            this.target_mc.parent["ef_mc"].gotoAndStop(2);
            this.tempLoader = new Loader();
            this.tempLoader.load(new URLRequest("module/flvMovie/FlvPlayer.swf"));
            BC.addEvent(this,this.tempLoader.contentLoaderInfo,Event.COMPLETE,this.completeHandler);
         }
         else if(this.loadMovieBool)
         {
            if(!this.Movie.visible)
            {
               this.target_mc.down_mp3.buttonMode = false;
               DownMp3ToLocal.getInstance().removeEventFun();
               this.target_mc.playMovie_btn.gotoAndStop(2);
               this.Movie.visible = true;
               this.depth_mc.play_mc.light.play();
               this.target_mc.mask1_mc.gotoAndStop(2);
               this.target_mc.mask2_mc.gotoAndStop(2);
               this.target_mc.parent["ef_mc"].gotoAndStop(2);
            }
            else
            {
               this.target_mc.down_mp3.buttonMode = true;
               DownMp3ToLocal.getInstance().addEventFun(this.target_mc.down_mp3);
               this.target_mc.playMovie_btn.gotoAndStop(1);
               this.Movie.visible = false;
               this.depth_mc.play_mc.light.gotoAndStop(1);
               this.target_mc.mask1_mc.gotoAndStop(1);
               this.target_mc.mask2_mc.gotoAndStop(1);
               this.target_mc.parent["ef_mc"].gotoAndStop(1);
               if(Boolean(this.tempLoader))
               {
                  BC.removeEvent(this,this.tempLoader.contentLoaderInfo,Event.COMPLETE,this.completeHandler);
                  if(this.loadMovieBool)
                  {
                     this.tempLoader.unload();
                  }
                  this.tempLoader = null;
               }
               this.loadMovieBool = false;
               if(this.Movie != null)
               {
                  this.Movie["clearClass"]();
               }
               this.Movie = null;
            }
         }
      }
      
      private function completeHandler(e:Event) : void
      {
         this.Movie = e.target.content;
         this.target_mc.movie_mc.addChild(this.Movie);
         this.Movie["init"](this.target_mc.movie_mc.rect_mc.width,this.target_mc.movie_mc.rect_mc.height);
         BC.addEvent(this,this.Movie,"onStatus",this.changeStatus);
         BC.addEvent(this,this.target_mc.b1_btn,MouseEvent.CLICK,this.playfun);
         BC.addEvent(this,this.target_mc.b2_btn,MouseEvent.CLICK,this.soundfun);
         BC.addEvent(this,this.target_mc.b3_btn,MouseEvent.CLICK,this.goFullScreen);
         BC.addEvent(this,this.target_mc.b4_btn,MouseEvent.CLICK,this.listfun);
         this.target_mc.playMovie_btn.gotoAndStop(2);
         this.loadMovieBool = true;
         this.target_mc.movie_mc.load_MC.gotoAndStop(1);
         BC.removeEvent(this,this.tempLoader.contentLoaderInfo,Event.COMPLETE,this.completeHandler);
      }
      
      private function playfun(E:MouseEvent) : void
      {
         this.Movie["controlMC"].play_icon.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function soundfun(E:MouseEvent) : void
      {
         this.Movie["controlMC"].mute_button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function listfun(E:MouseEvent) : void
      {
         this.Movie["controlMC"].more_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function goFullScreen(E:MouseEvent) : void
      {
         this.Movie["controlMC"].fullScreen_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function changeStatus(E:Event = null) : void
      {
         MovieClip(this.target_mc.b1_btn).gotoAndStop(this.Movie["controlMC"].play_icon.currentFrame);
         MovieClip(this.target_mc.b2_btn).gotoAndStop(this.Movie["controlMC"].mute_button.currentFrame);
         MovieClip(this.target_mc.b3_btn).gotoAndStop(this.Movie["controlMC"].fullScreen_btn.currentFrame);
         MovieClip(this.target_mc.b4_btn).gotoAndStop(this.Movie["controlMC"].more_btn.currentFrame);
      }
      
      private function getGoodsEvent(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 160201;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function showBookHandler(evt:MouseEvent) : void
      {
         var loadInfo:String = null;
         var str:String = null;
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("dramaBookMC"))
         {
            loadInfo = "正在打開劇本......";
            str = "resource/besmearBook/drama.swf";
            this.dramaBookMC = new MovieClip();
            this.dramaBookMC.name = "dramaBookMC";
            MainManager.getGameLevel().addChild(this.dramaBookMC);
            tempMC = new MCLoader(str,this.dramaBookMC,1,loadInfo);
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         GV.onlineSocket.addEventListener("removeMC_newsbook",this.removeDramaMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
         mcloader.clear();
      }
      
      private function removeDramaMC(evt:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMC_newsbook",this.removeDramaMC);
         GC.stopAllMC(this.childMC.content);
         GC.clearChildren(this.childMC.content);
         MainManager.getGameLevel().removeChild(this.dramaBookMC);
         this.dramaBookMC = null;
      }
      
      private function jubenHandler(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/ActorTxt.swf","正在打開劇本",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         if(this.depth_mc.deskMC.mc_2.currentFrame == 1)
         {
            this.depth_mc.deskMC.mc_2.gotoAndStop(2);
            this.depth_mc.box_1.gotoAndPlay(2);
            this.depth_mc.box_2.gotoAndPlay(2);
            this.musicHand = this.danceMusic.play(0,1000000);
         }
         else
         {
            this.depth_mc.deskMC.mc_2.gotoAndStop(1);
            this.depth_mc.box_1.gotoAndStop(1);
            this.depth_mc.box_2.gotoAndStop(1);
            this.musicHand.stop();
         }
      }
      
      private function goodBookHandler(event:MouseEvent) : void
      {
         var GOODS:Class = null;
         if(!MainManager.getAppLevel().getChildByName("goodsBookMC"))
         {
            GOODS = GV.Lib_Map.getClass("GOODS_BookMC") as Class;
            this.goodsBookMC = new GOODS() as MovieClip;
            this.goodsBookMC.name = "goodsBookMC";
            this.goodsBookMC.x = (MainManager.getStageWidth() - this.goodsBookMC.width) / 2;
            this.goodsBookMC.y = (MainManager.getStageHeight() - this.goodsBookMC.height) / 2;
            MainManager.getAppLevel().addChild(this.goodsBookMC);
            this.goodsBookMC.close_btn.addEventListener(MouseEvent.CLICK,this.closeGoodBookHandler);
            GV.onlineSocket.addEventListener("VIPBUY_EVENT",this.newBuyHandler);
         }
      }
      
      private function newBuyHandler(evt:EventTaomee) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = evt.EventObj.id;
         itemObj.price = 700;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function closeGoodBookHandler(event:MouseEvent = null) : void
      {
         this.goodsBookMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closeGoodBookHandler);
         GC.clearChildren(this.goodsBookMC);
         MainManager.getAppLevel().removeChild(this.goodsBookMC);
         this.goodsBookMC = null;
      }
      
      private function goodItemHandler(event:MouseEvent) : void
      {
         var url:String = "module/external/BooksUI/theaterBookView.swf";
         var str:String = "正在加載書本......";
         var mcName:String = "SutraBookMC";
         ScatteredBookModule.getInstance().initView(url,str,mcName);
      }
      
      private function McEventComplete(evt:Event) : void
      {
      }
      
      private function petAction_suc(evt:EventTaomee) : void
      {
         var type:uint = uint(evt.EventObj.type);
         this.target_mc["key" + type]["music" + type].gotoAndPlay(2);
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         if(this.Movie != null)
         {
            this.Movie["clearClass"]();
         }
         this.Movie = null;
         if(this.dramaBookMC != null)
         {
            this.removeDramaMC();
         }
         if(this.musicHand != null)
         {
            this.musicHand.stop();
         }
         this.musicHand = null;
         this.danceMusic = null;
         if(this.goodsBookMC != null)
         {
            this.closeGoodBookHandler();
         }
         BC.removeEvent(this);
         this.BC_List = null;
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         this.CoinBuyModles = null;
      }
   }
}

