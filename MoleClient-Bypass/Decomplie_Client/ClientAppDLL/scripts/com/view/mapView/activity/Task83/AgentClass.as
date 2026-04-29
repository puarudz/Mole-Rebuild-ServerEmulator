package com.view.mapView.activity.Task83
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.session.BringTagoutLoginSocket;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   
   public class AgentClass
   {
      
      private static var _instance:AgentClass;
      
      private var byte:ByteArray = new ByteArray();
      
      private var game_id:uint;
      
      private var type:String;
      
      public function AgentClass()
      {
         super();
      }
      
      public static function get instance() : AgentClass
      {
         if(!_instance)
         {
            _instance = new AgentClass();
         }
         return _instance;
      }
      
      private static function B2S(b:ByteArray) : String
      {
         var t:String = null;
         var s:String = "";
         var op:uint = b.position;
         b.position = 0;
         while(Boolean(b.bytesAvailable))
         {
            t = b.readUnsignedByte().toString(16);
            s += t.length == 1 ? "0" + t : t;
         }
         b.position = op;
         return s;
      }
      
      public function AgentRegistration(id:uint, str:String) : void
      {
         this.game_id = id;
         this.type = str;
         BC.addEvent(this,GV.onlineSocket,"read_" + 426,this.getInformation);
         BringTagoutLoginSocket.get_GameSID(id);
      }
      
      private function getInformation(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 426,this.getInformation);
         ByteArray(e.EventObj).position = 0;
         ByteArray(e.EventObj).readBytes(this.byte);
         this.byte.position = 0;
         this.checkToJump();
      }
      
      private function checkToJump() : void
      {
         var url:String = null;
         switch(this.type)
         {
            case "pay61":
               url = "http://pay.61.com/award?game=mole&userid=" + LocalUserInfo.getUserID() + "&gameid=10000&session=" + B2S(this.byte);
               break;
            case "tougao":
               url = "http://service.61.com/user?uid=" + LocalUserInfo.getUserID() + "&gameid=1&session=" + B2S(this.byte);
               B2S(this.byte);
               break;
            case "dc61":
               url = "http://bbs.61.com/checksession/?username=" + LocalUserInfo.getUserID() + "&gid=1&session=b068fd29894e2342530b96746afb4e45&fid=2";
               B2S(this.byte);
         }
         navigateToURL(new URLRequest(url),"_blank");
      }
   }
}

