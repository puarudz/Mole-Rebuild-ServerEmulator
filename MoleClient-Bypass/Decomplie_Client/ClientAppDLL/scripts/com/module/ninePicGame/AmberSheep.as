package com.module.ninePicGame
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.module.deal.SwapItem;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AmberSheep
   {
      
      private static var instance:AmberSheep = null;
      
      private var control_mc:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var getcuguoBool:Boolean;
      
      public function AmberSheep()
      {
         super();
      }
      
      public static function getInstance() : AmberSheep
      {
         return instance = instance || new AmberSheep();
      }
      
      public function removeEventHandler(e:*) : void
      {
         this.getcuguoBool = false;
         BC.removeEvent(this);
      }
      
      public function init(controlmc:MovieClip, topmc:MovieClip) : void
      {
         BC.addEvent(this,LamuMantra,LamuMantra.BIBOBIBO,this.useMagic);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.control_mc = controlmc;
         this.top_mc = topmc;
         this.control_mc.cuguo.visible = false;
         BC.addEvent(this,this.top_mc.sheep_tip.close_btn,MouseEvent.CLICK,this.closeTip);
         BC.addEvent(this,this.control_mc.sheep_btn,MouseEvent.CLICK,this.clickTip);
         if(GF.getLocalGameHighScore("sheep" + LocalUserInfo.getUserID()) == 1)
         {
            this.control_mc.sheep_mc.stone.gotoAndStop(50);
         }
         BC.addEvent(this,this.control_mc.cuguo,MouseEvent.CLICK,this.getcuguo);
         if(GV.MAN_PEOPLE.Petlevel > 100)
         {
            this.control_mc.sheep_mc.stone.visible = true;
            this.control_mc.sheep_mc.stone.buttonMode = true;
            BC.addEvent(this,this.control_mc.sheep_mc.stone,MouseEvent.CLICK,this.clickStone);
         }
         else
         {
            this.control_mc.sheep_mc.stone.visible = false;
         }
      }
      
      public function useMagic(e:*) : void
      {
         if(!this.getcuguoBool && GV.MyInfo_PetObj.Level > 100)
         {
            this.control_mc.stone1.gotoAndPlay(2);
            this.control_mc.cuguo.visible = true;
         }
      }
      
      public function closeTip(e:MouseEvent) : void
      {
         this.top_mc.sheep_tip.y = -1000;
      }
      
      public function clickTip(e:MouseEvent) : void
      {
         this.top_mc.sheep_tip.x = 280;
         this.top_mc.sheep_tip.y = 20;
      }
      
      public function getcuguo(e:MouseEvent) : void
      {
         Deal.BuyItem(190413,1,function(e:*):void
         {
            Alert.getIconByID_Alart(190413,"　　醋果已放入百寶箱中，趕快用它到魔法閣樓熬制醋果自由湯吧！");
            control_mc.cuguo.visible = false;
            getcuguoBool = true;
         });
      }
      
      private function showsheep() : void
      {
         Deal.DelItem([new SwapItem(190414,1)]);
         this.control_mc.sheep_mc.stone.gotoAndPlay(2);
      }
      
      private function getsheep() : void
      {
         GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getsheepSucc);
         PresentGoodsReq.req(20);
      }
      
      private function getsheepSucc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getsheepSucc);
         if(evt.EventObj.ItemID == 1270006)
         {
            if(evt.EventObj.Flag == 1)
            {
               Alert.smileAlart("　　感謝你的拉姆用魔法力量，解救了公綿羊動物寶寶，它已經住進你的牧場倉庫中了！");
               this.playsheepanm();
            }
            else
            {
               Alert.smileAlart("　　今天已經有2隻小羊跟你回家了，你明天再來領它們吧！");
            }
         }
         else if(evt.EventObj.ItemID == 1270007)
         {
            if(evt.EventObj.Flag == 1)
            {
               this.playsheepanm();
               Alert.smileAlart("　　感謝你的拉姆用魔法力量，解救了母綿羊動物寶寶，它已經住進你的牧場倉庫中了！");
            }
            else
            {
               Alert.smileAlart("　　今天已經有2隻小羊跟你回家了，你明天再來領它們吧！");
            }
         }
         else if(evt.EventObj.ItemID == 0)
         {
            Alert.smileAlart("　　今天已經有2隻小羊跟你回家了，你明天再來領它們吧！");
         }
      }
      
      private function playsheepanm() : void
      {
         GF.updateLocalGameHighScore("sheep" + LocalUserInfo.getUserID(),1);
         this.loadLongLostMovie();
      }
      
      public function loadLongLostMovie() : void
      {
         var callBoardMC:MovieClip = new MovieClip();
         callBoardMC.name = "sheephome";
         MainManager.getGameLevel().addChild(callBoardMC);
         var tempMC:MCLoader = new MCLoader("resource/movie/sheepbackhome.swf",callBoardMC,1,"正在打開動畫");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(evt:MCLoadEvent) : void
      {
         var childMC:* = undefined;
         var gotoend:Function = null;
         gotoend = function(evt:Event):void
         {
            if(evt.target.currentFrame == evt.target.totalFrames)
            {
               childMC.content.root.removeEventListener(Event.ENTER_FRAME,gotoend);
               childMC.parent.removeChild(childMC);
            }
         };
         var mainMC:DisplayObjectContainer = evt.getParent();
         childMC = evt.getLoader();
         mainMC.addChild(childMC);
         childMC.content.root.gotoAndPlay(2);
         childMC.content.root.addEventListener(Event.ENTER_FRAME,gotoend);
      }
      
      private function havecao(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.havecao);
         if(evt.EventObj.count == 1)
         {
            this.getsheep();
         }
         else
         {
            Alert.getIconByID_Alart(190351,"　　小綿羊最喜歡吃螢火草啦，趕快到漿果叢林割一些吧！");
         }
      }
      
      private function havetang(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.havetang);
         if(GV.MyInfo_PetObj.Level > 100)
         {
            if(evt.EventObj.count == 1)
            {
               this.showsheep();
               return;
            }
            Alert.imagesBigAlert("　　這是綿羊琥珀石，在琥珀中困著一隻可愛的小綿羊。只要超級拉姆念魔法咒語就可以找到解救它的果實——酸酸的醋果。\n　　將醋果放到魔法閣樓的湯鍋中熬制出“醋果自由湯”，就可以幫助小綿羊恢復自由哦！","resource/allJob/AlertPic/map83/sheepNeedHelp.swf");
            if(!this.getcuguoBool)
            {
               this.control_mc.cuguo.visible = true;
            }
         }
         else
         {
            Alert.smileAlart("　　帶著超級拉姆一起來，讓它幫你發現琥珀石的奇妙吧！");
         }
      }
      
      public function clickStone(e:MouseEvent) : void
      {
         if(e.currentTarget.currentFrame == 50)
         {
            checkItem.checkItemHandler(190351);
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.havecao);
            return;
         }
         checkItem.checkItemHandler(190414);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.havetang);
      }
   }
}

