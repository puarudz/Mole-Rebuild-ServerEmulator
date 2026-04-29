package com.logic.socket.card
{
   import com.event.EventTaomee;
   
   public class CardNumRes
   {
      
      public static var GET_CARD_NUM_SUCC:String = "GET_CARD_NUM_SUCC";
      
      public function CardNumRes()
      {
         super();
      }
      
      public static function addCard() : void
      {
         var i:uint = 0;
         var cardObj:Object = null;
         var cardObj2:Object = null;
         var CardArr:Array = new Array();
         var CardArr2:Array = new Array();
         var flag:uint = GV.onlineSocket.readUnsignedInt();
         var winNum:uint = GV.onlineSocket.readUnsignedInt();
         var lostNum:uint = GV.onlineSocket.readUnsignedInt();
         var len:uint = GV.onlineSocket.readUnsignedInt();
         for(i = 0; i < len; i++)
         {
            cardObj = new Object();
            cardObj.type = GV.onlineSocket.readUnsignedByte();
            cardObj.value = GV.onlineSocket.readUnsignedByte();
            cardObj.event = GV.onlineSocket.readUnsignedByte();
            cardObj.color = GV.onlineSocket.readUnsignedByte() + 1;
            cardObj.star = GV.onlineSocket.readUnsignedByte();
            CardArr.push(cardObj);
         }
         var len1:uint = GV.onlineSocket.readUnsignedInt();
         for(i = 0; i < len1; i++)
         {
            cardObj2 = new Object();
            cardObj2.type = GV.onlineSocket.readUnsignedByte();
            cardObj2.value = GV.onlineSocket.readUnsignedByte();
            cardObj2.event = GV.onlineSocket.readUnsignedByte();
            cardObj2.color = GV.onlineSocket.readUnsignedByte() + 1;
            cardObj2.star = GV.onlineSocket.readUnsignedByte();
            CardArr2.push(cardObj2);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_CARD_NUM_SUCC,{
            "arr":CardArr,
            "arr2":CardArr2,
            "win":winNum,
            "lost":lostNum,
            "Flag":flag
         }));
      }
      
      public static function res_repairRedCloth() : void
      {
      }
   }
}

