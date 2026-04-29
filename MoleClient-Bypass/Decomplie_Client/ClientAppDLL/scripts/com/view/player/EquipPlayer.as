package com.view.player
{
   import com.mole.utils.URLUtil;
   import com.taomee.mole.player.SpritePlayer;
   import flash.system.ApplicationDomain;
   
   public class EquipPlayer extends SpritePlayer
   {
      
      private var _slot:int;
      
      private var _resId:int;
      
      private var _actionTypeId:uint = 1001;
      
      public function EquipPlayer(slot:int)
      {
         super();
         this._slot = slot;
      }
      
      public function get slot() : int
      {
         return this._slot;
      }
      
      public function get resId() : uint
      {
         return this._resId;
      }
      
      override public function clear() : void
      {
         super.clear();
         this._resId = 0;
      }
      
      public function updateEquip(resId:uint) : void
      {
         if(resId != this._resId)
         {
            this._resId = resId;
            resourceURL = URLUtil.getClothSwf(this._resId,this._actionTypeId);
         }
      }
      
      public function updateEquipFromDomain(resId:uint, domain:ApplicationDomain) : void
      {
         if(resId != this._resId)
         {
            this._resId = resId;
            setDomain(URLUtil.getClothSwf(this._resId,this._actionTypeId),domain);
         }
      }
      
      public function set actionTypeId(val:uint) : void
      {
         if(this._actionTypeId != val)
         {
            if(this._slot != ClothConstant.NUDE)
            {
               super.visible = false;
            }
            else
            {
               super.stop();
            }
            if(this._resId != 0)
            {
               resourceURL = URLUtil.getClothSwf(this._resId,val);
            }
            this._actionTypeId = val;
         }
      }
   }
}

