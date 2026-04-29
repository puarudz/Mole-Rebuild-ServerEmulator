package com.module.dragon.dragonAction
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.view.PeopleView.ChildPeople.BoyAvatar;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class DragonAction extends EventDispatcher
   {
      
      private static var instance:DragonAction;
      
      public function DragonAction()
      {
         super();
      }
      
      public static function getInstance() : DragonAction
      {
         return instance = Boolean(instance) ? instance : new DragonAction();
      }
      
      public function EventAggregation(type:String, p:PeopleManageView, data:Object) : void
      {
         this[type](p,data);
         dispatchEvent(new EventTaomee(type,{
            "p":p,
            "data":data
         }));
      }
      
      public function dragon_1350004(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p.addEventListener(PeopleManageView.ON_GO_START,this.startdump);
      }
      
      public function dragon_1350037(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p.addEventListener(PeopleManageView.ON_GO_START,this.startdump);
      }
      
      public function dragon_1350043(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p.addEventListener(PeopleManageView.ON_GO_START,this.startdump);
      }
      
      public function dragon_1350044(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p.addEventListener(PeopleManageView.ON_GO_START,this.startdump);
      }
      
      public function dragon_1350009(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         if(p.id == 85577)
         {
            p.addEventListener(PeopleManageView.ON_GO_START,this.startdump);
         }
         else
         {
            p.addEventListener(PeopleManageView.ON_GO_START,this.startdump2);
         }
      }
      
      private function dragon_1350045(p:PeopleManageView, data:Object) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p.addEventListener(PeopleManageView.ON_GO_START,this.showSnow);
      }
      
      private function showSnow(E:Event) : void
      {
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         var p:PeopleManageView = E.target as PeopleManageView;
         var cl:BoyAvatar = p.avatarClass as BoyAvatar;
         if(Boolean(p) && Boolean(p.dragon_Info) && p.dragon_Info.ItemID != 1350045)
         {
            this.getOffSnowLong(p);
            return;
         }
         if(Boolean(p) && !p.dragon_Info)
         {
            this.getOffSnowLong(p);
            return;
         }
         if(p.dragon_Info.Growth < p.dragon_Info.Growth)
         {
            this.getOffSnowLong(p);
            return;
         }
         this.getOnSnowLong(p);
      }
      
      public function startdump2(E:Event) : void
      {
         var p:PeopleManageView = null;
         var cl:BoyAvatar = null;
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p = E.target as PeopleManageView;
         cl = p.avatarClass as BoyAvatar;
         if(Boolean(p) && Boolean(p.dragon_Info) && p.dragon_Info.ItemID != 1350009)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump2);
            return;
         }
         if(Boolean(p) && !p.dragon_Info)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump2);
            return;
         }
         if(p.dragon_Info.Growth < p.dragon_Info.Growth)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump2);
            return;
         }
         if(Boolean(cl) && Boolean(p))
         {
            p.stopAction(cl.currentDirection);
            cl.myTween_X.stop();
            cl.myTween_Y.stop();
            GC.setGTimeout(function():void
            {
               p.x = p.endX;
               p.y = p.endY;
               p.isFlying = false;
               GC.setGTimeout(cl.goOver,500);
               GC.setGTimeout(cl.goOver,500);
            },500);
         }
      }
      
      private function getOnSnowLong(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            BC.addEvent(this,PeoPleMC,PeopleManageView.ON_SET_DEPTH,this.addSnowLongMark);
            BC.addEvent(this,PeoPleMC,PeopleManageView.ON_GO_START,this.addSnowLongMark);
         }
      }
      
      private function getOffSnowLong(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            BC.removeEvent(this,PeoPleMC,PeopleManageView.ON_SET_DEPTH,this.addSnowLongMark);
            BC.removeEvent(this,PeoPleMC,PeopleManageView.ON_GO_START,this.addSnowLongMark);
         }
      }
      
      private function addSnowLongMark(e:Event) : void
      {
         var p:PeopleManageView = PeopleManageView(e.target);
         if(Boolean(p) && Boolean(p.dragon_Info) && p.dragon_Info.ItemID != 1350045)
         {
            this.getOffSnowLong(p);
            return;
         }
         if(Boolean(p) && !p.dragon_Info)
         {
            this.getOffSnowLong(p);
            return;
         }
         if(p.dragon_Info.Growth < p.dragon_Info.Growth)
         {
            this.getOffSnowLong(p);
            return;
         }
         var tempFootMark:MovieClip = UIManager.getMovieClip("SnowLong");
         var tempMarkDirction:uint = 0;
         tempMarkDirction = p.avatarClass.DirectionNum;
         tempFootMark.gotoAndStop(tempMarkDirction + 1);
         tempFootMark.x = p.x;
         tempFootMark.y = p.y;
         var mc:MovieClip = GV.MC_mapFrame;
         if(Boolean(mc))
         {
            mc.addChildAt(tempFootMark,mc.getChildIndex(mc["depth_mc"]) - 1);
         }
      }
      
      public function startdump(E:Event) : void
      {
         var len:int;
         var a:Point;
         var b:Point;
         var p:PeopleManageView = null;
         var cl:BoyAvatar = null;
         var pa:Array = null;
         var t:Timer = null;
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         p = E.target as PeopleManageView;
         cl = p.avatarClass as BoyAvatar;
         if(Boolean(p && p.dragon_Info && p.dragon_Info.ItemID != 1350004 && p.dragon_Info.ItemID != 1350037) && Boolean(p.dragon_Info.ItemID != 1350043) && p.dragon_Info.ItemID != 1350044)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump);
            return;
         }
         if(Boolean(p) && !p.dragon_Info)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump2);
            return;
         }
         if(p.dragon_Info.Growth < p.dragon_Info.Growth)
         {
            p.removeEventListener(PeopleManageView.ON_GO_START,this.startdump2);
            return;
         }
         len = Point.distance(new Point(p.startX,p.startY),new Point(p.endX,p.endY));
         a = new Point(p.startX,p.startY);
         b = new Point(p.endX,p.endY);
         pa = [Point.interpolate(a,b,0.9),Point.interpolate(a,b,0.8),Point.interpolate(a,b,0.6),Point.interpolate(a,b,0.3)];
         if(!cl)
         {
            cl = p.avatarClass as BoyAvatar;
         }
         if(Boolean(cl))
         {
            p.visible = false;
            p.stopAction(cl.currentDirection);
            cl.myTween_X.stop();
            cl.myTween_Y.stop();
         }
         t = GC.setGInterval(function():void
         {
            var mc:* = undefined;
            var s:* = undefined;
            var top:* = undefined;
            if(Boolean(p.parent))
            {
               if(t.currentCount >= 5)
               {
                  p.x = p.endX;
                  p.y = p.endY;
                  p.isFlying = false;
                  p.visible = true;
                  if(Boolean(cl))
                  {
                     GC.setGTimeout(cl.goOver,500);
                  }
               }
               else
               {
                  mc = copyBmp(p,true);
                  mc.x = pa[t.currentCount - 1].x;
                  mc.y = pa[t.currentCount - 1].y;
                  mc.alpha = t.currentCount / 5;
                  mc.mouseEnabled = false;
                  mc.mouseChildren = false;
                  s = new ColorMatrixFilter();
                  s.matrix = [1,0,0,0,-100,0,1,0,0,-100,0,0,1,0,-100,0,0,0,1,0];
                  mc.filters = [s];
                  mc.addEventListener(Event.ENTER_FRAME,function(e:Event):void
                  {
                     mc.alpha -= 0.05;
                     if(mc.alpha <= 0)
                     {
                        GC.clearAll(mc);
                     }
                  });
                  top = p.parent.parent["top_mc"] as MovieClip;
                  if(!top)
                  {
                     top = new MovieClip();
                     p.parent.parent["top_mc"] = top;
                     p.parent.parent.addChild(top);
                  }
                  top.addChild(mc);
               }
            }
         },"20:5");
      }
      
      private function copyBmp(mc:DisplayObjectContainer, repairRegistPoint:Boolean = false) : Sprite
      {
         var offsety:int = 0;
         var rect:Rectangle = mc.getRect(mc.parent);
         var offsetx:int = mc.x - rect.x;
         offsety = mc.y - rect.y;
         var matrix:Matrix = new Matrix(1,0,0,1,offsetx,offsety);
         var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
         bmd.draw(mc,matrix);
         var FairyBMP:Bitmap = new Bitmap(bmd);
         if(repairRegistPoint)
         {
            FairyBMP.x = offsetx * -1;
            FairyBMP.y = offsety * -1;
         }
         var sd:Sprite = new Sprite();
         sd.addChild(FairyBMP);
         return sd;
      }
      
      public function changeDirection(p:PeopleManageView, data:Object) : void
      {
         var dir:int = p.dragon["dirObj"][data.dir] + 2;
         data.mc.gotoAndStop(dir);
      }
   }
}

