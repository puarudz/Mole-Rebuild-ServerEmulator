package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetGoodsInfoByArr;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.dragonTreasure.GetMineMapKeyCmd;
   import com.logic.socket.dragonTreasure.QueryMineKeyChanceCmd;
   import com.mole.app.utils.PlayMovie;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DragonsTreasureActiviteCtl
   {
      
      private static var _instance:DragonsTreasureActiviteCtl;
      
      private var _keyIDArr:Array = [190898,190899,190900,190901];
      
      private var _keyCountArr:Array = [0,0,0,0];
      
      private var _mapID:uint;
      
      private var _mc:MovieClip;
      
      private var _ply:PlayMovie;
      
      private var _bl:Boolean = false;
      
      private var _flag:int;
      
      private var _hitBl:Boolean = false;
      
      private var target_mc:MovieClip;
      
      public function DragonsTreasureActiviteCtl()
      {
         super();
      }
      
      public static function get instance() : DragonsTreasureActiviteCtl
      {
         if(_instance == null)
         {
            _instance = new DragonsTreasureActiviteCtl();
         }
         return _instance;
      }
      
      public function InitMap() : void
      {
         this._mapID = GV.MapInfo_mapID;
         this._mc = GV.MC_mapFrame["buttonLevel"];
         this._bl = false;
         this._hitBl = false;
         this.getKeyChance();
      }
      
      private function getKeyChance() : void
      {
         BC.addEvent(this,GV.onlineSocket,QueryMineKeyChanceCmd.READ_8087,this.onResGetKeyChance);
         QueryMineKeyChanceCmd.sendReq();
      }
      
      private function onResGetKeyChance(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,QueryMineKeyChanceCmd.READ_8087,this.onResGetKeyChance);
         this._flag = event.EventObj.flag;
         this.checkMapID();
      }
      
      private function getKeyInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.res_GetKeyInfo);
         GetGoodsInfoByArr.GetGoodsInfo(0,this._keyIDArr);
      }
      
      private function res_GetKeyInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.res_GetKeyInfo);
         var arr:Array = event.EventObj.itemArr;
         var len:int = int(arr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(arr[i].itemID == 190898)
            {
               this._keyCountArr[0] = arr[i].count;
            }
            else if(arr[i].itemID == 190899)
            {
               this._keyCountArr[1] = arr[i].count;
            }
            else if(arr[i].itemID == 190900)
            {
               this._keyCountArr[2] = arr[i].count;
            }
            else if(arr[i].itemID == 190901)
            {
               this._keyCountArr[3] = arr[i].count;
            }
         }
         this.checkKey();
      }
      
      private function checkMapID() : void
      {
         if(this._mapID == 112)
         {
            if(this._flag == 1)
            {
               this.addEvent();
            }
         }
         else if(this._mapID == 80)
         {
            if(this._flag == 2)
            {
               this.addEvent();
            }
         }
         else if(this._mapID == 41)
         {
            if(this._flag == 4)
            {
               this.addEvent();
            }
         }
      }
      
      private function addEvent() : void
      {
         this._mc["dragons_mc"].visible = true;
         this._mc["dragons_mc"].buttonMode = true;
         BC.addEvent(this,this._mc["dragons_mc"],MouseEvent.CLICK,this.onGetKey);
      }
      
      private function onGetKey(event:MouseEvent) : void
      {
         this._bl = true;
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.onMoveOver);
         GV.MAN_PEOPLE.moveTo(this._mc["dragons_point"].x,this._mc["dragons_point"].y);
      }
      
      private function onMoveOver(event:*) : void
      {
         if(Boolean(GV.MAN_PEOPLE.hitTestObject(this._mc["dragons_point"])))
         {
            if(this._hitBl)
            {
               return;
            }
            this._hitBl = true;
            if(this._bl)
            {
               BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.onMoveStart);
               MoveTo.CanMove = false;
               this._ply = PlayMovie.play("resource/task/waMC.swf",this.loaderSuc,null,this.backFun,null);
            }
         }
      }
      
      private function loaderSuc() : void
      {
         this._ply.movie_mc.x = this._mc["dragons_mc"].x - this._mc["dragons_mc"].height;
         this._ply.movie_mc.y = this._mc["dragons_mc"].y;
      }
      
      private function backFun() : void
      {
         if(Boolean(this._ply))
         {
            this._ply.destroy();
            this._ply = null;
            MoveTo.CanMove = true;
            this._bl = false;
            this._mc["dragons_mc"].visible = false;
            this._mc["key"].visible = true;
            BC.addEvent(this,this._mc["key"],MouseEvent.CLICK,this.onPlayGetKeyMovie);
         }
      }
      
      private function onMoveStart(event:*) : void
      {
         BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.onMoveStart);
         if(Boolean(this._ply))
         {
            this._ply.destroy();
            this._ply = null;
            MoveTo.CanMove = true;
         }
         this._hitBl = false;
      }
      
      private function onPlayGetKeyMovie(event:MouseEvent) : void
      {
         BC.removeEvent(this,this._mc["key"],MouseEvent.CLICK,this.onPlayGetKeyMovie);
         this._mc["key"].visible = false;
         this._ply = PlayMovie.play("resource/task/MV.swf",null,null,this.backFun2,null);
      }
      
      private function backFun2() : void
      {
         if(Boolean(this._ply))
         {
            this._ply.destroy();
            this._ply = null;
         }
         this.onGetKeyBySocket();
      }
      
      private function onGetKeyBySocket() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetMineMapKeyCmd.READ_8086,this.onGetKeySuc);
         GetMineMapKeyCmd.sendReq();
      }
      
      private function onGetKeySuc(event:EventTaomee) : void
      {
         Alert.smileAlart("    恭喜你獲得了一枚月食鑰匙碎片！");
         this.getKeyInfo();
      }
      
      private function checkKey() : void
      {
         if(this._keyCountArr[0] >= 1 && this._keyCountArr[1] >= 1 && this._keyCountArr[2] >= 1)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetAllKeySuc);
            exchange.exchange_goods(998);
         }
      }
      
      private function onGetAllKeySuc(event:EventTaomee) : void
      {
         this._ply = PlayMovie.play("resource/task/KeyComposeMV.swf",null,null,this.backFun3,null);
      }
      
      private function backFun3() : void
      {
         if(Boolean(this._ply))
         {
            this._ply.destroy();
            this._ply = null;
         }
         PlayMovie.play("resource/task/AllKeyOver.swf",null,null,null,null);
      }
      
      public function InitMap241(mc:MovieClip) : void
      {
         this.target_mc = mc;
         BC.addEvent(this,this.target_mc["MC"],MouseEvent.CLICK,this.onClickMC);
      }
      
      private function onClickMC(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc["MC"],MouseEvent.CLICK,this.onClickMC);
         BC.addEvent(this,GV.onlineSocket,"read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.res_GetAllKeyInfo);
         GetGoodsInfoByArr.GetGoodsInfo(0,[190901]);
      }
      
      private function res_GetAllKeyInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.res_GetAllKeyInfo);
         var arr:Array = event.EventObj.itemArr;
         var len:int = int(arr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(arr[i].itemID == 190901)
            {
               this._keyCountArr[3] = arr[i].count;
               break;
            }
         }
         if(this._keyCountArr[3] > 0)
         {
            BC.addEvent(this,this.target_mc["MC"],"longEggFrame2",this.showLongEgg,true);
            this.target_mc["MC"].gotoAndStop(2);
         }
         else
         {
            Alert.smileAlart("      你還沒有收集到鑰匙哦！");
            BC.addEvent(this,this.target_mc["MC"],MouseEvent.CLICK,this.onClickMC);
         }
      }
      
      private function showLongEgg(event:Event) : void
      {
         BC.removeEvent(this,this.target_mc["MC"],"longEggFrame2",this.showLongEgg,true);
         BC.addEvent(this,this.target_mc["MC"],MouseEvent.CLICK,this.getLongEgg);
      }
      
      private function getLongEgg(event:MouseEvent) : void
      {
         this.getDateType();
      }
      
      private function getDateType() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_2008",this.dofinishSomething);
         NpcBallotSocket.NpcBallotReq();
      }
      
      private function dofinishSomething(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_2008",this.dofinishSomething);
         var bit:int = 202;
         var index:int = 202 / 32;
         if(!GF.getBitBool(int(event.EventObj.arr[index]),int(bit - 32)))
         {
            this._ply = PlayMovie.play("resource/task/longMC.swf",null,null,this.backFun4,null);
         }
      }
      
      private function backFun4() : void
      {
         if(Boolean(this._ply))
         {
            this._ply.destroy();
            this._ply = null;
         }
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetLongEggSuc);
         exchange.exchange_goods(999);
      }
      
      private function onGetLongEggSuc(event:EventTaomee) : void
      {
         PlayMovie.play("resource/task/gotoMap27Panel.swf");
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
      }
   }
}

