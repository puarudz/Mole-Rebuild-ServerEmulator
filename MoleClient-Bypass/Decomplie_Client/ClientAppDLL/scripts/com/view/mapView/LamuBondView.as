package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.module.activityModule.Presented;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class LamuBondView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var subTractTimer:Timer;
      
      private var attachTimer:Timer;
      
      private var attachMC:MovieClip;
      
      private var doorBool:Boolean = false;
      
      private var dataNum:uint;
      
      public function LamuBondView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.initTimer();
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,this.botton_mc.mc_190611,MouseEvent.CLICK,this.clickMc190611Fun);
         BC.addEvent(this,this.target_mc.btn_1230012,MouseEvent.CLICK,this.btnClickFun);
      }
      
      override public function init() : void
      {
         var p:PeopleManageView;
         super.init();
         p = GV.MAN_PEOPLE as PeopleManageView;
         if(!(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1)))
         {
            this.doorBool = true;
            this.botton_mc.fire_mc.visible = true;
            BC.addEvent(this,this.botton_mc.fire_mc,MouseEvent.CLICK,this.fireClickOneFun);
         }
         setTimeout(function():void
         {
            var npc:MoleNPC = NPC.getNPCInstance(110);
            npc.dialogInfo = _mapControl.getNpcDialogInfo(100);
         },1000);
         SystemEventManager.addEventListener("tree_studyTree",this.onStudyTree);
         SystemEventManager.addEventListener("tree_treeOK",this.playEvent);
         SystemEventManager.addEventListener("tree_treePlay",this.onTreePlay);
         SystemEventManager.addEventListener("tree_treeTaskOK",this.onTaskOK);
      }
      
      private function onTaskOK(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu.learningSkill(3,0);
         PeopleManageView(GV.MAN_PEOPLE).addEffect("sure_ef");
         var msg:String = "    不錯哦，已經學會木系技能了！如果你能同樣得到其他兩位酋長的信任，就能學到他們的變身技能哦！";
         var url:String = "resource/allJob/AlertPic/rescue/tree";
         Alert.showAlert(LevelManager.appLevel,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         var npc:I_NPC = NPC.getNPCInstance(110);
         mapSay(20);
      }
      
      private function onTreePlay(e:SystemEvent) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(110);
         npc.closeAutoMove_And_Stop();
         npc.autoMove = false;
         npc.Speed *= 3;
         npc["addEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenTreeEvent);
         GC.setGTimeout(npc.MoveTo,150,519,150);
      }
      
      private function pOvenTreeEvent(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(110) as I_NPC;
         npc["removeEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenTreeEvent);
         npc["addEventListener"]("onSheikOver",this.playTreeOven);
         NPC.getNPCInstance(110).showAction("Skills");
         GV.onlineSocket.dispatchEvent(new Event("npcTreeOven"));
      }
      
      private function playTreeOven(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(110);
         npc.MoveTo(300,102);
         npc["removeEventListener"]("onSheikOver",this.playTreeOven);
         npc.showAction("routine");
         mapSay(17);
      }
      
      private function onStudyTree(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
         {
            GV.onlineSocket.addEventListener("ERROR_CMD_-12621",this.error_cmd4Fun);
            GV.onlineSocket.addEventListener("read_" + 1215,this.dataFlag4Fun);
            ephemeralDataSocket.getData(4);
         }
         else
         {
            mapSay(18);
         }
      }
      
      private function error_cmd4Fun(evt:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("npc_say_oven"));
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd4Fun);
         GV.onlineSocket.addEventListener("read_" + 1915,this.check190595HasSGM);
      }
      
      private function dataFlag4Fun(evt:EventTaomee) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("npc_say_oven"));
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd4Fun);
         GV.onlineSocket.removeEventListener("read_" + 1215,this.dataFlag4Fun);
         var npc:I_NPC = NPC.getNPCInstance(110);
         if(evt.EventObj.type == 4 && evt.EventObj.data > 1000)
         {
            GV.onlineSocket.addEventListener("read_" + 1915,this.check190595HasSGM);
            examinePackStuff.examinePack_create([190595]);
         }
         else
         {
            mapSay(10);
            ephemeralDataSocket.setData(4,1001);
         }
      }
      
      private function check190595HasSGM(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190595HasSGM);
         var npc:I_NPC = NPC.getNPCInstance(110);
         var bool:Boolean = false;
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(14);
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
            mapSay(16);
         }
         else
         {
            mapSay(19);
         }
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         var p:PeopleManageView = null;
         if(evt.EventObj.type == 2)
         {
            if(this.doorBool)
            {
               GV.Room_DefaultRoomID = 0;
               LocalUserInfo.setMapID(0);
               GF.switchMap(131,true);
            }
            else
            {
               Alert.smileAlart("    沒有酋長的允許無法進入惡魔樹精棲息地哦！");
            }
         }
         else if(evt.EventObj.type == 3)
         {
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
            {
               Alert.smileAlart("    這條道路已經被封閉，從其他地方走走看吧！");
            }
            else
            {
               GV.Room_DefaultRoomID = 0;
               LocalUserInfo.setMapID(0);
               GF.switchMap(128,true);
            }
         }
      }
      
      private function btnClickFun(evt:MouseEvent) : void
      {
         BC.addEvent(this,this.target_mc.btn_1230012,MouseEvent.CLICK,this.btnClickFun);
         this.target_mc.btn_1230012.visible = false;
         Presented.getInstance().FreeReceiveBy1117(24);
      }
      
      private function fireClickOneFun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 3)
         {
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
            {
               Alert.smileAlart("    等你能變成小樹苗了再來收集吧！");
            }
            else
            {
               p.lamu.geocaching(this.botton_mc.fire_mc,function(mc:MovieClip):*
               {
                  return 190611;
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190611,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190611) + "，已經放入你主人的百寶箱中了！");
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190611,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190611) + "，明天再來看看吧！");
               });
            }
         }
         else
         {
            Alert.smileAlart("    等你能變成小樹苗了再來收集吧！");
         }
      }
      
      private function clickMc190611Fun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 3)
         {
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
            {
               Alert.smileAlart("    等你能變成小樹苗了再來收集吧！");
            }
            else
            {
               p.lamu.geocaching(this.botton_mc.mc_190611,function(mc:MovieClip):*
               {
                  return 190611;
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190611,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190611) + "，已經放入你主人的百寶箱中了！");
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190611,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190611) + "，明天再來看看吧！");
               });
            }
         }
         else
         {
            Alert.smileAlart("    等你能變成小樹苗了再來收集吧！");
         }
      }
      
      private function initTimer() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         ephemeralDataSocket.getData(4);
      }
      
      private function data1215Fun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         var dataNum:* = evt.EventObj.data;
         if(evt.EventObj.type == 4)
         {
            if(dataNum > 1000)
            {
               this.doorBool = true;
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"npc_say_oven",this.sayOven);
            }
         }
      }
      
      private function sayOven(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"npc_say_oven",this.sayOven);
         this.doorBool = true;
      }
      
      private function error_cmd0Fun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         ephemeralDataSocket.setData(4,1000);
      }
      
      public function playEvent(E:*) : void
      {
         BC.addEvent(this,this.botton_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
         this.botton_mc.fire_mc.visible = true;
         this.botton_mc.mc_190611.visible = false;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamuinfo.isUserSKill = 1208002;
         p.lamu["refurbish"]();
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 3)
         {
            BC.removeEvent(this,this.botton_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
            p.lamu.geocaching(this.botton_mc.fire_mc,function(mc:MovieClip):*
            {
               return 190611;
            },function(E:*):*
            {
               botton_mc.fire_mc.visible = false;
               botton_mc.mc_190611.visible = true;
               Alert.getIconByID_Alart(190611,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190611) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190611,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190611) + "，明天再來看看吧！");
            });
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
            {
               BC.addEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
            }
         }
      }
      
      private function npcsayFun(evt:*) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.removeEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
         mapSay(19);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("tree_studyTree",this.onStudyTree);
         SystemEventManager.removeEventListener("tree_treeOK",this.playEvent);
         SystemEventManager.removeEventListener("tree_treePlay",this.onTreePlay);
         SystemEventManager.removeEventListener("tree_treeTaskOK",this.onTaskOK);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

