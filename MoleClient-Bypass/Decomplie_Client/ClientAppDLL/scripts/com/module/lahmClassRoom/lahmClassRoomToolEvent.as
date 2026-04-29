package com.module.lahmClassRoom
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   
   public class lahmClassRoomToolEvent
   {
      
      private static var instance:lahmClassRoomToolEvent;
      
      private static var canotNew:Boolean = true;
      
      public function lahmClassRoomToolEvent()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomToolEvent不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomToolEvent
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomToolEvent();
            canotNew = true;
         }
         return instance;
      }
      
      public function usingTool(itemId:int, petId:int = 0) : void
      {
         var toolGoodsArr:Array = lahmClassRoomUI.getInstance().toolGoodsArr;
         var toolSpecialGoodsArr:Array = lahmClassRoomUI.getInstance().toolSpecialGoodsArr;
         if(toolGoodsArr.indexOf(itemId) != -1)
         {
            if(itemId == 190752)
            {
               this.item190752(itemId,petId);
            }
            else if(itemId == 190753)
            {
               this.item190753(itemId,petId);
            }
            else if(itemId == 190754)
            {
               this.item190754(itemId,petId);
            }
            else
            {
               this.usingItem(itemId,petId);
            }
         }
         else if(toolSpecialGoodsArr.indexOf(itemId) != -1)
         {
            Alert.smileAlart("    選擇一個學生以後再使用這個道具吧。");
         }
      }
      
      private function usingItem(itemId:int, petId:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1270",this.onUsingItem);
         lahmClassRoomSocket.usingItem(itemId,petId);
      }
      
      private function onUsingItem(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1270",this.onUsingItem);
         var toolGoodsArr:Array = lahmClassRoomUI.getInstance().toolGoodsArr;
         var toolSpecialGoodsArr:Array = lahmClassRoomUI.getInstance().toolSpecialGoodsArr;
         var itemId:int = int(evt.EventObj.itemId);
         if(toolGoodsArr.indexOf(itemId) != -1)
         {
            lahmClassRoomUI.getInstance().toolGoodSEffect(itemId);
            lahmClassRoomUI.getInstance().onItemTool();
         }
         else if(toolSpecialGoodsArr.indexOf(itemId) != -1)
         {
         }
      }
      
      private function item190752(itemId:int, petId:int) : void
      {
         var classRoomFlag:int = int(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().classRoomFlag);
         if(classRoomFlag == 0 || classRoomFlag == 1)
         {
            this.usingItem(itemId,petId);
         }
         else
         {
            Alert.smileAlart("    教室裡的學生正在休息中呢，等他們上課以後再使用吧。");
         }
      }
      
      private function item190753(itemId:int, petId:int) : void
      {
         var energy:int = int(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().energy);
         if(energy < 1000)
         {
            this.usingItem(itemId,petId);
         }
         else
         {
            Alert.smileAlart("    你現在的教師精力很充足哦，不需要再喝營養能量汁啦。");
         }
      }
      
      private function item190754(itemId:int, petId:int) : void
      {
         var lovely:int = int(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().lovely);
         if(lovely < 1000)
         {
            this.usingItem(itemId,petId);
         }
         else
         {
            Alert.smileAlart("    學生現在和你的關係很好哦，不需要恢復親密度啦。");
         }
      }
   }
}

