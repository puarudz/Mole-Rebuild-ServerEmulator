package com.logic.socket.grayGirlActive
{
   import com.common.data.HashMap;
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.mole.info.ItemInfo;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GrayGirlSocket
   {
      
      public static const GetDancePartyInfoCmd:uint = 8535;
      
      public static const JoinDanceCmd:uint = 8534;
      
      public static const GetDancePartyAwardsCmd:uint = 8536;
      
      public static const RandomGiftCmd:uint = 8538;
      
      public static const GIFTCmd:uint = 8539;
      
      public static const CompletionCmd:uint = 8542;
      
      public static const GetActiveResultCmd:uint = 8537;
      
      public function GrayGirlSocket()
      {
         super();
      }
      
      public static function GetDancePartyInfo() : void
      {
         MsgHead.Command = GetDancePartyInfoCmd;
         GF.writeHead();
      }
      
      public static function res_GetDancePartyInfo() : void
      {
         var tmp:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:HashMap = new HashMap();
         obj.add("dancing_state",output.readUnsignedInt());
         obj.add("dance_type",output.readUnsignedInt());
         var groupTeam:Object = [];
         for(var i:uint = 0; i < 5; i++)
         {
            tmp = {};
            tmp.left = output.readUnsignedInt();
            tmp.right = output.readUnsignedInt();
            groupTeam.push(tmp);
         }
         obj.add("group_team",groupTeam);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDancePartyInfoCmd,obj));
      }
      
      public static function JoinDance(seat:uint, isOn:uint) : void
      {
         MsgHead.Command = JoinDanceCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(seat);
         tempByteArray.writeUnsignedInt(isOn);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_JoinDance() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.result = output.readUnsignedInt();
         obj.seat = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + JoinDanceCmd,obj));
      }
      
      public static function GetDancePartyAwards() : void
      {
         MsgHead.Command = GetDancePartyAwardsCmd;
         GF.writeHead();
      }
      
      public static function res_GetDancePartyAwards() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDancePartyAwardsCmd,obj));
      }
      
      public static function RandomGift() : void
      {
         MsgHead.Command = RandomGiftCmd;
         GF.writeHead();
      }
      
      public static function res_RandomGift() : void
      {
         var tmp:ItemInfo = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.state = output.readUnsignedInt();
         obj.arr = [];
         var count:uint = output.readUnsignedInt();
         for(var i:uint = 0; i < count; i++)
         {
            tmp = new ItemInfo();
            tmp.ID = output.readUnsignedInt();
            tmp.count = output.readUnsignedInt();
            obj.arr.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + RandomGiftCmd,obj));
      }
      
      public static function GetGift(type:uint, _flag:int) : void
      {
         MsgHead.Command = GIFTCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(_flag);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetGift() : void
      {
         var i:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.type = output.readUnsignedInt();
         if(obj.type == 0)
         {
            obj.flag = output.readUnsignedInt();
            obj.value = output.readUnsignedInt();
         }
         else
         {
            obj.value = output.readUnsignedInt();
            for(i = 0; i < obj.value; i++)
            {
               obj["itemID" + i] = output.readUnsignedInt();
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GIFTCmd,obj));
      }
      
      public static function Completion() : void
      {
         MsgHead.Command = CompletionCmd;
         GF.writeHead();
      }
      
      public static function res_Completion() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         for(var i:int = 1; i < 7; i++)
         {
            obj["flag" + i] = output.readUnsignedInt();
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CompletionCmd,obj));
      }
      
      public static function res_GetActiveResult() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var len:int = int(output.readUnsignedInt());
         var msg:String = output.readUTFBytes(len);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetActiveResultCmd,msg));
      }
   }
}

