package com.module.lamuPkSys.eggRainSkillInMap
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.lamuPkSys.AnimalSkillSocket;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class inMapEgg
   {
      
      public var eggInfo:Object;
      
      private const eggPath:String = "resource/lamuPKSys/eggInMap/";
      
      private var eggLoader:Loader;
      
      public function inMapEgg(einfo:Object)
      {
         super();
         this.eggInfo = einfo;
      }
      
      public function loadEggInMap(eggBoxmc:MovieClip) : void
      {
         var path:String = this.eggPath + this.eggInfo.itemid + ".swf";
         this.eggLoader = new Loader();
         this.eggLoader.unload();
         this.eggLoader.load(VL.getURLRequest(path));
         this.eggLoader.x = this.eggInfo.x;
         this.eggLoader.y = this.eggInfo.y;
         this.eggLoader.addEventListener(MouseEvent.CLICK,this.onEggLoaderHandler);
         this.eggLoader.addEventListener(MouseEvent.MOUSE_OVER,this.onEggLoaderHandler);
         this.eggLoader.addEventListener(MouseEvent.MOUSE_OUT,this.onEggLoaderHandler);
         eggBoxmc.addChild(this.eggLoader);
      }
      
      private function onEggLoaderHandler(evt:MouseEvent) : void
      {
         var eggItemId:int = 0;
         var tipsS:String = null;
         if(evt.type == MouseEvent.CLICK)
         {
            eggItemId = int(evt.currentTarget.content.itemId);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100216",this.onGetEggErr);
            BC.addEvent(this,GV.onlineSocket,"read_1409",this.onGetEgg);
            AnimalSkillSocket.GetEgg(LocalUserInfo.getMapID(),this.eggInfo.posid);
         }
         else if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = GoodsInfo.getItemNameByID(this.eggInfo.itemid);
            tip.tipTailDisPlayObject(evt.currentTarget,tipsS);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
         }
      }
      
      private function onGetEggErr(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1409",this.onGetEgg);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100216",this.onGetEggErr);
         GC.clearAll(this.eggLoader);
      }
      
      private function onGetEgg(evt:EventTaomee) : void
      {
         if(evt.EventObj.itemid == this.eggInfo.itemid)
         {
            BC.removeEvent(this,GV.onlineSocket,"read_1409",this.onGetEgg);
            BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100216",this.onGetEggErr);
            GC.clearAll(this.eggLoader);
            Alert.smileAlart("    恭喜你獲得了一個" + GoodsInfo.getItemNameByID(this.eggInfo.itemid) + "，已經放入你的牧場倉庫中。");
         }
      }
   }
}

