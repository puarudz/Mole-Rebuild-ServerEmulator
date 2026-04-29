package com.module.npc.npcInstance.lamu.skillBar
{
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.module.npc.lamu.LamuInfo;
   import com.view.PeopleView.PeopleManageView;
   import com.view.PeopleView.PetHitConditional;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LamuSkillBar
   {
      
      private static var _instance:LamuSkillBar;
      
      private static var skill_mc:MovieClip;
      
      public function LamuSkillBar()
      {
         super();
         _instance = this;
         this.init();
      }
      
      public static function getInstance() : LamuSkillBar
      {
         return Boolean(_instance) ? _instance : new LamuSkillBar();
      }
      
      public function init() : void
      {
         BC.addEvent(this,PetHitConditional,MouseEvent.MOUSE_OVER,this.lamuOver);
         skill_mc = UIManager.getMovieClip("skill_mc") as MovieClip;
         GV.onlineSocket.addEventListener("removeMapEvent",this.hideLamuIco);
      }
      
      private function hideLamuIco(e:*) : void
      {
         tip.hideTip();
         GC.clearAllChildren(skill_mc);
         if(Boolean(skill_mc.parent))
         {
            skill_mc.parent.removeChild(skill_mc);
         }
         BC.removeEvent(this);
         BC.addEvent(this,PetHitConditional,MouseEvent.MOUSE_OVER,this.lamuOver);
      }
      
      private function lamuOver(e:EventTaomee) : void
      {
         var po:Point = null;
         var mc:* = undefined;
         var type:int = 0;
         var lv:int = 0;
         var sort_Array:Array = null;
         var tips:String = null;
         var i:int = 0;
         var obj:Object = null;
         var p:PeopleManageView = e.EventObj.People as PeopleManageView;
         var isSelf:Boolean = Boolean(e.EventObj.isSelf);
         if(Boolean(isSelf && !creatShareObject.getInstance().getLahuWood()) && Boolean(p.avatarMC.pet_mc.visible) && Boolean(p.lamu["visible"]))
         {
            GC.clearAllChildren(skill_mc);
            BC.addEvent(this,p,PeopleManageView.ON_GO_START,this.hideLamuIco);
            BC.addEvent(this,p.stage,MouseEvent.MOUSE_UP,this.lamuOut);
            MainManager.getGameLevel().addChild(skill_mc);
            po = new Point(p.lamu.x,p.lamu.y);
            po = p.lamu["parent"].localToGlobal(po);
            skill_mc.x = po.x;
            skill_mc.y = po.y - 10;
            type = 0;
            lv = 0;
            sort_Array = [];
            tips = "";
            if(p.lamuinfo.isUserSKill < 1208012)
            {
               for(i = 0; i < 3; i++)
               {
                  obj = p.lamuinfo.getSkillBoxInfo(i + 1);
                  if(Boolean(obj.v))
                  {
                     mc = UIManager.getMovieClip("UI010_skillBtn_mc");
                     type = int(obj.t);
                     lv = int(obj.l);
                     mc.name = "_" + type + "_" + lv;
                     mc.gotoAndStop((type - 1) * 40 + lv);
                     skill_mc.addChild(mc);
                     if(type == 1)
                     {
                        tips = LamuInfo.fireArr[lv - 1];
                     }
                     else if(type == 2)
                     {
                        tips = LamuInfo.waterArr[lv - 1];
                     }
                     else if(type == 3)
                     {
                        tips = LamuInfo.woodArr[lv - 1];
                     }
                     tip.tipTailDisPlayObject(mc,tips);
                     sort_Array.push(mc);
                     BC.addEvent(this,mc,MouseEvent.CLICK,this.useLamuSkill);
                  }
               }
            }
            if(p.lamuinfo.skill_Fire > 1 || p.lamuinfo.skill_Water > 1 || p.lamuinfo.skill_Wood > 1)
            {
               mc = UIManager.getMovieClip("UI010_skillBtn_mc");
               if(p.lamuinfo.isUserSKill >= 1208012)
               {
                  mc.gotoAndStop("useSkill");
                  skill_mc.addChild(mc);
                  tips = "釋放技能";
                  tip.tipTailDisPlayObject(mc,tips);
                  sort_Array.push(mc);
                  BC.addEvent(this,mc,MouseEvent.CLICK,this.escLamuSkill);
               }
               else
               {
                  mc.gotoAndStop("set");
                  skill_mc.addChild(mc);
                  tips = "替換技能";
                  tip.tipTailDisPlayObject(mc,tips);
                  sort_Array.push(mc);
                  BC.addEvent(this,mc,MouseEvent.CLICK,this.setLamuSkill);
               }
            }
            if(sort_Array.length >= 4)
            {
               for(i = 0; i < sort_Array.length; i++)
               {
                  sort_Array[i].x = 0;
                  sort_Array[i].y = 0;
                  sort_Array[i].rotation = i * 35;
               }
            }
            else
            {
               for(i = 0; i < sort_Array.length; i++)
               {
                  sort_Array[i].x = 0;
                  sort_Array[i].y = 0;
                  sort_Array[i].rotation = i * 35 + 10;
               }
            }
         }
      }
      
      private function lamuOut(e:MouseEvent = null) : void
      {
         if(e.type == MouseEvent.MOUSE_UP || !skill_mc.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY))
         {
            DisplayUtil.removeForParent(skill_mc,false);
            BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_UP,this.lamuOut);
            BC.removeEvent(this,null,PeopleManageView.ON_GO_START,this.hideLamuIco);
         }
      }
      
      private function escLamuSkill(E:MouseEvent) : *
      {
         var p:PeopleManageView = null;
         p = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            p.lamu.geocaching(p.lamu as DisplayObjectContainer,function():*
            {
               var id:uint = 0;
               var r:int = Math.random() * 100;
               if(p.lamuinfo.skillLevel == 6)
               {
                  if(r < 30)
                  {
                     return 190751;
                  }
                  if(r < 60)
                  {
                     return 190752;
                  }
                  return 190753;
               }
               if(r < 30)
               {
                  return 190673;
               }
               if(r < 60)
               {
                  return 190674;
               }
               if(r < 90)
               {
                  return 190672;
               }
               return 190688;
            });
         }
      }
      
      private function setLamuSkill(E:MouseEvent) : void
      {
         LamuSkillBox.getInstance().show();
      }
      
      private function useLamuSkill(E:MouseEvent) : void
      {
         var mc:MovieClip = E.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            p.lamu.useLamuSkill(mc.name.split("_")[1],mc.name.split("_")[2]);
         }
      }
   }
}

