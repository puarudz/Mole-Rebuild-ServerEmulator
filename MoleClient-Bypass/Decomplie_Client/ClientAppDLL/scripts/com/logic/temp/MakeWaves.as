package com.logic.temp
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.mole.app.utils.Tool;
   
   public class MakeWaves
   {
      
      private static var _num:uint = 0;
      
      public function MakeWaves()
      {
         super();
      }
      
      public static function isDoAll() : void
      {
         _num = 0;
         Tool.finishSomething(31496,overCall0Back);
         Tool.finishSomething(31497,overCall1Back);
         Tool.finishSomething(31498,overCall2Back);
      }
      
      private static function overCall0Back(count:uint) : void
      {
         if(count > 0)
         {
            ++_num;
         }
      }
      
      private static function overCall1Back(count:uint) : void
      {
         if(count > 0)
         {
            ++_num;
         }
      }
      
      private static function overCall2Back(count:uint) : void
      {
         if(count > 0)
         {
            ++_num;
         }
         Tool.finishSomething(31499,overCall3Back);
      }
      
      private static function overCall3Back(count:uint) : void
      {
         if(count == 0)
         {
            if(_num == 3)
            {
               GV.onlineSocket.addEventListener(exchange.EXCHANGE_ITEM,socksgiftHandler);
               exchange.exchange_goods(2227,1,1);
            }
         }
      }
      
      private static function socksgiftHandler(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(exchange.EXCHANGE_ITEM,socksgiftHandler);
         Alert.smileAlart("  恭喜你今天作戰大成功，獲得許願星*15");
      }
   }
}

