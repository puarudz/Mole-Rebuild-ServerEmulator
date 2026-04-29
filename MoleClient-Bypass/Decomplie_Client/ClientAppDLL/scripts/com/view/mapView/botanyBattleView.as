package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.dialogBox.DialogBox;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.petClass.ListItem.PetStep5ClassSocket;
   import com.module.query.QueryImpl;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class botanyBattleView extends MapBase
   {
      
      private static var isFirst:Boolean = true;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var isJoinGame:Boolean = false;
      
      private var level:int;
      
      private var box:DialogBox;
      
      public function botanyBattleView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         if(isFirst)
         {
            isFirst = false;
            GV.MC_mapFrame["top_mc"].movie_mc.gotoAndPlay(3);
         }
         this.initGame();
      }
      
      private function error_cmdFun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmdFun);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.checkIsOver);
         ephemeralDataSocket.setData(6,0);
         QueryImpl.getInstance().QueryItem([190611,190610,190612],this.setPropNumFun);
         this.box = DialogBox.showDialogBox("");
         this.box.removeDialogBox();
      }
      
      private function say(msg:String) : void
      {
         this.box.removeDialogBox();
         this.box.say(msg,5000);
         this.box.setPosXY(276,237);
         this.target_mc.addChild(this.box);
      }
      
      private function initGame() : void
      {
         BC.addEvent(this,this.target_mc.hitMC2,"onHit",this.joinGame);
         this.depth_mc.tips_mc.gotoAndStop("flag1");
      }
      
      private function joinGame(E:* = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmdFun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.checkIsOver);
         ephemeralDataSocket.getData(6);
      }
      
      private function checkIsOver(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmdFun);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.checkIsOver);
         var totalKillBoss:int = int(evt.EventObj.data);
         if(totalKillBoss >= 450)
         {
            Alert.smileAlart("　　真厲害！食人花已經全部被擊退了！");
         }
         else
         {
            QueryImpl.getInstance().QueryItem([190611,190610,190612],this.setPropNumFun);
            this.box = DialogBox.showDialogBox("");
            this.box.removeDialogBox();
         }
      }
      
      private function setPropNumFun(arr:Array) : void
      {
         if(arr[0].count >= 4 && arr[1].count >= 4 && arr[2].count >= 4)
         {
            if(this.isJoinGame)
            {
               return;
            }
            this.isJoinGame = true;
            this.target_mc.join2_btn.visible = false;
            this.target_mc.game_mc.item1_num = arr[0].count;
            this.target_mc.game_mc.item2_num = arr[1].count;
            this.target_mc.game_mc.item3_num = arr[2].count;
            this.target_mc.game_mc.bossTotal = 24 + this.level * 4;
            this.target_mc.game_mc.gotoAndStop("start");
            setTimeout(this.target_mc.game_mc.showInfo,100);
            BC.addEvent(this,this.target_mc.game_mc,"useSkill",this.useSkillFun);
            BC.addEvent(this,this.target_mc.game_mc,"win",this.winFun);
            BC.addEvent(this,this.target_mc.game_mc,"fail",this.failFun);
            this.depth_mc.tips_mc.gotoAndStop("flag2");
         }
         else
         {
            Alert.smileAlart("　　至少需要三種戰鬥植物各 4個，才能參加戰鬥，快去收集吧！");
            PeopleManageView(GV.MAN_PEOPLE).moveTo(61,390);
         }
      }
      
      private function winFun(E:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1208,this.getPalaceHeightBack);
         PetStep5ClassSocket.setPillarHeight(2,1);
      }
      
      private function getPalaceHeightBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1208,this.getPalaceHeightBack);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.addnumFun);
         ephemeralDataSocket.getData(6);
      }
      
      private function addnumFun(evt:EventTaomee = null) : void
      {
         if(evt.EventObj.type != 6)
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.addnumFun);
         var totalKillBoss:int = int(evt.EventObj.data) + 30;
         if(totalKillBoss >= 450)
         {
            Alert.smileAlart("　　真厲害！你已經擊退很多食人花了！");
         }
         else
         {
            Alert.smileAlart("　　哇！你一共已經擊退" + totalKillBoss + "隻食人花，快去圖騰外面看看圖騰有沒有被修復吧！");
         }
         ephemeralDataSocket.setData(6,totalKillBoss);
         PeopleManageView(GV.MAN_PEOPLE).moveTo(61,390);
         this.clearGame();
         this.target_mc.lamu_mc.gotoAndStop("show");
      }
      
      private function clearGame() : void
      {
         this.target_mc.join2_btn.visible = true;
         BC.removeEvent(this,this.target_mc.game_mc);
         this.target_mc.mask_mc.gotoAndStop(1);
         this.target_mc.gotoAndStop(2);
         this.target_mc.gotoAndStop(1);
         this.isJoinGame = false;
      }
      
      private function failFun(E:*) : void
      {
         Alert.smileAlart("　　你沒能打敗食人花呀！圖騰裡的食人花好像越來越多啦！加油加油呀！");
         this.clearGame();
         PeopleManageView(GV.MAN_PEOPLE).moveTo(61,390);
      }
      
      private function useSkillFun(E:EventTaomee) : void
      {
         var mc:MovieClip = null;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         mc = E.EventObj as MovieClip;
         p.lamu.geocaching(mc as DisplayObjectContainer,function():void
         {
            var boss_mc:MovieClip = null;
            var pi:Point = mc.parent.localToGlobal(new Point(mc.x,mc.y));
            var bossArr:Array = target_mc.game_mc["bossArr"];
            if(!bossArr)
            {
               bossArr = [];
            }
            for(var i:int = 0; i < bossArr.length; i++)
            {
               boss_mc = bossArr[i];
               if(boss_mc.box)
               {
                  if(boss_mc.hitTestPoint(pi.x,pi.y - 10,true))
                  {
                     boss_mc.xue = 0;
                     boss_mc.hitBoss();
                  }
               }
            }
         });
      }
      
      override public function destroy() : void
      {
         this.clearGame();
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

