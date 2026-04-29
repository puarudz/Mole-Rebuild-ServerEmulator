package com.logic.socket.fightTree
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class FightTreeCheckPeoinfProtocol extends SocketProtocol
   {
      
      private var _stateList:Array;
      
      private var _times:uint;
      
      public function FightTreeCheckPeoinfProtocol()
      {
         super(CommandID.FIGHT_TREE_CHECK_PEOINF);
      }
      
      public static function send() : void
      {
         GF.sendSocket(CommandID.FIGHT_TREE_CHECK_PEOINF);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var userObj:Object = null;
         this._stateList = new Array();
         this._times = bodyData.readUnsignedInt();
         var count:uint = bodyData.readUnsignedInt();
         for(var i:uint = 0; i < count; i++)
         {
            userObj = new Object();
            userObj.userID = bodyData.readUnsignedInt();
            this._stateList.push(userObj);
         }
      }
      
      public function get stateList() : Array
      {
         return this._stateList;
      }
      
      public function get startTime() : uint
      {
         return this._times;
      }
   }
}

