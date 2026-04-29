package com.view.player
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Tick;
   
   public class MultiEquipPlayer extends Sprite
   {
      
      public static const CHANGE_CLOTH_OVER:String = "CHANGE_CLOTH_OVER";
      
      public static const THROW_ITEM_INIT:String = "throw_item_init";
      
      public static const THROW_ITEM_START:String = "throw_item_start";
      
      protected var playerMap:HashMap;
      
      protected var _nudePlayer:EquipPlayer;
      
      protected var _facePlayer:EquipPlayer;
      
      protected var _curAction:uint;
      
      protected var loop:uint;
      
      protected var loopOverAction:int;
      
      protected var dir:uint;
      
      protected var _curActionTypeIndex:uint;
      
      protected var allGet:Boolean;
      
      protected var dispatchEvt:Boolean;
      
      protected var _isPlaying:Boolean;
      
      protected var color:Object;
      
      public function MultiEquipPlayer(color:Object)
      {
         super();
         this.playerMap = new HashMap();
         this.color = color;
         this.init();
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
      }
      
      protected function init() : void
      {
         var player:EquipPlayer = new EquipPlayer(ClothConstant.NICK_DECORATION);
         addChild(player);
         this.playerMap.add(ClothConstant.NICK_DECORATION,player);
         this._nudePlayer = new EquipPlayer(ClothConstant.NUDE);
         addChild(this._nudePlayer);
         this.playerMap.add(ClothConstant.NUDE,this._nudePlayer);
         this._facePlayer = new EquipPlayer(ClothConstant.NUDE_FACE);
         addChild(this._facePlayer);
         this.playerMap.add(ClothConstant.NUDE_FACE,this._facePlayer);
         player = new EquipPlayer(ClothConstant.FOOT);
         addChild(player);
         this.playerMap.add(ClothConstant.FOOT,player);
         player = new EquipPlayer(ClothConstant.WING);
         addChild(player);
         this.playerMap.add(ClothConstant.WING,player);
         player = new EquipPlayer(ClothConstant.BODY);
         addChild(player);
         this.playerMap.add(ClothConstant.BODY,player);
         player = new EquipPlayer(ClothConstant.NECK);
         addChild(player);
         this.playerMap.add(ClothConstant.NECK,player);
         player = new EquipPlayer(ClothConstant.FACE);
         addChild(player);
         this.playerMap.add(ClothConstant.FACE,player);
         player = new EquipPlayer(ClothConstant.HEAD);
         addChild(player);
         this.playerMap.add(ClothConstant.HEAD,player);
         player = new EquipPlayer(ClothConstant.HAND);
         addChild(player);
         this.playerMap.add(ClothConstant.HAND,player);
         player = new EquipPlayer(ClothConstant.DECORATION);
         addChild(player);
         this.playerMap.add(ClothConstant.DECORATION,player);
         Tick.instance.addRender(this.renderHandler);
         this._nudePlayer.updateEquip(1);
         this._nudePlayer.transform.colorTransform = new ColorTransform(this.color.red / 256,this.color.green / 256,this.color.blue / 256,1);
         this._facePlayer.updateEquip(2);
         this.doAction(PlayerActionConstant.ACTION_STAND,0);
      }
      
      private function removeFromStage(evt:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
      }
      
      public function updatePlayerPos(playerTyper:uint, pos:Point, isOff:Boolean = true) : void
      {
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            if(player.slot == playerTyper)
            {
               if(isOff)
               {
                  player.x += pos.x;
                  player.y += pos.y;
               }
               else
               {
                  player.x = pos.x;
                  player.y = pos.y;
               }
            }
         });
      }
      
      public function changeColor(color:Object) : void
      {
         this._nudePlayer.transform.colorTransform = new ColorTransform(color.red / 256,color.green / 256,color.blue / 256,1);
      }
      
      public function changeNude(nudeIndex:uint) : void
      {
         this._nudePlayer.updateEquip(nudeIndex);
      }
      
      public function updateEquip(clothArr:Array) : void
      {
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            var haveCloth:Boolean = false;
            var cloth:Object = null;
            if(player.slot != ClothConstant.NUDE && player.slot != ClothConstant.NUDE_FACE)
            {
               haveCloth = false;
               for each(cloth in clothArr)
               {
                  if(cloth.layer == player.slot && cloth.ItemID != 0)
                  {
                     haveCloth = true;
                     player.updateEquip(cloth.ItemID);
                     break;
                  }
               }
               if(!haveCloth)
               {
                  player.clear();
               }
            }
         });
         this.allGet = false;
         this.dispatchEvt = true;
      }
      
      public function doAction(action:uint, _dir:uint, _loop:uint = 0, _loopOverAction:int = 1) : void
      {
         var actionTypeIndex:uint = 0;
         var actionIndex:uint = 0;
         this._isPlaying = true;
         this._curAction = action;
         this.dir = _dir;
         actionTypeIndex = PlayerActionConstant.getActionTypeId(action);
         if(this._curActionTypeIndex != actionTypeIndex)
         {
            this._curActionTypeIndex = actionTypeIndex;
            this.allGet = false;
         }
         actionIndex = PlayerActionConstant.getActionIndex(action,this.dir);
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            player.actionTypeId = actionTypeIndex;
            player.setIndex(actionIndex);
         });
         if(_dir >= 3 && _dir <= 5)
         {
            addChild(this.playerMap.getValue(ClothConstant.WING));
         }
         else
         {
            addChildAt(this.playerMap.getValue(ClothConstant.WING),1);
         }
         this._nudePlayer.removeFrameCompleteEvent(this.frameLoopCompleteHandler);
         this.loopOverAction = -1;
         if(_loop != 0)
         {
            this.loop = _loop;
            this.loopOverAction = _loopOverAction;
            this._nudePlayer.addFrameCompleteEvent(this.frameLoopCompleteHandler);
         }
      }
      
      protected function frameLoopCompleteHandler(evt:Event) : void
      {
         --this.loop;
         if(this.loop == 0)
         {
            if(this.loopOverAction == -1)
            {
               this._isPlaying = false;
            }
            else
            {
               this.doAction(this.loopOverAction,this.dir);
               trace("動作播放完成");
            }
         }
      }
      
      protected function renderHandler(... ret) : void
      {
         var flag:Boolean;
         var nudeDownOver:Boolean = false;
         var curNudeFrame:uint = 0;
         if(!this._isPlaying)
         {
            return;
         }
         flag = true;
         nudeDownOver = !this._nudePlayer.isGeting;
         curNudeFrame = 0;
         if(nudeDownOver)
         {
            curNudeFrame = this._nudePlayer.currentFrame;
         }
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            if(player.isGeting)
            {
               flag = false;
            }
            if(nudeDownOver)
            {
               if(!player.isGeting)
               {
                  player.visible = true;
                  player.gotoAndPlay(curNudeFrame);
               }
            }
            if(player.isPlaying)
            {
               player.render();
            }
         });
         if(flag && !this.allGet)
         {
            this.allGet = true;
            if(this.dispatchEvt && Boolean(this.parent))
            {
               this.dispatchEvt = false;
               dispatchEvent(new Event(CHANGE_CLOTH_OVER));
            }
         }
         if(this._curAction == PlayerActionConstant.ACTION_THROW)
         {
            if(this._nudePlayer.currentFrame == 4)
            {
               dispatchEvent(new Event(THROW_ITEM_INIT));
            }
            else if(this._nudePlayer.currentFrame == 12)
            {
               dispatchEvent(new Event(THROW_ITEM_START));
            }
         }
      }
      
      public function stop() : void
      {
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            player.stop();
         });
      }
      
      public function dispose() : void
      {
         Tick.instance.removeRender(this.renderHandler);
         if(Boolean(this._nudePlayer))
         {
            this._nudePlayer.removeFrameCompleteEvent(this.frameLoopCompleteHandler);
         }
         this.playerMap.eachValue(function(player:EquipPlayer):void
         {
            player.clear();
            player.dispose();
            player = null;
         });
         this.playerMap = null;
         this._nudePlayer = null;
         this._facePlayer = null;
      }
      
      public function get curAction() : uint
      {
         return this._curAction;
      }
   }
}

