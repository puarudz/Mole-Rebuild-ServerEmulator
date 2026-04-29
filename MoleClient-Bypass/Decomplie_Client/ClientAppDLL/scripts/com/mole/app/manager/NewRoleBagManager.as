package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetRedPacketProtocol;
   import com.logic.socket.useUserDItem.UseUserItemRigReq;
   import com.mole.app.info.SuitCloth;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.Tool;
   import com.mole.net.events.SocketEvent;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   
   public class NewRoleBagManager extends EventDispatcher
   {
      
      private static var _inst:NewRoleBagManager;
      
      private static var _bagView:AppModuleControl;
      
      public static const GET_RED_PACKET_OVER:String = "GET_RED_PACKET_OVER";
      
      public var curRoleClothArr:Array;
      
      public var selectSuit:SuitCloth;
      
      public var clothObject:Object;
      
      public var curSelectCloth:Array;
      
      public var suitClothList:Vector.<SuitCloth>;
      
      public var tempRoleType:uint;
      
      public function NewRoleBagManager()
      {
         super();
      }
      
      public static function get inst() : NewRoleBagManager
      {
         if(_inst == null)
         {
            _inst = new NewRoleBagManager();
         }
         return _inst;
      }
      
      public static function closeBag() : void
      {
         if(Boolean(_bagView))
         {
            _bagView.close();
            _bagView = null;
         }
      }
      
      public static function openBag() : void
      {
         _bagView = ModuleManager.openPanel(ModuleType.New_ROLE_BAG_PANEL,null,"正在加載背包。");
         _bagView.addEventListener(ModuleEvent.DESTROY,onBagViewDestroy);
      }
      
      private static function onBagViewDestroy(e:ModuleEvent) : void
      {
         _bagView.removeEventListener(ModuleEvent.DESTROY,onBagViewDestroy);
         _bagView = null;
      }
      
      public function save() : void
      {
         var mReq:UseUserItemRigReq = null;
         var userShared:SharedObject = null;
         if(Boolean(this.curSelectCloth))
         {
            mReq = new UseUserItemRigReq();
            mReq.useUserItemRig(this.curSelectCloth.slice(0));
            LocalUserInfo.setClothItem(this.curSelectCloth.slice(0));
            GV.MAN_PEOPLE.clothsArray = LocalUserInfo.getClothItem();
            GV.onlineSocket.dispatchEvent(new EventTaomee("changeClothForMap"));
            userShared = MainManager.getGlobalObject();
            userShared.data.clothArray = this.curSelectCloth.slice();
            GV.MAN_PEOPLE.ChangeCloths();
         }
      }
      
      public function getRedPacket() : void
      {
         OnlineManager.addCmdListener(CommandID.GET_RED_PACKET,this.onGetRedPacket);
         OnlineManager.send(CommandID.GET_RED_PACKET);
      }
      
      private function onGetRedPacket(e:SocketEvent) : void
      {
         var pro:GetRedPacketProtocol = e.bodyInfo;
         if(pro.state == 2)
         {
            Tool.alert(pro.itemID,pro.count);
            if(pro.itemID == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + pro.count);
            }
         }
         else if(pro.state == 1)
         {
            Alert.smileAlart("    你已經擁有了" + GoodsInfo.getItemNameByID(pro.itemID) + ",無法重復獲得!");
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_RED_PACKET_OVER,pro.state));
      }
      
      public function destroy() : void
      {
         this.curRoleClothArr = null;
         this.clothObject = null;
         this.curSelectCloth = null;
         this.suitClothList = null;
      }
   }
}

