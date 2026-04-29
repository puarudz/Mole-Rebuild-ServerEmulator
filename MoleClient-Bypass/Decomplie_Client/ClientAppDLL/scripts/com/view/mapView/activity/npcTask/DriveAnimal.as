package com.view.mapView.activity.npcTask
{
   import com.logic.FindPathLogic.FindPathLogic;
   import com.module.npc.I_NPC;
   import com.module.npc.NPCInfo;
   import com.module.npc.npcInstance.GhostNPC;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class DriveAnimal
   {
      
      public var en_name:String;
      
      public var _taskinfo:NPCInfo;
      
      public var _pigsnum:int = 5;
      
      public var pigsArray:Array;
      
      public var isCheck1:Boolean = true;
      
      public var _setDepthFun:Function;
      
      public function DriveAnimal()
      {
         super();
      }
      
      public function init(type:String = "redPig", pigsnum:int = 5) : void
      {
         var n:I_NPC = null;
         this._pigsnum = pigsnum;
         this.pigsArray = new Array(pigsnum);
         for(var i:int = 0; i < pigsnum; i++)
         {
            n = new GhostNPC(type);
            n.inSideRangeByMC(GV.MAN_PEOPLE as DisplayObjectContainer,100);
            this.pigsArray[i] = n;
            BC.addEvent(this,n,GhostNPC.ON_INSIDE_RANGE,this.checkIsPos);
            BC.addEvent(this,n["MoveEngine"],PeopleManageView.ON_SET_DEPTH,this.on_set_depth);
         }
      }
      
      private function on_set_depth(E:Event) : void
      {
         if(this._setDepthFun != null)
         {
            this._setDepthFun(this.pigsArray);
         }
      }
      
      public function addMoveCheck(setDepthFun:Function) : void
      {
         this._setDepthFun = setDepthFun;
      }
      
      public function get AnimalList() : Array
      {
         return this.pigsArray;
      }
      
      private function checkIsPos(E:Event) : void
      {
         var n:I_NPC = E.target as I_NPC;
         var p:Point = FindPathLogic.noHitLatelyPoint(new Point(n.x,n.y),new Point(n.x - (GV.MAN_PEOPLE.x - n.x),n.y - (GV.MAN_PEOPLE.y - n.y)),10);
         if(Point.distance(new Point(n.x,n.y),p) < 40)
         {
            p = n["addToFloor"]();
            n.MoveTo(p.x,p.y);
         }
         else
         {
            n.MoveTo(p.x,p.y);
         }
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
      }
   }
}

