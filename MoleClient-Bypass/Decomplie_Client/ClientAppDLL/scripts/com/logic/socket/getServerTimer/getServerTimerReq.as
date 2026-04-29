package com.logic.socket.getServerTimer
{
   import com.common.data.HashMap;
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class getServerTimerReq
   {
      
      private static var _backHash:HashMap = new HashMap();
      
      public function getServerTimerReq()
      {
         super();
      }
      
      public static function getServerTimer(backKey:*, backFunName:*) : void
      {
         _backHash.add(backKey,backFunName);
         MsgHead.Command = CommandID.GET_SERVER_TIMER;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function returnRes(date:Date) : void
      {
         var backFun:* = undefined;
         var keyObj:* = undefined;
         var keyArr:Array = _backHash.keys;
         for each(keyObj in keyArr)
         {
            if(Boolean(keyObj))
            {
               backFun = keyObj[_backHash.getValue(keyObj)];
               if(Boolean(backFun))
               {
                  backFun(date);
               }
            }
         }
         _backHash.clear();
      }
   }
}

