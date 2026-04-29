package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.dialogBox.DialogBox;
   import com.common.util.DisplayUtil;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.logic.socket.raimblowLoL.GetLollipopsProtocol;
   import com.module.activityModule.Presented;
   import com.module.activityModule.superPetLogin;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.FishToMap5.FishToMap5;
   import com.view.mapView.activity.Task83.DragonsTreasureActiviteCtl;
   import com.view.mapView.activity.activity201308.EliseDiary20130830;
   import com.view.mapView.housebase.HouseBase;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BugBugVale extends HouseBase
   {
      
      private var shu:MovieClip;
      
      private var cao:MovieClip;
      
      private var songshu:MovieClip;
      
      private var lamu:MovieClip;
      
      private var caobtn:SimpleButton;
      
      private var shubtn:SimpleButton;
      
      private var getBugNum:int = 0;
      
      private var shuRandom:int;
      
      private var mifeng:MovieClip;
      
      private var joinholdSign:Boolean = false;
      
      private var _seatip_mc:MovieClip;
      
      private var _sea_btn:SimpleButton;
      
      private var _isHaveGoddess:uint;
      
      private var step:uint;
      
      private var getRabbitNum:int = 0;
      
      private var treeRoot:MovieClip;
      
      private var treeHole:MovieClip;
      
      private var lamuAnimation:MovieClip;
      
      private var canGot:Boolean;
      
      private var squirrel:MovieClip;
      
      private var timer:Timer;
      
      private var checkPKTimer:Number;
      
      private var timeBackId:uint;
      
      private var escaped:Boolean;
      
      private var squirrelTip:MovieClip;
      
      private var box:DialogBox;
      
      private var isLimited:Boolean;
      
      private var ifDonedCount:int = 0;
      
      public function BugBugVale()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._seatip_mc = target_mc["seatip_mc"] as MovieClip;
         this._sea_btn = target_mc["sea_btn"] as SimpleButton;
         BC.addEvent(this,this._sea_btn,MouseEvent.CLICK,this.onClickStaBtn);
         this.shu = depth_mc["shu"] as MovieClip;
         this.cao = depth_mc["cao"] as MovieClip;
         this.caobtn = target_mc["caobtn"] as SimpleButton;
         this.caobtn.visible = false;
         target_mc.chongbtn.visible = false;
         this.shubtn = target_mc["shubtn"] as SimpleButton;
         this.songshu = top_mc["songshu"] as MovieClip;
         this.songshu.buttonMode = true;
         this.mifeng = depth_mc["mifeng"] as MovieClip;
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBugBack);
         finishSomethingReq.sendReq(305);
         BC.addEvent(this,this.shu,"playover",this.shuPlayOver);
         BC.addEvent(this,this.cao,"playover",this.caoPlayOver);
         BC.addEvent(this,this.target_mc.tuzi,"playover",this.tuziPlayOver);
         BC.addEvent(this,this.songshu,MouseEvent.CLICK,this.songshuClick);
         BC.addEvent(this,this.top_mc["superPanel"],"OpenSuperPanel",this.openSuperPanel);
         target_mc.flowerDoor.buttonMode = true;
         BC.addEvent(this,target_mc.flowerDoor,MouseEvent.CLICK,this.flowerClick);
         this.initGot();
         DragonsTreasureActiviteCtl.instance.InitMap();
         EliseDiary20130830.getInstance().serverInfo();
         BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,this.bufferHanalde);
         BufferManager.getBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT);
         FishToMap5.getInstance().init(target_mc,1,3);
      }
      
      private function onClickStaBtn(e:Event) : void
      {
         DisplayUtil.removeForParent(this._seatip_mc);
         DisplayUtil.removeForParent(this._sea_btn);
         if(this.step == 1)
         {
            setTimeout(function():void
            {
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,2);
               Alert.smileAlart("  恭喜你，獲得了神仙水，快去魔法馬車合成現身液吧。",function():void
               {
                  MapManager.enterMap(24);
               });
            },2000);
         }
      }
      
      private function bufferHanalde(e:EventTaomee) : void
      {
         this.step = uint(e.EventObj);
         if(this.step != 1)
         {
            this._seatip_mc.visible = false;
            this._sea_btn.visible = false;
            DisplayUtil.removeForParent(this._seatip_mc);
            DisplayUtil.removeForParent(this._sea_btn);
         }
      }
      
      private function onlollipopsClickItem(e:Event) : void
      {
         GetLollipopsProtocol.send(4);
      }
      
      private function initGot() : void
      {
         target_mc.dungBeetle_2.buttonMode = false;
         target_mc.dungBeetle_3.buttonMode = false;
         target_mc.dungBeetle_2.mouseEnabled = false;
         target_mc.dungBeetle_3.mouseEnabled = false;
         BC.addEvent(this,target_mc.mogu_mc,MouseEvent.CLICK,this.gotMoGuHandler);
         BC.addEvent(this,target_mc.cai1_mc,MouseEvent.CLICK,this.gotcai1_mcHandler);
         BC.addEvent(this,target_mc.cai2_mc,MouseEvent.CLICK,this.gotcai2_mcHandler);
      }
      
      private function gotMoGuHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,190657);
      }
      
      private function gotcai1_mcHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,190656);
      }
      
      private function gotcai2_mcHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,190655);
      }
      
      private function checkGetSkillItem(mc:MovieClip, item:int) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            if(!p.lamu.checkCanGetItem(item))
            {
               return;
            }
            p.lamu.geocaching(mc,function(mc:MovieClip):*
            {
               return item;
            },function(E:*):void
            {
               Alert.getIconByID_Alart(item,"    恭喜你獲得" + GoodsInfo.getItemNameByID(item) + "，已經放入你主人的百寶箱中了！");
               mc.gotoAndStop(2);
            },function(E:*):*
            {
               Alert.getIconByID_Alart(item,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(item) + "，明天再來看看吧！");
            });
         }
         else
         {
            Alert.smileAlart("    你好像還沒有帶拉姆來哦!");
         }
      }
      
      private function flowerClick(e:MouseEvent) : void
      {
         target_mc.doorControl.gotoAndPlay(2);
      }
      
      private function tuziPlayOver(e:Event) : void
      {
         if(Boolean(target_mc.tuzi.visible))
         {
            GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getRabbitSucc);
            GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getRabbitError);
            PresentGoodsReq.req(66);
         }
         this.target_mc.tuzi.gotoAndStop(1);
      }
      
      private function getRabbitSucc(e:EventTaomee) : void
      {
         if(e.EventObj.Flag == 1)
         {
            ++this.getRabbitNum;
            this.checkCanRabbit();
            Alert.getIconByID_Alart(1270016,"    發現一隻撞暈了的兔子寶寶，已經放入你的牧場倉庫中了！");
         }
         else
         {
            Alert.getIconByID_Alart(1270016,"    可憐可憐這隻的兔子吧，你今天已經抓了很多兔子了");
         }
         this.getRabbitError();
      }
      
      private function getRabbitError(e:Event = null) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getRabbitSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getRabbitError);
      }
      
      private function checkHaveRabbitBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkHaveRabbitBack);
         this.getRabbitNum = e.EventObj.Done;
         this.checkCanRabbit();
      }
      
      private function checkCanRabbit() : void
      {
         if(this.getRabbitNum < 3)
         {
            target_mc.tuzi.visible = true;
         }
         else
         {
            target_mc.tuzi.visible = false;
         }
      }
      
      private function getHChongSucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getHChongSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getHChongError);
         if(e.EventObj.Flag == 1)
         {
            GV.onlineClass.chating(0,"哈哈，黃鳳蝶幼蟲看你往哪跑，抓到你啦。");
            Alert.getIconByID_Alart(1270026,"    抓到了一隻黃鳳蝶幼蟲哦，趕快回牧場倉庫看看吧，可以在昆蟲房養成蝴蝶哦。");
            ++this.getBugNum;
            this.checkCanDebug();
         }
      }
      
      private function getHChongError(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getHChongSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getHChongError);
      }
      
      private function shuPlayOver(e:Event) : void
      {
         var timer:Timer = null;
         var mc:MovieClip = this.shu.getChildAt(0) as MovieClip;
         if(mc.currentFrame == 202)
         {
            GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getHChongSucc);
            GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getHChongError);
            PresentGoodsReq.req(77);
            PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = true;
            this.shu.gotoAndPlay(1);
         }
         else if(mc.currentFrame == 237)
         {
            timer = new Timer(100,30);
            GV.onlineClass.chating(0,"/zk");
            BC.addEvent(this,timer,TimerEvent.TIMER_COMPLETE,this.onTimer);
            timer.start();
            this.mifeng.visible = true;
            this.mifeng.play();
            this.runWithPeople();
            BC.addEvent(this,timer,TimerEvent.TIMER,this.man_peop_event);
         }
         else if(mc.currentFrame == 17 || mc.currentFrame == 109)
         {
            PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = false;
         }
         else if(mc.currentFrame == 108)
         {
            PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = true;
            this.shu.gotoAndPlay(1);
         }
      }
      
      private function caoPlayOver(e:Event) : void
      {
         if(this.songshu.currentLabel != "用户点击树叶")
         {
            this.songshu["gotoState"] = "用戶點擊樹葉";
            this.songshu.gotoAndPlay("跳下");
         }
      }
      
      private function startDance(e:Event) : void
      {
         var songshu:* = undefined;
         BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_ACTION_DANCE,this.startDance);
         songshu = this.songshu;
         setTimeout(function():void
         {
            var msg:String = null;
            var alert:* = undefined;
            songshu.gotoAndPlay("跳上");
            if(GV.MAN_PEOPLE.Petlevel == 101)
            {
               GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,getLChongSucc);
               GV.onlineSocket.addEventListener("ERROR_CMD_1116",getLChongError);
               PresentGoodsReq.req(78);
            }
            else if(GV.MAN_PEOPLE.Petlevel > 1)
            {
               msg = "好像你還沒有帶超級拉姆哦，我好想見見它。有了的話再來找我哦。";
               alert = GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            }
            else
            {
               msg = "你忘記帶拉姆過來跳舞給我看了哦！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            }
         },5000);
      }
      
      private function openSuperPanel(e:Event = null) : void
      {
         superPetLogin.gotoPay();
      }
      
      private function getLChongSucc(e:EventTaomee) : void
      {
         var mc:MovieClip = null;
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getLChongSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getLChongError);
         if(e.EventObj.Flag == 1)
         {
            this.target_mc.chongbtn.visible = false;
            mc = this.depth_mc.cao.getChildAt(0) as MovieClip;
            mc.chong.visible = false;
            Alert.getIconByID_Alart(1270027,"    好啦，給你一條藍鳳蝶幼蟲啦，已經放入你的牧場倉庫中了,要好好照顧它哦！");
         }
         else
         {
            Alert.getIconByID_Alart(1270027,"    今天好像已經給你一條了，明天再來看看吧！");
         }
      }
      
      private function getLChongError(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getLChongSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getLChongError);
         Alert.getIconByID_Alart(1270027,"    今天好像已經給你一條了，明天再來看看吧！");
      }
      
      private function songshuClick(e:MouseEvent) : void
      {
         if(this.songshu.currentLabel == "用户点击树叶")
         {
            this.songshu.gotoAndPlay("点击后要求跳舞");
         }
         else if(this.songshu.currentLabel == "点击后要求跳舞")
         {
            if(LocalUserInfo.isVIP())
            {
               BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_ACTION_DANCE,this.startDance);
               this.songshu.gotoAndPlay("松鼠跟着超拉跳舞");
            }
            else
            {
               Alert.SLAlart("    好像你還沒有帶超級拉姆哦，我好想見見它。有了的話再來找我哦。");
               this.songshu.gotoAndPlay("跳上");
            }
         }
         else if(this.songshu.currentLabel == "松鼠跟着超拉跳舞")
         {
            BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_ACTION_DANCE,this.startDance);
            this.songshu.gotoAndPlay("跳上");
         }
         else if(Boolean(this.songshu["canPlay"]))
         {
            if(this.songshu.currentLabel == "常规")
            {
               this.songshu.gotoAndPlay("第一次点击");
            }
            else if(this.songshu.currentLabel == "第一次点击")
            {
               this.songshu.gotoAndPlay("第二次点击");
            }
            else if(this.songshu.currentLabel == "第二次点击")
            {
               this.songshu.gotoAndPlay("第三次点击");
            }
            else if(this.songshu.currentLabel == "第三次点击")
            {
               this.songshu.gotoAndPlay("第四次点击");
            }
            else if(this.songshu.currentLabel == "第四次点击")
            {
               this.songshu.gotoAndPlay("第5次点击");
            }
            else if(this.songshu.currentLabel == "第5次点击")
            {
               this.songshu.gotoAndPlay("第6次点击");
            }
            else if(this.songshu.currentLabel == "第6次点击")
            {
               this.songshu.gotoAndPlay("第7次点击");
            }
            else if(this.songshu.currentLabel == "第7次点击")
            {
               this.songshu.gotoAndPlay("第8次点击");
            }
            else if(this.songshu.currentLabel == "第8次点击")
            {
               this.songshu.gotoAndPlay("常规");
            }
         }
      }
      
      public function getFrame(label:Object) : int
      {
         var oldmcCurrentLable:String = this.songshu.currentLabel;
         this.songshu.gotoAndStop(label);
         label = this.songshu.currentFrame;
         this.songshu.gotoAndPlay(oldmcCurrentLable);
         return label as int;
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         e.currentTarget.stop();
         GF.switchMap(80,true);
      }
      
      private function man_peop_event(e:TimerEvent) : void
      {
         this.runWithPeople();
      }
      
      private function runWithPeople() : void
      {
         TweenLite.to(this.mifeng,0.5,{
            "x":GV.MAN_PEOPLE.x,
            "y":GV.MAN_PEOPLE.y
         });
      }
      
      private function checkBugBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBugBack);
         this.getBugNum = e.EventObj.Done;
         this.checkCanDebug();
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkHaveRabbitBack);
         finishSomethingReq.sendReq(310);
      }
      
      private function checkCanDebug() : void
      {
         if(this.getBugNum >= 2)
         {
            this.depth_mc["CannotCatch"]();
         }
      }
      
      private function caoClick(e:MouseEvent) : void
      {
         this.cao.gotoAndStop(2);
         this.caobtn.parent.removeChild(this.caobtn);
         BC.removeEvent(this,this.caobtn,MouseEvent.CLICK,this.caoClick);
         this.caobtn = null;
      }
      
      private function randomShu() : void
      {
         this.shuRandom = int(Math.random() * 3);
      }
      
      private function initCatchSquirrel() : void
      {
         this.treeRoot = GV.MC_mapFrame["treeRoot"];
         this.treeHole = this.treeRoot["treeHole"];
         this.lamuAnimation = this.treeRoot["lamu"];
         this.squirrel = botton_mc.catchSquirrel;
         this.treeHole.buttonMode = true;
         BC.addEvent(this,this.squirrel,"squirrelAnimationEventComplete",this.squirrelAnimationEventComplete);
         BC.addEvent(this,this.lamuAnimation,"animationCompleteEvent",this.animationCompleteEventHandler);
         BC.addEvent(this,this.treeHole,MouseEvent.CLICK,this.treeHoleClick);
         BC.addEvent(this,target_mc.catchSquirrelTip,MouseEvent.CLICK,this.catchSquirrelTipClick);
         BC.addEvent(this,botton_mc.catchSquirrel,MouseEvent.CLICK,this.onCatchSquirrel);
         BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
         var obj0:Object = {
            "btn":this.squirrel,
            "mc":new MovieClip(),
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         throwHitTest.HitTestMC(obj0);
         this.botton_mc.catchSquirrel.visible = true;
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishHandler);
         finishSomethingReq.sendReq(336);
         BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.lahm_go_home);
      }
      
      private function catchSquirrelTipClick(e:MouseEvent) : void
      {
         var fla_squirrelTip:Class = null;
         if(this.squirrelTip == null)
         {
            fla_squirrelTip = GV.Lib_Map.getClass("fla_squirrelTip");
            this.squirrelTip = new fla_squirrelTip();
            this.squirrelTip.x = GV.MC_AppLever.stage.stageWidth / 2;
            this.squirrelTip.y = GV.MC_AppLever.stage.stageHeight / 2;
            GV.MC_TopLever.addChild(this.squirrelTip);
            BC.addEvent(this,this.squirrelTip.close_btn,MouseEvent.CLICK,this.squirrelTipClose);
         }
         else
         {
            this.squirrelTip.x = GV.MC_AppLever.stage.stageWidth / 2;
         }
      }
      
      private function squirrelTipClose(e:MouseEvent) : void
      {
         this.squirrelTip.x = -500;
      }
      
      private function finishHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishHandler);
         var obj:Object = e.EventObj;
         if(obj.Type == 336)
         {
            this.ifDonedCount = e.EventObj.Done;
            if(this.ifDonedCount >= 2)
            {
               this.isLimited = true;
               this.botton_mc.catchSquirrel.visible = false;
            }
         }
      }
      
      private function squirrelAnimationEventComplete(e:Event) : void
      {
         e.stopPropagation();
         if(this.squirrel.currentFrame == 4)
         {
            this.canGot = true;
         }
         else if(this.squirrel.currentFrame == 7)
         {
            if(this.joinholdSign)
            {
               this.squirrel.gotoAndStop(9);
               this.timeBackId = setTimeout(this.squarrlGoBack,15 * 1000);
            }
            else
            {
               this.squirrel.gotoAndStop(8);
            }
         }
         else if(this.squirrel.currentFrame == 8 || this.squirrel.currentFrame == 5)
         {
            this.escaped = true;
            GV.onlineClass.chating(0,"/fd");
         }
         else if(this.squirrel.currentFrame == 6)
         {
            this.escaped = true;
            GV.onlineClass.chating(0,"/fd");
         }
      }
      
      private function squarrlGoBack() : void
      {
         var saidMsg:String = null;
         clearTimeout(this.timeBackId);
         if(this.squirrel.currentFrame == 9 && !this.canGot)
         {
            this.squirrel.gotoAndStop(6);
            if(this.lamuAnimation.currentFrame > 1)
            {
               saidMsg = "唉~，眼睜睜地看著可愛的小松鼠逃跑了。";
               if(this.box == null)
               {
                  this.box = DialogBox.showDialogBox(saidMsg,5000);
                  top_mc.addChild(this.box);
               }
               else
               {
                  this.box.say(saidMsg,5000);
                  top_mc.addChild(this.box);
               }
               this.box.setPosXY(744,380);
            }
         }
      }
      
      private function getHitTestInfo(evt:EventTaomee) : void
      {
         var randomID:int = 0;
         var saidMsg:String = null;
         if(this.squirrel.currentFrame == 9)
         {
            randomID = Math.random() * 100;
            if(randomID < 50)
            {
               this.squirrel.gotoAndStop(4);
               GV.onlineClass.chating(0,"/wx");
               if(this.lamuAnimation.currentFrame > 1)
               {
                  saidMsg = "小主人好厲害，一下就把小松鼠打暈了。";
                  if(this.box == null)
                  {
                     this.box = DialogBox.showDialogBox(saidMsg,5000);
                     top_mc.addChild(this.box);
                  }
                  else
                  {
                     this.box.say(saidMsg,5000);
                     top_mc.addChild(this.box);
                  }
                  this.box.setPosXY(744,380);
               }
            }
         }
      }
      
      private function animationCompleteEventHandler(e:Event) : void
      {
         e.stopPropagation();
         var saidMsg:String = "小主人，你放心趕松鼠吧，這裡有我看著，到時候就看你的水彈了。";
         if(this.squirrel.currentFrame == 7 || this.squirrel.currentFrame == 9)
         {
            saidMsg = "小主人快快用你的水彈。";
         }
         else if(this.squirrel.currentFrame == 8 && !this.escaped)
         {
            saidMsg = "小主人動作不夠快啊。";
         }
         else if(this.squirrel.currentFrame == 6 && !this.escaped)
         {
            saidMsg = "唉~，眼睜睜地看著可愛的小松鼠逃跑了。";
         }
         else if(this.escaped)
         {
            saidMsg = "真可惜，這次沒能捉到可愛的小松鼠。";
         }
         else if(this.isLimited)
         {
            saidMsg = "今天已經抓到了" + this.ifDonedCount + "隻小松鼠。其他小松鼠好像都害怕躲起來了，明天再來吧小主人。";
         }
         else if(this.canGot && this.squirrel.visible)
         {
            saidMsg = "小主人好厲害，一下就把小松鼠打暈了。";
         }
         else if(this.canGot)
         {
            saidMsg = "今天真高興，抓到了" + (this.ifDonedCount + 1) + "隻可愛的小松鼠。";
         }
         else if(this.squirrel.visible == false)
         {
            saidMsg = "好像松鼠都躲起來了，明天再來吧小主人。";
         }
         if(this.box == null)
         {
            this.box = DialogBox.showDialogBox(saidMsg,5000);
            top_mc.addChild(this.box);
         }
         else
         {
            this.box.say(saidMsg,5000);
            top_mc.addChild(this.box);
         }
         this.box.setPosXY(744,380);
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.moleStartMoveHandler);
      }
      
      private function lahm_go_home(e:Event) : void
      {
         this.moleStartMoveHandler();
      }
      
      private function moleStartMoveHandler(e:Event = null) : void
      {
         BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.moleStartMoveHandler);
         PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = true;
         this.joinholdSign = false;
         this.lamuAnimation.gotoAndStop(1);
         if(this.squirrel.currentFrame == 9)
         {
            this.squirrel.gotoAndStop(8);
         }
         if(Boolean(this.box))
         {
            this.box.stop();
            if(top_mc.contains(this.box))
            {
               top_mc.removeChild(this.box);
            }
         }
      }
      
      private function treeHoleClick(e:MouseEvent) : void
      {
         if(PeopleManageView(GV.MAN_PEOPLE).Petlevel <= 1)
         {
            Alert.smileAlart("    這個樹洞好像是小松鼠的必經之路，拉姆或許能幫忙一起抓到松鼠。");
            return;
         }
         if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 1)
         {
            PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = false;
            if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 1)
            {
               this.lamuAnimation.gotoAndStop(2);
            }
            this.joinholdSign = true;
         }
      }
      
      private function onCatchSquirrel(evt:MouseEvent) : void
      {
         if(this.canGot)
         {
            Presented.getInstance().FreeReceive(88);
            this.squirrel.visible = false;
            return;
         }
         if(this.squirrel.currentFrame == 1)
         {
            this.squirrel.gotoAndStop(7);
         }
      }
      
      override public function destroy() : void
      {
         EliseDiary20130830.getInstance().destroy();
         if(Boolean(this.squirrelTip))
         {
            GV.MC_TopLever.removeChild(this.squirrelTip);
         }
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            if(Boolean(p.petmc))
            {
               p.petmc.visible = true;
            }
            p.pet_hitBtn.visible = true;
         }
         DragonsTreasureActiviteCtl.instance.destroy();
         BC.removeEvent(this,controlLevel["lollipops"],MouseEvent.CLICK,this.onlollipopsClickItem);
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,this.bufferHanalde);
         super.destroy();
      }
   }
}

