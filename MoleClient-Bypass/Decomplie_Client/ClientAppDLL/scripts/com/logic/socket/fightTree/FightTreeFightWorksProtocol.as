package com.logic.socket.fightTree
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class FightTreeFightWorksProtocol extends SocketProtocol
   {
      
      private var _userID:uint;
      
      private var _flag:uint;
      
      private var _pos:uint;
      
      public function FightTreeFightWorksProtocol()
      {
         super(CommandID.FIGHT_TREE_FIGHTWORKS);
      }
      
      public static function send(flag:uint, pos:uint) : void
      {
         GF.sendSocket(CommandID.FIGHT_TREE_FIGHTWORKS,flag,pos);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._userID = bodyData.readUnsignedInt();
         this._flag = bodyData.readUnsignedInt();
         this._pos = bodyData.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get pos() : uint
      {
         return this._pos;
      }
   }
}

