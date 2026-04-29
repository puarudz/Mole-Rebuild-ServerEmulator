package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.module.deal.Deal;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class WaterChiefHoleView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var lightBallMC:MovieClip;
      
      private var doorBool:Boolean = false;
      
      private var clickBool:Boolean = false;
      
      private var dataNum:uint;
      
      private var icekeyMC:MovieClip;
      
      private var directionkeyMC:MovieClip;
      
      private var border_mc:MovieClip;
      
      private var bomb_mc:MovieClip;
      
      private var completekey_mc:MovieClip;
      
      private var block1:MovieClip;
      
      private var block2:MovieClip;
      
      private var block3:MovieClip;
      
      private var block4:MovieClip;
      
      private const SPEED:int = 20;
      
      private var initPoint1:Point = new Point();
      
      private var initPoint2:Point = new Point();
      
      private var initPoint3:Point = new Point();
      
      private var initIceKeyPint:Point = new Point();
      
      private var tip_mc:SimpleButton;
      
      private var gametip_mc:MovieClip;
      
      private var checkKeyTimeID:uint;
      
      private var direction:String;
      
      private var hitBlock1:Boolean;
      
      private var hitBlock2:Boolean;
      
      private var hitBlock3:Boolean;
      
      private var hitBlock4:Boolean;
      
      public function WaterChiefHoleView()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
      }
      
      override public function init() : void
      {
         var p:PeopleManageView;
         super.init();
         this.studyEvent();
         p = GV.MAN_PEOPLE as PeopleManageView;
         if(!(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Water_By_Level(1)))
         {
            this.doorBool = true;
         }
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         setTimeout(function():void
         {
            var npc:* = NPC.getNPCInstance(114);
            npc.dialogInfo = _mapControl.getNpcDialogInfo(20);
         },1000);
         SystemEventManager.addEventListener("water_studyWater",this.onStudySheik);
         SystemEventManager.addEventListener("water_waterOK",this.onWaterOK);
         SystemEventManager.addEventListener("water_waterPlay",this.onSheikPlay);
         SystemEventManager.addEventListener("water_waterTaskOK",this.onSheikTaskOK);
         SystemEventManager.addEventListener("water_waterTaskStar",this.waterTaskStar);
      }
      
      public function waterTaskStar(e:SystemEvent) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(114);
         mapSay(43);
         ephemeralDataSocket.setData(7,1001);
         GV.onlineSocket.dispatchEvent(new Event("water_say_oven"));
      }
      
      private function check190628HasSGM(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190628HasSGM);
         var npc:I_NPC = NPC.getNPCInstance(114);
         var bool:Boolean = false;
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(24);
         }
         else
         {
            GV.onlineSocket.addEventListener("read_" + 1915,this.check190625Fun);
            examinePackStuff.examinePack_create([190625]);
         }
      }
      
      private function check190625Fun(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190625Fun);
         var npc:I_NPC = NPC.getNPCInstance(114);
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(26);
         }
         else
         {
            mapSay(29);
         }
      }
      
      private function onSheikTaskOK(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu.learningSkill(2,0);
         PeopleManageView(GV.MAN_PEOPLE).addEffect("sure_ef");
         var msg:String = "    水系技能我先傳授給你，我可不確定其他兩位酋長也會教你技能。不然你可是沒辦法進化為神力拉姆的。";
         var url:String = "resource/allJob/AlertPic/rescue/water.swf";
         Alert.showAlert(LevelManager.appLevel,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         var npc:I_NPC = NPC.getNPCInstance(114);
         mapSay(30);
      }
      
      private function onSheikPlay(e:SystemEvent) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(114);
         npc.closeAutoMove_And_Stop();
         npc.autoMove = false;
         npc.Speed *= 3;
         npc["addEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenWaterEvent);
         GC.setGTimeout(npc.MoveTo,100,536,156);
      }
      
      private function pOvenWaterEvent(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(114) as I_NPC;
         npc["removeEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenWaterEvent);
         npc["addEventListener"]("onSheikOver",this.playWaterOven);
         NPC.getNPCInstance(114).showAction("Skills");
         GV.onlineSocket.dispatchEvent(new Event("npcWaterOven"));
      }
      
      private function playWaterOven(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(114);
         npc.MoveTo(536,160);
         npc["removeEventListener"]("onSheikOver",this.playWaterOven);
         npc.showAction("routine");
         mapSay(27);
      }
      
      private function onStudySheik(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Water_By_Level(1))
         {
            GV.onlineSocket.addEventListener("ERROR_CMD_-12621",this.error_cmd7Fun);
            GV.onlineSocket.addEventListener("read_" + 1215,this.dataFlag7Fun);
            ephemeralDataSocket.getData(7);
         }
         else
         {
            mapSay(18);
         }
      }
      
      private function error_cmd7Fun(evt:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("water_say_oven"));
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd7Fun);
         GV.onlineSocket.addEventListener("read_" + 1915,this.check190595HasSGM);
         ephemeralDataSocket.setData(7,10001);
      }
      
      private function dataFlag7Fun(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd7Fun);
         GV.onlineSocket.removeEventListener("read_" + 1215,this.dataFlag7Fun);
         if(evt.EventObj.type == 7 && evt.EventObj.data > 1000)
         {
            GV.onlineSocket.addEventListener("read_" + 1915,this.check190628HasSGM);
            examinePackStuff.examinePack_create([190628]);
         }
         else
         {
            mapSay(40);
         }
      }
      
      private function check190595HasSGM(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190595HasSGM);
         var npc:I_NPC = NPC.getNPCInstance(110);
         var bool:Boolean = false;
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(24);
         }
         else
         {
            GV.onlineSocket.addEventListener("read_" + 1915,this.check190611Fun);
            examinePackStuff.examinePack_create([190611]);
         }
      }
      
      private function check190611Fun(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190611Fun);
         var npc:I_NPC = NPC.getNPCInstance(110);
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(26);
         }
         else
         {
            mapSay(29);
         }
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type == 2)
         {
            if(this.doorBool)
            {
               this.target_mc.door.play();
               setTimeout(function():void
               {
                  GF.switchMap(135,true);
               },2 * 1000);
            }
            else
            {
               Alert.smileAlart("    你沒有通過酋長的允許，無法進入試煉場哦！");
            }
         }
      }
      
      private function studyEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         ephemeralDataSocket.getData(7);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.addEvent(this,this.target_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
         this.target_mc.fire_mc.buttonMode = true;
      }
      
      private function data1215Fun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         var dataNum:int = int(evt.EventObj.data);
         if(evt.EventObj.type == 7)
         {
            if(dataNum > 1000)
            {
               this.doorBool = true;
            }
            BC.addEvent(this,GV.onlineSocket,"water_say_oven",this.sayOven);
         }
      }
      
      private function error_cmd0Fun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         ephemeralDataSocket.setData(7,1000);
      }
      
      private function sayOven(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"water_say_oven",this.sayOven);
         this.doorBool = true;
      }
      
      public function onWaterOK(E:*) : void
      {
         BC.addEvent(this,this.target_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
         this.target_mc.fire_mc.buttonMode = true;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamuinfo.isUserSKill = 1208001;
         p.lamu["refurbish"]();
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 2)
         {
            p.lamu.geocaching(this.target_mc.fire_mc,function(mc:MovieClip):*
            {
               return 190625;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190625,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190625) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190625,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190625) + "，明天再來看看吧！");
            });
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Water_By_Level(1))
            {
               BC.addEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
            }
         }
         else
         {
            Alert.smileAlart("    必須使用變身小水滴技能才能拿該物品哦！");
         }
      }
      
      private function npcsayFun(evt:*) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.removeEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
      }
      
      private function initIceKeyGame() : void
      {
         this.icekeyMC = this.target_mc.moveGame_mc.icekey_mc;
         this.tip_mc = this.target_mc.moveGame_mc.tip_mc;
         this.gametip_mc = this.top_mc.gametip_mc;
         GV.MC_TopLever.addChild(this.gametip_mc);
         this.initIceKeyPint.x = this.icekeyMC.x;
         this.initIceKeyPint.y = this.icekeyMC.y;
         this.block1 = this.target_mc.moveGame_mc.block1;
         this.block2 = this.target_mc.moveGame_mc.block2;
         this.block3 = this.target_mc.moveGame_mc.block3;
         this.block4 = this.target_mc.moveGame_mc.block4;
         this.initPoint1.x = this.block1.x;
         this.initPoint1.y = this.block1.y;
         this.initPoint2.x = this.block2.x;
         this.initPoint2.y = this.block2.y;
         this.initPoint3.x = this.block3.x;
         this.initPoint3.y = this.block3.y;
         this.directionkeyMC = this.icekeyMC.directionkey_mc;
         this.border_mc = this.target_mc.border_mc;
         this.bomb_mc = this.target_mc.bomb_mc;
         this.bomb_mc.x = -1000;
         this.completekey_mc = this.target_mc.completekey_mc;
         this.completekey_mc.x = -1000;
         this.target_mc.moveGame_mc.addChild(this.bomb_mc);
         this.target_mc.moveGame_mc.addChild(this.completekey_mc);
         BC.addEvent(this,this.directionkeyMC,MouseEvent.CLICK,this.directionkeyMCClickHandler);
         BC.addEvent(this,this.block1.directionkey_mc,MouseEvent.CLICK,this.block1CkickHandler);
         BC.addEvent(this,this.block2.directionkey_mc,MouseEvent.CLICK,this.block2CkickHandler);
         BC.addEvent(this,this.block3.directionkey_mc,MouseEvent.CLICK,this.block3CkickHandler);
         BC.addEvent(this,this.completekey_mc,"gotKeyEvent",this.gotKeyEventHandler);
         BC.addEvent(this,this.bomb_mc,"bombCompleteEvent",this.bombCompleteEventHandler);
         BC.addEvent(this,this.tip_mc,MouseEvent.CLICK,this.tip_mcClickHandler);
         BC.addEvent(this,this.gametip_mc.close_btn,MouseEvent.CLICK,this.close_btnHandler);
      }
      
      private function tip_mcClickHandler(e:MouseEvent) : void
      {
         this.gametip_mc.x = 960 / 2;
         this.gametip_mc.y = 560 / 2;
      }
      
      private function close_btnHandler(e:MouseEvent) : void
      {
         this.gametip_mc.x = -500;
      }
      
      private function bombCompleteEventHandler(e:Event) : void
      {
         this.icekeyMC.x = this.initIceKeyPint.x;
         this.icekeyMC.y = this.initIceKeyPint.y;
         this.icekeyMC.visible = true;
      }
      
      private function gotKeyEventHandler(e:Event) : void
      {
         Deal.BuyItem(190626,1,function():*
         {
            Alert.getIconByID_Alart(190626,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190626) + "，已經放入你的百寶箱中了!");
            completekey_mc.visible = false;
         });
      }
      
      private function block1CkickHandler(e:MouseEvent) : void
      {
         var mc:SimpleButton = e.target as SimpleButton;
         if(mc.name == "left")
         {
            if(this.block1.y > this.initPoint1.y - 5 && this.block1.y < this.initPoint1.y + 5 && this.block1.x > this.initPoint1.x - 5)
            {
               this.block1.x -= 54;
               this.hitBlock1 = false;
            }
         }
         else if(mc.name == "up")
         {
            if(this.block1.y > this.initPoint1.y - 5 && this.block1.y < this.initPoint1.y + 5 && (this.block1.x > this.initPoint1.x - 5 && this.block1.x < this.initPoint1.x + 5))
            {
               this.block1.y -= 48;
               this.hitBlock1 = false;
            }
         }
         else if(mc.name == "right")
         {
            if(this.block1.y > this.initPoint1.y - 5 && this.block1.y < this.initPoint1.y + 5 && this.block1.x < this.initPoint1.x + 5)
            {
               this.block1.x += 54;
               this.hitBlock1 = false;
            }
         }
         else if(mc.name == "down")
         {
            if(this.block1.y > this.initPoint1.y - 5 - 48 && this.block1.y < this.initPoint1.y + 5 - 48 && (this.block1.x > this.initPoint1.x - 5 && this.block1.x < this.initPoint1.x + 5))
            {
               this.block1.y += 48;
               this.hitBlock1 = false;
            }
         }
      }
      
      private function block2CkickHandler(e:MouseEvent) : void
      {
         var mc:SimpleButton = e.target as SimpleButton;
         if(mc.name == "left")
         {
            if(this.block2.y > this.initPoint2.y - 5 - 48 && this.block2.y < this.initPoint2.y + 5 - 48 && this.block2.x > this.initPoint2.x - 5)
            {
               this.block2.x -= 54;
               this.hitBlock2 = false;
            }
         }
         else if(mc.name == "up")
         {
            if(this.block2.y > this.initPoint2.y - 5 && this.block2.y < this.initPoint2.y + 5 && (this.block2.x > this.initPoint2.x - 5 && this.block2.x < this.initPoint2.x + 5))
            {
               this.block2.y -= 48;
               this.hitBlock2 = false;
            }
         }
         else if(mc.name == "right")
         {
            if(this.block2.y > this.initPoint2.y - 5 - 48 && this.block2.y < this.initPoint2.y + 5 - 48 && this.block2.x < this.initPoint2.x + 5)
            {
               this.block2.x += 54;
               this.hitBlock2 = false;
            }
         }
         else if(mc.name == "down")
         {
            if(this.block2.y > this.initPoint2.y - 5 - 48 && this.block2.y < this.initPoint2.y + 5 - 48 && (this.block2.x > this.initPoint2.x - 5 && this.block2.x < this.initPoint2.x + 5))
            {
               this.block2.y += 48;
               this.hitBlock2 = false;
            }
         }
      }
      
      private function block3CkickHandler(e:MouseEvent) : void
      {
         var mc:SimpleButton = e.target as SimpleButton;
         if(mc.name == "left")
         {
            if(this.block3.y > this.initPoint3.y - 5 && this.block3.y < this.initPoint3.y + 5 && this.block3.x > this.initPoint3.x - 5)
            {
               this.block3.x -= 54;
               this.hitBlock3 = false;
            }
         }
         else if(mc.name == "up")
         {
            if(this.block3.y > this.initPoint3.y - 5 && this.block3.y < this.initPoint3.y + 5 && (this.block1.x > this.initPoint3.x - 5 && this.block3.x < this.initPoint3.x + 5))
            {
               this.block3.y -= 48;
               this.hitBlock3 = false;
            }
         }
         else if(mc.name == "right")
         {
            if(this.block3.y > this.initPoint3.y - 5 && this.block3.y < this.initPoint3.y + 5 && this.block3.x < this.initPoint3.x + 5)
            {
               this.block3.x += 54;
               this.hitBlock3 = false;
            }
         }
         else if(mc.name == "down")
         {
            if(this.block3.y > this.initPoint3.y - 5 - 48 && this.block3.y < this.initPoint3.y + 5 - 48 && (this.block3.x > this.initPoint3.x - 5 && this.block3.x < this.initPoint3.x + 5))
            {
               this.block3.y += 48;
               this.hitBlock3 = false;
            }
         }
      }
      
      private function directionkeyMCClickHandler(e:MouseEvent) : void
      {
         var mc:SimpleButton = e.target as SimpleButton;
         this.direction = mc.name;
         this.directionkeyMC.visible = false;
         this.icekeyMC.addEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
      }
      
      private function moveFrameHandler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(this.direction == "left")
         {
            mc.x -= 20;
         }
         else if(this.direction == "up")
         {
            mc.y -= 20;
         }
         else if(this.direction == "right")
         {
            mc.x += 20;
         }
         else if(this.direction == "down")
         {
            mc.y += 20;
         }
         if(!this.hitBlock1 && Boolean(HitTest.complexHitTestObject(mc,this.block1.hitBlock)))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            this.hitBlock1 = true;
            this.hitBlock2 = false;
            this.hitBlock3 = false;
            this.hitBlock4 = false;
         }
         else if(!this.hitBlock2 && Boolean(HitTest.complexHitTestObject(mc,this.block2.hitBlock)))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            this.hitBlock1 = false;
            this.hitBlock2 = true;
            this.hitBlock3 = false;
            this.hitBlock4 = false;
         }
         else if(!this.hitBlock3 && Boolean(HitTest.complexHitTestObject(mc,this.block3.hitBlock)))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            this.hitBlock1 = false;
            this.hitBlock2 = false;
            this.hitBlock3 = true;
            this.hitBlock4 = false;
         }
         else if(!this.hitBlock4 && Boolean(HitTest.complexHitTestObject(mc,this.block4.hitBlock)))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            this.hitBlock1 = false;
            this.hitBlock2 = false;
            this.hitBlock3 = false;
            this.hitBlock4 = true;
            mc.visible = false;
            this.completekey_mc.x = mc.x;
            this.completekey_mc.y = mc.y;
            this.completekey_mc.play();
         }
         else if(HitTest.complexHitTestObject(mc,this.border_mc))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            mc.visible = false;
            this.hitBlock1 = false;
            this.hitBlock2 = false;
            this.hitBlock3 = false;
            this.hitBlock4 = false;
            this.bomb_mc.x = mc.x;
            this.bomb_mc.y = mc.y;
            this.bomb_mc.play();
         }
         else if(HitTest.complexHitTestObject(mc,this.target_mc.border2))
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.moveFrameHandler);
            mc.visible = false;
            this.hitBlock1 = false;
            this.hitBlock2 = false;
            this.hitBlock3 = false;
            this.hitBlock4 = false;
            this.bomb_mc.x = mc.x;
            this.bomb_mc.y = mc.y;
            this.bomb_mc.play();
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("water_studyWater",this.onStudySheik);
         SystemEventManager.removeEventListener("water_waterOK",this.onWaterOK);
         SystemEventManager.removeEventListener("water_waterPlay",this.onSheikPlay);
         SystemEventManager.removeEventListener("water_waterTaskOK",this.onSheikTaskOK);
         SystemEventManager.removeEventListener("water_waterTaskStar",this.waterTaskStar);
         if(Boolean(this.gametip_mc))
         {
            GV.MC_TopLever.removeChild(this.gametip_mc);
         }
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class HitTest
{
   
   public function HitTest()
   {
      super();
   }
   
   public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1) : Boolean
   {
      return complexIntersectionRectangle(target1,target2,accurracy).width != 0;
   }
   
   public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject) : Rectangle
   {
      if(!target1.root || !target2.root || !target1.hitTestObject(target2))
      {
         return new Rectangle();
      }
      var bounds1:Rectangle = target1.getBounds(target1.root);
      var bounds2:Rectangle = target2.getBounds(target2.root);
      var intersection:Rectangle = new Rectangle();
      intersection.x = Math.max(bounds1.x,bounds2.x);
      intersection.y = Math.max(bounds1.y,bounds2.y);
      intersection.width = Math.min(bounds1.x + bounds1.width - intersection.x,bounds2.x + bounds2.width - intersection.x);
      intersection.height = Math.min(bounds1.y + bounds1.height - intersection.y,bounds2.y + bounds2.height - intersection.y);
      return intersection;
   }
   
   public static function complexIntersectionRectangle(target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1) : Rectangle
   {
      if(accurracy <= 0)
      {
         throw new Error("ArgumentError: Error #5001: Invalid value for accurracy",5001);
      }
      if(!target1.hitTestObject(target2))
      {
         return new Rectangle();
      }
      var hitRectangle:Rectangle = intersectionRectangle(target1,target2);
      if(hitRectangle.width * accurracy < 1 || hitRectangle.height * accurracy < 1)
      {
         return new Rectangle();
      }
      var bitmapData:BitmapData = new BitmapData(hitRectangle.width * accurracy,hitRectangle.height * accurracy,false,0);
      bitmapData.draw(target1,HitTest.getDrawMatrix(target1,hitRectangle,accurracy),new ColorTransform(1,1,1,1,255,-255,-255,255));
      bitmapData.draw(target2,HitTest.getDrawMatrix(target2,hitRectangle,accurracy),new ColorTransform(1,1,1,1,255,255,255,255),BlendMode.DIFFERENCE);
      var intersection:Rectangle = bitmapData.getColorBoundsRect(4294967295,4278255615);
      bitmapData.dispose();
      if(accurracy != 1)
      {
         intersection.x /= accurracy;
         intersection.y /= accurracy;
         intersection.width /= accurracy;
         intersection.height /= accurracy;
      }
      intersection.x += hitRectangle.x;
      intersection.y += hitRectangle.y;
      return intersection;
   }
   
   protected static function getDrawMatrix(target:DisplayObject, hitRectangle:Rectangle, accurracy:Number) : Matrix
   {
      var localToGlobal:Point = null;
      var matrix:Matrix = null;
      var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
      localToGlobal = target.localToGlobal(new Point());
      matrix = target.transform.concatenatedMatrix;
      matrix.tx = localToGlobal.x - hitRectangle.x;
      matrix.ty = localToGlobal.y - hitRectangle.y;
      matrix.a /= rootConcatenatedMatrix.a;
      matrix.d /= rootConcatenatedMatrix.d;
      if(accurracy != 1)
      {
         matrix.scale(accurracy,accurracy);
      }
      return matrix;
   }
}
