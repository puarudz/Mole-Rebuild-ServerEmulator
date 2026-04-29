package com.mole.app.activity
{
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class FireGodCup4
   {
      
      private static var _inst:FireGodCup4;
      
      public var team:uint;
      
      private var _tempTeam:int;
      
      public function FireGodCup4()
      {
         super();
      }
      
      public static function get inst() : FireGodCup4
      {
         if(_inst == null)
         {
            _inst = new FireGodCup4();
         }
         return _inst;
      }
      
      public function getTeam() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,this.getKnightTransferState);
         GF.sendSocket(CommandID.GET_KNIGHT_TRANSFER_STATE);
      }
      
      private function getKnightTransferState(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,this.getKnightTransferState);
         var recData:ByteArray = evt.data as ByteArray;
         recData.position = 0;
         this.team = recData.readUnsignedInt();
      }
      
      public function getRank(team:int) : void
      {
         this._tempTeam = team;
         GV.onlineSocket.addCmdListener(8881,this.readRankOver);
         GF.sendSocket(8881,2200000015,2200000018);
      }
      
      private function readRankOver(e:SocketEvent) : void
      {
         var o:Object = null;
         GV.onlineSocket.removeCmdListener(8881,this.readRankOver);
         var data:ByteArray = e.data as ByteArray;
         var arr:Array = [];
         var count:int = int(data.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            o = {};
            o.type = data.readUnsignedInt();
            o.value = data.readUnsignedInt();
            arr.push(o);
         }
         arr.sortOn(["value"],Array.DESCENDING | Array.NUMERIC);
         var rank:int = 0;
         for(var ii:int = 0; ii < count; ii++)
         {
            if(this._tempTeam == arr[ii].type - 2200000014)
            {
               rank = ii + 1;
               break;
            }
         }
         if(GV.MC_mapFrame["depth_mc"].numRank != undefined)
         {
            GV.MC_mapFrame["depth_mc"].numRank.gotoAndStop(rank);
         }
      }
   }
}

