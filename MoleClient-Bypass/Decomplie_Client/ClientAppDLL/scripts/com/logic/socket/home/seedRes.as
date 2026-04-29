package com.logic.socket.home
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.IDataInput;
   
   public class seedRes
   {
      
      public static const SEED_UP_DATA:String = "seed_UpData";
      
      public function seedRes()
      {
         super();
      }
      
      public static function Planting_seed() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.PLANTING_SEED,readSeed()));
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,1);
      }
      
      public static function delete_seed() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var itemCountObj:Object = new Object();
         itemCountObj.PlantID = output.readUnsignedInt();
         itemCountObj.Count = output.readUnsignedInt();
         itemCountObj.goodsArray = new Array();
         for(var i:int = 0; i < itemCountObj.Count; i++)
         {
            obj = {};
            obj.ItemID = output.readUnsignedInt();
            obj.Num = output.readUnsignedInt();
            itemCountObj.goodsArray.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.DELETE_SEED,itemCountObj));
      }
      
      public static function delete_field() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var itemCountObj:Object = new Object();
         itemCountObj.PlantID = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1299,itemCountObj));
      }
      
      public static function IrrigateWater() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.IRRIGATE_WATER,readSeed()));
      }
      
      public static function UseInsecticide() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.USE_INSECTICIDE,readSeed()));
      }
      
      public static function res_Pollination() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1298,readSeed()));
      }
      
      public static function res_Fertilizer() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1297));
      }
      
      public static function get_seed_info() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.GET_SEED_INFO,SeedParse()));
      }
      
      public static function get_seed2_info() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.GET_SEED_INFO,SeedParse()));
      }
      
      public static function gainFruitage() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var itemCountObj:Object = new Object();
         itemCountObj.PlantID = output.readUnsignedInt();
         itemCountObj.ItemID = output.readUnsignedInt();
         itemCountObj.FruitNum = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.GAIN_FRUITAGE,itemCountObj));
      }
      
      public static function coneyGainFruitage() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var itemFlag:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.CONEY_GAIN_FRUITAGE,itemFlag));
      }
      
      public static function thiefGainFruitage() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var itemFlag:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1341,itemFlag));
      }
      
      public static function SeedParse() : Object
      {
         var output:IDataInput = GV.onlineSocket;
         var itemCountObj:Object = new Object();
         itemCountObj.PlantID = output.readUnsignedInt();
         itemCountObj.ID = output.readUnsignedInt();
         itemCountObj.PosX = output.readShort();
         itemCountObj.PosY = output.readShort();
         itemCountObj.Growth = output.readUnsignedInt();
         itemCountObj.SickFlag = output.readUnsignedInt();
         itemCountObj.FruitNum = output.readUnsignedInt();
         itemCountObj.Fruit_status = output.readUnsignedInt();
         itemCountObj.Mature_time = output.readUnsignedInt();
         itemCountObj.Diff_mature_time = output.readUnsignedInt();
         itemCountObj.Cur_grow_rate = output.readUnsignedInt();
         itemCountObj.EarthState = output.readUnsignedInt();
         itemCountObj.Pollination = output.readUnsignedInt();
         var Can_thief:int = 0;
         Can_thief = int(output.readUnsignedInt());
         itemCountObj.Can_thief = Boolean(Can_thief) ? Can_thief : 0;
         var tobj:Object = GoodsInfo.getInfoById(itemCountObj.ID);
         itemCountObj.typeObject = tobj.typeObject;
         itemCountObj.id = tobj.id;
         itemCountObj.ItemID = tobj.ItemID;
         itemCountObj.name = tobj.name;
         itemCountObj.price = tobj.price;
         itemCountObj.Type = tobj.Type;
         itemCountObj.Class = tobj.Class;
         itemCountObj.LevelArray = tobj.LevelArray;
         itemCountObj.Fruit = tobj.Fruit;
         return itemCountObj;
      }
      
      private static function readSeed() : Object
      {
         var itemCountObj:Object = SeedParse();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEED_UP_DATA,itemCountObj));
         return itemCountObj;
      }
   }
}

