package com.logic.socket.CSItems
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class exchange
   {
      
      public static var EXCHANGE_ITEM:String = "exchange_item";
      
      public static var CELEBRATE_INFO:String = "celebrate_info";
      
      public static var CONTINUOUS_LOGIN:String = "Continuous_Login";
      
      public static var CONTINUOUS_DATA:String = "Continuous_Data";
      
      public static var EXCHANGE_MOLING:String = "exchange_item_12027";
      
      public static var FINISH_EXP_MOLING:String = "finish_exp_9301";
      
      public function exchange()
      {
         super();
      }
      
      public static function exchange_goods(_id:int, _count:int = 1, _flag:int = 0) : void
      {
         MsgHead.Command = 1243;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_id);
         tempByteArray.writeUnsignedInt(_count);
         tempByteArray.writeUnsignedInt(_flag);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_exchange_goods() : void
      {
         var i:int = 0;
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         var totalTrueArr:Array = [];
         infoObj.type = output.readUnsignedInt();
         infoObj.Count = output.readUnsignedInt();
         if(infoObj.Count >= 1)
         {
            for(i = 0; i < infoObj.Count; i++)
            {
               obj = new Object();
               obj.itemID = output.readUnsignedInt();
               obj.count = output.readUnsignedInt();
               totalTrueArr.push(obj);
            }
            infoObj.arr = totalTrueArr;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(EXCHANGE_ITEM,infoObj));
      }
      
      public static function celebrate(_id:int, _count:int = 1) : void
      {
         MsgHead.Command = 1258;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_id);
         tempByteArray.writeUnsignedInt(_count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_celebrate() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemID = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(CELEBRATE_INFO,obj));
      }
      
      public static function badLookLoginInfo() : void
      {
         MsgHead.Command = 4108;
         GF.writeHead();
      }
      
      public static function res_badLookLoginInfo() : void
      {
         var _o:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.dayTotal = output.readUnsignedInt();
         obj.dayCount = output.readUnsignedInt();
         obj.arr = [];
         for(var i:int = 0; i < obj.dayCount; i++)
         {
            _o = {};
            _o.dayInfo = output.readUnsignedInt();
            obj.arr.push(_o);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(CONTINUOUS_LOGIN,obj));
      }
      
      public static function receiveBadLook(_type:int) : void
      {
         MsgHead.Command = 4109;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_receiveBadLook() : void
      {
         var _o:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Count = output.readUnsignedInt();
         obj.arr = [];
         for(var i:int = 0; i < obj.Count; i++)
         {
            _o = {};
            _o.Itemid = output.readUnsignedInt();
            _o.count = output.readUnsignedInt();
            if(_o.Itemid == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + _o.count);
            }
            obj.arr.push(_o);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(CONTINUOUS_DATA,obj));
      }
      
      public static function finishExp_12027(dataType:int = 0, dataTypeCount:int = 1) : void
      {
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = 9301;
         with({})
         {
            _temp_2.addCmdListener(_temp_1,function back9301(e:*):void
            {
               GV.onlineSocket.removeCmdListener(9301,back9301);
               var date:ByteArray = e.data as ByteArray;
               var tp:uint = date.readUnsignedInt();
               var aa:uint = date.readUnsignedInt();
               var bb:uint = date.readUnsignedInt();
               GV.onlineSocket.dispatchEvent(new EventTaomee(FINISH_EXP_MOLING,{
                  "type":tp,
                  "val_1":aa,
                  "val_2":bb
               }));
            });
            GF.sendSocket(9301,dataType);
         }
         
         public static function exchange_12027(typeID:int = 0, count:int = 1, _flag:int = 0) : void
         {
            var _temp_2:* = GV.onlineSocket;
            var _temp_1:* = 12027;
            with({})
            {
               _temp_2.addCmdListener(_temp_1,function back12027(e:*):void
               {
                  var infoObj:Object = null;
                  var i:int = 0;
                  var obj:Object = null;
                  GV.onlineSocket.removeCmdListener(12027,back12027);
                  var output:ByteArray = e.data as ByteArray;
                  if(output != null)
                  {
                     infoObj = {};
                     infoObj.Count = output.readUnsignedInt();
                     infoObj.arr = [];
                     if(infoObj.Count >= 1)
                     {
                        for(i = 0; i < infoObj.Count; i++)
                        {
                           obj = new Object();
                           obj.times = output.readUnsignedInt();
                           obj.itemID = output.readUnsignedInt();
                           obj.count = output.readUnsignedInt();
                           infoObj.arr.push(obj);
                        }
                     }
                     GV.onlineSocket.dispatchEvent(new EventTaomee(EXCHANGE_MOLING,infoObj));
                  }
               });
               GF.sendSocket(12027,typeID,count,_flag);
            }
         }
      }
      
      