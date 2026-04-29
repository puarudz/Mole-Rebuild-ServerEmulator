package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class LamuFalmeMapView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var doorBool:Boolean = false;
      
      public function LamuFalmeMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,GV.onlineSocket,"itemID_190586",this.itemID190586);
         BC.addEvent(this,this.target_mc.mc_190591,MouseEvent.CLICK,this.clickMc190591Fun);
         BC.addEvent(this,GV.onlineSocket,"npc_say_oven",this.npcSayOvenFun);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         ephemeralDataSocket.getData(2);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(!(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(1)))
         {
            this.doorBool = true;
         }
      }
      
      override public function init() : void
      {
         super.init();
         setTimeout(function():void
         {
            var npc:* = NPC.getNPCInstance(108);
            npc.dialogInfo = _mapControl.getNpcDialogInfo(20);
         },1000);
         SystemEventManager.addEventListener("sheik_studySkills",this.onStudySheik);
         SystemEventManager.addEventListener("sheik_sheikOk",this.onSheikOK);
         SystemEventManager.addEventListener("sheik_sheikPlay",this.onSheikPlay);
         SystemEventManager.addEventListener("sheik_sheikTaskOK",this.onSheikTaskOK);
      }
      
      private function onSheikPlay(e:SystemEvent) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(108);
         npc.closeAutoMove_And_Stop();
         npc.autoMove = false;
         npc.Speed *= 3;
         npc["addEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenEvent);
         GC.setGTimeout(npc.MoveTo,100,300,100);
      }
      
      private function pOvenEvent(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(108) as I_NPC;
         npc["removeEventListener"](PeopleManageView.ON_GO_OVER,this.pOvenEvent);
         npc["addEventListener"]("onSheikOver",this.playOven);
         NPC.getNPCInstance(108).showAction("Skills");
      }
      
      private function playOven(evt:*) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(108);
         npc.MoveTo(300,102);
         npc["removeEventListener"]("onSheikOver",this.playOven);
         NPC.getNPCInstance(108).showAction("routine");
         mapSay(27);
      }
      
      private function onSheikTaskOK(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamu.learningSkill(1,0);
         PeopleManageView(GV.MAN_PEOPLE).addEffect("sure_ef");
         var msg:String = "    很不錯嘛，我就傳授你變身小火苗的技能吧。我可是只傳授給有能力的拉姆，如果其他兩位酋長也肯教你的話，你就可以到藏寶神殿進化了。";
         var url:String = "resource/allJob/AlertPic/rescue/sheik.swf";
         Alert.showAlert(LevelManager.appLevel,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         mapSay(30);
      }
      
      private function onStudySheik(e:SystemEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(1))
         {
            GV.onlineSocket.addEventListener("ERROR_CMD_-12621",this.error_cmd0Fun1);
            GV.onlineSocket.addEventListener("read_" + 1215,this.data1215Fun1);
            ephemeralDataSocket.getData(2);
         }
         else
         {
            mapSay(28);
         }
      }
      
      private function error_cmd0Fun1(evt:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("npc_say_oven"));
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd0Fun1);
         GV.onlineSocket.addEventListener("read_" + 1915,this.check1915HasSGM);
         examinePackStuff.examinePack_create([190593]);
      }
      
      private function data1215Fun1(evt:EventTaomee) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("npc_say_oven"));
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd0Fun1);
         GV.onlineSocket.removeEventListener("read_" + 1215,this.data1215Fun1);
         GV.onlineSocket.addEventListener("read_" + 1915,this.check1915HasSGM);
         examinePackStuff.examinePack_create([190593]);
      }
      
      private function check1915HasSGM(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check1915HasSGM);
         var npc:I_NPC = NPC.getNPCInstance(108);
         var bool:Boolean = false;
         if(evt.EventObj.arr[0].count == 0)
         {
            mapSay(24);
         }
         else
         {
            GV.onlineSocket.addEventListener("read_" + 1915,this.check190590SGM);
            examinePackStuff.examinePack_create([190591]);
         }
      }
      
      private function check190590SGM(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.check190590SGM);
         var npc:I_NPC = NPC.getNPCInstance(108);
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
               MapManager.enterMap(127);
            }
            else
            {
               Alert.smileAlart("    你沒有通過酋長的允許，無法進入試煉場哦！");
            }
         }
      }
      
      private function npcSayOvenFun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"npc_say_oven",this.npcSayOvenFun);
         this.doorBool = true;
      }
      
      private function data1215Fun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         var dataNum:* = evt.EventObj.data;
         if(evt.EventObj.type == 2)
         {
            if(dataNum > 1000)
            {
               this.doorBool = true;
            }
         }
      }
      
      private function error_cmd0Fun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         ephemeralDataSocket.setData(2,1000);
      }
      
      private function clickMc190591Fun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 1)
         {
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(1))
            {
               Alert.smileAlart("    等你能變成小火苗了再來收集吧！");
            }
            else
            {
               p.lamu.geocaching(this.target_mc.mc_190591,function(mc:MovieClip):*
               {
                  return 190591;
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190591,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190591) + "，已經放入你主人的百寶箱中了！");
               },function(E:*):*
               {
                  Alert.getIconByID_Alart(190591,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190591) + "，明天再來看看吧！");
               });
            }
         }
      }
      
      private function itemID190586(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"itemID_190586",this.itemID190586);
         BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
         GetItemEveryDay.req_getItemEveryDay(2);
      }
      
      private function read117Handler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
         this.target_mc.mc_190586.visible = false;
         if(e.EventObj.itmeCount == 0)
         {
            Alert.smileAlart("    今天你已經得到太多" + GoodsInfo.getItemNameByID(e.EventObj.itemid) + "，明天再來看看吧！");
         }
         else
         {
            Alert.getIconByID_Alart(e.EventObj.itemid);
         }
      }
      
      public function onSheikOK(E:*) : void
      {
         BC.addEvent(this,this.target_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
         this.target_mc.fire_mc.visible = true;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamuinfo.isUserSKill = 1208000;
         p.lamu["refurbish"]();
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 1)
         {
            BC.removeEvent(this,this.target_mc.fire_mc,MouseEvent.CLICK,this.fireClickFun);
            this.target_mc.fire_mc.visible = false;
            p.lamu.geocaching(this.target_mc.fire_mc,function(mc:MovieClip):*
            {
               return 190591;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190591,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190591) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190591,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190591) + "，明天再來看看吧！");
            });
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(1))
            {
               BC.addEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
            }
         }
      }
      
      private function npcsayFun(evt:*) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         BC.removeEvent(this,p.lamu.boneManaage,"getItemOver",this.npcsayFun);
         mapSay(29);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("sheik_studySkills",this.onStudySheik);
         SystemEventManager.removeEventListener("sheik_sheikOk",this.onSheikOK);
         SystemEventManager.removeEventListener("sheik_sheikPlay",this.onSheikPlay);
         SystemEventManager.removeEventListener("sheik_sheikTaskOK",this.onSheikTaskOK);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-12621",this.error_cmd0Fun1);
         GV.onlineSocket.removeEventListener("read_" + 1215,this.data1215Fun1);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

