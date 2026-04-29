package com.module.elementKnight
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.module.elementKnight.info.ElementKnightCardInfo;
   import com.module.elementKnight.info.ElementKnightInfo;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class ElementCardManager extends EventDispatcher
   {
      
      private static var _instance:ElementCardManager;
      
      public static const KNIGHT_LV_EXP:Array = [0,102,312,642,1110,1740,2562,3612,4932,6570,8580,11022,13962,17472,21630,26520,32232,38862,46512,55290,65310,76692,89562,104052,120300,138450,158652,181062,205842,233160,263190,296112,332112,371382,414120,460530,510822,565212,623922,687180,755220,828282,906612,990462,1080090,1175760,1277742,1386312,1501752,1624350,1754400,1892202,2038062,2192292,2355210,2527140,2708412,2899362,3100332,3311670,3533730,3766872,4011462,4267872,4536480,4817670,5111832,5419362,5740662,6076140,6426210,6791292,7171812,7568202,7980900,8410350,8857002,9321312,9803742,10304760,10824840,11364462,11924112,12504282,13105470,13728180,14372922,15040212,15730572,16444530,17182620,17945382,18733362,19547112,20387190,21254160,22148592,23071062,24022152,25002450,26012550];
      
      public static const KNIGHT_CARD_NUM:Array = [0,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9];
      
      public static const KNIGHT_CARD_LV_EXP:Array = [[0,8,10,12,14,16,18,20,22,24,26],[0,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48],[0,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70],[0,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92],[0,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114],[0,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136]];
      
      public static const GET_INFO_BACK:String = "get_info_back";
      
      public static const GET_ITEM_BACK:String = "get_item_back";
      
      public static const SWAP_CARD_BACK:String = "swap_card_back";
      
      private var _userMap:HashMap;
      
      private var _elementKnightInfo:ElementKnightInfo;
      
      private var _selfElementInfo:ElementKnightInfo;
      
      public function ElementCardManager()
      {
         super();
         this._userMap = new HashMap();
      }
      
      public static function get instance() : ElementCardManager
      {
         if(!_instance)
         {
            _instance = new ElementCardManager();
         }
         return _instance;
      }
      
      public function getElementInfo(userID:uint = 0) : void
      {
         if(userID == 0)
         {
            this._selfElementInfo = null;
         }
         GV.onlineSocket.addCmdListener(CommandID.ELEMENT_KNIGHT_INFO,this.getElementInfoBack);
         GF.sendSocket(CommandID.ELEMENT_KNIGHT_INFO,userID);
      }
      
      private function getElementInfoBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.ELEMENT_KNIGHT_INFO,this.getElementInfoBack);
         var recData:ByteArray = evt.data as ByteArray;
         this._elementKnightInfo = new ElementKnightInfo(recData);
         this._userMap.add(this._elementKnightInfo.id,this._elementKnightInfo);
         if(!recData)
         {
            return;
         }
         dispatchEvent(new EventTaomee(GET_INFO_BACK));
      }
      
      public function swapCard(putCardId:uint, pushCardId:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.ELEMENT_KNIGHT_SWAP_CARD,this.swapCardtBack);
         GF.sendSocket(CommandID.ELEMENT_KNIGHT_SWAP_CARD,putCardId,pushCardId);
      }
      
      private function swapCardtBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.ELEMENT_KNIGHT_SWAP_CARD,this.swapCardtBack);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         dispatchEvent(new EventTaomee(SWAP_CARD_BACK,state));
      }
      
      public function get lv() : uint
      {
         return this.selfInfo.lv;
      }
      
      public function updateLv(exper:uint) : void
      {
         this.selfInfo.updateLv(exper);
      }
      
      public function get needExp() : uint
      {
         return this.selfInfo.needExp;
      }
      
      public function get curExp() : uint
      {
         return this.selfInfo.curExp;
      }
      
      private function get selfInfo() : ElementKnightInfo
      {
         return this._selfElementInfo = this._selfElementInfo || this.getElementInfoById(LocalUserInfo.getUserID());
      }
      
      public function get id() : uint
      {
         return this.selfInfo.id;
      }
      
      public function get type() : uint
      {
         if(Boolean(this.selfInfo))
         {
            return this.selfInfo.type;
         }
         return 0;
      }
      
      public function get nick() : String
      {
         return this.selfInfo.nick;
      }
      
      public function get exp() : uint
      {
         return this.selfInfo.exp;
      }
      
      public function set exp(value:uint) : void
      {
         this.selfInfo.exp = value;
      }
      
      public function get curStrength() : uint
      {
         return this.selfInfo.curStrength;
      }
      
      public function set curStrength(value:uint) : void
      {
         this.selfInfo.curStrength = value;
      }
      
      public function get maxStrength() : uint
      {
         return this.selfInfo.maxStrength;
      }
      
      public function set maxStrength(value:uint) : void
      {
         this.selfInfo.maxStrength = value;
      }
      
      public function get talent() : uint
      {
         return this.selfInfo.talent;
      }
      
      public function get minAttack() : uint
      {
         return this.selfInfo.minAttack;
      }
      
      public function get maxAttack() : uint
      {
         return this.selfInfo.maxAttack;
      }
      
      public function get minDef() : uint
      {
         return this.selfInfo.minDef;
      }
      
      public function get maxDef() : uint
      {
         return this.selfInfo.maxDef;
      }
      
      public function get pvpWin() : uint
      {
         return this.selfInfo.pvpWin;
      }
      
      public function get pvpLose() : uint
      {
         return this.selfInfo.pvpLose;
      }
      
      public function get chasm() : uint
      {
         return this.selfInfo.chasm;
      }
      
      public function get rank() : uint
      {
         return this.selfInfo.rank;
      }
      
      public function set rank(value:uint) : void
      {
         this.selfInfo.rank = value;
      }
      
      public function get coolDown() : uint
      {
         return this.selfInfo.coolDown;
      }
      
      public function get cardList() : Vector.<ElementKnightCardInfo>
      {
         return this.selfInfo.cardList;
      }
      
      public function get itemMap() : HashMap
      {
         return this.selfInfo.itemMap;
      }
      
      public function getElementInfoById(id:uint) : ElementKnightInfo
      {
         return this._userMap.getValue(id) as ElementKnightInfo;
      }
   }
}

