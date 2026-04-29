package com.view.mapView.activity.Task83
{
   import com.logic.socket.statistics.statisticsSocket;
   import flash.net.URLRequest;
   import flash.net.sendToURL;
   
   public class StatisticsClass
   {
      
      public function StatisticsClass()
      {
         super();
      }
      
      public static function getInstance() : StatisticsClass
      {
         return new StatisticsClass();
      }
      
      public function init(type:uint, str:String = "") : void
      {
         if(type != 0)
         {
            statisticsSocket.Statistics(type);
         }
         if(Boolean(str))
         {
            sendToURL(new URLRequest(str));
         }
      }
      
      public function destroy() : void
      {
      }
   }
}

