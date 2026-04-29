package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.enterGame.EnterGameRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.logic.socket.moleshow.MoleShow;
   import com.module.LocusWork.MCContorl;
   import com.module.LocusWork.NumSprite;
   import com.module.activityModule.SoundControlModule;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.coin.CoinBuyModle;
   import com.module.coin.SutraBookModule;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.mapView.activity.Task83.SuperPrivilegeCtl;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.media.Sound;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ShowBarView extends MapBase
   {
      
      private static const MedalExp:Array = [0,2,101,301,601,901,1301,1601,1901,2401,2801,3401,4001,5001,5501,6301,7301,8401,9001,10001,11001,12601,13601,15001,16401,18401,19801,21201,22601,25000,25000];
      
      private static var grayColorArray:Array = [0.63,0.63,0.63,0,0,0.63,0.63,0.63,0,0,0.63,0.63,0.63,0,0,0.63,0.63,0.63,0,0,0,0,0,1,0];
      
      private var CoinBuyModles:CoinBuyModle;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var clothBookMC:MovieClip;
      
      private var danceMusic:Sound;
      
      private var clothArray:Array = [100025,100043,100002,100008,100044,100042,100033,100009,100045,100032,100047,100001,100010,100028,100029,100526,100524,100072,100528,100070];
      
      private var joinRequest:EnterGameReq = new EnterGameReq();
      
      private var presentUserID:uint = 0;
      
      private var timeoutID:uint = 0;
      
      private var socre0:uint = 0;
      
      private var socre1:uint = 0;
      
      private var socre2:uint = 0;
      
      private var itemID:uint = 0;
      
      private var canPlay:Boolean = true;
      
      private var lvl:uint = 0;
      
      private var exp:uint = 0;
      
      private var medalLvl:int = 0;
      
      private var onTime:Boolean = false;
      
      private var wordsArr00:Array = new Array();
      
      private var wordsArr01:Array = new Array();
      
      private var wordsArr02:Array = new Array();
      
      private var wordsArr03:Array = new Array();
      
      private var wordsArr04:Array = new Array();
      
      private var wordsArr10:Array = new Array();
      
      private var wordsArr11:Array = new Array();
      
      private var wordsArr12:Array = new Array();
      
      private var wordsArr13:Array = new Array();
      
      private var wordsArr14:Array = new Array();
      
      private var wordsArr20:Array = new Array();
      
      private var wordsArr21:Array = new Array();
      
      private var wordsArr22:Array = new Array();
      
      private var wordsArr23:Array = new Array();
      
      private var wordsArr24:Array = new Array();
      
      public function ShowBarView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.CoinBuyModles = new CoinBuyModle();
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         this.target_mc.startShow.buttonMode = true;
         BC.addEvent(this,this.target_mc.buyBtn,MouseEvent.CLICK,this.buyNewHandler);
         BC.addEvent(this,this.botton_mc.bookBtn,MouseEvent.CLICK,this.loadClothHandler);
         this.showInit();
         SystemEventManager.addEventListener("openSuperPrivilegeBook",this.onOpenSuperPrivilegeBook);
         SystemEventManager.addEventListener("clickMomo",this.momoSay);
      }
      
      private function momoSay(e:*) : void
      {
         var tFunc:Function = function():void
         {
            target_mc.chat0.visible = false;
         };
         this.target_mc.chat0.visible = true;
         setTimeout(tFunc,5000);
      }
      
      private function onOpenSuperPrivilegeBook(e:Event) : void
      {
         SuperPrivilegeCtl.getInstance().onOpenSuperPrivilegeBook();
      }
      
      private function onMouseOverJoin(event:MouseEvent) : void
      {
         depthLevel.joinBtn.gotoAndStop(2);
      }
      
      private function onMouseOutJoin(event:MouseEvent) : void
      {
         depthLevel.joinBtn.gotoAndStop(1);
      }
      
      private function onMouseOverExchange(event:MouseEvent) : void
      {
         depthLevel.exchangBtn.gotoAndStop(2);
      }
      
      private function onMouseOutExchange(event:MouseEvent) : void
      {
         depthLevel.exchangBtn.gotoAndStop(1);
      }
      
      private function onOpenMainPanel(event:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67748893);
         ModuleManager.openPanel(ModuleType.COSPLAY_MAIN_PANEL);
      }
      
      private function onOpenExchangePanel(event:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.COSPLAY_EXCHANGE_PANEL);
      }
      
      private function showInit() : void
      {
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.joinShow);
         BC.addEvent(this,GV.onlineSocket,EnterGameRes.ENTER_GAME,this.enterGameHandler);
         BC.addEvent(this,GV.onlineSocket,ClientOnLineSerSocket.ERROR_GAME,this.haveSitHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1949,this.leaveGameHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1936,this.getOnTimeHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1932,this.getScoreHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1935,this.onTimeHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1950,this.getExpHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1951,this.lvlupHandler);
         MoleShow.getOnTime();
         MoleShow.getExp();
         finishSomethingReq.sendReq(211);
         BC.addEvent(this,GV.onlineSocket,"FINISH_SOMETHING_SUCC",this.checkFinishedTime);
         BC.addEvent(this,this.botton_mc.chooseBtn,MouseEvent.CLICK,this.showBord);
         BC.addEvent(this,this.target_mc.lvlBord.close_btn,MouseEvent.CLICK,this.hideBord);
         MainManager.getRootMC().addChild(this.target_mc.lvlBord);
         this.initArr();
      }
      
      private function initArr() : void
      {
         this.wordsArr00.push("很樸素的裝扮，下次還是把你壓箱底的寶貝都穿出來看看吧","搭配的還行，就是樣式有些單一","看得出你平時生活一定很忙碌，不過還是要多抽出點時間照顧一下自己");
         this.wordsArr01.push("恩，你衣服的整體色調是我喜歡的","不要太在意那些金光閃閃的東西，整體的搭配才是最重要的","成為莊園裡最熱心的人，你就會成為最漂亮的");
         this.wordsArr02.push("你服裝的整體色調和搭配都是相當出色的","看得出你平時一定很樂於助人的，哈哈","你現在的搭配應該進一步的向套裝方向發展","樣式簡約，風格樸素，不錯","整體感覺很不錯，我很期待你的下次表現");
         this.wordsArr03.push("太出色了，完美的搭配協調的色調","這絕對是本次評選中最引人注目的搭配之一","我會把你的搭配記下來的，我也考慮試穿一下","你應該給自己照張像，真是非常出色的裝扮","這就對了，教科書般的搭配，毫無瑕疵");
         this.wordsArr04.push("你把自己的裝扮經驗寫成書吧，我要在大學裡教授你的著裝經驗","如果可以的話我一定要和你合影","完美、充滿創意、極致簡約，太令人激動了","如果我現在還年輕，我一定會把你作為偶像的");
         this.wordsArr10.push("我建議你去參與最少裝扮獎","哦，我相信你一定是不小心被擠上台的","額，穿的很有特點，下一位選手可以準備上台了");
         this.wordsArr11.push("看得出你已經對服飾小有心得了","再加上一些獨特的飾品一定會增色不少","簡約而不簡單，很棒");
         this.wordsArr12.push("恩，這是非常出色的搭配和色調","充滿激情的搭配，給人振奮人心的感覺","我相信西索看了你的搭配也會認可的","看起來就充滿著激情與活力","我相信，你可以將引領時尚作為自己的發展目標");
         this.wordsArr13.push("相當獨創的搭配，開闊了我的眼界","好多的飾品呀，好像是穿著摩爾的衣服一樣，哈哈～","天衣無縫的搭配，絕對可以讓西索也佩服你的","就是這種套裝的感覺，這才稱得上優秀","毫無疑問，這將成為本次比賽中的經典");
         this.wordsArr14.push("多麼精彩的搭配呀，能夠看到你的裝扮本身就是一種享受","完美的組合加上獨特的創意，你注定會引領摩爾莊園的時尚之風","我真是無法想象出還有什麼樣的搭配能達到你這樣的境界","不要動，讓我拍張照，你的裝扮簡直就是一件藝術品");
         this.wordsArr20.push("注意，我們這裡是時尚裝扮大賽","下次來服裝店的時候，記得多看看新推出的雜志","太簡單了，缺乏層次");
         this.wordsArr21.push("恩，有不少值得注意的細節","總體不錯，但是缺少一致的品味","細節和品味是一套服飾的靈魂");
         this.wordsArr22.push("加強對時尚的敏感你可以獲得更高分的","看來你已經理解到細節的妙處","其實時尚的效果往往來源於某幾件獨特的裝扮","細節處理的不錯，但是還需要仔細研究一下時尚","細節的層次感是你目前唯一的缺憾");
         this.wordsArr23.push("豐富的層次感，獨特的品味，讓人眼前一亮呀","看得出你一定是緊跟時尚步伐的摩爾潮人","非常有品位的裝飾再加上對細節出色的處理，感覺非常好","真不錯，新鮮的搭配，給人眼前一亮的感覺","絕對是耳目一新的創意，還有令人感動的色彩搭配");
         this.wordsArr24.push("太出色了，如果我要選時尚設計師一定選你","完美的搭配，我開始考慮為你專門出一套服飾了","對時尚驚人的嗅覺，讓我都自愧不如了","對細節完美的把握，以及對時尚的高度敏感，非常完美");
      }
      
      private function showBord(e:MouseEvent) : void
      {
         this.target_mc.lvlBord.y = 460;
      }
      
      private function hideBord(e:MouseEvent) : void
      {
         this.target_mc.lvlBord.y = -50;
      }
      
      private function lvlupHandler(e:EventTaomee) : void
      {
         var tempStr:String = "\t恭喜你在時尚評選比賽中達到了" + e.EventObj.lvl + "級";
         if(e.EventObj.itemID != 0)
         {
            tempStr += ",送你一個" + GoodsInfo.getItemNameByID(e.EventObj.itemID) + "作為獎勵，加油哦！";
         }
         else
         {
            tempStr += "!";
         }
         Alert.smileAlart(tempStr);
      }
      
      private function getExpHandler(e:EventTaomee) : void
      {
         MCContorl.stopAllMC(this.target_mc.lvlBord);
         this.lvl = e.EventObj.lvl;
         this.exp = Math.max(0,e.EventObj.restExp);
         this.SetShowMedalTip();
         this.target_mc.lvlBord.level_bar.level_text.text = MedalExp[int(this.lvl)] - this.exp + "/" + MedalExp[int(this.lvl)];
         var step:int = int((MedalExp[int(this.lvl)] - this.exp) / MedalExp[int(this.lvl)] * 50);
         MovieClip(this.target_mc.lvlBord.level_bar).gotoAndStop(step);
         if(this.lvl == 0)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(1);
            this.SetMedal(0);
         }
         else if(this.lvl >= 1 && this.lvl < 3)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(2);
            this.SetMedal(1);
         }
         else if(this.lvl >= 3 && this.lvl < 7)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(3);
            this.SetMedal(2);
         }
         else if(this.lvl >= 7 && this.lvl < 10)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(4);
            this.SetMedal(3);
         }
         else if(this.lvl >= 10 && this.lvl < 14)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(5);
            this.SetMedal(4);
         }
         else if(this.lvl >= 14 && this.lvl < 20)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(6);
            this.SetMedal(5);
         }
         else if(this.lvl >= 20 && this.lvl < 25)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(7);
            this.SetMedal(6);
         }
         else if(this.lvl >= 25 && this.lvl < 30)
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(8);
            this.SetMedal(7);
         }
         else
         {
            this.target_mc.lvlBord.lvl.gotoAndStop(9);
            this.SetMedal(8);
            this.target_mc.lvlBord.level_bar.level_text.text = "";
         }
         var nsc:NumSprite = new NumSprite(this.target_mc.lvlBord["lvl_num"]);
         nsc.value = int(this.lvl);
         var d:Date = ServerUpTime.getInstance().date;
      }
      
      private function SetShowMedalTip() : void
      {
         var i:int;
         var medal:MovieClip = null;
         for(i = 1; i <= 8; i++)
         {
            var _temp_2:* = medal;
            var _temp_1:* = MouseEvent.MOUSE_OVER;
            with({})
            {
               
               var _temp_4:* = medal;
               var _temp_3:* = MouseEvent.MOUSE_OUT;
               with({})
               {
                  
                  _temp_4.addEventListener(_temp_3,function over(e:MouseEvent):void
                  {
                     var id:String = e.currentTarget["_id"];
                     if(int(id) <= medalLvl + 1)
                     {
                        MovieClip(e.currentTarget).gotoAndStop(1);
                     }
                     else
                     {
                        MovieClip(e.currentTarget).gotoAndStop(3);
                     }
                     MovieClip(target_mc.lvl_tip).y = -100;
                     try
                     {
                        target_mc.stage.removeChild(target_mc.lvl_tip);
                     }
                     catch(e:Error)
                     {
                     }
                  });
               }
            }
            
            private function SetMedal(m:int) : void
            {
               var medal:MovieClip = null;
               this.medalLvl = m;
               for(var i:int = 1; i <= 8; i++)
               {
                  medal = this.target_mc.lvlBord["Medal_" + i];
                  medal.gotoAndStop(1);
                  if(i <= this.medalLvl)
                  {
                     medal.filters = new Array();
                  }
                  else if(i == this.medalLvl + 1)
                  {
                     medal.filters = new Array(new ColorMatrixFilter(grayColorArray));
                  }
                  else
                  {
                     medal.gotoAndStop(3);
                  }
               }
            }
            
            private function checkFinishedTime(e:EventTaomee) : void
            {
               if(e.EventObj.Done >= 8)
               {
                  this.canPlay = false;
               }
            }
            
            private function getOnTimeHandler(e:EventTaomee) : void
            {
               BC.removeEvent(this,GV.onlineSocket,"read_" + 1936,this.getOnTimeHandler);
               if(e.EventObj.onTime == 1)
               {
                  this.onTime = true;
                  this.depth_mc.man0.visible = true;
                  this.depth_mc.man1.visible = true;
                  this.depth_mc.man2.visible = true;
                  this.depth_mc.subMan0.visible = true;
                  this.depth_mc.subMan1.visible = true;
                  this.depth_mc.woman.visible = true;
               }
               else
               {
                  this.onTime = false;
                  this.depth_mc.scoreBord.visible = false;
               }
            }
            
            private function onTimeHandler(e:EventTaomee) : void
            {
               if(e.EventObj.onTime == 1)
               {
                  this.onTime = true;
                  this.depth_mc.man0.visible = true;
                  this.depth_mc.man1.visible = true;
                  this.depth_mc.man2.visible = true;
                  this.depth_mc.subMan0.visible = true;
                  this.depth_mc.subMan1.visible = true;
                  this.depth_mc.woman.visible = true;
               }
               else
               {
                  this.onTime = false;
                  this.NPCleave();
                  this.depth_mc.scoreBord.visible = false;
                  this.depth_mc.subMan0.visible = false;
                  this.depth_mc.subMan1.visible = false;
                  this.depth_mc.woman.visible = false;
               }
            }
            
            private function NPCleave() : void
            {
               if(Boolean(this.depth_mc.man0.visible))
               {
                  this.depth_mc.man0.gotoAndStop(8);
               }
               if(Boolean(this.depth_mc.man1.visible))
               {
                  this.depth_mc.man1.gotoAndStop(8);
               }
               if(Boolean(this.depth_mc.man2.visible))
               {
                  this.depth_mc.man2.gotoAndStop(8);
               }
            }
            
            private function openLightEffect() : void
            {
               if(this.onTime)
               {
                  this.depth_mc.TV.gotoAndStop(1);
                  this.depth_mc.TV.visible = true;
                  this.depth_mc.scoreBord.visible = true;
               }
               this.depth_mc.topLeftLight.gotoAndStop(2);
               this.depth_mc.topRightLight.gotoAndStop(2);
               this.depth_mc.music_0.gotoAndStop(2);
               this.depth_mc.music_1.gotoAndStop(2);
               this.depth_mc.leftLight.light.visible = true;
               this.depth_mc.rightLight.light.visible = true;
            }
            
            private function closeLightEffect() : void
            {
               this.depth_mc.TV.visible = false;
               this.depth_mc.scoreBord.visible = false;
               this.depth_mc.topLeftLight.gotoAndStop(1);
               this.depth_mc.topRightLight.gotoAndStop(1);
               this.depth_mc.music_0.gotoAndStop(1);
               this.depth_mc.music_1.gotoAndStop(1);
               this.depth_mc.leftLight.light.visible = false;
               this.depth_mc.rightLight.light.visible = false;
            }
            
            private function joinShow(e:EventTaomee) : void
            {
               if(!this.onTime)
               {
                  Alert.smileAlart("\t\t還沒到開放時間哦，耐心等待吧！");
                  return;
               }
               if(this.canPlay)
               {
                  this.joinRequest.enterGame(1);
               }
               else
               {
                  Alert.showAlert(MainManager.getGameLevel(),"    你今天已經show的太累了，明天再來吧！","",6,"D");
               }
            }
            
            private function haveSitHandler(evt:EventTaomee) : void
            {
               Alert.showAlert(MainManager.getGameLevel(),"    動作慢了一步，已經有人搶先了！","",6,"D");
            }
            
            private function enterGameHandler(evt:EventTaomee) : void
            {
               this.openLightEffect();
               this.depth_mc.woman.gotoAndPlay(2);
               this.presentUserID = evt.EventObj.UserID;
               this.depth_mc.scoreBord.name_txt.text = GF.getPeopleByID(this.presentUserID).nickName;
               var tempWords:String = "";
               if(Math.random() < 0.33)
               {
                  tempWords = "加油啊！";
               }
               else if(Math.random() < 0.5)
               {
                  tempWords = "下一位：";
               }
               else
               {
                  tempWords = "別緊張，";
               }
               this.botton_mc.chat.say(tempWords + this.depth_mc.scoreBord.name_txt.text,2000);
               if(this.presentUserID == LocalUserInfo.getUserID())
               {
                  MoveTo.CanMove = false;
                  MoveTo.AutoFind(500,223,GV.MAN_PEOPLE);
                  BC.addEvent(this,GV.MAN_PEOPLE.avatarClass,"onGoOver",this.arrivalHandler);
               }
            }
            
            private function leaveGameHandler(evt:EventTaomee) : void
            {
               this.closeLightEffect();
               if(this.onTime)
               {
                  this.hideScore();
               }
            }
            
            private function arrivalHandler(e:Event) : void
            {
               if(this.presentUserID == LocalUserInfo.getUserID())
               {
                  BC.removeEvent(this,GV.MAN_PEOPLE.avatarClass,"onGoOver",this.arrivalHandler);
                  setTimeout(this.danceToAll,100);
                  if(this.onTime)
                  {
                     MoleShow.getScore();
                  }
                  clearTimeout(this.timeoutID);
                  this.timeoutID = setTimeout(this.leaveStage,10000);
               }
            }
            
            private function danceToAll() : void
            {
               var tempReq:ActionReq = null;
               if(Boolean(GV.MAN_PEOPLE.dance()))
               {
                  tempReq = new ActionReq();
                  tempReq.actions(1,0);
               }
            }
            
            private function leaveStage() : void
            {
               MoveTo.AutoFind(645,310,GV.MAN_PEOPLE);
               BC.addEvent(this,GV.MAN_PEOPLE.avatarClass,"onGoOver",this.completeShowHandler);
               LeaveGameReq.leaveGame(1);
               if(this.presentUserID == LocalUserInfo.getUserID())
               {
                  finishSomethingReq.sendReq(211);
                  MoleShow.getExp();
               }
            }
            
            private function completeShowHandler(e:Event) : void
            {
               BC.removeEvent(this,GV.MAN_PEOPLE.avatarClass,"onGoOver",this.completeShowHandler);
               MoveTo.CanMove = true;
            }
            
            private function getScoreHandler(e:EventTaomee) : void
            {
               this.socre0 = e.EventObj.socre0;
               this.socre1 = e.EventObj.socre1;
               this.socre2 = e.EventObj.socre2;
               if(this.onTime)
               {
                  this.showScore();
                  this.scoreEffect();
               }
               if(this.presentUserID == LocalUserInfo.getUserID() && e.EventObj.itemID != 0)
               {
                  Alert.getIconByID_Alart(e.EventObj.itemID,"你的裝扮真是太絕版了，送你一個" + GoodsInfo.getItemNameByID(e.EventObj.itemID) + "作為獎勵！");
               }
            }
            
            private function showScore() : void
            {
               this.depth_mc.scoreBord.score0.text = this.socre0.toString();
               this.depth_mc.scoreBord.score1.text = this.socre1.toString();
               this.depth_mc.scoreBord.score2.text = this.socre2.toString();
               this.depth_mc.scoreBord.scoreTotal.text = (this.socre0 + this.socre1 + this.socre2).toString();
               if(this.socre0 + this.socre1 + this.socre2 <= 80)
               {
                  this.depth_mc.TV.gotoAndStop(2);
               }
               else if(this.socre0 + this.socre1 + this.socre2 <= 120)
               {
                  this.depth_mc.TV.gotoAndStop(3);
               }
               else if(this.socre0 + this.socre1 + this.socre2 <= 160)
               {
                  this.depth_mc.TV.gotoAndStop(4);
               }
               else if(this.socre0 + this.socre1 + this.socre2 <= 200)
               {
                  this.depth_mc.TV.gotoAndStop(5);
               }
               else if(this.socre0 + this.socre1 + this.socre2 <= 240)
               {
                  this.depth_mc.TV.gotoAndStop(6);
               }
               else if(this.socre0 + this.socre1 + this.socre2 <= 270)
               {
                  this.depth_mc.TV.gotoAndStop(7);
               }
               else
               {
                  this.depth_mc.TV.gotoAndStop(8);
               }
            }
            
            private function hideScore() : void
            {
               this.depth_mc.scoreBord.score0.text = "";
               this.depth_mc.scoreBord.score1.text = "";
               this.depth_mc.scoreBord.score2.text = "";
               this.depth_mc.scoreBord.scoreTotal.text = "";
               this.depth_mc.scoreBord.name_txt.text = "";
               this.depth_mc.scoreBord.visible = false;
            }
            
            private function scoreEffect() : void
            {
               this.depth_mc.subMan0.gotoAndPlay(2);
               this.depth_mc.subMan1.gotoAndPlay(2);
               this.depth_mc.man0.visible = true;
               this.depth_mc.man1.visible = true;
               this.depth_mc.man2.visible = true;
               if(this.socre0 <= 20)
               {
                  this.depth_mc.man0.gotoAndStop(2);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr00[uint(Math.random() * (this.wordsArr00.length - 1))],8000);
                  }
               }
               else if(this.socre0 > 20 && this.socre0 <= 45)
               {
                  this.depth_mc.man0.gotoAndStop(3);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr00[uint(Math.random() * (this.wordsArr00.length - 1))],8000);
                  }
               }
               else if(this.socre0 > 45 && this.socre0 <= 60)
               {
                  this.depth_mc.man0.gotoAndStop(4);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr01[uint(Math.random() * (this.wordsArr01.length - 1))],8000);
                  }
               }
               else if(this.socre0 > 60 && this.socre0 <= 80)
               {
                  this.depth_mc.man0.gotoAndStop(5);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr02[uint(Math.random() * (this.wordsArr02.length - 1))],8000);
                  }
               }
               else if(this.socre0 > 80 && this.socre0 <= 90)
               {
                  this.depth_mc.man0.gotoAndStop(6);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr03[uint(Math.random() * (this.wordsArr03.length - 1))],8000);
                  }
               }
               else if(this.socre0 > 90)
               {
                  this.depth_mc.man0.gotoAndStop(7);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat0.say(this.wordsArr04[uint(Math.random() * (this.wordsArr04.length - 1))],8000);
                  }
               }
               if(this.socre1 <= 20)
               {
                  this.depth_mc.man1.gotoAndStop(2);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr10[uint(Math.random() * (this.wordsArr10.length - 1))],8000);
                  }
               }
               else if(this.socre1 > 20 && this.socre1 <= 45)
               {
                  this.depth_mc.man1.gotoAndStop(3);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr10[uint(Math.random() * (this.wordsArr10.length - 1))],8000);
                  }
               }
               else if(this.socre1 > 45 && this.socre1 <= 60)
               {
                  this.depth_mc.man1.gotoAndStop(4);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr11[uint(Math.random() * (this.wordsArr11.length - 1))],8000);
                  }
               }
               else if(this.socre1 > 60 && this.socre1 <= 80)
               {
                  this.depth_mc.man1.gotoAndStop(5);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr12[uint(Math.random() * (this.wordsArr12.length - 1))],8000);
                  }
               }
               else if(this.socre1 > 80 && this.socre1 <= 90)
               {
                  this.depth_mc.man1.gotoAndStop(6);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr13[uint(Math.random() * (this.wordsArr13.length - 1))],8000);
                  }
               }
               else if(this.socre1 > 90)
               {
                  this.depth_mc.man1.gotoAndStop(7);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat1.say(this.wordsArr14[uint(Math.random() * (this.wordsArr14.length - 1))],8000);
                  }
               }
               if(this.socre2 <= 20)
               {
                  this.depth_mc.man2.gotoAndStop(2);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr20[uint(Math.random() * (this.wordsArr20.length - 1))],8000);
                  }
               }
               else if(this.socre2 > 20 && this.socre2 <= 45)
               {
                  this.depth_mc.man2.gotoAndStop(3);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr20[uint(Math.random() * (this.wordsArr20.length - 1))],8000);
                  }
               }
               else if(this.socre2 > 45 && this.socre2 <= 60)
               {
                  this.depth_mc.man2.gotoAndStop(4);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr21[uint(Math.random() * (this.wordsArr21.length - 1))],8000);
                  }
               }
               else if(this.socre2 > 60 && this.socre2 <= 80)
               {
                  this.depth_mc.man2.gotoAndStop(5);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr22[uint(Math.random() * (this.wordsArr22.length - 1))],8000);
                  }
               }
               else if(this.socre2 > 80 && this.socre2 <= 90)
               {
                  this.depth_mc.man2.gotoAndStop(6);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr23[uint(Math.random() * (this.wordsArr23.length - 1))],8000);
                  }
               }
               else if(this.socre2 > 90)
               {
                  this.depth_mc.man2.gotoAndStop(7);
                  if(Math.random() > 0.6)
                  {
                     this.botton_mc.chat2.say(this.wordsArr24[uint(Math.random() * (this.wordsArr24.length - 1))],8000);
                  }
               }
            }
            
            private function buyNewHandler(evt:MouseEvent) : void
            {
               GV.itemID = 3;
               var itemObj:Object = new Object();
               itemObj.id = 12340;
               itemObj.price = 0;
               itemObj.info = "";
               clothBuyModule.buyAction(itemObj);
            }
            
            private function soundHandler(evt:MouseEvent) : void
            {
               if(evt.currentTarget.currentFrame == 1)
               {
                  this.target_mc.soundBtn.gotoAndStop(2);
                  SoundControlModule.getInstance().stopSund();
               }
               else
               {
                  this.target_mc.soundBtn.gotoAndStop(1);
                  SoundControlModule.getInstance().playSund();
               }
            }
            
            private function overSutraBookHandler(evt:MouseEvent) : void
            {
               GF.showTip("摩爾時尚絕版冊");
            }
            
            private function outSutraBookHandler(evt:MouseEvent) : void
            {
               GF.clearTip();
            }
            
            private function loadSutraBookHandler(evt:MouseEvent) : void
            {
               var url:String = "module/external/CoinBookUI/sutraClothBook.swf";
               var str:String = "正在加載摩爾時尚特別版......";
               var mcName:String = "SutraBookMC";
               SutraBookModule.getInstance().initView(url,str,mcName);
            }
            
            private function loadClothHandler(evt:MouseEvent) : void
            {
               var url:String = "module/external/CoinBookUI/CClothBuyBook.swf";
               var str:String = "正在加載摩爾時尚絕版冊......";
               var mcName:String = "CoinClothBookMC";
               SutraBookModule.getInstance().initView(url,str,mcName);
            }
            
            private function initClothHandler() : void
            {
               for(var i:int = 0; i < this.clothArray.length; i++)
               {
                  if(Boolean(this.target_mc["cloth_" + (i + 1)]))
                  {
                     if(i == 16)
                     {
                        this.target_mc["cloth_" + (i + 1)].addEventListener(MouseEvent.CLICK,this.loadClothHandler);
                     }
                     else if(i == 17 || i == 18)
                     {
                        this.target_mc["cloth_" + (i + 1)].addEventListener(MouseEvent.CLICK,this.loadClothHandler);
                     }
                     else
                     {
                        this.target_mc["cloth_" + (i + 1)].addEventListener(MouseEvent.CLICK,this.loadClothHandler);
                     }
                  }
               }
            }
            
            private function buyHandler(evt:MouseEvent) : void
            {
               var tempName:String = String(evt.target.name);
               var tempNum:int = int(tempName.substr(6));
               var commodityID:int = int(this.clothArray[tempNum - 1]);
               this.CoinBuyModles.BuyModle(commodityID,1);
            }
            
            override public function destroy() : void
            {
               SystemEventManager.removeEventListener("openSuperPrivilegeBook",this.onOpenSuperPrivilegeBook);
               SystemEventManager.removeEventListener("clickMomo",this.momoSay);
               clearTimeout(this.timeoutID);
               this.danceMusic = null;
               this.CoinBuyModles = null;
               this.target_mc = null;
               this.depth_mc = null;
               this.botton_mc = null;
               this.clothBookMC = null;
               super.destroy();
            }
         }
      }
      
      