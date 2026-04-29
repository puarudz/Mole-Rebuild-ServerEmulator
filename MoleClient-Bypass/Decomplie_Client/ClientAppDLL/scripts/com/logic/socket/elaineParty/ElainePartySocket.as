package com.logic.socket.elaineParty
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ElainePartySocket
   {
      
      public static const GuessGameOfferPriceCommand:int = 1260;
      
      public static const GuessGameCheckCommand:int = 1261;
      
      public static const GuessGameEndCommand:int = 1262;
      
      public static const CharityOfferCommand:int = 1129;
      
      public static const CharityDonateInfoCommand:int = 1131;
      
      public static const CharityDonateRankingCommand:int = 1130;
      
      public static const Rank_Type_Donate:int = 1;
      
      public static const Rank_Type_DonateItem:int = 2;
      
      public static const Rank_Type_DonateGuess:int = 3;
      
      public function ElainePartySocket()
      {
         super();
      }
      
      public static function GuessGameOfferPrice(value:int) : void
      {
         MsgHead.Command = GuessGameOfferPriceCommand;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(value);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GuessGameOfferPrice() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GuessGameOfferPriceCommand,obj));
      }
      
      public static function GuessGameCheck() : void
      {
         MsgHead.Command = GuessGameCheckCommand;
         GF.writeHead();
      }
      
      public static function res_GuessGameCheck() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GuessGameCheckCommand,obj));
      }
      
      public static function res_GuessGameEnd() : void
      {
         var winer:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.winerArr = new Array();
         obj.itemId = output.readUnsignedInt();
         obj.itemCount = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            winer = new Object();
            winer.id = output.readUnsignedInt();
            winer.money = output.readUnsignedInt();
            obj.winerArr.push(winer);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GuessGameEndCommand,obj));
      }
      
      public static function CharityOffer(item:int, count:int) : void
      {
         MsgHead.Command = CharityOfferCommand;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(item);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_CharityOffer() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CharityOfferCommand,obj));
      }
      
      public static function CharityDonateInfo() : void
      {
         MsgHead.Command = CharityDonateInfoCommand;
         GF.writeHead();
      }
      
      public static function res_CharityDonateInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userCount = output.readUnsignedInt();
         obj.moneyCount = output.readUnsignedInt() / 100;
         obj.itemCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CharityDonateInfoCommand,obj));
      }
      
      public static function CheckCharityDonateRanking(type:int) : void
      {
         MsgHead.Command = CharityDonateRankingCommand;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_CheckCharityDonateRanking() : void
      {
         var user:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         obj.userArr = new Array();
         for(var i:int = 0; i < count; i++)
         {
            user = new Object();
            user.id = output.readUnsignedInt();
            user.count = output.readUnsignedInt();
            obj.userArr.push(user);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CharityDonateRankingCommand,obj));
      }
   }
}

