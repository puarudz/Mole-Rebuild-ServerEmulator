package com.module.elementKnight.info
{
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.module.elementKnight.ElementCardManager;
   import com.module.elementKnight.ElementKnightInfoManager;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightInfo
   {
      
      public var id:uint;
      
      public var type:uint;
      
      public var nick:String;
      
      public var exp:uint;
      
      public var curStrength:uint;
      
      public var maxStrength:uint;
      
      public var talent:uint;
      
      public var minAttack:uint;
      
      public var maxAttack:uint;
      
      public var minDef:uint;
      
      public var maxDef:uint;
      
      public var pvpWin:uint;
      
      public var pvpLose:uint;
      
      public var chasm:uint;
      
      public var rank:uint;
      
      public var coolDown:uint;
      
      public var cardList:Vector.<ElementKnightCardInfo>;
      
      public var itemMap:HashMap;
      
      private var _lv:uint;
      
      private var _curExp:uint;
      
      private var _needExp:uint;
      
      public function ElementKnightInfo(recData:ByteArray)
      {
         var i:int = 0;
         var itemId:uint = 0;
         var itemCount:uint = 0;
         super();
         if(!recData)
         {
            this.type = 0;
            return;
         }
         this.cardList = new Vector.<ElementKnightCardInfo>();
         this.itemMap = new HashMap();
         this.id = recData.readUnsignedInt();
         this.type = recData.readUnsignedInt();
         this.nick = recData.readUTFBytes(16);
         this.exp = recData.readUnsignedInt();
         this.curStrength = recData.readUnsignedInt();
         this.maxStrength = recData.readUnsignedInt();
         this.talent = recData.readUnsignedInt();
         this.coolDown = this.getCD(recData.readUnsignedInt());
         this.minAttack = recData.readUnsignedInt();
         this.maxAttack = recData.readUnsignedInt();
         this.minDef = recData.readUnsignedInt();
         this.maxDef = recData.readUnsignedInt();
         this.pvpWin = recData.readUnsignedInt();
         this.pvpLose = recData.readUnsignedInt();
         this.chasm = recData.readUnsignedInt();
         this.rank = recData.readUnsignedInt();
         this.cardList.length = 0;
         var count:uint = recData.readUnsignedInt();
         for(i = 0; i < count; i++)
         {
            this.cardList.push(new ElementKnightCardInfo(recData));
         }
         count = recData.readUnsignedInt();
         this.itemMap.clear();
         for(i = 0; i < count; i++)
         {
            itemId = recData.readUnsignedInt();
            itemCount = recData.readUnsignedInt();
            this.itemMap.add(itemId,itemCount);
         }
         if(this.id == 0)
         {
            this.id = LocalUserInfo.getUserID();
         }
      }
      
      private function getCD(time:uint) : uint
      {
         var talnetInfo:ElementKnightTalnetInfo = ElementKnightInfoManager.getInstace().getTalnetInfoById(this.talent,this.type);
         var count:uint = ServerUpTime.getInstance().serverTime / 1000 - time;
         if(count < talnetInfo.time * 60)
         {
            return talnetInfo.time * 60 - count;
         }
         return 0;
      }
      
      public function get lv() : uint
      {
         var lvVal:int = 0;
         for(var ix:int = 0; ix < ElementCardManager.KNIGHT_LV_EXP.length; ix++)
         {
            if(this.exp < ElementCardManager.KNIGHT_LV_EXP[ix])
            {
               this._lv = ix;
               this._curExp = this.exp - ElementCardManager.KNIGHT_LV_EXP[ix - 1];
               this._needExp = ElementCardManager.KNIGHT_LV_EXP[ix] - ElementCardManager.KNIGHT_LV_EXP[ix - 1];
               break;
            }
         }
         return this._lv;
      }
      
      public function updateLv(exper:uint) : void
      {
         this.exp += exper;
         this._lv = 0;
         this.lv;
      }
      
      public function get needExp() : uint
      {
         this.lv;
         return this._needExp;
      }
      
      public function get curExp() : uint
      {
         this.lv;
         return this._curExp;
      }
   }
}

