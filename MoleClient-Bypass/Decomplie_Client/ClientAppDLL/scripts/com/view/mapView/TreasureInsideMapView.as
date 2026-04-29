package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.activetyView.PetStep5View;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TreasureInsideMapView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var tom_mc:MovieClip;
      
      public function TreasureInsideMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         super.init();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.tom_mc = GV.MC_mapFrame["top_mc"];
         this.tom_mc.mouseEnabled = false;
         this.tom_mc.mouseChildren = false;
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,this.botton_mc.panel_btn,MouseEvent.CLICK,this.showPanel2);
         this.botton_mc.skill_btn1.visible = false;
         this.botton_mc.skill_btn2.visible = false;
         this.botton_mc.skill_btn4.visible = false;
         this.botton_mc.skill_btn7.visible = false;
         BC.addEvent(this,this.botton_mc.skill_btn1,MouseEvent.CLICK,this.showSkillPanel);
         BC.addEvent(this,this.botton_mc.skill_btn2,MouseEvent.CLICK,this.showSkillPanel);
         BC.addEvent(this,this.botton_mc.skill_btn4,MouseEvent.CLICK,this.showSkillPanel);
         BC.addEvent(this,this.botton_mc.skill_btn7,MouseEvent.CLICK,this.showSkillPanel);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         ephemeralDataSocket.getData(10);
      }
      
      private function showPanel2(e:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("skillPanel");
      }
      
      private function data1215Fun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1215,this.data1215Fun);
         if(evt.EventObj.type == 10)
         {
            this.botton_mc.skill_btn1.visible = true;
            this.botton_mc.skill_btn2.visible = true;
            this.botton_mc.skill_btn4.visible = true;
            this.botton_mc.skill_btn7.visible = true;
            this.target_mc.skillmc1.gotoAndStop(2);
            this.target_mc.skillmc2.gotoAndStop(2);
            this.target_mc.skillmc3.gotoAndStop(2);
            this.depth_mc.skillmc.gotoAndStop(2);
         }
      }
      
      private function showSkillBtn(evt:* = null) : void
      {
         ephemeralDataSocket.setData(10,1000);
         this.botton_mc.skill_btn1.visible = true;
         this.botton_mc.skill_btn2.visible = true;
         this.botton_mc.skill_btn4.visible = true;
         this.botton_mc.skill_btn7.visible = true;
         this.target_mc.skillmc1.gotoAndStop(2);
         this.target_mc.skillmc2.gotoAndStop(2);
         this.target_mc.skillmc3.gotoAndStop(2);
         this.depth_mc.skillmc.gotoAndStop(2);
      }
      
      private function showSkillPanel(evt:MouseEvent = null) : void
      {
         var btn:SimpleButton = evt.currentTarget as SimpleButton;
         var index:int = parseInt(btn.name.slice(9));
         PetStep5View.getInstance().upgradePet(index);
      }
      
      private function showEvent(evt:MouseEvent) : void
      {
         Alert.smileAlart("    請你不要移動拉姆王石像，否則神殿會再次坍塌哦！");
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         switch(evt.EventObj.type)
         {
            case 1:
               this.firstEvent();
               break;
            case 2:
               this.secondEvent();
               break;
            case 3:
               this.thirdlyEvent();
         }
      }
      
      private function firstEvent() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 1)
         {
            if(this.depth_mc.mc_1.currentFrame == 1)
            {
               this.depth_mc.mc_1.gotoAndPlay(2);
               this.testEvent();
            }
         }
         else
         {
            Alert.smileAlart("    需要使用變身小火苗才能開啟哦！");
         }
         GV.MAN_PEOPLE["moveTo"](254,375);
      }
      
      private function secondEvent() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 2)
         {
            if(this.depth_mc.mc_2.currentFrame == 1)
            {
               this.depth_mc.mc_2.gotoAndPlay(2);
               this.testEvent();
            }
         }
         else
         {
            Alert.smileAlart("    需要使用變身小水滴才能開啟哦！");
         }
         GV.MAN_PEOPLE["moveTo"](445,331);
      }
      
      private function thirdlyEvent() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 3)
         {
            if(this.depth_mc.mc_3.currentFrame == 1)
            {
               this.depth_mc.mc_3.gotoAndPlay(2);
               this.testEvent();
            }
         }
         else
         {
            Alert.smileAlart("    需要使用變身小樹苗才能開啟哦！");
         }
         GV.MAN_PEOPLE["moveTo"](702,384);
      }
      
      private function testEvent() : void
      {
         var a:int = 0;
         for(var i:int = 1; i < 4; i++)
         {
            if(this.depth_mc["mc_" + i].currentFrame != 1)
            {
               a++;
            }
         }
         if(a == 3)
         {
            this.showSkillBtn();
         }
      }
      
      private function showPanel(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("gamePanel");
         if(this.botton_mc.bead_mc.currentFrame == 1)
         {
            this.botton_mc.bead_mc.gotoAndPlay(2);
         }
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

