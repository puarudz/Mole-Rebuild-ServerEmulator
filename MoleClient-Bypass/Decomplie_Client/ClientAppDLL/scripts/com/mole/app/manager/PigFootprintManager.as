package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.BitArray;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ballot.NpcBallotSocket;
   import flash.events.Event;
   
   public class PigFootprintManager
   {
      
      private static var _instance:PigFootprintManager;
      
      public static const FLAG1:uint = 205;
      
      public static const FLAG2:uint = 206;
      
      public static const FLAG3:uint = 207;
      
      private var _getItem1:Boolean = false;
      
      private var _getItem2:Boolean = false;
      
      private var _getItem3:Boolean = false;
      
      public function PigFootprintManager()
      {
         super();
      }
      
      public static function get instance() : PigFootprintManager
      {
         if(_instance == null)
         {
            _instance = new PigFootprintManager();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_2008",this.CheckGetedGiftHandler);
         NpcBallotSocket.NpcBallotReq();
      }
      
      private function CheckGetedGiftHandler(e:EventTaomee) : void
      {
         var bitArr:BitArray = e.EventObj.data;
         this._getItem1 = bitArr.getBitAt(FLAG1);
         this._getItem2 = bitArr.getBitAt(FLAG2);
         this._getItem3 = bitArr.getBitAt(FLAG3);
         BC.addEvent(this,GV.onlineSocket,"get_2011_11_change_Pig_item_1",this.GetChangeItem_1);
         BC.addEvent(this,GV.onlineSocket,"get_2011_11_change_Pig_item_2",this.GetChangeItem_2);
         BC.addEvent(this,GV.onlineSocket,"get_2011_11_change_Pig_item_3",this.GetChangeItem_3);
      }
      
      private function GetChangeItem_1(e:Event) : void
      {
         if(this._getItem1 == false)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_1_Over);
            exchange.exchange_goods(914);
         }
      }
      
      private function GetItem_1_Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 914)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_1_Over);
            Alert.smileAlart("    恭喜你獲得了" + GoodsInfo.getItemNameByID(e.EventObj.arr[0].itemID) + "，請繼續努力吧！");
            this._getItem1 = true;
         }
      }
      
      private function GetChangeItem_2(e:Event) : void
      {
         if(this._getItem2 == false)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_2_Over);
            exchange.exchange_goods(915);
         }
      }
      
      private function GetItem_2_Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 915)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_2_Over);
            Alert.smileAlart("    恭喜你獲得了" + GoodsInfo.getItemNameByID(e.EventObj.arr[0].itemID) + "，請繼續努力吧！");
            this._getItem2 = true;
         }
      }
      
      private function GetChangeItem_3(e:Event) : void
      {
         if(this._getItem3 == false)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_3_Over);
            exchange.exchange_goods(916);
         }
      }
      
      private function GetItem_3_Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 916)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetItem_3_Over);
            Alert.smileAlart("    恭喜你獲得了" + GoodsInfo.getItemNameByID(e.EventObj.arr[0].itemID) + "，請繼續努力吧！");
            this._getItem3 = true;
         }
      }
   }
}

