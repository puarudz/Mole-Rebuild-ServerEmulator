package com.logic.active
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.view.PeopleView.PeopleManageView;
   
   public class CandyNotActy
   {
      
      private static var _inst:CandyNotActy;
      
      private var mapArr:Array = [2,10,77,7];
      
      private var index:int = 0;
      
      private var _movie:PlayMovie;
      
      private var itemID:int;
      
      private var count:int;
      
      public function CandyNotActy()
      {
         super();
      }
      
      public static function get inst() : CandyNotActy
      {
         if(_inst == null)
         {
            _inst = new CandyNotActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         var i:int = 0;
         var mid:int = LocalUserInfo.getMapID();
         for(i = 0; i < 4; i++)
         {
            if(mid == this.mapArr[i])
            {
               SystemEventManager.addEventListener("CandyNotEvent",this.CandyNotEvent);
               this.index = i;
               break;
            }
         }
      }
      
      private function CandyNotEvent(e:SystemEvent) : void
      {
         var i:int = 0;
         var mid:int = LocalUserInfo.getMapID();
         for(i = 0; i < 4; i++)
         {
            if(mid == this.mapArr[i])
            {
               if(PeopleManageView(GV.MAN_PEOPLE).address == "17014")
               {
                  this.index = i;
                  Tool.finishSomething(30126,this.getDoneTimesOver);
               }
               else
               {
                  Alert.smileAlart("    你還沒有變身成為幽靈，所以嚇不到人哦~");
               }
               break;
            }
         }
      }
      
      private function getDoneTimesOver(doneTimes:int) : void
      {
         if(doneTimes < 20)
         {
            BC.addEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver);
            superlamuPartySocket.treasurebowl(167);
         }
         else
         {
            Alert.smileAlart("    小摩爾今天玩的次數已經達到上限了，請明天再來玩吧!");
         }
      }
      
      private function getPrizeOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver);
         GV.MAN_PEOPLE.visible = false;
         this.count = e.EventObj.count;
         if(this.count > 0)
         {
            this._movie = PlayMovie.play("module/external/exeModule/201310/movie" + this.index * 2 + ".swf",null,null,this.playMovieOver);
         }
         else
         {
            this.change();
            this._movie = PlayMovie.play("module/external/exeModule/201310/movie" + (this.index * 2 + 1) + ".swf",null,null,this.playMovieOver);
         }
         this.itemID = e.EventObj.itemId;
      }
      
      private function change() : void
      {
         var arr:Array = [17001,17012];
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = LocalUserInfo.getUserID();
         throwItemObj.ItemID = arr[int(Math.random() * 2)];
         throwItemObj.OtherID = LocalUserInfo.getUserID();
         throwItemObj.FlashTag = 0;
         throwItemObj.ChangeID = LocalUserInfo.getUserID();
         GV.onlineSocket.dispatchEvent(new EventTaomee("effect_item",throwItemObj));
      }
      
      private function playMovieOver() : void
      {
         GV.MAN_PEOPLE.visible = true;
         this._movie.destroy();
         this._movie = null;
         if(this.count > 0)
         {
            Tool.alert(this.itemID,this.count);
         }
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      private function destroy() : void
      {
         GV.MAN_PEOPLE.visible = true;
         if(Boolean(this._movie))
         {
            this._movie.destroy();
            this._movie = null;
         }
         this.itemID = 0;
         this.count = 0;
         SystemEventManager.removeEventListener("CandyNotEvent",this.CandyNotEvent);
      }
   }
}

