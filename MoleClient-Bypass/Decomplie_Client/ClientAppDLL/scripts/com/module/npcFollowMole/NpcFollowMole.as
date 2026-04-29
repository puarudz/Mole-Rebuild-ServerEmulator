package com.module.npcFollowMole
{
   import com.module.npc.NPCEvent;
   import com.module.npc.npcInstance.MoleNPC;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class NpcFollowMole
   {
      
      private var _mole:PeopleManageView;
      
      private var _npcId:int = -1;
      
      private var _npc:MoleNPC;
      
      private var _moveTimer:Timer;
      
      private var _offsetWidth:Number = 30;
      
      private var _speed:Number = 1;
      
      private var _defaultSpeed:int = 100;
      
      public function NpcFollowMole()
      {
         super();
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set speed(value:Number) : void
      {
         this._speed = value;
         if(Boolean(this._npc))
         {
            this._npc.Speed = this._defaultSpeed * this._speed;
         }
      }
      
      public function get npc() : MoleNPC
      {
         return this._npc;
      }
      
      public function Follow(id:int) : void
      {
         this._npcId = id;
         BC.addEvent(this,GV.onlineSocket,"wordMapChang_over",this.FollowPeopleHandler);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.ClearMapHandler);
         if(Boolean(this._mole))
         {
            this.FollowPeopleHandler();
         }
      }
      
      private function ClearMapHandler(e:Event) : void
      {
         GC.clearGTimeout(this._moveTimer);
      }
      
      private function FollowPeopleHandler(e:Event = null) : void
      {
         if(this._npcId >= 0)
         {
            this._npc = new MoleNPC(this._npcId,false);
            this._mole = GV.MAN_PEOPLE as PeopleManageView;
            var _temp_4:* = BC;
            var _temp_3:* = this._npc;
            var _temp_2:* = NPCEvent;
            var _temp_1:* = NPCEvent.ON_NPC_LOADED;
            with({})
            {
               
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:Event):void
               {
                  _npc.autoMove = false;
                  _npc.x = _mole.x + _offsetWidth;
                  _npc.y = _mole.y;
               });
               this._npc.hideButton();
               BC.addEvent(this,this._mole,PeopleManageView.ON_GO_START,this.followTarget);
            }
         }
         
         public function followTarget(E:Event) : void
         {
            var _temp_2:* = this;
            var _temp_1:* = GC;
            with({})
            {
               _temp_2._moveTimer = _temp_1.setGTimeout(function move():void
               {
                  _npc.MoveTo(_mole.endX + _offsetWidth,_mole.endY);
               },500);
            }
            
            public function Say(str:String) : void
            {
               this._npc.say(str);
            }
            
            public function UnFollow() : void
            {
               BC.removeEvent(this);
               GC.clearGTimeout(this._moveTimer);
               if(Boolean(this._npc))
               {
                  this._npc.clearClass();
                  this._npc = null;
               }
               this._npcId = -1;
            }
            
            public function get npcId() : int
            {
               return this._npcId;
            }
         }
      }
      
      