package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.module.LocusWork.MCContorl;
   import com.module.LocusWork.NumSprite;
   import com.module.query.QueryImpl;
   import com.mole.app.map.MapBase;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class SkyPlaygroundView extends MapBase
   {
      
      private static var arrTime:Array;
      
      private static var huocheState:Boolean = false;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var task_mc:MovieClip;
      
      private var goodsPath:String = "resource/allJob/icon/";
      
      private var goodsLoad:Loader;
      
      private var timer:Timer;
      
      private var goodsIdArr:Array = new Array(160825,160826,160827,160828,160829,160830,1270066,1270067,1351019,1351018);
      
      private var goodsNeedNumArr:Array = new Array(30,20,20,10,15,30,15,10);
      
      private var currGoodsNeedNum:int;
      
      private const tipsarr:Array = new Array("<b>遊戲機</b>\n兌換條件:\n30個月桂枝\n天空遊樂場的必備玩具\n放在家中，格外得耀眼啊！","<b>遊戲桌</b>\n兌換條件:\n20個月桂枝\n再沒有比它更受歡迎的了，兔子們的最愛！","<b>鴨鴨水池</b>\n兌換條件:\n20個月桂枝\n鴨子小浴池，如果你想打造一個完美的\n遊樂場，怎麼能少了它呢？","<b>蘑菇箭靶</b>\n兌換條件:\n10個月桂枝\n咻咻咻，小飛鏢飛呀飛！","<b>兔兔躲貓貓</b>\n兌換條件:\n15個月桂枝\n躲貓貓躲貓貓！叫上朋友一起來自己的家裡吧！","<b>貓咪碰碰球</b>\n兌換條件:\n30個月桂枝\n這可是天上的高科技玩具！\n不是一般小摩爾能擁有的哦！","<b>月光光兔(母)</b>\n兌換條件:\n15個月桂枝\n天上無敵可愛的萌萌小母兔子，\n牧場裡的幸運星！帶出去很拉風哦！","<b>月亮亮兔(公)</b>\n兌換條件:\n10個月桂枝\n天上可愛無敵的勇敢小公兔子，\n是月光光兔的絕佳守護者！","<b>雲朵餅乾</b>\n兌換條件:\n3個月桂枝\n雲朵餅乾用來參加淘淘樂街\n的藏寶大行動，換取大鑰匙，非常珍貴！","<b>雲朵鈴鐺</b>\n兌換條件:\n3個月桂枝\n雲朵鈴鐺用來參加淘淘樂街\n的藏寶大行動，換取大鑰匙，極其珍貴！");
      
      private const tipsarr2:Array = new Array("<b>遊戲機</b>\n    曾在天上第七屆玩具大展上榮獲十大最佳玩具稱\n號，而後被天上的小神仙們競相搶購，慢慢流傳開來！\n成為居家旅行必備之物件！","<b>遊戲桌</b>\n    採用最珍貴的月桂枝幹製作！精雕細琢的足球台\n面，上手感覺極佳，難怪吳剛都那麼喜歡它！","<b>鴨鴨水池</b>\n    一天，一個小神仙路過陽光牧場，看到滿地亂跑\n的小黃鴨，驚訝道莊園竟然有如此可愛的小生物，回\n到天上後，小神仙就依照自己的回憶，設計出了鴨鴨水\n池，風靡一時。","<b>蘑菇箭靶</b>\n    有一個神仙非常喜歡打獵。有一天，他在狩獵時\n不小心跌落到莊園，變成了一隻小紅豬，在神仙變成\n紅豬的日子裡，他漸漸和小動物們成為了朋友，並且\n開始懂得，原來每個生命都是珍貴的。後來神仙回到天\n上，就再也沒有射殺過小動物，蘑菇箭靶就是他的發明。","<b>兔兔躲貓貓</b>\n    嫦娥姐姐最喜歡小兔子了，但是天上總有那麼一\n段時間，小兔子們需要前往另外一個地方，參加兔子\n的集會。每當這個時候，嫦娥姐姐總是孤孤單單，後來\n小兔子們就造了兔兔躲貓貓，任何人鑽到躲貓貓後\n面，都會變成小兔子。","<b>貓咪碰碰球</b>\n    這個機器並沒有什麼偉大的故事，但是他的主人\n很有來頭，據說是大衛的老師，曾經把自己的畢生設\n計傳授給了大衛，也不知道是不是真的。","<b>月光光兔(母)</b>\n    嫦娥姐姐最喜歡的小兔子之一，調皮又搗蛋！","<b>月亮亮兔(公)</b>\n    嫦娥姐姐最喜歡的小兔子之二，含羞又文靜！","<b>雲朵餅乾</b>\n    雲朵餅乾，可用來參加淘淘樂街的藏寶大行動，\n換取大鑰匙，非常珍貴！","<b>雲朵鈴鐺</b>\n    雲朵鈴鐺，可用來參加淘淘樂街的藏寶大行動，\n換取大鑰匙，極其珍貴！");
      
      private var currGoodsId:int;
      
      private var fzTimer:Timer;
      
      private var dagongTime:int;
      
      public function SkyPlaygroundView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         MoveTo.CanMove = true;
         MoveTo.CanMove2 = true;
         this.task_mc = this.button_mc["task_mc"];
         this.dagongfun();
         this.setFanezhou();
         this.fzTimer = new Timer(1000);
         this.target_mc["huoche_mc"].buttonMode = true;
         BC.addEvent(this,this.fzTimer,TimerEvent.TIMER,this.setFanezhou);
         this.fzTimer.start();
         this.target_mc["huoche_mc"].gotoAndStop(1);
         this.target_mc["huoche_mc"].visible = true;
         tip.tipTailDisPlayObject(this.target_mc["huoche_mc"],"天之方舟");
         BC.addEvent(this,this.target_mc["huoche_mc"],MouseEvent.CLICK,this.huocheClick);
      }
      
      private function onGetGameAward(evt:EventTaomee) : void
      {
         var str:String = null;
         var c:int = 0;
         var i:int = 0;
         var itemID:int = 0;
         var itemCount:int = 0;
         if(LocalUserInfo.getMapID() != 4 && LocalUserInfo.getMapID() != 28)
         {
            if(LocalUserInfo.getMapID() == 3)
            {
               return;
            }
            if(Boolean(evt.EventObj.arr))
            {
               str = "    恭喜你獲得";
               c = 0;
               for(i = 0; i < evt.EventObj.arr.length; i++)
               {
                  itemID = int(evt.EventObj.arr[i].itemId);
                  itemCount = int(evt.EventObj.arr[i].itemCount);
                  if(itemID == 0)
                  {
                     str += itemCount + "摩爾豆";
                     LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemCount);
                  }
                  else if(itemID == 190743)
                  {
                     str += "," + itemCount + "根月桂枝";
                  }
                  else
                  {
                     str += "和" + itemCount;
                     str += "個超級點點豆";
                  }
               }
               str += "，快去看看吧!";
               Alert.smileAlart(str);
            }
         }
      }
      
      private function infoClick(e:MouseEvent) : void
      {
         var p:Sprite = this.addPanel(2);
         for(var i:int = 1; i < 9; i++)
         {
            tip.tipTailDisPlayObject(p["btn" + i],this.tipsarr2[i - 1]);
         }
         BC.addEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
         BC.addEvent(this,p,Event.REMOVED_FROM_STAGE,this.premoved);
      }
      
      private function pclose(e:MouseEvent) : void
      {
         var p:Sprite = e.currentTarget["parent"] as Sprite;
         this.removePanel(p.name.slice(-1));
      }
      
      private function huocheClick(e:MouseEvent) : void
      {
         var p:Sprite = this.addPanel(3);
         BC.addEvent(this,p["infoBtn"],MouseEvent.CLICK,this.infoClick);
         BC.addEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
         BC.addEvent(this,p,Event.REMOVED_FROM_STAGE,this.premoved);
      }
      
      private function addPanel(id:int) : Sprite
      {
         var s0:String = "panel" + id;
         var s1:String = "Panel" + id;
         var p:Sprite = MainManager.getAppLevel().getChildByName(s0) as Sprite;
         if(p == null)
         {
            p = GV.Lib_Map.getMovieClip(s1);
            p.name = s0;
            this.setPanel(p);
         }
         MainManager.getAppLevel().addChild(p);
         return p;
      }
      
      private function removePanel(id:*) : Sprite
      {
         var s0:String = "panel" + id;
         var s1:String = "Panel" + id;
         var p:Sprite = MainManager.getAppLevel().getChildByName(s0) as Sprite;
         if(Boolean(p))
         {
            MainManager.getAppLevel().removeChild(p);
         }
         return p;
      }
      
      private function setPanel(p:Sprite) : void
      {
         var arr:Array = null;
         var i:int = 0;
         var mc:MovieClip = null;
         var c:int = 0;
         var id:int = int(p.name.slice(-1));
         switch(id)
         {
            case 1:
            case 2:
               break;
            case 3:
               arr = [1,2,3,4,5,6,7,8];
               for(i = 1; i < 5; i++)
               {
                  mc = p.getChildByName("mc" + i) as MovieClip;
                  c = int(arr.splice(int(Math.random() * arr.length),1)[0]);
                  mc.gotoAndStop(c);
                  BC.addEvent(this,mc,MouseEvent.CLICK,this.mcClick);
                  tip.tipTailDisPlayObject(mc,this.tipsarr[mc.currentFrame - 1]);
                  BC.addEvent(this,mc,Event.REMOVED_FROM_STAGE,this.removedMC);
               }
         }
      }
      
      private function premoved(e:Event) : void
      {
         var p:Sprite = e.currentTarget as Sprite;
         BC.removeEvent(this,p,Event.REMOVED_FROM_STAGE,this.premoved);
         var id:int = int(p.name.slice(-1));
         switch(id)
         {
            case 1:
               BC.removeEvent(this,p["yes_btn"],MouseEvent.CLICK,this.pClick);
               BC.removeEvent(this,p["no_btn"],MouseEvent.CLICK,this.pClick);
               break;
            case 3:
               BC.removeEvent(this,p["infoBtn"],MouseEvent.CLICK,this.infoClick);
               BC.removeEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
               break;
            case 2:
               BC.removeEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
               break;
            case 0:
               BC.removeEvent(this,p["smcBtn"],MouseEvent.CLICK,this.pclose);
               BC.removeEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
         }
      }
      
      private function pClick(e:MouseEvent) : void
      {
         var n:String = e.currentTarget.name;
         if(n == "yes_btn")
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchangeHandlerFun);
            switch(this.currGoodsId)
            {
               case 1:
                  exchange.exchange_goods(34);
                  break;
               case 2:
                  exchange.exchange_goods(35);
                  break;
               case 3:
                  exchange.exchange_goods(36);
                  break;
               case 4:
                  exchange.exchange_goods(37);
                  break;
               case 5:
                  exchange.exchange_goods(38);
                  break;
               case 6:
                  exchange.exchange_goods(39);
                  break;
               case 7:
                  exchange.exchange_goods(40);
                  break;
               case 8:
                  exchange.exchange_goods(41);
                  break;
               case 9:
                  exchange.exchange_goods(42);
                  break;
               case 10:
                  exchange.exchange_goods(43);
            }
         }
         else
         {
            this.removePanel(1);
         }
      }
      
      private function setPropNumFun(arr:Array) : void
      {
         var p:Sprite = null;
         var titlePath:String = null;
         if(arr[0].count == 0)
         {
            Alert.smileAlart("      這裡的寶貝都需要月桂枝兌換，快去天空遊樂場找兔子們吧，他們有很多月桂枝哦！");
         }
         else if(arr[0].count < this.currGoodsNeedNum)
         {
            Alert.smileAlart("      這件寶貝需要" + this.currGoodsNeedNum + "個月桂枝兌換，你的月桂枝還不夠哦！");
         }
         else
         {
            p = this.addPanel(1);
            p["Txt1"].text = this.currGoodsNeedNum;
            p["Txt2"].text = arr[0].count;
            titlePath = GoodsInfo.getItemPathByID(this.goodsIdArr[this.currGoodsId - 1]) + this.goodsIdArr[this.currGoodsId - 1] + ".swf";
            if(this.getGoodID(this.currGoodsId) == 1351019)
            {
               titlePath = "resource/allJob/icon/" + 1351019 + ".swf";
            }
            else if(this.getGoodID(this.currGoodsId) == 1351018)
            {
               titlePath = "resource/allJob/icon/" + 1351018 + ".swf";
            }
            else if(this.getGoodID(this.currGoodsId) == 190332)
            {
               titlePath = "resource/farm/icon/" + 190332 + ".swf";
            }
            else if(this.getGoodID(this.currGoodsId) == 1270066)
            {
               titlePath = "resource/farm/icon/" + 1270066 + ".swf";
            }
            else if(this.getGoodID(this.currGoodsId) == 1270067)
            {
               titlePath = "resource/farm/icon/" + 1270067 + ".swf";
            }
            else
            {
               titlePath = GoodsInfo.getItemPathByID(this.goodsIdArr[this.currGoodsId - 1]) + this.goodsIdArr[this.currGoodsId - 1] + ".swf";
            }
            if(Boolean(this.goodsLoad))
            {
               this.goodsLoad.unload();
            }
            this.goodsLoad = new Loader();
            GC.clearChildren(p["icon"]);
            this.goodsLoad.load(new URLRequest(titlePath));
            this.goodsLoad.scaleX = this.goodsLoad.scaleY = 1.5;
            p["icon"].addChild(this.goodsLoad);
            BC.addEvent(this,p,Event.REMOVED_FROM_STAGE,this.premoved);
            BC.addEvent(this,p["yes_btn"],MouseEvent.CLICK,this.pClick);
            BC.addEvent(this,p["no_btn"],MouseEvent.CLICK,this.pClick);
         }
      }
      
      private function mcClick(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         this.currGoodsId = 1;
         var id:int = int(mc.name.slice(-1));
         if(id > 4)
         {
            this.currGoodsId = id + 4;
            this.currGoodsNeedNum = 3;
         }
         else
         {
            this.currGoodsId = mc.currentFrame;
            this.currGoodsNeedNum = this.goodsNeedNumArr[mc.currentFrame - 1];
         }
         QueryImpl.getInstance().QueryItem([190743],this.setPropNumFun);
      }
      
      private function exchangeHandlerFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchangeHandlerFun);
         this.removePanel(1);
         if(this.currGoodsId == 9)
         {
            Alert.smileAlart("      恭喜你獲得雲朵餅乾，雲朵餅乾可以換取藏寶大行動裡的大鑰匙哦！");
         }
         else if(this.currGoodsId == 10)
         {
            Alert.smileAlart("      恭喜你獲得雲朵鈴鐺，雲朵鈴鐺可以換取藏寶大行動裡的大鑰匙哦！");
         }
         else
         {
            Alert.smileAlart("      恭喜你獲得" + GoodsInfo.getItemNameByID(this.getGoodID(this.currGoodsId)) + "！快去" + GoodsInfo.getItemCollectionBoxNameByID(this.getGoodID(this.currGoodsId)) + "看看吧！");
         }
      }
      
      private function getGoodID(id:int) : int
      {
         return this.goodsIdArr[id - 1];
      }
      
      private function removedMC(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         BC.removeEvent(this,mc,Event.REMOVED_FROM_STAGE,this.removedMC);
         BC.removeEvent(this,mc,MouseEvent.CLICK,this.mcClick);
      }
      
      private function setFanezhou(e:* = null) : void
      {
         var d:Date = ServerUpTime.getInstance().date;
         var p:Sprite = MainManager.getAppLevel().getChildByName("panel3") as Sprite;
         var num:int = int(d.getMinutes() / 5) * 5 * 60 - d.getMinutes() * 60 - d.getSeconds();
         var timeMC:MovieClip = this.target_mc["timePanle"]["timeMC"] as MovieClip;
         if(Boolean(p))
         {
            d = ServerUpTime.getInstance().date;
            p["timeTxt"].text = num + 2 * 5 * 60 + "秒";
         }
         num += 5 * 60;
         var min:int = num / 60;
         var sec:int = num % 60;
         var s:String = min + (sec < 10 ? "0" + sec : sec).toString();
         new NumSprite(timeMC,int(s));
         if(Boolean(int(d.getMinutes() / 5) % 2))
         {
            this.showFz(e);
         }
         else
         {
            this.hideFz(e);
         }
      }
      
      private function showFz(e:*) : void
      {
         var txt:TextField;
         var mc:MovieClip = null;
         var tmc:MovieClip = null;
         var m:MovieClip = this.target_mc["huoche_mc"].getChildAt(0) as MovieClip;
         if(this.target_mc["huoche_mc"].currentFrame == 2)
         {
            return;
         }
         txt = this.target_mc["timePanle"]["txt"];
         txt.text = "出發";
         if(Boolean(e))
         {
            mc = this.target_mc["huoche_mc"] as MovieClip;
            MCContorl.stopTo(mc,2,function():*
            {
               tmc = mc.getChildAt(0) as MovieClip;
               tmc.play();
            });
         }
         else
         {
            mc = this.target_mc["huoche_mc"] as MovieClip;
            MCContorl.stopTo(mc,2,function():*
            {
               tmc = mc.getChildAt(0) as MovieClip;
               tmc.gotoAndStop(tmc.totalFrames);
            });
         }
      }
      
      private function hideFz(e:*) : void
      {
         var txt:TextField;
         var p:Sprite;
         var tmc:MovieClip = null;
         var mc:MovieClip = null;
         var m:MovieClip = this.target_mc["huoche_mc"].getChildAt(0) as MovieClip;
         if(this.target_mc["huoche_mc"].currentFrame == 3)
         {
            return;
         }
         txt = this.target_mc["timePanle"]["txt"];
         txt.text = "返航";
         if(Boolean(e))
         {
            mc = this.target_mc["huoche_mc"] as MovieClip;
            MCContorl.stopTo(mc,3,function():*
            {
               tmc = mc.getChildAt(0) as MovieClip;
               tmc.play();
            });
         }
         else
         {
            mc = this.target_mc["huoche_mc"] as MovieClip;
            MCContorl.stopTo(mc,3,function():*
            {
               tmc = mc.getChildAt(0) as MovieClip;
               tmc.gotoAndStop(tmc.totalFrames);
            });
         }
         p = this.removePanel(3);
         this.removePanel(1);
         this.removePanel(2);
         if(Boolean(p))
         {
            p = this.addPanel(0);
            BC.addEvent(this,p["smcBtn"],MouseEvent.CLICK,this.pclose);
            BC.addEvent(this,p["close_btn"],MouseEvent.CLICK,this.pclose);
            BC.addEvent(this,p,Event.REMOVED_FROM_STAGE,this.premoved);
         }
      }
      
      private function dagongfun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.dagongGoFun);
      }
      
      private function dagongGoFun(evt:EventTaomee) : void
      {
         var loginGame:* = undefined;
         if(evt.EventObj.type == 2 || evt.EventObj.type == 1)
         {
            if(LocalUserInfo.isVIP())
            {
               if(evt.EventObj.type == 1)
               {
                  loginGame = GV.GF.loginGame(6,2,47);
                  loginGame.loginInit(this,"testOnload");
               }
               else
               {
                  loginGame = GV.GF.loginGame(6,1,46);
                  loginGame.loginInit(this,"testOnload");
               }
            }
            else
            {
               Alert.SLAlart("    只有擁有超級拉姆的小摩爾，才能玩天空遊樂場裡的小遊戲哦！快點加入超級拉姆大家庭吧！");
            }
         }
         else if(LocalUserInfo.isVIP())
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.sendResFun);
            finishSomethingReq.sendReq(35);
         }
         else
         {
            Alert.SLAlart("    只有超級拉姆的神奇力量，才能揮動斧頭砍月桂樹哦！快點加入超級拉姆大家庭吧！");
         }
      }
      
      private function sendResFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.sendResFun);
         if(evt.EventObj.Done == 0)
         {
            this.dagongVisibleFun(true);
            this.dagongTime = 60;
            if(Boolean(this.timer))
            {
               BC.removeEvent(this,this.timer,TimerEvent.TIMER,this.dagongTimeFun);
            }
            this.timer = new Timer(1000);
            BC.addEvent(this,this.timer,TimerEvent.TIMER,this.dagongTimeFun);
            this.timer.start();
         }
         else if(evt.EventObj.Done != 0)
         {
            Alert.smileAlart("    你今天已經砍過月桂樹囉！不能太頻繁呀！請明天再過來吧！");
         }
      }
      
      private function dagongTimeFun(evt:TimerEvent) : void
      {
         --this.dagongTime;
         if(this.dagongTime < 0)
         {
            BC.removeEvent(this,this.timer,TimerEvent.TIMER,this.dagongTimeFun);
            BC.addEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.giftSucHandler);
            finishedSomethingReq.sendReq(35);
            this.dagongVisibleFun(false);
         }
      }
      
      private function giftSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.giftSucHandler);
         var msg:String = "  恭喜你獲得1個點點豆、2根月桂枝，月桂樹上的好東西還真多呀！";
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function dagongVisibleFun(vis:Boolean) : void
      {
         if(vis)
         {
            this.target_mc.dagongmc.gotoAndPlay(2);
         }
         else
         {
            this.target_mc.dagongmc.gotoAndStop(1);
         }
         this.target_mc.dagongmc.visible = vis;
         GV.MAN_PEOPLE.visible = !vis;
         this.target_mc.dagongdian.visible = !vis;
         MoveTo.CanMove = !vis;
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
         }
         if(Boolean(this.fzTimer))
         {
            this.fzTimer.stop();
         }
         this.timer = null;
         this.fzTimer = null;
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

