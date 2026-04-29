package com.logic.socket.summerAct
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class SummerSocket
   {
      
      public static const GET_POST_DATA_CMD:int = 8573;
      
      public static const PROP_FETCH_CMD:int = 8816;
      
      public static const GET_STEP_CMD:int = 8817;
      
      public static const GET_WOOD_STATE_CMD:int = 8574;
      
      public static const THROW_WATER_CMD:int = 8575;
      
      public static const THROW_OVER_CMD:int = 8576;
      
      public static const PICK_UP_CMD:int = 8577;
      
      public static const SURGE_EXE_CMD:int = 8582;
      
      public static const GET_BATH_INFO_CMD:int = 8583;
      
      public static const ENTER_BATH_CMD:int = 8584;
      
      public static const LOTTERY_CMD:int = 8589;
      
      public static const ADD_GLAMOUR_CMD:int = 8591;
      
      public static const THROW_EGG_FLOWER_CMD:int = 8594;
      
      public static const GET_LIGHT_INFO_CMD:int = 8595;
      
      public static const GET_BIG_PRIZE_CMD:int = 8596;
      
      public static const GET_POST_DATA:String = "read_8573";
      
      public static const PROP_FETCH:String = "read_8816";
      
      public static const GET_STEP:String = "read_8817";
      
      public static const GET_WOOD_STATE:String = "read_8574";
      
      public static const THROW_WATER:String = "read_8575";
      
      public static const THROW_OVER:String = "read_8576";
      
      public static const PICK_UP:String = "read_8577";
      
      public static const SURGE_EXE:String = "read_8582";
      
      public static const GET_BATH_INFO:String = "read_8583";
      
      public static const ENTER_BATH:String = "read_8584";
      
      public static const LOTTERY:String = "read_8589";
      
      public static const ADD_GLAMOUR:String = "read_8591";
      
      public static const THROW_EGG_FLOWER:String = "read_8594";
      
      public static const GET_LIGHT_INFO:String = "read_8595";
      
      public static const GET_BIG_PRIZE:String = "read_8596";
      
      public function SummerSocket()
      {
         super();
      }
      
      public static function getPostData(index:int) : void
      {
         MsgHead.Command = GET_POST_DATA_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetPostData() : void
      {
         var state0:int = int(GV.onlineSocket.readUnsignedInt());
         var state1:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_POST_DATA,{
            "state0":state0,
            "state1":state1
         }));
      }
      
      public static function propFetch(index:int) : void
      {
         MsgHead.Command = PROP_FETCH_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_PropFetch() : void
      {
         var itemID:int = 0;
         var itemCnt:int = 0;
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            itemID = int(GV.onlineSocket.readUnsignedInt());
            itemCnt = int(GV.onlineSocket.readUnsignedInt());
            arr.push({
               "itemID":itemID,
               "count":itemCnt
            });
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(PROP_FETCH,{"arr":arr}));
      }
      
      public static function getStep() : void
      {
         MsgHead.Command = GET_STEP_CMD;
         GF.writeHead();
      }
      
      public static function res_GetStep() : void
      {
         var gameStep:int = int(GV.onlineSocket.readUnsignedInt());
         var coinNum:int = int(GV.onlineSocket.readUnsignedInt());
         var propNum:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_STEP,{
            "gameStep":gameStep,
            "coinNum":coinNum,
            "propNum":propNum
         }));
      }
      
      public static function getWoodState() : void
      {
         MsgHead.Command = GET_WOOD_STATE_CMD;
         GF.writeHead();
      }
      
      public static function res_GetWoodState() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_WOOD_STATE,{"state":state}));
      }
      
      public static function throwWater() : void
      {
         MsgHead.Command = THROW_WATER_CMD;
         GF.writeHead();
      }
      
      public static function res_ThrowWater() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(THROW_WATER,{"state":state}));
      }
      
      public static function res_ThrowOver() : void
      {
         var itemID:int = 0;
         var itemCnt:int = 0;
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            itemID = int(GV.onlineSocket.readUnsignedInt());
            itemCnt = int(GV.onlineSocket.readUnsignedInt());
            arr.push({
               "itemID":itemID,
               "count":itemCnt
            });
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(THROW_OVER,{"arr":arr}));
      }
      
      public static function pickUp(itemID:int) : void
      {
         MsgHead.Command = PICK_UP_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_PickUp() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(PICK_UP,{"state":state}));
      }
      
      public static function surgeExe() : void
      {
         MsgHead.Command = SURGE_EXE_CMD;
         GF.writeHead();
      }
      
      public static function res_SurgeExe() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         var itemID:int = int(GV.onlineSocket.readUnsignedInt());
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(SURGE_EXE,{
            "state":state,
            "itemID":itemID,
            "count":count
         }));
      }
      
      public static function getBathInfo() : void
      {
         MsgHead.Command = GET_BATH_INFO_CMD;
         GF.writeHead();
      }
      
      public static function res_GetBathInfo() : void
      {
         var i:int = 0;
         var index:int = 0;
         var userID:int = 0;
         var seat:Array = [];
         for(i = 0; i < 3; i++)
         {
            seat.push(GV.onlineSocket.readUnsignedInt());
         }
         var arr:Array = [];
         for(i = 0; i < 50; i++)
         {
            index = int(GV.onlineSocket.readUnsignedInt());
            userID = int(GV.onlineSocket.readUnsignedInt());
            arr.push({
               "index":index,
               "userID":userID
            });
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BATH_INFO,{
            "arr":arr,
            "seat":seat
         }));
      }
      
      public static function enterBath(type:int, position:int) : void
      {
         MsgHead.Command = ENTER_BATH_CMD;
         var tArr:ByteArray = new ByteArray();
         tArr.writeUnsignedInt(type);
         tArr.writeUnsignedInt(position);
         GF.writeHead(tArr);
      }
      
      public static function res_EnterBath() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(ENTER_BATH,{"state":state}));
      }
      
      public static function res_Lottery() : void
      {
         var pool:int = int(GV.onlineSocket.readUnsignedInt());
         var itemID:int = int(GV.onlineSocket.readUnsignedInt());
         var itemCnt:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(LOTTERY,{
            "pool":pool,
            "itemID":itemID,
            "itemCnt":itemCnt
         }));
      }
      
      public static function res_AddGlamour() : void
      {
         var pool:int = int(GV.onlineSocket.readUnsignedInt());
         var glamour:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_GLAMOUR,{
            "pool":pool,
            "glamour":glamour
         }));
      }
      
      public static function getLightInfo() : void
      {
         MsgHead.Command = GET_LIGHT_INFO_CMD;
         GF.writeHead();
      }
      
      public static function res_GetLightInfo() : void
      {
         var flag:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_LIGHT_INFO,{"flag":flag}));
      }
      
      public static function getBigPrize() : void
      {
         MsgHead.Command = GET_BIG_PRIZE_CMD;
         GF.writeHead();
      }
      
      public static function res_GetBigPrize() : void
      {
         var state:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BIG_PRIZE,{"state":state}));
      }
      
      public static function throwEggFlower(userID:int, type:int) : void
      {
         MsgHead.Command = THROW_EGG_FLOWER_CMD;
         var tArr:ByteArray = new ByteArray();
         tArr.writeUnsignedInt(userID);
         tArr.writeUnsignedInt(type);
         GF.writeHead(tArr);
      }
      
      public static function res_ThrowEggFlower() : void
      {
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         var charm:int = int(GV.onlineSocket.readUnsignedInt());
         var partScore:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(THROW_EGG_FLOWER,{
            "userID":userID,
            "charm":charm,
            "partScore":partScore
         }));
      }
   }
}

