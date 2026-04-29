package com.view.player
{
   import org.taomee.utils.Tick;
   
   public class TransfigurationMultiEquipPlayer extends MultiEquipPlayer
   {
      
      public static const POSITIVE_ORDER:Array = [ClothConstant.WING,ClothConstant.NUDE,ClothConstant.FACE,ClothConstant.BODY,ClothConstant.HEAD,ClothConstant.DECORATION];
      
      public static const BACK_ORDER:Array = [ClothConstant.DECORATION,ClothConstant.FACE,ClothConstant.NUDE,ClothConstant.BODY,ClothConstant.HEAD,ClothConstant.WING];
      
      private var positive:Boolean;
      
      private var _nudeIndex:uint;
      
      public function TransfigurationMultiEquipPlayer(color:Object)
      {
         super(color);
      }
      
      override protected function init() : void
      {
         _nudePlayer = new EquipPlayer(ClothConstant.NUDE);
         addChild(_nudePlayer);
         playerMap.add(ClothConstant.NUDE,_nudePlayer);
         var player:EquipPlayer = new EquipPlayer(ClothConstant.DECORATION);
         addChild(player);
         playerMap.add(ClothConstant.DECORATION,player);
         player = new EquipPlayer(ClothConstant.HEAD);
         addChild(player);
         playerMap.add(ClothConstant.HEAD,player);
         player = new EquipPlayer(ClothConstant.BODY);
         addChild(player);
         playerMap.add(ClothConstant.BODY,player);
         player = new EquipPlayer(ClothConstant.FACE);
         addChild(player);
         playerMap.add(ClothConstant.FACE,player);
         player = new EquipPlayer(ClothConstant.WING);
         addChild(player);
         playerMap.add(ClothConstant.WING,player);
         Tick.instance.addRender(renderHandler);
         this.doAction(PlayerActionConstant.ACTION_STAND,0);
      }
      
      override public function doAction(action:uint, _dir:uint, _loop:uint = 0, _loopOverAction:int = 1) : void
      {
         var tmpPositive:Boolean;
         var actionTypeIndex:uint = 0;
         var actionIndex:uint = 0;
         var arr:Array = null;
         var index:uint = 0;
         _isPlaying = true;
         _curAction = action;
         actionTypeIndex = PlayerActionConstant.getActionTypeId(action);
         if(_curActionTypeIndex != actionTypeIndex)
         {
            _curActionTypeIndex = actionTypeIndex;
            allGet = false;
         }
         actionIndex = PlayerActionConstant.getNewRoleActionIndex(action,_dir);
         playerMap.eachValue(function(player:EquipPlayer):void
         {
            player.actionTypeId = actionTypeIndex;
            player.setIndex(actionIndex);
         });
         dir = _dir;
         tmpPositive = false;
         if(dir > 4)
         {
            scaleX = -1;
         }
         else
         {
            scaleX = 1;
         }
         if(dir >= 3 && dir <= 5)
         {
            tmpPositive = false;
         }
         else
         {
            tmpPositive = true;
         }
         if(this.positive != tmpPositive)
         {
            arr = [];
            if(tmpPositive)
            {
               arr = POSITIVE_ORDER;
            }
            else
            {
               arr = BACK_ORDER;
            }
            for each(index in arr)
            {
               addChild(playerMap.getValue(index));
            }
            this.positive = tmpPositive;
         }
         _nudePlayer.removeFrameCompleteEvent(frameLoopCompleteHandler);
         loopOverAction = -1;
         if(_loop != 0)
         {
            loop = _loop;
            loopOverAction = _loopOverAction;
            _nudePlayer.addFrameCompleteEvent(frameLoopCompleteHandler);
         }
      }
      
      override public function changeColor(color:Object) : void
      {
         this.color = color;
      }
      
      override public function changeNude(nudeIndex:uint) : void
      {
         this._nudeIndex = nudeIndex + 2;
         _nudePlayer.updateEquip(this._nudeIndex);
         var player:EquipPlayer = playerMap.getValue(ClothConstant.FACE);
         player.updateEquip(100 + this._nudeIndex);
         this.doAction(PlayerActionConstant.ACTION_STAND,0);
      }
      
      override public function updateEquip(clothArr:Array) : void
      {
         super.updateEquip(clothArr);
         var player:EquipPlayer = playerMap.getValue(ClothConstant.FACE);
         if(player.resId == 0)
         {
            player.updateEquip(100 + this._nudeIndex);
         }
      }
      
      override public function dispose() : void
      {
         Tick.instance.removeRender(renderHandler);
         if(Boolean(_nudePlayer))
         {
            _nudePlayer.removeFrameCompleteEvent(frameLoopCompleteHandler);
         }
         playerMap.eachValue(function(player:EquipPlayer):void
         {
            player.dispose();
            player = null;
         });
         playerMap = null;
         _nudePlayer = null;
         _facePlayer = null;
      }
   }
}

