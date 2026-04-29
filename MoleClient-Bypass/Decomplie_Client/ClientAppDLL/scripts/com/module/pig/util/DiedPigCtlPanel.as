package com.module.pig.util
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.pig.PigSocket;
   import com.module.activityModule.checkItem;
   import com.module.pig.PigExtenalCtl;
   import com.module.pig.PigHouseUI;
   import com.module.pig.data.PigHouseData;
   import com.module.pig.view.pig.Pig;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DiedPigCtlPanel
   {
      
      private static const Save_Item:int = 1613108;
      
      private var _ui:MovieClip;
      
      private var _pig:Pig;
      
      private var _saveItemCount:int = 0;
      
      public function DiedPigCtlPanel(pig:Pig)
      {
         super();
         this._pig = pig;
         var uiUrl:String = "module/pig/ui/diePanel.swf";
         var loader:Loader = new Loader();
         BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
         loader.load(VL.getURLRequest(uiUrl));
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Close);
         this.GetCardCount();
      }
      
      private function GetCardCount() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.GetSaveItemHandler);
         checkItem.checkItemHandler(Save_Item);
      }
      
      private function GetSaveItemHandler(e:EventTaomee) : void
      {
         this._saveItemCount = e.EventObj.num;
      }
      
      private function Close(e:* = null) : void
      {
         BC.removeEvent(this);
         try
         {
            this._ui.visible = false;
            GC.clearAll(this._ui);
            this._pig = null;
         }
         catch(e:Error)
         {
         }
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         this._ui = loaderInfo.content as MovieClip;
         MainManager.getAppLevel().addChild(this._ui);
         BC.addEvent(this,this._ui.close_btn,MouseEvent.CLICK,this.Close);
         BC.addEvent(this,this._ui.save_btn,MouseEvent.CLICK,this.Save);
         BC.addEvent(this,this._ui.sell_btn,MouseEvent.CLICK,this.Sell);
      }
      
      private function Sell(e:MouseEvent) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.SellItemCmd,this.SellHandler);
         PigSocket.SellItem(1,0,0,[this._pig.pigData.id]);
      }
      
      private function SellHandler(e:EventTaomee) : void
      {
         var gold:int = int(e.EventObj.gold);
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + gold);
         this.Close();
         PigHouseData.instance.GetPigHouseData();
         Alert.smileAlart("      恭喜你獲得" + gold + "個摩爾豆。");
      }
      
      private function Save(e:MouseEvent) : void
      {
         if(this._saveItemCount <= 0)
         {
            Alert.smileAlart("     你沒有" + GoodsInfo.getItemNameByID(Save_Item) + "，請去商店購買吧。",this.OpenShop,"sure,cancel");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.UseItemCmd,this.SaveHandler);
            PigSocket.UseItem(Save_Item,this._pig.pigData.id);
         }
      }
      
      private function OpenShop(e:Event) : void
      {
         this.Close();
         PigExtenalCtl.OpenShop(3);
      }
      
      private function SaveHandler(e:EventTaomee) : void
      {
         var result:int = int(e.EventObj.result);
         var itemId:int = int(e.EventObj.itemId);
         var pigId:int = int(e.EventObj.pigId);
         if(result == 1)
         {
            this._pig.GetFullData(this.SavedOkHandler,true);
         }
      }
      
      private function SavedOkHandler() : void
      {
         var mc:MovieClip = PigHouseUI.instance.GetMovieClip("live_movie");
         mc.x = this._pig.pigView.x;
         mc.y = this._pig.pigView.y;
         MainManager.getAppLevel().addChild(mc);
         MovieClipUtil.playEndAndRemove(mc);
         this._pig.Reset();
         this.Close();
      }
   }
}

