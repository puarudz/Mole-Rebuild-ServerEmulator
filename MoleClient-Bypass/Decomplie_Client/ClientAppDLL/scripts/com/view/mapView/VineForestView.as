package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.queryTrainResult.queryTrainResult;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class VineForestView extends MapBase
   {
      
      private var checkCard:int = 0;
      
      public function VineForestView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         controlLevel["cardgamebtn"].buttonMode = true;
         BC.addEvent(this,controlLevel.hitMC,"onHit",this.inGame);
         BC.addEvent(this,controlLevel.tree_mc,MouseEvent.CLICK,this.lookHandler);
      }
      
      private function gotoCardGame(e:* = null) : void
      {
         GameframeLogic.dragonInfo = PeopleManageView(GV.MAN_PEOPLE).dragon_Info;
         MapManager.clearMap();
         new LoadGame("module/game/dreamland.swf","正在打開.....",MainManager.getGameLevel().addChild(new Sprite()) as Sprite);
      }
      
      private function inGame(e:Event) : void
      {
         var explain:String = null;
         var url:String = null;
         var joinObj:* = undefined;
         if(this.checkCard >= 2)
         {
            explain = "    你確定要進入龍之幻境來挑戰怪物嗎？";
            url = "module/gameUI/icon/001.swf";
            joinObj = Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            BC.addEvent(this,joinObj,"CLICK" + 1,this.gotoCardGame);
         }
         else if(this.checkCard == 1)
         {
            this.tipsNoCard();
         }
         else
         {
            this.checkCard = 1;
            BC.addEvent(this,GV.onlineSocket,"read_1223",this.onQueryNewCardBook);
            queryTrainResult.queryNewCardBook();
         }
      }
      
      private function onQueryNewCardBook(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1223",this.onQueryNewCardBook);
         if(evt.EventObj.ret != 0)
         {
            if(evt.EventObj.ret == 1)
            {
               this.checkCard = 2;
            }
         }
         this.inGame(null);
      }
      
      private function tipsNoCard() : void
      {
         var msg:String = "    我佩服你敢於挑戰龍之幻境的勇氣，不過你的準備還不夠充分哦，來森林訓練場找我土林長老吧，我會送你一本珍貴的卡牌冊幫助你戰勝怪物。";
         var url:String = "resource/allJob/AlertPic/tulin.swf";
         var alert:* = Alert.showAlert(MainManager.getTopLevel(),url,msg,Alert.CHANG_ALERT,"go,notgo",true,false,"SMCUI");
         BC.addEvent(this,alert,Alert.CLICK_ + "1",this.gotoMapEvent,false,0,true);
      }
      
      private function gotoMapEvent(e:*) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(152,true);
      }
      
      private function lookHandler(e:* = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"playOven_toMap",this.gotoMapFun);
         controlLevel.tree_mc.mc.gotoAndPlay(3);
         controlLevel.tree_mc.mc.mc.addChild(this.copyBmp(GV.MAN_PEOPLE as PeopleManageView,true));
         GV.MAN_PEOPLE.visible = false;
      }
      
      private function copyBmp(mc:DisplayObjectContainer, repairRegistPoint:Boolean = false) : Sprite
      {
         var FairyBMP:Bitmap = null;
         var rect:Rectangle = mc.getRect(mc.parent);
         var offsetx:int = mc.x - rect.x;
         var offsety:int = mc.y - rect.y;
         var matrix:Matrix = new Matrix(1,0,0,1,offsetx,offsety);
         var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
         bmd.draw(mc,matrix);
         FairyBMP = new Bitmap(bmd);
         if(repairRegistPoint)
         {
            FairyBMP.x = offsetx * -1;
            FairyBMP.y = offsety * -1;
         }
         var sd:Sprite = new Sprite();
         sd.addChild(FairyBMP);
         return sd;
      }
      
      private function vector2Bitmap(mc:PeopleManageView) : Bitmap
      {
         var rect:Rectangle = mc.getRect(mc.parent);
         var matrix:Matrix = new Matrix(1,0,0,1,int(mc.x - rect.x),int(mc.y - rect.y));
         var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
         bmd.draw(mc,matrix);
         return new Bitmap(bmd);
      }
      
      private function gotoMapFun(evt:* = null) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(152,true);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

