package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.global.staticData.CommandID;
   import com.logic.socket.ice.IceBabyAddBaseAttributeProtocol;
   import com.mole.net.events.SocketEvent;
   
   public class IceBabyManager
   {
      
      public function IceBabyManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         OnlineManager.addCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,onAddBaseAttribute);
      }
      
      private static function onAddBaseAttribute(e:SocketEvent) : void
      {
         var attributePro:IceBabyAddBaseAttributeProtocol = e.bodyInfo;
         if(attributePro.type == 2 && attributePro.game == 1)
         {
            if(attributePro.state == 0)
            {
               Alert.smileAlart("　　臀部力量需要每天鍛煉！獲得魅力" + attributePro.award + "，參與積分" + attributePro.award + "！");
            }
            else
            {
               Alert.smileAlart("　　今日玩的次數太多了！");
            }
         }
         else if(attributePro.type == 2 && attributePro.game == 2)
         {
            if(attributePro.state == 0)
            {
               Alert.smileAlart("　　冰泉寶貝需要廣闊的胸襟和強健的臂腕, 獲得魅力" + attributePro.award + "!");
            }
            else
            {
               Alert.smileAlart("　　今日玩的次數太多了！");
            }
         }
      }
      
      public static function addAttribute(type:uint, game:uint, value:uint) : void
      {
         OnlineManager.send(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,type,game,value);
      }
   }
}

