package com.module.newAngel.info
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.info.AngelStaticInfo;
   import flash.utils.IDataInput;
   
   public class AngelInfo
   {
      
      public var id:uint;
      
      public var angelStaticId:uint;
      
      public var angelNick:String;
      
      public var angelSex:uint;
      
      public var angelLv:uint;
      
      public var angelNextLvExp:uint;
      
      public var angelGrowth:uint;
      
      public var angelHp:uint;
      
      public var angelAtk:uint;
      
      public var angelDef:uint;
      
      public var angelSpeed:uint;
      
      public var angelDistance:uint;
      
      public var angelPower:uint;
      
      public var angelConstellation:uint;
      
      public var angelLoyalty:uint;
      
      public var startTime:uint;
      
      public var angelHpInc:uint;
      
      public var angelAtkInc:uint;
      
      public var angelDefInc:uint;
      
      public var angelSpeedInc:uint;
      
      public var angelDistanceInc:uint;
      
      public var angelSkill:uint;
      
      public function AngelInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.id = data.readUnsignedInt();
            this.angelStaticId = data.readUnsignedInt();
            this.angelNick = data.readUTFBytes(16);
            this.angelSex = data.readUnsignedInt();
            this.angelLv = data.readUnsignedInt();
            this.angelNextLvExp = data.readUnsignedInt();
            this.angelGrowth = data.readUnsignedInt();
            this.angelHp = data.readUnsignedInt();
            this.angelAtk = data.readUnsignedInt();
            this.angelDef = data.readUnsignedInt();
            this.angelSpeed = data.readUnsignedInt();
            this.angelDistance = data.readUnsignedInt();
            this.angelPower = data.readUnsignedInt();
            this.angelConstellation = data.readUnsignedInt();
            this.angelLoyalty = data.readUnsignedInt();
            this.startTime = data.readUnsignedInt();
            this.angelHpInc = data.readUnsignedInt();
            this.angelAtkInc = data.readUnsignedInt();
            this.angelDefInc = data.readUnsignedInt();
            this.angelSpeedInc = data.readUnsignedInt();
            this.angelDistanceInc = data.readUnsignedInt();
         }
      }
      
      public function get staticInfo() : AngelStaticInfo
      {
         return GoodsInfo.getAngelInfoById(this.angelStaticId);
      }
   }
}

