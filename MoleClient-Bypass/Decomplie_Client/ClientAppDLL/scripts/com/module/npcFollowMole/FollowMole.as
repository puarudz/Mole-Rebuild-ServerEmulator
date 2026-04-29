package com.module.npcFollowMole
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.logic.socket.pig.PigSocket;
   import com.module.newAngel.NewAngelManager;
   import com.module.pig.PigEvent;
   import com.module.pig.PigHouseEntrance;
   import com.mole.app.manager.OnlineManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   
   public class FollowMole
   {
      
      private static var _npcFollowDic:Dictionary = new Dictionary();
      
      public function FollowMole()
      {
         super();
      }
      
      public static function NpcFollow(npcId:int) : void
      {
         var nfm:NpcFollowMole = null;
         if(_npcFollowDic[npcId] == null)
         {
            nfm = new NpcFollowMole();
            nfm.Follow(npcId);
            _npcFollowDic[npcId] = nfm;
         }
      }
      
      public static function NpcUnFollow(npcId:int) : void
      {
         var nfm:NpcFollowMole = null;
         if(Boolean(_npcFollowDic[npcId]))
         {
            nfm = _npcFollowDic[npcId];
            nfm.UnFollow();
            _npcFollowDic[npcId] = null;
         }
      }
      
      public static function NpcSay(npcId:int, _str:String) : void
      {
         var nfm:NpcFollowMole = null;
         if(Boolean(_npcFollowDic[npcId]))
         {
            nfm = _npcFollowDic[npcId];
            nfm.Say(_str);
         }
      }
      
      public static function GetNpcFollowMole(npcId:int) : NpcFollowMole
      {
         return _npcFollowDic[npcId];
      }
      
      public static function AngelFollow(id:int) : void
      {
         var mole:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(mole.hasAngel) && Boolean(mole.angelFollow) && mole.angelFollow.angelId == id)
         {
            Alert.smileAlart("    你身邊帶的就是這個天使！");
            return;
         }
         GV.onlineSocket.addEventListener("read_" + AngelParkSocket.FollowCmd,OnAngelFollowOk);
         AngelParkSocket.Follow(id,1);
      }
      
      public static function NewAngleFollow(id:int) : void
      {
         var mole:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(mole.hasAngel) && Boolean(mole.angelFollow) && mole.angelFollow.angelId == id)
         {
            Alert.smileAlart("    你身邊帶的就是這個天使！");
            return;
         }
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_FOLLOW,OnNewAngelFollowOk);
         OnlineManager.send(CommandID.NEW_ANGEL_FOLLOW,id,1);
      }
      
      private static function OnNewAngelFollowOk(e:SocketEvent) : void
      {
         var mole:PeopleManageView = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_FOLLOW,OnNewAngelFollowOk);
         var bodyData:ByteArray = e.data as ByteArray;
         var state:int = int(bodyData.readUnsignedInt());
         var angleIndex:int = int(bodyData.readUnsignedInt());
         var angelID:int = int(bodyData.readUnsignedInt());
         if(state == 1)
         {
            mole = GV.MAN_PEOPLE as PeopleManageView;
            NewAngelManager.instance.followNewAngelID = angleIndex;
            mole.NewAngelFollow(angelID,angleIndex);
         }
      }
      
      private static function OnAngelFollowOk(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + AngelParkSocket.FollowCmd,OnAngelFollowOk);
         var id:int = int(e.EventObj);
         var mole:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         mole.AngelFollow(id);
      }
      
      public static function PigFollow(id:int) : void
      {
         var mole:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(mole.hasPig) && Boolean(mole.pigFollow) && mole.pigFollow.pigId == id)
         {
            Alert.smileAlart("    你正帶著TA呢！");
            return;
         }
         DoPigFollow(id);
      }
      
      private static function DoPigFollow(id:int) : void
      {
         GV.onlineSocket.addEventListener("read_" + PigSocket.FollowMoleCmd,OnPigFollowOk);
         PigSocket.FollowMole(id);
      }
      
      private static function OnPigFollowOk(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + PigSocket.FollowMoleCmd,OnPigFollowOk);
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Beauty_Has_Suc));
         var mole:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         mole.PigFollow(e.EventObj);
         if(PigHouseEntrance.instance.userId > 0)
         {
            PigSocket.GetPigHouseInfo(PigHouseEntrance.instance.userId);
         }
         else
         {
            PigSocket.GetPigHouseInfo(LocalUserInfo.getUserID());
         }
      }
   }
}

