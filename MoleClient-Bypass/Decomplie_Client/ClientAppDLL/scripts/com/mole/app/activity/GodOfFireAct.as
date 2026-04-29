package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.view.MapManageView.MapManageView;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class GodOfFireAct
   {
      
      private static var _inst:GodOfFireAct;
      
      private var _ChooseID:uint;
      
      private var _mapIndex:uint;
      
      private var choseCtl:AppModuleControl;
      
      private var mapIDVec:Vector.<uint> = new <uint>[344,344,344,344];
      
      private var groupIDVec:Vector.<uint> = new <uint>[1,2,3,4];
      
      private var swapIDVec:Vector.<uint> = new <uint>[2693,2694,2695,2696];
      
      private var creIDVec:Vector.<uint> = new <uint>[191070,191071,191072,191073];
      
      private const CERTID:uint = 2697;
      
      private const CERITEM:uint = 191069;
      
      private var gadID:uint = 2718;
      
      private var gadItem:uint = 191094;
      
      private var ArmIDVec:Vector.<uint> = new <uint>[2720,2721,2722,2723];
      
      private var ArmItemVec:Vector.<uint> = new <uint>[15027,15029,15026,15028];
      
      private var ClothIDVec:Vector.<uint> = new <uint>[2698,2699,2700,2715];
      
      private var clothItemID:Vector.<uint> = new <uint>[15038,15039,15040,15041];
      
      private var ClothHat:Vector.<uint> = new <uint>[2716,2717];
      
      private var clothHatIDVec:Vector.<uint> = new <uint>[15042,15043];
      
      private var appCtl:AppModuleControl;
      
      private var queryItem:QueryItemCntManager;
      
      public function GodOfFireAct()
      {
         super();
      }
      
      public static function getInst() : GodOfFireAct
      {
         if(!_inst)
         {
            _inst = new GodOfFireAct();
         }
         return _inst;
      }
      
      public function getIn() : void
      {
         var j:uint = 0;
         var getKnightTransferState:Function = null;
         if(MapManager.curMapID == 344)
         {
            for(j = 1; j < 5; j++)
            {
               SystemEventManager.addEventListener("sport" + j,this.sportHandle);
            }
            this.queryItem = new QueryItemCntManager();
            GV.onlineSocket.addEventListener("removeMapEvent",this.onChangeMap);
            getKnightTransferState = function(evt:SocketEvent):void
            {
               GV.onlineSocket.removeCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,getKnightTransferState);
               var recData:ByteArray = evt.data as ByteArray;
               recData.position = 0;
               var typeIndex:uint = recData.readUnsignedInt();
               FireGodCup4.inst.team = typeIndex;
            };
            GV.onlineSocket.addCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,getKnightTransferState);
            GF.sendSocket(CommandID.GET_KNIGHT_TRANSFER_STATE);
            SystemEventManager.addEventListener("sport" + 200,this.npcSportHandle);
            SystemEventManager.addEventListener("sport" + 300,this.npcSportHandle);
            SystemEventManager.addEventListener("sport" + 400,this.npcSportHandle);
         }
      }
      
      private function npcSportHandle(e:SystemEvent) : void
      {
         switch(this._ChooseID)
         {
            case 200:
               this.jiaoWenZhang();
               break;
            case 300:
               this.lingXiuZhang();
               break;
            case 400:
               this.lingDuiFu();
         }
      }
      
      private function sportHandle(e:SystemEvent) : void
      {
         var sayID:uint = 0;
         this._ChooseID = uint(String(e.type).slice(5,6));
         if(FireGodCup4.inst.team == this._ChooseID)
         {
            sayID = 8887 + this._ChooseID;
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(sayID));
         }
         else
         {
            switch(FireGodCup4.inst.team)
            {
               case 0:
                  this.queryItem.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.onItemHandle);
                  this.queryItem.oneItemQuery(this.creIDVec[this._mapIndex]);
                  break;
               case 1:
                  Alert.angryAlart("  你已經是水元素騎士了，應該去水元素隊長麼麼公主那裡報到哦！");
                  break;
               case 2:
                  Alert.angryAlart("  你已經是火元素騎士了，應該去火元素隊長丫麗那裡報到哦！");
                  break;
               case 3:
                  Alert.angryAlart("  你已經是風元素騎士了，應該去風元素隊長摩樂樂那裡報到哦！");
                  break;
               case 4:
                  Alert.angryAlart("  你已經是土元素騎士了，應該去土元素隊長菩提大伯那裡報到哦！");
            }
         }
      }
      
      private function lingDuiFu() : void
      {
         if(FireGodCup4.inst.team == 0)
         {
            Alert.angryAlart("  小摩爾還不是元素騎士哦，無法領取！");
         }
         else
         {
            this.queryItem.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.lingDuiFuHandle);
            this.queryItem.oneItemQuery(this.clothItemID[this._mapIndex]);
         }
      }
      
      private function lingDuiFuHandle(e:EventTaomee) : void
      {
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.lingDuiFuHandle);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(this.ClothIDVec[this._mapIndex]);
         }
         this.queryItem.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.continueHandle);
         this.queryItem.someGoosQuery(new Array(this.clothHatIDVec[0],this.clothHatIDVec[1]));
      }
      
      private function continueHandle(e:EventTaomee) : void
      {
         var dandan:* = undefined;
         this.queryItem.removeEventListener(QueryItemCntManager.CONTINUOUSITEM_QUERY,this.continueHandle);
         var arr:Array = e.EventObj as Array;
         var num:uint = 0;
         for each(dandan in arr)
         {
            if(dandan > 0)
            {
               num++;
            }
         }
         if(num <= 0)
         {
            this.choseCtl = ModuleManager.openPanel("ChooseSexMagicPanel",FireGodCup4.inst.team);
            this.choseCtl.addEventListener(ModuleEvent.DESTROY,this.onCheckChose);
         }
      }
      
      private function onCheckChose(e:ModuleEvent) : void
      {
         this.choseCtl.removeEventListener(ModuleEvent.DESTROY,this.onCheckChose);
         var score:uint = uint(e.data);
         Presented.getInstance().celebrate1225(this.ClothHat[score - 1]);
      }
      
      private function jiaoWenZhang() : void
      {
         if(FireGodCup4.inst.team == 0)
         {
            Alert.angryAlart("  小摩爾還不是元素騎士哦，無法領取！");
         }
         else
         {
            ModuleManager.openPanel("FireGodCup4TeamRankPanel");
         }
      }
      
      private function wenzhangHandle(e:EventTaomee) : void
      {
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.wenzhangHandle);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            Alert.angryAlart(" 很可惜,小摩爾現在還沒有" + GoodsInfo.getItemNameByID(this.gadItem) + "，所以現在還不能兌換!");
         }
         else
         {
            this.appCtl = ModuleManager.openPanel("SwapWenZhangPanel",times);
            this.appCtl.addEventListener(ModuleEvent.DESTROY,this.onSubmitScore);
         }
      }
      
      private function onSubmitScore(e:ModuleEvent) : void
      {
         var appCtl:AppModuleControl = e.currentTarget as AppModuleControl;
         appCtl.removeEventListener(ModuleEvent.DESTROY,this.onSubmitScore);
         var score:uint = uint(e.data);
         Presented.getInstance().celebrate1225(this.gadID,score);
      }
      
      private function lingXiuZhang() : void
      {
         if(FireGodCup4.inst.team == 0)
         {
            Alert.angryAlart("  小摩爾還不是元素騎士哦，無法領取！");
         }
         else
         {
            this.queryItem.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.xiuZhang);
            this.queryItem.oneItemQuery(this.ArmItemVec[this._mapIndex]);
         }
      }
      
      private function xiuZhang(e:EventTaomee) : void
      {
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.xiuZhang);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(this.ArmIDVec[this._mapIndex]);
         }
         else
         {
            Alert.angryAlart("  小摩爾已經有" + GoodsInfo.getItemNameByID(this.ArmItemVec[this._mapIndex]) + ",所以無法領取了哦!");
         }
      }
      
      private function baoMing() : void
      {
      }
      
      private function onItemHandle(e:EventTaomee) : void
      {
         var times:uint;
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.onItemHandle);
         times = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(this.swapIDVec[this._mapIndex]);
            this.queryItem.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.certifHandle);
            this.queryItem.oneItemQuery(this.CERITEM);
            Alert.smileAlart("  要加入隊伍，先要轉職成元素騎士哦，拿著這兩封推薦信去女神那裡轉職吧！",function():void
            {
               MapManager.enterMap(336);
            });
         }
         else
         {
            Alert.smileAlart("你已經有轉職信和見習信，現在就去時光女神那裡宣誓就職吧！",function():void
            {
               MapManager.enterMap(336);
            });
         }
      }
      
      private function certifHandle(e:EventTaomee) : void
      {
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.certifHandle);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(this.CERTID);
         }
      }
      
      public function onChangeMap(e:*) : void
      {
         this.queryItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.lingDuiFuHandle);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         for(var i:uint = 1; i < 5; i++)
         {
            SystemEventManager.removeEventListener("sport" + i,this.sportHandle);
         }
         SystemEventManager.removeEventListener("sport" + 200,this.npcSportHandle);
         SystemEventManager.removeEventListener("sport" + 300,this.npcSportHandle);
         SystemEventManager.removeEventListener("sport" + 400,this.npcSportHandle);
      }
   }
}

