package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.task.SeaParkCtrl;
   import com.module.activityModule.Presented;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map256View extends MapBase
   {
      
      private static const WATER_CRYSTALS:uint = 191074;
      
      private var _siren_mc:MovieClip;
      
      private var _siren_btn:SimpleButton;
      
      private var _tarList:Array;
      
      public function Map256View()
      {
         super();
         Map255View.setPrevMapID(256);
      }
      
      override protected function initView() : void
      {
         var i:uint;
         var tar_mc:MovieClip = null;
         this._siren_mc = topLevel["siren_mc"];
         this._siren_btn = topLevel["siren_btn"];
         this._siren_btn.visible = this._siren_mc.visible = false;
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),14335,2);
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onCheckItem14335);
         this._siren_btn.addEventListener(MouseEvent.CLICK,this.onSeeSiren);
         this._tarList = new Array();
         for(i = 1; i <= 3; i++)
         {
            tar_mc = topLevel["tar" + i + "_mc"];
            tar_mc.mouseChildren = false;
            tar_mc.buttonMode = true;
            tar_mc.addEventListener(MouseEvent.CLICK,this.onGetAward1);
            this._tarList.push(tar_mc);
         }
         SeaParkCtrl.inst.initBucket();
         SeaParkCtrl.inst.initSpout();
         SystemEventManager.addEventListener("openSwap",this.onOpenSwap);
         SystemEventManager.addEventListener("buyGameMoney",this.onBuyGameMoney);
         SystemEventManager.addEventListener("blueKnight",this.onBlueKnight);
         BC.addEvent(this,topLevel["card1_mc"],MouseEvent.CLICK,function(e:Event):void
         {
            ModuleManager.openPanel(ModuleType.HAPPY_SUMMER_PANEL);
         });
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      private function onBlueKnight(evt:Event) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),WATER_CRYSTALS,2,WATER_CRYSTALS + 1);
      }
      
      private function getItemCountBk(evt:EventTaomee) : void
      {
         var itemObj:Object = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         var itemArr:Array = evt.EventObj.obj.arr;
         for each(itemObj in itemArr)
         {
            if(WATER_CRYSTALS == itemObj.ID)
            {
               if(itemObj.Count >= 1)
               {
                  mapSay(3);
                  ActivityTmpDataManager.getTransferItem(1);
                  return;
               }
            }
         }
         mapSay(4);
      }
      
      private function onOpenSwap(e:Event) : void
      {
         SeaParkCtrl.inst.openSeaParkExePanel();
      }
      
      private function onBuyGameMoney(e:Event) : void
      {
      }
      
      private function onOpenCard(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.PARADISE_POSTCARD_PANEL);
      }
      
      private function onGetAward1(e:MouseEvent) : void
      {
         var clothObj:Object = null;
         var tar_mc:MovieClip = null;
         var mc:MovieClip = null;
         var peopleView:PeopleManageView = null;
         var angle:Number = NaN;
         var disX:Number = NaN;
         var disY:Number = NaN;
         var isUse:Boolean = false;
         var clothList:Array = LocalUserInfo.getClothItem();
         for each(clothObj in clothList)
         {
            if(clothObj.id == 14335)
            {
               isUse = true;
               break;
            }
         }
         if(isUse)
         {
            tar_mc = e.currentTarget as MovieClip;
            tar_mc.mouseChildren = false;
            tar_mc.mouseEnabled = false;
            mc = GV.Lib_Map.getMovieClip("RES_WaterBall") as MovieClip;
            peopleView = GV.MAN_PEOPLE;
            mc.x = peopleView.x;
            mc.y = peopleView.y - 30;
            angle = Math.atan2(tar_mc.y - mc.y,tar_mc.x - mc.x);
            disX = Math.cos(angle) * 90;
            disY = Math.sin(angle) * 90;
            mc.rotation = angle * 180 / Math.PI;
            topLevel.addChild(mc);
            TweenLite.to(mc,0.6,{
               "x":tar_mc.x - disX,
               "y":tar_mc.y - 50 - disY,
               "onComplete":function():void
               {
                  DisplayUtil.removeForParent(mc);
                  if(Math.random() > 0.7)
                  {
                     MovieClipUtil.playAppointFrameAndFunc(tar_mc,2,function():void
                     {
                        var win_mc:* = undefined;
                        win_mc = tar_mc["win_mc"];
                        MovieClipUtil.playEndAndFunc(win_mc,function():void
                        {
                           win_mc.stop();
                           Presented.getInstance().celebrate1225(1599,1,1,"","　　這個靶子的禮品今天已經全部發完了哦！明天再來吧！");
                        });
                     });
                  }
                  else
                  {
                     tar_mc.gotoAndStop(3);
                  }
               }
            });
         }
         else
         {
            Alert.smileAlart("　　請先裝備好水槍！");
         }
      }
      
      private function onCheckItem14335(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckItem14335);
         var itemPro:GetItemCountRes = e.bodyInfo;
         var itemInfo:ItemInfo = itemPro.itemHash.getValue(14335);
         if(itemInfo == null || itemInfo.count == 0)
         {
            this._siren_btn.visible = this._siren_mc.visible = true;
         }
      }
      
      private function onSeeSiren(e:MouseEvent) : void
      {
         MovieClipUtil.playEndAndFunc(this._siren_mc,function():void
         {
            exchange.exchange_goods(1600);
            Alert.smileAlart("　　恭喜你獲得水槍！");
            _siren_btn.visible = _siren_mc.visible = false;
         });
         this._siren_mc.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         var tar_mc:DisplayObject = null;
         SystemEventManager.removeEventListener("blueKnight",this.onBlueKnight);
         SystemEventManager.removeEventListener("openSwap",this.onOpenSwap);
         SeaParkCtrl.inst.destroy();
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckItem14335);
         for each(tar_mc in this._tarList)
         {
            tar_mc.removeEventListener(MouseEvent.CLICK,this.onGetAward1);
         }
         this._tarList = null;
         this._siren_btn.removeEventListener(MouseEvent.CLICK,this.onSeeSiren);
         super.destroy();
      }
   }
}

