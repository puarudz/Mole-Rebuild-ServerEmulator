package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Tick;
   
   public class footballView extends MapBase
   {
      
      private var monsterMc:MovieClip;
      
      private var startBtn:SimpleButton;
      
      private var exitBtn:SimpleButton;
      
      private var gameIntrBtn:SimpleButton;
      
      private var runScope:Rectangle;
      
      private var curHp:int;
      
      private var totalHp:int = 100;
      
      private var lastFightTime:uint = 0;
      
      private var fightCdTime:uint = 2;
      
      private var monsterHp:uint;
      
      private var monsterMaxHp:uint = 500;
      
      private var inGame:Boolean;
      
      private var monsterHpMc:MovieClip;
      
      private var moleHpMc:MovieClip;
      
      private var handMc:MovieClip;
      
      private var isRun:Boolean;
      
      private var stopTime:uint;
      
      private var runDir:int = 1;
      
      public function footballView()
      {
         super();
      }
      
      override public function init() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function initFightMonster() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_NOTICE,this.fightMonsterNoticeHandler);
         GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_AWARD,this.fightMonsterAwardHandler);
         GF.sendSocket(CommandID.YEAR_MONSTER_FIGHT_NOTICE);
         this.monsterMc = MovieClip(depthLevel["monsterCon_mc"])["monster_mc"] as MovieClip;
         this.moleHpMc = depthLevel["moleHpMc"] as MovieClip;
         this.moleHpMc.visible = false;
         this.monsterHpMc = MovieClip(depthLevel["monsterCon_mc"])["hpMc"] as MovieClip;
         this.startBtn = depthLevel["startFight_btn"] as SimpleButton;
         this.exitBtn = topLevel["exitFight_btn"] as SimpleButton;
         this.exitBtn.visible = false;
         this.gameIntrBtn = depthLevel["gameIntr_btn"] as SimpleButton;
         this.handMc = topLevel["hand_mc"] as MovieClip;
         this.handMc.mouseChildren = false;
         this.handMc.visible = true;
         depthLevel.mouseChildren = true;
         this.startBtn.addEventListener(MouseEvent.CLICK,this.startGameHandler);
         this.exitBtn.addEventListener(MouseEvent.CLICK,this.exitGameHandler);
         this.gameIntrBtn.addEventListener(MouseEvent.CLICK,this.gameIntrHandler);
         TaomeeManager.stage.addEventListener(MouseEvent.CLICK,this.hitMonsterHandler);
         this.monsterMc.gotoAndStop("comm");
         this.runDir = -1;
         this.continueRun();
         Tick.instance.addRender(this.moveHand);
      }
      
      private function fightMonsterNoticeHandler(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         this.monsterHp = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         if(flag == 1)
         {
            this.resurrection();
         }
         this.monsterHpMc["hpBar_mc"].width = 208 * this.monsterHp / this.monsterMaxHp;
         if(this.inGame && this.monsterHp == 0)
         {
            this.exitGame();
         }
      }
      
      private function resurrection() : void
      {
      }
      
      private function startGameHandler(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         if(SystemTimeController.instance.checkSysTimeAchieve(24) && !this.inGame)
         {
            GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,this.startOrExitHandler);
            GF.sendSocket(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,1);
         }
         else
         {
            Alert.smileAlart("年獸之戰時間為:2013年2月7日到2月21日的每天14點到16點 以及19點到21點");
         }
      }
      
      private function exitGameHandler(evt:MouseEvent) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,this.startOrExitHandler);
         GF.sendSocket(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,0);
      }
      
      private function gameIntrHandler(evt:MouseEvent) : void
      {
         SimpleIntrPanelManager.show("yearMonsterFightIntr");
      }
      
      private function hitMonsterHandler(evt:MouseEvent) : void
      {
         if(!this.inGame)
         {
            return;
         }
         if(!this.monsterMc.hitTestPoint(TaomeeManager.stage.mouseX,TaomeeManager.stage.mouseY))
         {
            return;
         }
         if(this.lastFightTime == 0 || ServerUpTime.getInstance().valueDate.time / 1000 - this.lastFightTime > this.fightCdTime)
         {
            this.lastFightTime = ServerUpTime.getInstance().valueDate.time / 1000;
            GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_HIT,this.fightMonsterHitHandler);
            GF.sendSocket(CommandID.YEAR_MONSTER_FIGHT_HIT);
         }
      }
      
      private function fightMonsterHitHandler(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_HIT,this.fightMonsterHitHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         this.monsterMc.gotoAndPlay("hit");
         if(this.stopTime != 0)
         {
            clearTimeout(this.stopTime);
            this.stopTime = 0;
         }
         this.isRun = false;
         this.stopTime = setTimeout(this.continueRun,2000);
         if(state == 1)
         {
            this.handMc.gotoAndPlay(2);
         }
      }
      
      private function continueRun() : void
      {
         if(this.stopTime != 0)
         {
            clearTimeout(this.stopTime);
            this.stopTime = 0;
         }
         this.isRun = true;
         this.monsterMc.gotoAndPlay("run");
      }
      
      private function fightMonsterAwardHandler(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         var itemId:uint = recData.readUnsignedInt();
         var count:uint = recData.readUnsignedInt();
         var fightCount:uint = recData.readUnsignedInt();
         Alert.smileAlart("成功驅逐年獸,您燃放了" + fightCount + "個鞭炮,獲得了 " + GoodsInfo.getItemNameByID(itemId) + " X" + count);
      }
      
      private function fightMonsterHurtHandler(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         var recHp:uint = recData.readUnsignedInt();
         if(recHp < this.curHp)
         {
            this.monsterMc.gotoAndPlay("atk");
            if(this.stopTime != 0)
            {
               clearTimeout(this.stopTime);
               this.stopTime = 0;
            }
            this.isRun = false;
            this.stopTime = setTimeout(this.continueRun,2000);
            this.curHp = recHp;
            if(this.curHp <= 0)
            {
               Alert.angryAlart("你一不小心被年獸打敗了!等待下一場戰鬥!");
               this.exitGame();
            }
            else
            {
               this.moleHpMc["hpBar_mc"].width = 208 * this.curHp / this.totalHp;
            }
         }
      }
      
      private function startOrExitHandler(evt:SocketEvent) : void
      {
         var fightPos:Point = null;
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,this.startOrExitHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         var type:uint = recData.readUnsignedInt();
         if(type == 1)
         {
            switch(state)
            {
               case 0:
                  Alert.angryAlart("年獸之戰時間為:2013年2月7日到2月21日的每天14點到16點 以及19點到21點");
                  break;
               case 1:
                  MoveTo.CanMove = false;
                  this.curHp = this.totalHp;
                  this.inGame = true;
                  GV.onlineSocket.addCmdListener(CommandID.YEAR_MONSTER_FIGHT_HURT,this.fightMonsterHurtHandler);
                  fightPos = new Point(486,200);
                  fightPos.x += 170 - Math.random() * 340;
                  fightPos.y += 50 + Math.random() * 40;
                  this.setMolePos(fightPos);
                  PeopleManageView(GV.MAN_PEOPLE).addChild(this.moleHpMc);
                  this.moleHpMc.visible = true;
                  this.moleHpMc["hpBar_mc"].width = 208;
                  this.moleHpMc.x = -this.moleHpMc.width / 2;
                  this.moleHpMc.y = -50;
                  this.handMc.visible = true;
                  this.exitBtn.visible = true;
                  break;
               case 2:
                  Alert.angryAlart("人數已滿,請等待下一場戰鬥!");
                  break;
               case 3:
                  Alert.angryAlart("在戰鬥中陣亡的摩爾不能再參加本場戰鬥,請等待下一場戰鬥!");
                  break;
               case 4:
                  Alert.angryAlart("請等待年獸復活!");
                  break;
               case 5:
                  Alert.angryAlart("當天獎勵達到上限，請明天再來!");
            }
         }
         else
         {
            this.exitGame();
         }
      }
      
      private function moveHand(val:uint) : void
      {
         if(this.inGame)
         {
            this.handMc.x = TaomeeManager.stage.mouseX;
            this.handMc.y = TaomeeManager.stage.mouseY;
            if(this.handMc.x < 300 || this.handMc.x > 650 || this.handMc.y < 100 || this.handMc.y > 350)
            {
               this.handMc.visible = false;
            }
            else
            {
               this.handMc.visible = true;
            }
         }
         else
         {
            this.handMc.visible = false;
         }
         if(this.isRun)
         {
            MovieClip(depthLevel["monsterCon_mc"]).x = MovieClip(depthLevel["monsterCon_mc"]).x + this.runDir * 1.5;
            if(MovieClip(depthLevel["monsterCon_mc"]).x <= 300)
            {
               this.runDir = 1;
            }
            else if(MovieClip(depthLevel["monsterCon_mc"]).x >= 650)
            {
               this.runDir = -1;
            }
            if(this.runDir == 1)
            {
               this.monsterMc.scaleX = -1;
            }
            else
            {
               this.monsterMc.scaleX = 1;
            }
         }
      }
      
      private function setMolePos(pos:Point) : void
      {
         GV.onlineClass.walking(pos.x,pos.y,LocalUserInfo.getUserID());
         PeopleManageView(GV.MAN_PEOPLE).stopToHere();
         PeopleManageView(GV.MAN_PEOPLE).avatarClass.showActionWithId(PlayerActionConstant.ACTION_STAND,0);
         PeopleManageView(GV.MAN_PEOPLE).x = pos.x;
         PeopleManageView(GV.MAN_PEOPLE).y = pos.y;
         MapDepthManageLogic.setPeopleDepth(PeopleManageView(GV.MAN_PEOPLE));
      }
      
      private function exitGame() : void
      {
         this.handMc.visible = false;
         this.exitBtn.visible = false;
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_HURT,this.fightMonsterHurtHandler);
         this.inGame = false;
         MoveTo.CanMove = true;
         if(Boolean(this.moleHpMc) && PeopleManageView(GV.MAN_PEOPLE).contains(this.moleHpMc))
         {
            PeopleManageView(GV.MAN_PEOPLE).removeChild(this.moleHpMc);
         }
         this.setMolePos(new Point(160,480));
      }
      
      private function destroyMonsterFight() : void
      {
         if(this.stopTime != 0)
         {
            clearTimeout(this.stopTime);
            this.stopTime = 0;
         }
         if(Boolean(this.moleHpMc) && PeopleManageView(GV.MAN_PEOPLE).contains(this.moleHpMc))
         {
            PeopleManageView(GV.MAN_PEOPLE).removeChild(this.moleHpMc);
         }
         Tick.instance.removeRender(this.moveHand);
         depthLevel.mouseChildren = false;
         MoveTo.CanMove = true;
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_NOTICE,this.fightMonsterNoticeHandler);
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_HIT,this.fightMonsterHitHandler);
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_AWARD,this.fightMonsterAwardHandler);
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_HURT,this.fightMonsterHurtHandler);
         GV.onlineSocket.removeCmdListener(CommandID.YEAR_MONSTER_FIGHT_START_OR_EXIT,this.startOrExitHandler);
         this.startBtn.removeEventListener(MouseEvent.CLICK,this.startGameHandler);
         this.exitBtn.removeEventListener(MouseEvent.CLICK,this.exitGameHandler);
         this.gameIntrBtn.removeEventListener(MouseEvent.CLICK,this.gameIntrHandler);
         this.monsterMc.removeEventListener(MouseEvent.CLICK,this.hitMonsterHandler);
      }
   }
}

