package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class KillMonsterSocket
   {
      
      public static var b_count:int = 0;
      
      public function KillMonsterSocket()
      {
         super();
      }
      
      public static function killMonsterFun(arr:Array) : void
      {
         MsgHead.Command = 7077;
         var count:int = int(arr.length);
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(count);
         for(var i:int = 0; i < count; i++)
         {
            tempByteArray.writeUnsignedInt(arr[i].monster_id);
            tempByteArray.writeUnsignedInt(arr[i].monster_count);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_killMonsterFun() : void
      {
         var obj:Object = null;
         var arr:Array = null;
         var j:int = 0;
         var o:Object = null;
         var m_count:int = int(GV.onlineSocket.readUnsignedInt());
         var m_arr:Array = new Array();
         for(var i:int = 0; i < m_count; i++)
         {
            obj = new Object();
            obj.Monster_Id = GV.onlineSocket.readUnsignedInt();
            obj.Count = GV.onlineSocket.readUnsignedInt();
            arr = [];
            for(j = 0; j < obj.Count; j++)
            {
               o = {};
               o.Itemid = GV.onlineSocket.readUnsignedInt();
               o.Itemid_Count = GV.onlineSocket.readUnsignedInt();
               if(o.Itemid >= 1353433 && o.Itemid <= 1354032)
               {
                  b_count += o.Itemid_Count;
               }
               arr.push(o);
            }
            obj.itemArr = arr;
            m_arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7077,m_arr));
      }
   }
}

