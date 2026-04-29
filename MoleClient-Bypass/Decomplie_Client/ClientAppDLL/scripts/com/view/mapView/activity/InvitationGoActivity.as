package com.view.mapView.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.manager.QueryItemCntManager;
   
   public class InvitationGoActivity
   {
      
      private static var _instance:InvitationGoActivity;
      
      public static var _isBeginFromThis:Boolean;
      
      public static var isDoElemenKing:Boolean;
      
      public static var _flag:uint = 0;
      
      private var _queryItem:QueryItemCntManager;
      
      private var _itemArr:Array = [1351782,1351783,1351784,1351785,1351786,1351787];
      
      private var _nowInvitId:uint;
      
      private var _index:int = -1;
      
      public function InvitationGoActivity()
      {
         super();
      }
      
      public static function instance() : InvitationGoActivity
      {
         if(_instance == null)
         {
            _instance = new InvitationGoActivity();
         }
         return _instance;
      }
      
      public function mainEntry() : void
      {
         if(this._queryItem == null)
         {
            this._queryItem = new QueryItemCntManager();
            this._queryItem.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.onQueryItem);
            GV.onlineSocket.addEventListener("invitation_refresh",this.petFileHanlder);
            GV.onlineSocket.addEventListener("invitation_gameover",this.onGameOverHander);
            BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.GetRandomGift);
         }
      }
      
      public function queryInit(index:uint) : void
      {
         this._nowInvitId = this._itemArr[index];
         _flag = 0;
         if(this._queryItem == null)
         {
            this._queryItem = new QueryItemCntManager();
            this._queryItem.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.onQueryItem);
            GV.onlineSocket.addEventListener("invitation_refresh",this.petFileHanlder);
            GV.onlineSocket.addEventListener("invitation_gameover",this.onGameOverHander);
            BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.GetRandomGift);
         }
         this._queryItem.someGoosQuery(this._itemArr);
      }
      
      private function onGameOverHander(e:EventTaomee) : void
      {
         var type:uint = uint(e.EventObj);
         if(this._index == -1)
         {
            return;
         }
         if(type != this._index)
         {
            return;
         }
         if(type == 0)
         {
            superlamuPartySocket.treasurebowl(205);
         }
         if(type == 1)
         {
            superlamuPartySocket.treasurebowl(206);
         }
         if(type == 2)
         {
            if(isDoElemenKing)
            {
               isDoElemenKing = false;
               superlamuPartySocket.treasurebowl(207);
            }
            else
            {
               Alert.smileAlart("      你還沒有挑戰啊");
            }
         }
         if(type == 3)
         {
            superlamuPartySocket.treasurebowl(208);
         }
         if(type == 4)
         {
            superlamuPartySocket.treasurebowl(209);
         }
         if(type == 5)
         {
            superlamuPartySocket.treasurebowl(210);
         }
      }
      
      private function petFileHanlder(event:EventTaomee) : void
      {
         this._queryItem.someGoosQuery(this._itemArr);
      }
      
      private function GetRandomGift(e:EventTaomee) : void
      {
         if(e.EventObj.type >= 205 && e.EventObj.type <= 211)
         {
            Alert.smileAlart("    恭喜你獲得" + GoodsInfo.getItemNameByID(e.EventObj.itemId));
            this._index = -1;
            this._queryItem.someGoosQuery(this._itemArr);
         }
      }
      
      private function onQueryItem(e:EventTaomee) : void
      {
         var ishave:Boolean = false;
         var getitemArr:Array = e.EventObj as Array;
         if(getitemArr.length == 0)
         {
            return;
         }
         for(var i:uint = 0; i < getitemArr.length; i++)
         {
            if(getitemArr[i] != 0)
            {
               this._index = i;
               ishave = true;
               if(this._itemArr[i] == this._nowInvitId)
               {
                  _flag = 2;
                  return;
               }
            }
         }
         if(ishave)
         {
            _flag = 1;
         }
      }
   }
}

