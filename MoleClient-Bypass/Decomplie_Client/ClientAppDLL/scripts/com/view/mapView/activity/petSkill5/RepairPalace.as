package com.view.mapView.activity.petSkill5
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.petClass.ListItem.PetStep5ClassSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RepairPalace
   {
      
      public static var height1:uint;
      
      public static var height2:uint;
      
      public static var height3:uint;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var boxMC:*;
      
      private var stoneNumArr:Array;
      
      private var waterMNumArr:Array;
      
      public function RepairPalace()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.showLamuKingFun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1210,this.getPalaceHeightBack);
         PetStep5ClassSocket.getPillarHeight();
      }
      
      private function getPalaceHeightBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1210,this.getPalaceHeightBack);
         height1 = evt.EventObj.height1;
         height2 = evt.EventObj.height2;
         height3 = evt.EventObj.height3;
         if(height1 >= 1)
         {
            this.depth_mc.light1.visible = false;
            this.depth_mc.fire_pillar.gotoAndStop(3);
         }
         if(height2 >= 1)
         {
            this.depth_mc.light2.visible = false;
            this.depth_mc.water_pillar.gotoAndStop(3);
         }
         if(height3 >= 1)
         {
            this.depth_mc.light3.visible = false;
            BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.getDataHandler);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
            ephemeralDataSocket.getData(5);
         }
         else
         {
            this.walkGameNumEvent();
         }
      }
      
      private function error_cmd0Fun(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.getDataHandler);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         ephemeralDataSocket.setData(5,1);
         this.depth_mc.wood_pillar.gotoAndStop(2);
         this.walkGameNumEvent();
      }
      
      private function getDataHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.getDataHandler);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         if(evt.EventObj.data == 1)
         {
            this.depth_mc.wood_pillar.gotoAndStop(3);
         }
         this.walkGameNumEvent();
      }
      
      private function showLamuKingFun(evt:EventTaomee = null) : void
      {
         var msg:String = null;
         var myalter:* = undefined;
         if(evt.EventObj.type == 2)
         {
            if(height1 < 1)
            {
               if(GV.MAN_PEOPLE.Petlevel <= 0)
               {
                  Alert.smileAlart("    這裡的洞太小了，只有你的拉姆才能變小鑽進去幫忙修復神殿哦！");
               }
               else
               {
                  if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Fire())
                  {
                     Alert.smileAlart("    你的拉姆還沒有學會變身小火苗，無法幫忙修復神殿，去拉姆縮小世界學習技能吧！");
                     return;
                  }
                  msg = "    你需要把你的拉姆縮小後才能進入圖騰柱裡進行修復哦，確定要幫忙嗎？";
                  myalter = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
                  BC.addEvent(this,myalter,Alert.CLICK_ + "1",this.lightLamuFun,false,0,true);
               }
            }
            else
            {
               Alert.smileAlart("    你已經修復完火系圖騰柱，水火木全部修復完畢就能進入神殿升級為第五階段了！");
            }
         }
         if(evt.EventObj.type == 3)
         {
            if(height3 < 1)
            {
               if(GV.MAN_PEOPLE.Petlevel <= 0)
               {
                  Alert.smileAlart("    這裡的洞太小了，只有你的拉姆才能變小鑽進去幫忙修復神殿哦！");
               }
               else
               {
                  if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood())
                  {
                     Alert.smileAlart("    你的拉姆還沒有學會變身小樹苗，無法幫忙修復神殿，去拉姆縮小世界學習技能吧！");
                     return;
                  }
                  MapManager.enterMap(132);
               }
            }
            else
            {
               Alert.smileAlart("    你已經修復完木系圖騰柱，水火木全部修復完畢就能進入神殿升級為第五階段了！");
            }
         }
         if(evt.EventObj.type == 4)
         {
            if(height2 < 1)
            {
               if(GV.MAN_PEOPLE.Petlevel <= 0)
               {
                  Alert.smileAlart("    這裡的洞太小了，只有你的拉姆才能變小鑽進去幫忙修復神殿哦！");
               }
               else
               {
                  if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Water())
                  {
                     Alert.smileAlart("    你的拉姆還沒有學會變身小水滴，無法幫忙修復神殿，去拉姆縮小世界學習技能吧！");
                     return;
                  }
                  msg = "    你需要把你的拉姆縮小後才能進入圖騰柱裡進行修復哦，確定要幫忙嗎？";
                  myalter = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
                  BC.addEvent(this,myalter,Alert.CLICK_ + "1",this.waterLamuFun,false,0,true);
               }
            }
            else
            {
               Alert.smileAlart("    你已經修復完水系圖騰柱，水火木全部修復完畢就能進入神殿升級為第五階段了！");
            }
         }
      }
      
      private function waterLamuFun(evt:Event = null) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu_follow_off();
         p.lamu.autoMove = false;
         TweenLite.to(p.lamu,1,{
            "scaleX":0.5,
            "scaleY":0.5,
            "onComplete":this.moveLamuWater
         });
      }
      
      private function moveLamuWater() : void
      {
         if(!this.target_mc.waterdoor_mc)
         {
            return;
         }
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu.MoveTo(this.target_mc.waterdoor_mc.x,this.target_mc.waterdoor_mc.y);
         BC.addEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.lamuTweenEvent2);
      }
      
      private function lamuTweenEvent2(evt:* = null) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.removeEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.lamuTweenEvent2);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.backWaterMInfo);
         examinePackStuff.examinePack_create([190623,190624,190625]);
      }
      
      private function backWaterMInfo(evt:EventTaomee = null) : void
      {
         var tempMC:Class = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.backWaterMInfo);
         this.waterMNumArr = evt.EventObj.arr;
         if(!MainManager.getAppLevel().getChildByName("GamePanel"))
         {
            tempMC = GV.Lib_Map.getClass("waterGamePanel") as Class;
            this.boxMC = new tempMC();
            this.boxMC.name = "GamePanel";
            this.showScoreFun(this.boxMC.num1,this.waterMNumArr[0].count);
            this.showScoreFun(this.boxMC.num2,this.waterMNumArr[1].count);
            this.showScoreFun(this.boxMC.num3,this.waterMNumArr[2].count);
            MainManager.getAppLevel().addChild(this.boxMC);
            BC.addEvent(this,this.boxMC.close_btn,MouseEvent.CLICK,this.removeboxMCHandler);
            BC.addEvent(this,this.boxMC.next_btn,MouseEvent.CLICK,this.removeboxMCHandler);
            BC.addEvent(this,this.boxMC.continue_btn,MouseEvent.CLICK,this.checkWaterMFun);
         }
      }
      
      private function checkWaterMFun(evt:MouseEvent) : void
      {
         this.removeboxMC();
         if(this.waterMNumArr[0].count < 4 || this.waterMNumArr[1].count < 4 || this.waterMNumArr[2].count < 4)
         {
            Alert.smileAlart("    你身上的材料不夠哦！");
            this.resetLamu();
         }
         else
         {
            this.playGame("IcingGame");
         }
      }
      
      private function lightLamuFun(evt:Event = null) : void
      {
         this.target_mc.stone_mc.gotoAndPlay(2);
         BC.addEvent(this,GV.onlineSocket,"light_finish",this.reSizeLamuFun);
      }
      
      private function reSizeLamuFun(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"light_finish",this.reSizeLamuFun);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu_follow_off();
         p.lamu.autoMove = false;
         TweenLite.to(p.lamu,1,{
            "scaleX":0.5,
            "scaleY":0.5,
            "onComplete":this.moveLamuFire
         });
      }
      
      private function moveLamuFire() : void
      {
         if(!this.target_mc.lamu1_mc)
         {
            return;
         }
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu.MoveTo(this.target_mc.lamu1_mc.x,this.target_mc.lamu1_mc.y);
         BC.addEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.lamuTweenEvent);
      }
      
      private function lamuTweenEvent(evt:* = null) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.removeEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.lamuTweenEvent);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.backStoneInfo);
         examinePackStuff.examinePack_create([190590,190591,190592]);
      }
      
      private function backStoneInfo(evt:EventTaomee = null) : void
      {
         var tempMC:Class = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.backStoneInfo);
         this.stoneNumArr = evt.EventObj.arr;
         if(!MainManager.getAppLevel().getChildByName("GamePanel"))
         {
            tempMC = GV.Lib_Map.getClass("gamePanel") as Class;
            this.boxMC = new tempMC();
            this.boxMC.name = "GamePanel";
            this.showScoreFun(this.boxMC.num1,this.stoneNumArr[0].count);
            this.showScoreFun(this.boxMC.num2,this.stoneNumArr[1].count);
            this.showScoreFun(this.boxMC.num3,this.stoneNumArr[2].count);
            MainManager.getAppLevel().addChild(this.boxMC);
            BC.addEvent(this,this.boxMC.close_btn,MouseEvent.CLICK,this.removeboxMCHandler);
            BC.addEvent(this,this.boxMC.next_btn,MouseEvent.CLICK,this.removeboxMCHandler);
            BC.addEvent(this,this.boxMC.continue_btn,MouseEvent.CLICK,this.checkStoneFun);
         }
      }
      
      private function removeboxMC() : void
      {
         var temp:MovieClip = MainManager.getAppLevel().getChildByName("GamePanel") as MovieClip;
         MainManager.getAppLevel().removeChild(temp);
         temp = null;
      }
      
      private function removeboxMCHandler(evt:MouseEvent = null) : void
      {
         this.removeboxMC();
         this.resetLamu();
      }
      
      private function checkStoneFun(evt:MouseEvent) : void
      {
         this.removeboxMC();
         if(this.stoneNumArr[0].count < 4 || this.stoneNumArr[1].count < 4 || this.stoneNumArr[2].count < 4)
         {
            Alert.smileAlart("    你身上的石頭不夠哦！");
            this.resetLamu();
         }
         else
         {
            this.playGame("AGameNew");
         }
      }
      
      private function playGame(game:String) : void
      {
         new PetTaskData();
         MapManager.clearMap();
         var loadGame:LoadGame = new LoadGame("module/game/" + game + ".swf","正在打開.....",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function walkGameNumEvent() : void
      {
         var gameNum:Number = PetTaskData.HIGHFLAG;
         if(gameNum < 0)
         {
            return;
         }
         if(gameNum == 0)
         {
            Alert.smileAlart("    你這次沒有完成圖騰柱的修復，繼續加油喲！");
            this.resetLamu();
         }
         else if(gameNum == 1)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1208,this.repairFireHandler);
            PetStep5ClassSocket.setPillarHeight(0,1);
         }
         else if(gameNum == 2)
         {
            Alert.smileAlart("    只有在氧氣值用完前修補完20個洞才可以哦！你還沒有補完水系圖騰柱呢！");
            this.resetLamu();
         }
         else if(gameNum == 3)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1208,this.repairWaterHandler);
            PetStep5ClassSocket.setPillarHeight(1,1);
         }
         PetTaskData.HIGHFLAG = -2;
      }
      
      private function repairFireHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1208,this.repairFireHandler);
         if(evt.EventObj.Height >= 1)
         {
            height1 = evt.EventObj.Height;
            Alert.smileAlart("    你已經修復完火系圖騰柱，水火木全部修復完畢就能進入神殿升級為第五階段了！");
            this.depth_mc.fire_pillar.gotoAndStop(2);
            this.botton_mc.repair1_btn.visible = false;
         }
         else
         {
            height1 = evt.EventObj.Height;
            Alert.smileAlart("    你還需要修復" + (1 - evt.EventObj.Height) + "米才能完成這根柱子的修復工作哦，加油吧！");
         }
      }
      
      private function repairWaterHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1208,this.repairWaterHandler);
         if(evt.EventObj.Height >= 1)
         {
            height2 = evt.EventObj.Height;
            Alert.smileAlart("    你已經修復完水系圖騰柱，水火木全部修復完畢就能進入神殿升級為第五階段了！");
            this.depth_mc.water_pillar.gotoAndStop(2);
            this.botton_mc.repair2_btn.visible = false;
         }
         else
         {
            height2 = evt.EventObj.Height;
            Alert.smileAlart("    感謝你成功填補了20個洞口，還需要修補" + (1 - evt.EventObj.Height) + "次，你就能完成水系圖騰柱的修補哦!");
         }
      }
      
      private function resetLamu() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu_follow_on();
         TweenLite.to(p.lamu,1,{
            "scaleX":1,
            "scaleY":1
         });
         p.lamu["refurbish"]();
      }
      
      private function showScoreFun(mc:MovieClip, count:uint) : void
      {
         var num:uint = uint(mc.numChildren);
         var arr:Array = String(count).split("");
         while(arr.length < num)
         {
            arr.splice(0,0,0);
         }
         for(var i:int = 1; i <= arr.length; i++)
         {
            mc["zero" + i].gotoAndStop(uint(arr[i - 1]) + 1);
         }
      }
      
      private function removeEventHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
      }
   }
}

