package com.module.npc.npcInstance.lamu.skillBar
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.logic.socket.petSocket.lamuSocket;
   import com.module.npc.lamu.LamuInfo;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class LamuSkillBox
   {
      
      private static var _instance:LamuSkillBox;
      
      private var skill_mc:MovieClip;
      
      private var arr1:Array;
      
      private var enptyArr:Array = [];
      
      private var selectedIndex:int = 1;
      
      public function LamuSkillBox()
      {
         super();
         _instance = this;
         this.skill_mc = UIManager.getMovieClip("UI010_skill_box_mc") as MovieClip;
         GV.onlineSocket.addEventListener("removeMapEvent",this.hide);
      }
      
      public static function getInstance() : LamuSkillBox
      {
         return Boolean(_instance) ? _instance : new LamuSkillBox();
      }
      
      public function show() : void
      {
         BC.addEvent(this,this.skill_mc.bg_1,MouseEvent.CLICK,this.lamuOver);
         BC.addEvent(this,this.skill_mc.bg_2,MouseEvent.CLICK,this.lamuOver);
         BC.addEvent(this,this.skill_mc.bg_3,MouseEvent.CLICK,this.lamuOver);
         BC.addEvent(this,this.skill_mc.close_btn,MouseEvent.CLICK,this.hide);
         this.skill_mc.x = 960 * 0.5 - 245 * 0.5;
         this.skill_mc.y = 150;
         MainManager.getGameLevel().addChild(this.skill_mc);
         this.skill_mc.bg_1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         tip.hideTip();
      }
      
      private function hide(e:*) : void
      {
         if(Boolean(this.skill_mc.parent))
         {
            this.skill_mc.parent.removeChild(this.skill_mc);
         }
         BC.removeEvent(this);
      }
      
      private function checkHasIcon() : void
      {
         var i:int = 0;
         var item:MovieClip = null;
         this.arr1 = [];
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var boxinfo1:Object = p.lamuinfo.getSkillBoxInfo(1);
         var boxinfo2:Object = p.lamuinfo.getSkillBoxInfo(2);
         var boxinfo3:Object = p.lamuinfo.getSkillBoxInfo(3);
         var tips:String = "";
         for(i = 0; i < 6; i++)
         {
            if(p.lamuinfo.hasSkill_Fire_By_Level(i + 1))
            {
               item = this.skill_mc.getChildByName("1_" + (i + 1)) as MovieClip;
               if(!item)
               {
                  item = UIManager.getMovieClip("UI010_skillItem_mc") as MovieClip;
                  item.name = "1_" + (i + 1);
                  item.gotoAndStop(i + 1 + 20);
                  tips = LamuInfo.fireArr[i];
                  item.tips = tips;
                  tip.delTipTailDisPlayObject(item);
                  tip.tipTailDisPlayObject(item,tips);
                  this.skill_mc.addChild(item);
               }
               if(item.name != boxinfo1.t + "_" + boxinfo1.l && item.name != boxinfo2.t + "_" + boxinfo2.l && item.name != boxinfo3.t + "_" + boxinfo3.l)
               {
                  this.arr1.push(item);
               }
            }
         }
         for(i = 0; i < 6; i++)
         {
            if(p.lamuinfo.hasSkill_Water_By_Level(i + 1))
            {
               item = this.skill_mc.getChildByName("2_" + (i + 1)) as MovieClip;
               if(!item)
               {
                  item = UIManager.getMovieClip("UI010_skillItem_mc") as MovieClip;
                  item.name = "2_" + (i + 1);
                  item.gotoAndStop(i + 1 + 40);
                  tips = LamuInfo.waterArr[i];
                  item.tips = tips;
                  tip.delTipTailDisPlayObject(item);
                  tip.tipTailDisPlayObject(item,tips);
                  this.skill_mc.addChild(item);
               }
               if(item.name != boxinfo1.t + "_" + boxinfo1.l && item.name != boxinfo2.t + "_" + boxinfo2.l && item.name != boxinfo3.t + "_" + boxinfo3.l)
               {
                  this.arr1.push(item);
               }
            }
         }
         for(i = 0; i < 6; i++)
         {
            if(p.lamuinfo.hasSkill_Wood_By_Level(i + 1))
            {
               item = this.skill_mc.getChildByName("3_" + (i + 1)) as MovieClip;
               if(!item)
               {
                  item = UIManager.getMovieClip("UI010_skillItem_mc") as MovieClip;
                  item.name = "3_" + (i + 1);
                  item.gotoAndStop(i + 1 + 60);
                  tips = LamuInfo.woodArr[i];
                  item.tips = tips;
                  tip.delTipTailDisPlayObject(item);
                  tip.tipTailDisPlayObject(item,tips);
                  this.skill_mc.addChild(item);
               }
               if(item.name != boxinfo1.t + "_" + boxinfo1.l && item.name != boxinfo2.t + "_" + boxinfo2.l && item.name != boxinfo3.t + "_" + boxinfo3.l)
               {
                  this.arr1.push(item);
               }
            }
         }
      }
      
      private function sortIcon() : void
      {
         var mc:MovieClip = null;
         var l:int = 0;
         while(Boolean(this.enptyArr.length))
         {
            this.skill_mc.removeChild(DisplayObjectContainer(this.enptyArr.pop()));
         }
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var boxinfo:Object = p.lamuinfo.getSkillBoxInfo(1);
         if(Boolean(boxinfo))
         {
            mc = this.skill_mc.getChildByName(boxinfo.t + "_" + boxinfo.l) as MovieClip;
         }
         tip.delTipTailDisPlayObject(this.skill_mc.bg_1);
         if(Boolean(mc))
         {
            mc.x = this.skill_mc.bg_1.x;
            mc.y = this.skill_mc.bg_1.y;
            mc.scaleX = mc.scaleY = 2;
            mc.visible = false;
            this.skill_mc.bg_1.tips = mc.tips;
            tip.tipTailDisPlayObject(this.skill_mc.bg_1,mc.tips);
            this.skill_mc.bg_1.gotoAndStop(mc.currentFrame);
         }
         else
         {
            this.skill_mc.bg_1.gotoAndStop(1);
         }
         mc = null;
         boxinfo = p.lamuinfo.getSkillBoxInfo(2);
         if(Boolean(boxinfo))
         {
            mc = this.skill_mc.getChildByName(boxinfo.t + "_" + boxinfo.l) as MovieClip;
         }
         tip.delTipTailDisPlayObject(this.skill_mc.bg_2);
         if(Boolean(mc))
         {
            mc.x = this.skill_mc.bg_2.x;
            mc.y = this.skill_mc.bg_2.y;
            mc.scaleX = mc.scaleY = 2;
            mc.visible = false;
            this.skill_mc.bg_2.tips = mc.tips;
            tip.tipTailDisPlayObject(this.skill_mc.bg_2,mc.tips);
            this.skill_mc.bg_2.gotoAndStop(mc.currentFrame);
         }
         else
         {
            this.skill_mc.bg_2.gotoAndStop(1);
         }
         mc = null;
         boxinfo = p.lamuinfo.getSkillBoxInfo(3);
         if(Boolean(boxinfo))
         {
            mc = this.skill_mc.getChildByName(boxinfo.t + "_" + boxinfo.l) as MovieClip;
         }
         tip.delTipTailDisPlayObject(this.skill_mc.bg_3);
         if(Boolean(mc))
         {
            mc.x = this.skill_mc.bg_3.x;
            mc.y = this.skill_mc.bg_3.y;
            mc.scaleX = mc.scaleY = 2;
            mc.visible = false;
            this.skill_mc.bg_3.tips = mc.tips;
            tip.tipTailDisPlayObject(this.skill_mc.bg_3,mc.tips);
            this.skill_mc.bg_3.gotoAndStop(mc.currentFrame);
         }
         else
         {
            this.skill_mc.bg_3.gotoAndStop(1);
         }
         var len:int = (int((this.arr1.length - 1) / 5) + 1) * 5;
         for(var i:int = 0; i < len; i++)
         {
            mc = i < this.arr1.length ? this.arr1[i] : this.getEnptyMC();
            l = int(i / 5);
            mc.x = i * 40 - l * 5 * 40 + 5 + this.selectedIndex * 20 + 30;
            mc.y = l * 40 + 115;
            mc.bg_mc.alpha = 1;
            mc.scaleX = mc.scaleY = 1;
            BC.addEvent(this,mc,MouseEvent.MOUSE_DOWN,this.useLamuSkill);
            mc.btn.visible = false;
            mc.visible = true;
         }
      }
      
      private function getEnptyMC() : MovieClip
      {
         var item:MovieClip = UIManager.getMovieClip("UI010_skillItem_mc") as MovieClip;
         item.gotoAndStop(3);
         item.mouseEnabled = false;
         item.mouseChildren = false;
         this.enptyArr.push(item);
         this.skill_mc.addChild(item);
         return item;
      }
      
      private function lamuOver(e:MouseEvent) : void
      {
         this.skill_mc.bg_1.btn.gotoAndStop(1);
         this.skill_mc.bg_2.btn.gotoAndStop(1);
         this.skill_mc.bg_3.btn.gotoAndStop(1);
         this.selectedIndex = int(e.currentTarget.name.split("_")[1]);
         this.skill_mc["bg_" + this.selectedIndex].btn.gotoAndStop(2);
         this.checkHasIcon();
         this.sortIcon();
      }
      
      private function useLamuSkill(E:MouseEvent) : void
      {
         var mc:MovieClip = E.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            trace(int(mc.name.split("_")[0]),int(mc.name.split("_")[1]));
            p.lamuinfo.setSkillBoxInfo(this.selectedIndex,int(mc.name.split("_")[0]),int(mc.name.split("_")[1]));
            lamuSocket.setPetSkillBox(p.lamuinfo.PetID,p.lamuinfo.getSkillBoxInfo(1).v,p.lamuinfo.getSkillBoxInfo(2).v,p.lamuinfo.getSkillBoxInfo(3).v);
         }
         this.checkHasIcon();
         this.sortIcon();
      }
   }
}

