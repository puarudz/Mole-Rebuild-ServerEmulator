package com.view.activetyView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.petClass.ListItem.PetStep5ClassSocket;
   import com.module.helpPanel.HelpPanel;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class PetStep5View
   {
      
      public static var petView:PetStep5View;
      
      private var jobPanel:MovieClip;
      
      private var type:uint;
      
      private var upgradeMC:MovieClip;
      
      private var p:PeopleManageView;
      
      private var skillXML:XML;
      
      private var SkillArr1:Array;
      
      private var SkillArr2:Array;
      
      private var SkillArr4:Array;
      
      private var SkillArr7:Array;
      
      private var typeArr:Array = [0,1,2,4,7];
      
      public function PetStep5View()
      {
         super();
      }
      
      public static function getInstance() : PetStep5View
      {
         if(!petView)
         {
            petView = new PetStep5View();
         }
         return petView;
      }
      
      public function upgradePet(t:uint) : void
      {
         this.type = t;
         this.p = PeopleManageView(GV.MAN_PEOPLE);
         var tempClass:Class = GV.Lib_Map.getClass("jobPanel" + this.type) as Class;
         this.jobPanel = new tempClass();
         MainManager.getGameLevel().addChild(this.jobPanel);
         this.jobPanel.tip_mc.visible = false;
         this.jobPanel.up_btn.visible = false;
         this.jobPanel.down_btn.visible = false;
         this.setSkillTips();
         if(this.p.lamuinfo.hasSkillAvatar() == 1 && this.type == 1)
         {
            this.jobPanel.upgrade_btn.visible = false;
         }
         else if(this.p.lamuinfo.hasSkillAvatar() == 2 && this.type == 2)
         {
            this.jobPanel.upgrade_btn.visible = false;
         }
         else if(this.p.lamuinfo.hasSkillAvatar() == 3 && this.type == 4)
         {
            this.jobPanel.upgrade_btn.visible = false;
         }
         else if(this.p.lamuinfo.hasSkillAvatar() == 4 && this.type == 7)
         {
            this.jobPanel.upgrade_btn.visible = false;
         }
         BC.addEvent(this,this.jobPanel.close_btn,MouseEvent.CLICK,this.removeFun);
         BC.addEvent(this,this.jobPanel.upgrade_btn,MouseEvent.CLICK,this.makeSureFun);
      }
      
      private function setSkillTips() : void
      {
         var item:* = undefined;
         var obj:Object = null;
         var i:uint = 0;
         var j:uint = 0;
         var hasSkill:Boolean = false;
         this.SkillArr1 = new Array();
         this.SkillArr2 = new Array();
         this.SkillArr4 = new Array();
         this.SkillArr7 = new Array();
         this.skillXML = XMLInfo.petSkillListXML;
         this.skillXML.ignoreWhitespace = true;
         for each(item in this.skillXML.Fire.item)
         {
            obj = this.parseSkillData(item);
            this.SkillArr1.push(obj);
         }
         for each(item in this.skillXML.Water.item)
         {
            obj = this.parseSkillData(item);
            this.SkillArr2.push(obj);
         }
         for each(item in this.skillXML.Wood.item)
         {
            obj = this.parseSkillData(item);
            this.SkillArr4.push(obj);
         }
         this.SkillArr7 = [this.SkillArr1,this.SkillArr2,this.SkillArr4];
         if(this.type != 7)
         {
            for(i = 0; i < this["SkillArr" + this.type].length; i++)
            {
               obj = this["SkillArr" + this.type][i];
               this.jobPanel.skillList["skill" + i].SKILLNAME = obj.skillname;
               this.jobPanel.skillList["skill" + i].SKILLTYPE = this.type;
               if(this.type == 4)
               {
                  this.jobPanel.skillList["skill" + i].SKILLTYPE = 3;
               }
               this.jobPanel.skillList["skill" + i].SKILLLEVEL = parseInt(obj.grade);
               hasSkill = false;
               if(this.type == 1)
               {
                  if(this.p.lamuinfo.hasSkill_Fire_By_Level(i + 2))
                  {
                     hasSkill = true;
                  }
               }
               else if(this.type == 2)
               {
                  if(this.p.lamuinfo.hasSkill_Water_By_Level(i + 2))
                  {
                     hasSkill = true;
                  }
               }
               else if(this.type == 4)
               {
                  if(this.p.lamuinfo.hasSkill_Wood_By_Level(i + 2))
                  {
                     hasSkill = true;
                  }
               }
               if(hasSkill)
               {
                  this.jobPanel.skillList["btn" + i].visible = false;
                  this.jobPanel.skillList["skill" + i].gotoAndStop(2);
                  this.jobPanel.skillList["skill" + i].SKILL = "<font color=\'#0000FF\'>技能名稱：" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.desc + "\n<font color=\'#FF0000\'>已學習</FONT>";
                  BC.addEvent(this,this.jobPanel.skillList["skill" + i],MouseEvent.MOUSE_OVER,this.overFun2);
                  BC.addEvent(this,this.jobPanel.skillList["skill" + i],MouseEvent.MOUSE_OUT,this.outFun);
               }
               else
               {
                  this.jobPanel.skillList["skill" + i].SKILLPART = "<font color=\'#0000FF\'>技能名稱：" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.desc;
                  this.jobPanel.skillList["skill" + i].SKILL = "<font color=\'#0000FF\'>技能名稱：" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.desc + "\n<font color=\'#FF0000\'>" + obj.operate + "</FONT>";
                  BC.addEvent(this,this.jobPanel.skillList["btn" + i],MouseEvent.MOUSE_OVER,this.overFun);
                  BC.addEvent(this,this.jobPanel.skillList["btn" + i],MouseEvent.MOUSE_OUT,this.outFun);
                  BC.addEvent(this,this.jobPanel.skillList["btn" + i],MouseEvent.CLICK,this.learnSkillFun);
               }
            }
         }
         else
         {
            for(j = 1; j <= 3; j++)
            {
               for(i = 0; i < 5; i++)
               {
                  obj = this.SkillArr7[j - 1][i];
                  this.jobPanel["skillList" + j]["skill" + i].SKILLNAME = obj.skillname;
                  this.jobPanel["skillList" + j]["skill" + i].SKILLTYPE = j;
                  this.jobPanel["skillList" + j]["skill" + i].SKILLLEVEL = parseInt(obj.grade);
                  this.jobPanel["skillList" + j]["skill" + i].SKILL = "<font color=\'#0000FF\'>" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.supDesc + "\n<font color=\'#FF0000\'>" + obj.operate + "</FONT>";
                  hasSkill = false;
                  if(j == 1)
                  {
                     if(this.p.lamuinfo.hasSkill_Fire_By_Level(i + 2))
                     {
                        hasSkill = true;
                     }
                  }
                  else if(j == 2)
                  {
                     if(this.p.lamuinfo.hasSkill_Water_By_Level(i + 2))
                     {
                        hasSkill = true;
                     }
                  }
                  else if(j == 3)
                  {
                     if(this.p.lamuinfo.hasSkill_Wood_By_Level(i + 2))
                     {
                        hasSkill = true;
                     }
                  }
                  if(hasSkill)
                  {
                     this.jobPanel["skillList" + j]["btn" + i].visible = false;
                     this.jobPanel["skillList" + j]["skill" + i].gotoAndStop(2);
                     this.jobPanel["skillList" + j]["skill" + i].SKILL = "<font color=\'#0000FF\'>" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.supDesc + "\n<font color=\'#FF0000\'>已學習</FONT>";
                     BC.addEvent(this,this.jobPanel["skillList" + j]["skill" + i],MouseEvent.MOUSE_OVER,this.overFun2);
                     BC.addEvent(this,this.jobPanel["skillList" + j]["skill" + i],MouseEvent.MOUSE_OUT,this.outFun);
                  }
                  else
                  {
                     this.jobPanel["skillList" + j]["skill" + i].SKILLPART = "<font color=\'#0000FF\'>技能名稱：" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.supDesc;
                     this.jobPanel["skillList" + j]["skill" + i].SKILL = "<font color=\'#0000FF\'>" + obj.skillname + "\n要求變身等級：" + obj.grade + "級</font>\n" + obj.supDesc + "\n<font color=\'#FF0000\'>" + obj.operate + "</FONT>";
                     BC.addEvent(this,this.jobPanel["skillList" + j]["btn" + i],MouseEvent.MOUSE_OVER,this.overFun);
                     BC.addEvent(this,this.jobPanel["skillList" + j]["btn" + i],MouseEvent.MOUSE_OUT,this.outFun);
                     BC.addEvent(this,this.jobPanel["skillList" + j]["btn" + i],MouseEvent.CLICK,this.learnSkillFun);
                  }
               }
            }
         }
      }
      
      private function parseSkillData(item:*) : Object
      {
         var obj:Object = new Object();
         obj.skillname = String(item.@skillname);
         obj.grade = String(item.@grade);
         obj.desc = String(item.@desc);
         obj.supDesc = String(item.@supDesc);
         obj.operate = String(item.@operate);
         return obj;
      }
      
      private function learnSkillFun(evt:MouseEvent = null) : void
      {
         var index:int = 0;
         var pmc:MovieClip = null;
         var msg:String = null;
         var myalter:* = undefined;
         var btn:SimpleButton = evt.currentTarget as SimpleButton;
         index = parseInt(btn.name.slice(3));
         pmc = btn.parent as MovieClip;
         var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
         if(p.lamuinfo.hasSkillAvatar() <= 0)
         {
            GF.showAlert(MainManager.getGameLevel(),"    你的拉姆還沒有進化為第五階段,不能學習技能哦!","",100,"iknow",true,false,"E");
            return;
         }
         if(this.typeArr[p.lamuinfo.hasSkillAvatar()] != this.type)
         {
            GF.showAlert(MainManager.getGameLevel(),"    你的拉姆沒有加入該系哦,帶它去它的技能系裡學習技能吧!","",100,"iknow",true,false,"E");
            return;
         }
         var str:String = "";
         switch(pmc["skill" + index].SKILLTYPE)
         {
            case 1:
               str = "Fire";
               break;
            case 2:
               str = "Water";
               break;
            case 3:
               str = "Wood";
         }
         if(!p.lamuinfo["canLearnSkill" + str](index + 2))
         {
            msg = "    拉姆變身等級不夠，還無法學習這個技能哦！快去了解一下變身等級吧！";
            myalter = Alert.showAlert(MainManager.getGameLevel(),"",msg,Alert.SELECT_ALERT);
            BC.addEvent(this,myalter,Alert.CLICK_ + "1",this.showSkillPanel,false,0,true);
         }
         else
         {
            p.lamu.learningSkill(pmc["skill" + index].SKILLTYPE,index + 2);
            pmc["skill" + index].gotoAndStop(2);
            pmc["btn" + index].visible = false;
            btn.visible = false;
            pmc["skill" + index].SKILL = pmc["skill" + index].SKILLPART + "\n<font color=\'#FF0000\'>已學習</FONT>";
            BC.addEvent(this,pmc["skill" + index],MouseEvent.MOUSE_OVER,this.overFun2);
            BC.addEvent(this,pmc["skill" + index],MouseEvent.MOUSE_OUT,this.outFun);
            GF.showAlert(MainManager.getGameLevel(),"    你已經學會" + pmc["skill" + index].SKILLNAME + "技能了！用技能收集新物品，繼續修煉吧！！","",100,"iknow",true,false,"E");
         }
      }
      
      private function showSkillPanel(evt:Event) : void
      {
         this.removeFun();
         HelpPanel.getInstance().panelVisible("skillPanel");
      }
      
      private function overFun(e:MouseEvent) : void
      {
         var btn:SimpleButton = e.currentTarget as SimpleButton;
         var index:int = parseInt(btn.name.slice(3));
         var pmc:MovieClip = btn.parent as MovieClip;
         var MC:MovieClip = this.jobPanel.tip_mc;
         MC.txt.htmlText = pmc["skill" + index].SKILL;
         MC.txt.wordWrap = false;
         MC.txt.autoSize = TextFieldAutoSize.LEFT;
         MC.txt.width = MC.txt.textWidth;
         MC.bg_mc.width = MC.txt.textWidth + 25;
         MC.bg_mc.height = MC.txt.textHeight + 25;
         this.jobPanel.tip_mc.x = e.currentTarget.x + 220;
         this.jobPanel.tip_mc.y = e.currentTarget.y + 280;
         this.jobPanel.tip_mc.visible = true;
      }
      
      private function outFun(e:*) : void
      {
         this.jobPanel.tip_mc.x = this.jobPanel.tip_mc.y = 0;
         this.jobPanel.tip_mc.visible = false;
      }
      
      private function overFun2(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         var MC:MovieClip = this.jobPanel.tip_mc;
         MC.txt.htmlText = mc.SKILL;
         MC.txt.wordWrap = false;
         MC.txt.autoSize = TextFieldAutoSize.LEFT;
         MC.txt.width = MC.txt.textWidth;
         MC.bg_mc.width = MC.txt.textWidth + 25;
         MC.bg_mc.height = MC.txt.textHeight + 25;
         this.jobPanel.tip_mc.x = e.currentTarget.x + 220;
         this.jobPanel.tip_mc.y = e.currentTarget.y + 280;
         this.jobPanel.tip_mc.visible = true;
      }
      
      private function makeSureFun(evt:MouseEvent) : void
      {
         var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
         if(this.type != 7 && GV.MAN_PEOPLE.Petlevel == 101 && p.lamuinfo.hasSkillAvatar() == 0)
         {
            GF.showAlert(MainManager.getGameLevel(),"    你帶來的是超級拉姆，直接進化為強大的神力超拉系吧！","",100,"iknow",true,false,"E");
            return;
         }
         if(this.type == 7 && GV.MAN_PEOPLE.Petlevel != 101)
         {
            if(LocalUserInfo.getSuperPet() == false)
            {
               GF.showAlert(MainManager.getGameLevel(),"    你還沒有超級拉姆，先帶著一隻拉姆去克勞神父處升級吧！","",100,"iknow",true,false,"E");
               return;
            }
            GF.showAlert(MainManager.getGameLevel(),"    只有超級拉姆才能直接進化為強大的神力超拉系哦！","",100,"iknow",true,false,"E");
            return;
         }
         if(p.lamuinfo.hasSkillAvatar() > 0 && this.typeArr[p.lamuinfo.hasSkillAvatar()] != this.type)
         {
            if(this.typeArr[p.lamuinfo.hasSkillAvatar()] == 7)
            {
               GF.showAlert(MainManager.getGameLevel(),"    你的拉姆已成為神力超級拉姆，能夠同時學會3個系的技能，不用再加入其它系啦！","",100,"iknow",true,false,"E");
            }
            else
            {
               GF.showAlert(MainManager.getGameLevel(),"    你的拉姆已經進化為其他系啦，不能再加入該系了哦！","",100,"iknow",true,false,"E");
            }
            return;
         }
         var alert:* = Alert.showAlert(MainManager.getGameLevel(),"","  進化為神力拉姆將會擁有新的形態，並且只能學習本系技能。你確定要進化嗎？",Alert.SELECT_ALERT);
         BC.addEvent(this,alert,Alert.CLICK_ + "1",this.upgradeFun);
      }
      
      private function upgradeFun(evt:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1217,this.upgradePetHandler);
         PetStep5ClassSocket.setPetSkillType(GV.MAN_PEOPLE.PetID,this.type);
      }
      
      private function upgradePetHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1217,this.upgradePetHandler);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamuinfo.skill_learnType = evt.EventObj.skillType;
         this.upgradeMC = new MovieClip();
         MainManager.getGameLevel().addChild(this.upgradeMC);
         var loader:MCLoader = new MCLoader("resource/movie/pet5/movie" + this.type + ".swf",this.upgradeMC,1,"加載進化動畫...");
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
         loader.doLoad();
         loader = null;
      }
      
      private function loadSuccFun(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"close_pet",this.closeFun);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
         mcloader.clear();
         GV.map_ManagerChange.refreshMap();
      }
      
      private function closeFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"close_pet",this.closeFun);
         MainManager.getGameLevel().removeChild(this.upgradeMC);
         this.upgradeMC = null;
         this.removeFun();
         BC.addEvent(this,GV.onlineSocket,"read_" + 1213,this.checkPetHandler);
         PetStep5ClassSocket.askAllPetStep5Class(1);
         var msg:String = "    恭喜你已經擁有火系拉姆了！用技能獲取相應的物品，增加變身值後就能修得更厲害的技能啦！點拉姆，就能看到自己的變身等級和變身值了！";
         switch(this.type)
         {
            case 2:
               msg = "    恭喜你已經擁有水系拉姆了！用技能獲取相應的物品，增加變身值後就能修得更厲害的技能啦！點拉姆，就能看到自己的變身等級和變身值了！";
               break;
            case 4:
               msg = "    恭喜你已經擁有木系拉姆了！用技能獲取相應的物品，增加變身值後就能修得更厲害的技能啦！點拉姆，就能看到自己的變身等級和變身值了！";
               break;
            case 7:
               msg = "    恭喜你已經擁有神力超級拉姆了！如果超級拉姆到期後離開，不會影響已經獲得的技能、變身值。只需要帶拉姆來神殿重新進化，即可使用已經學會的該系技能！點擊拉姆，就能看到自己的變身等級和變身值了！";
         }
         Alert.showAlert(MainManager.getGameLevel(),"",msg,Alert.IKNOW_ALERT);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.lamuinfo.skill_learnType = this.type;
         if(this.type == 7)
         {
            p.lamuinfo.Petlevel = 101;
         }
         else
         {
            p.lamuinfo.Petlevel = 5;
         }
         p.lamu["refurbish"]();
      }
      
      private function checkPetHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1213,this.checkPetHandler);
         if(evt.EventObj.Count <= 0)
         {
            LocalUserInfo.PetSkill5_Flag = 0;
         }
      }
      
      private function removeFun(evt:MouseEvent = null) : void
      {
         if(Boolean(this.jobPanel))
         {
            MainManager.getGameLevel().removeChild(this.jobPanel);
            this.jobPanel = null;
         }
      }
   }
}

