package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PetClassLogic.PetClassLogic;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class farmCloneView extends MapBase
   {
      
      public static var TeamColor:ColorTransform;
      
      public var masonNPCLogic:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var effect_mc:MovieClip;
      
      private var tipMC:MovieClip;
      
      private var isFirst:Boolean = false;
      
      private var npcTime:Timer;
      
      private var NPCLogics:MovieClip;
      
      private var timer:Timer;
      
      private var taskObj:Object;
      
      public var top_mc:MovieClip;
      
      private var levelFlowersNum:int = 1;
      
      private var levelFlowers:MovieClip;
      
      private var clickFlowers:MovieClip;
      
      private var clickFlowersSign:Boolean;
      
      private var clickFlowersNum:int;
      
      private var giftObj:SharedObject;
      
      private var myTimer:Timer;
      
      private var totalNum:int;
      
      private var hasBool:Boolean = true;
      
      private var magicBool:Boolean = true;
      
      private var starBool:Boolean = true;
      
      private var nowPet_arr:Array;
      
      private var ClassNum:int;
      
      public function farmCloneView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.levelFlowers = GV.MC_mapFrame["levelFlowers"];
         this.clickFlowers = GV.MC_mapFrame["clickFlowers"];
         for(var i:int = 0; i < 6; i++)
         {
            this.target_mc.activMC["mc_" + i].mc.gotoAndStop(2);
            this.target_mc.activMC["mc_" + i].mc.mouseEnabled = false;
         }
         BC.addEvent(this,this.target_mc.farm_btn,MouseEvent.CLICK,this.farm_BtnHandler);
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            this.initGamicTestOne();
         }
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.game_BtnHandler);
      }
      
      private function initGamicTestOne() : void
      {
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getOneInfo);
         PetClassLogic.getPetClassLogics().GetPetClass(GV.MyInfo_PetObj.SpriteID);
      }
      
      private function getOneInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getOneInfo);
         this.nowPet_arr = eve.EventObj.petClassList;
         if(this.nowPet_arr.length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this.nowPet_arr.length; )
         {
            if(this.nowPet_arr[i].classID == 103 && this.nowPet_arr[i].classStep == 5)
            {
               this.ClassNum = this.nowPet_arr[i].classID;
               if(this.nowPet_arr[i].arr[5] == 1 && this.nowPet_arr[i].arr[6] == 0)
               {
                  this.depth_mc.fruit_tree.visible = true;
                  this.target_mc.farm_btn.visible = true;
                  this.target_mc.game_btn.visible = true;
               }
               break;
            }
            i++;
         }
      }
      
      private function game_BtnHandler(evt:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlt:* = undefined;
         if(evt.EventObj.type == 5)
         {
            return;
         }
         if(!this.starBool)
         {
            return;
         }
         this.starBool = false;
         GV.isGameShowTip = true;
         MoveTo.CanMove = false;
         this.target_mc.no_go_mc.visible = true;
         if(evt.EventObj.type == 1)
         {
            url = "resource/allJob/AlertPic/petMagicClass/103.swf";
            msg = "    兔子會扔石頭攻擊你哦，點擊藍色魔法球釋放魔法，你的拉姆會保護好你。看到衝來搶果子的兔子，就拿起錘子趕跑他們！別讓兔子得逞了。";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
            BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.tipAddGame);
         }
      }
      
      private function tipAddGame(event:Event) : void
      {
         for(var i:int = 1; i < 6; i++)
         {
            this.depth_mc.fruit_tree["fruiter_" + i].gotoAndStop(1);
         }
         this.target_mc.magic_btn.visible = true;
         this.target_mc.time_mc.visible = true;
         this.target_mc.hit_mc1.buttonMode = true;
         this.target_mc.hit_mc1.gotoAndStop(2);
         this.target_mc.hit_mc2.gotoAndStop(2);
         this.target_mc.hitF_mc.visible = true;
         this.target_mc.shovel_btn.visible = true;
         this.initGameTimeStar();
         this.initGameHit();
         BC.addEvent(this,GV.onlineSocket,"Oven_NORMAL",this.Ovent_NextHandler);
         BC.addEvent(this,GV.onlineSocket,"HIT_MOLE",this.hit_moleHandler);
         BC.addEvent(this,this.target_mc.magic_btn,MouseEvent.CLICK,this.magic_BtnHandler);
      }
      
      private function magic_BtnHandler(event:MouseEvent) : void
      {
         LamuMantra.xingchenshouhu("xingchenshouhu");
         this.magicBool = false;
      }
      
      private function hit_moleHandler(event:Event) : void
      {
         if(!this.magicBool)
         {
            LamuMantra.xingchenshouhu("xingchenshouhu");
            this.target_mc.hit_mc2.gotoAndStop(4);
            return;
         }
         var peopleMC:MovieClip = GV.MAN_PEOPLE;
         var FMC:MovieClip = IndexManager.getInstance().getMovieClip("molefaint");
         FMC.width *= 1.2;
         FMC.height *= 1.2;
         peopleMC.avatarMC.tomatoMC.addChild(FMC);
         this.hasBool = false;
         setTimeout(this.initGameOven,5000);
      }
      
      private function initGameOven() : void
      {
         this.hasBool = true;
      }
      
      private function Game_Ovent_NextHandler(event:Event) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlt:* = undefined;
         if(this.totalNum == 5)
         {
            GV.isGameShowTip = false;
            MoveTo.CanMove = true;
            this.target_mc.no_go_mc.visible = false;
            this.starBool = true;
            this.totalNum = 0;
            this.target_mc.hitF_mc.visible = false;
            this.target_mc.shovel_mc.visible = false;
            this.target_mc.shovel_btn.visible = false;
            this.target_mc.hit_mc1.gotoAndStop(1);
            this.target_mc.hit_mc2.gotoAndStop(1);
            this.removeGmaeOvent();
            url = "resource/allJob/AlertPic/petMagicClass/001.swf";
            msg = "    唉，我可憐的苗苗。我相信你能做到的，再試一次吧?";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok,cancel",true,false,"SMCUI");
         }
      }
      
      private function Ovent_NextHandler(event:Event) : void
      {
         ++this.totalNum;
         this.depth_mc.fruit_tree["fruiter_" + this.totalNum].gotoAndStop(2);
         BC.addEvent(this,GV.onlineSocket,"Game_Oven_NORMAL",this.Game_Ovent_NextHandler);
      }
      
      private function initGameHit() : void
      {
         BC.addEvent(this,this.target_mc.shovel_btn,MouseEvent.CLICK,this.shovelBtnDownHandler);
      }
      
      private function shovelBtnDownHandler(event:MouseEvent) : void
      {
         var sprite:MovieClip = null;
         this.magicBool = true;
         this.target_mc.shovel_btn.visible = false;
         this.target_mc.shovel_mc.visible = true;
         sprite = this.target_mc.shovel_mc;
         sprite.x = event.stageX;
         sprite.y = event.stageY;
         BC.addEvent(this,this.target_mc.shovel_mc,MouseEvent.CLICK,this.shovelMcHandler);
         BC.addEvent(this,this.target_mc.shovel_mc.stage,MouseEvent.MOUSE_MOVE,this.shovelBtnMoveHandler);
      }
      
      private function shovelBtnMoveHandler(event:MouseEvent) : void
      {
         var sprite:MovieClip = this.target_mc.shovel_mc;
         sprite.x = event.stageX;
         sprite.y = event.stageY;
      }
      
      private function shovelMcHandler(event:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"CHECK_MC",this.checkMcHandler);
         var sprite:MovieClip = this.target_mc.shovel_mc;
         this.target_mc.shovel_mc.gotoAndPlay(2);
         if(sprite.hitTestObject(this.target_mc.hitF_mc))
         {
            BC.removeEvent(this,this.target_mc.shovel_mc,MouseEvent.CLICK,this.shovelMcHandler);
            BC.removeEvent(this,this.target_mc.shovel_mc.stage,MouseEvent.MOUSE_MOVE,this.shovelBtnMoveHandler);
            this.target_mc.shovel_btn.visible = true;
            this.target_mc.shovel_mc.x = 1200;
            this.target_mc.shovel_mc.visible = false;
         }
      }
      
      private function checkMcHandler(event:Event) : void
      {
         if(!this.hasBool)
         {
            return;
         }
         var sprite:MovieClip = this.target_mc.shovel_mc.mc;
         if(sprite.hitTestObject(this.target_mc.hit_mc1))
         {
            this.target_mc.hit_mc1.gotoAndStop(3);
         }
      }
      
      private function initGameTimeStar() : void
      {
         this.myTimer = new Timer(1000,60);
         this.myTimer.addEventListener(TimerEvent.TIMER,this.timerStarHandler);
         this.myTimer.start();
      }
      
      private function timerStarHandler(event:TimerEvent) : void
      {
         var num:uint = uint(int(60 - this.myTimer.currentCount));
         var p:String = String(num);
         var lg:uint = uint(p.length);
         if(lg == 1)
         {
            if(num == 0)
            {
               this.target_mc.no_go_mc.visible = false;
               this.starBool = true;
               this.removeGmaeOvent();
               this.initGameSucceed();
               this.target_mc.time_mc.num1.gotoAndStop(1);
               this.target_mc.time_mc.num2.gotoAndStop(1);
            }
            else
            {
               this.target_mc.time_mc.num1.gotoAndStop(uint(p.charAt(0)) + 1);
               this.target_mc.time_mc.num2.gotoAndStop(1);
            }
         }
         else if(lg == 2)
         {
            this.target_mc.time_mc.num2.gotoAndStop(uint(p.charAt(0)) + 1);
            this.target_mc.time_mc.num1.gotoAndStop(uint(p.charAt(1)) + 1);
         }
      }
      
      private function initGameSucceed() : void
      {
         var i:int = 0;
         if(this.totalNum < 5)
         {
            this.target_mc.shovel_mc.visible = false;
            this.target_mc.hit_mc1.gotoAndStop(1);
            this.target_mc.hit_mc2.gotoAndStop(1);
            this.target_mc.magic_btn.visible = false;
            this.target_mc.time_mc.visible = false;
            this.target_mc.hit_mc1.buttonMode = false;
            this.target_mc.hitF_mc.visible = false;
            this.target_mc.shovel_btn.visible = false;
            for(i = 0; i < this.nowPet_arr.length; i++)
            {
               if(this.nowPet_arr[i].classID == 103)
               {
                  this.nowPet_arr[i].arr[6] = 1;
                  PetClassLogic.getPetClassLogics().setClassData(PeopleManageView(GV.MAN_PEOPLE).PetID,this.ClassNum,this.nowPet_arr[i].arr);
                  break;
               }
            }
            BC.addEvent(this,PetClassLogic.getPetClassLogics(),"set_class_data",this.set_class_data);
         }
      }
      
      private function set_class_data(event:EventTaomee) : void
      {
         GV.isGameShowTip = false;
         MoveTo.CanMove = true;
         this.target_mc.no_go_mc.visible = false;
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),"set_class_data",this.set_class_data);
         var url:String = "resource/allJob/AlertPic/petMagicClass/002.swf";
         var msg:String = "    太感謝你了，你的拉姆會那麼厲害的魔法。我也要趕緊給我的拉姆報名學習一下，以後再也不愁農場的壞兔子了。快回魔法閣樓找你的老師領取畢業徽章吧。";
         var myAlt:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"SMCUI");
      }
      
      private function farm_BtnHandler(evnet:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("FARM_TEPS");
      }
      
      private function showSuperPet() : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.target_mc.superItem.visible = true;
         }
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         for(var k:int = 0; k < 6; k++)
         {
            this.target_mc.activMC["mc_" + k].mc.gotoAndStop(2);
            this.target_mc.activMC["mc_" + k].mc.mouseEnabled = false;
         }
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            itemID = int(itemArray[i].itemID);
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  this.target_mc.activMC["mc_" + tempNum].mc.gotoAndStop(1);
                  this.target_mc.activMC["mc_" + tempNum].mc.mouseEnabled = true;
                  this.target_mc.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      private function removeGmaeOvent() : void
      {
         GV.isGameShowTip = false;
         MoveTo.CanMove = true;
         this.target_mc.no_go_mc.visible = false;
         if(this.myTimer != null)
         {
            this.myTimer.removeEventListener(TimerEvent.TIMER,this.timerStarHandler);
            this.myTimer.stop();
         }
      }
      
      override public function destroy() : void
      {
         this.removeGmaeOvent();
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         this.effect_mc = null;
         super.destroy();
      }
   }
}

