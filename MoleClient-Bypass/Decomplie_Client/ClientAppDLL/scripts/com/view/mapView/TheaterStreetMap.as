package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.lamuFoodGot.LamuFoodGot;
   import com.module.activityModule.PolicDutyModule;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TheaterStreetMap extends MapBase
   {
      
      public function TheaterStreetMap()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.policeEvent);
         BC.addEvent(this,controlLevel.buymachine,"lamuBuyEvent",this.lamuFoodGotHandler);
         BC.addEvent(this,GV.onlineSocket,"read_6001",this.read6001Handler);
         tip.tipTailDisPlayObject(controlLevel.buymachine,"拉姆易拉罐");
         BC.addEvent(this,GV.onlineSocket,"mc_play_oven",this.taskEvent);
      }
      
      private function onGotoMap60(event:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67748758);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(60,true);
      }
      
      private function taskEvent(evt:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckFlower);
         finishSomethingReq.sendReq(31031);
      }
      
      private function onCheckFlower(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckFlower);
         var obj:Object = e.EventObj;
         if(obj.Type == 31031)
         {
            if(obj.Done >= 3)
            {
               Alert.smileAlart("    你已經得到過了，留一些給其他小摩爾吧！");
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchEvent);
               exchange.exchange_goods(int(164),1);
            }
         }
      }
      
      private function exchEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchEvent);
         switch(evt.EventObj.arr[0].itemID)
         {
            case 0:
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + evt.EventObj.arr[0].count);
         }
         Alert.smileAlart("    恭喜你獲得" + evt.EventObj.arr[0].count + "個" + GoodsInfo.getItemNameByID(evt.EventObj.arr[0].itemID) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(evt.EventObj.arr[0].itemID) + "中！");
      }
      
      private function lamuFoodGotHandler(e:Event) : void
      {
         if(PeopleManageView(GV.MAN_PEOPLE).Petlevel <= 0)
         {
            Alert.showAlert(MainManager.getGameLevel(),"   這台機器只認拉姆不認摩爾，快帶你的小拉姆來喲！","",6,"D");
            return;
         }
         LamuFoodGot.lamuFoodGotReq();
      }
      
      private function read6001Handler(e:EventTaomee) : void
      {
         if(e.EventObj.flag == 0)
         {
            Alert.smileAlart("   這台機器已經“了吱了吱”轉不動了，明天再來試試吧！");
         }
         else
         {
            Alert.getIconByID_Alart(e.EventObj.itemID,"   免費的" + GoodsInfo.getItemNameByID(e.EventObj.itemID) + "，已經放入你的拉姆背包，收好啦！");
         }
      }
      
      private function policeEvent(evt:EventTaomee) : void
      {
         PolicDutyModule.getInstance().init(controlLevel);
      }
   }
}

