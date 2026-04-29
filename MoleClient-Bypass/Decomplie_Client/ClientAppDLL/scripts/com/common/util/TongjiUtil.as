package com.common.util
{
   import org.taomee.stat.StatisticsManager;
   
   public class TongjiUtil
   {
      
      private static var _nowUserId:int;
      
      private static const _sstids:Array = ["fGetRegSucc","fLoadRegSucc","fSendLoginReq","fGetLoginSucc","fStartSrvlistReq","fGetSrvlistSucc","fSendOnlineReq","fSocketOnline","fSend1001Req","fOnlineSucc","fLoadInfoSucc","fInterGameSucc","fLoadLoginSucc"];
      
      public function TongjiUtil()
      {
         super();
      }
      
      public static function sendTongji(sstid:int, uid:String, stid:String = "_newtrans_", gameId:String = "1") : void
      {
         StatisticsManager.sendHttpStat(stid,_sstids[sstid],null,parseInt(uid));
      }
      
      public static function get nowUserId() : int
      {
         return _nowUserId;
      }
      
      public static function set nowUserId(value:int) : void
      {
         _nowUserId = value;
      }
   }
}

