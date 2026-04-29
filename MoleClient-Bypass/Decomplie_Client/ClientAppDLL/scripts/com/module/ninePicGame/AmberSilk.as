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
   import com.module.pet.petClassLearnStatus;
   import com.module.pet.petLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AmberSilk
   {
      
      private static var instance:AmberSilk = null;
      
      private var top_mc:MovieClip;
      
      private var control_mc:MovieClip;
      
      private var getcuguoBool:Boolean;
      
      public function AmberSilk()
      {
         super();
      }
      
      public static function getInstance() : AmberSilk
      {
         return instance = instance || new AmberSilk();
      }
      
      public function AmberSheep() : void
      {
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
         this.control_mc.sangguo.visible = false;
         BC.addEvent(this,this.top_mc.silk_tip.close_btn,MouseEvent.CLICK,this.closeTip);
         BC.addEvent(this,this.control_mc.silk_btn,MouseEvent.CLICK,this.clickTip);
         if(GF.getLocalGameHighScore("silk" + LocalUserInfo.getUserID()) == 1)
         {
            this.control_mc.silk_mc.stone.gotoAndStop(50);
         }
         BC.addEvent(this,this.control_mc.sangguo,MouseEvent.CLICK,this.getcuguo);
         if(this.learnedMagic())
         {
            this.control_mc.silk_mc.stone.visible = true;
            this.control_mc.silk_mc.stone.buttonMode = true;
            BC.addEvent(this,this.control_mc.silk_mc.stone,MouseEvent.CLICK,this.clickStone);
         }
         else
         {
            this.control_mc.silk_mc.stone.visible = false;
         }
      }
      
      public function learnedMagic() : Boolean
      {
         var m:petClassLearnStatus = petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView);
         return m.hasFinish;
      }
      
      public function clickStone(e:MouseEvent) : void
      {
         if(e.currentTarget.currentFrame == 50)
         {
            checkItem.checkItemHandler(190412);
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.havecao);
            return;
         }
         checkItem.checkItemHandler(190411);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.havetang);
      }
      
      public function useMagic(e:*) : void
      {
         if(!this.getcuguoBool)
         {
            this.control_mc.stone2.gotoAndPlay(2);
            this.control_mc.sangguo.visible = true;
         }
      }
      
      public function closeTip(e:MouseEvent) : void
      {
         this.top_mc.silk_tip.y = -1000;
      }
      
      public function clickTip(e:MouseEvent) : void
      {
         this.top_mc.silk_tip.x = 280;
         this.top_mc.silk_tip.y = 20;
      }
      
      public function getcuguo(e:MouseEvent) : void
      {
         Deal.BuyItem(190410,1,function(e:*):void
         {
            Alert.getIconByID_Alart(190410,"　　桑果已放入百寶箱中，趕快用它到魔法閣樓熬制桑果自由湯吧！");
            control_mc.sangguo.visible = false;
            getcuguoBool = true;
         });
      }
      
      private function showsheep() : void
      {
         Deal.DelItem([new SwapItem(190411,1)]);
         this.control_mc.silk_mc.stone.gotoAndPlay(2);
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
            Alert.getIconByID_Alart(190412,"　　蠶寶寶最喜歡吃桑葉啦，趕快到漿果叢林摘一些吧！");
         }
      }
      
      private function playsheepanm() : void
      {
         GF.updateLocalGameHighScore("silk" + LocalUserInfo.getUserID(),1);
         this.loadLongLostMovie();
      }
      
      private function loadLongLostMovie() : void
      {
         var callBoardMC:MovieClip = new MovieClip();
         callBoardMC.name = "sheephome";
         MainManager.getGameLevel().addChild(callBoardMC);
         var tempMC:MCLoader = new MCLoader("resource/movie/silkbackhome.swf",callBoardMC,1,"正在打開動畫");
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
      
      private function getsheep() : void
      {
         GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getsheepSucc);
         PresentGoodsReq.req(21);
      }
      
      private function getsheepSucc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getsheepSucc);
         if(evt.EventObj.ItemID == 1270008)
         {
            if(evt.EventObj.Flag == 1)
            {
               Alert.smileAlart("　　感謝你的拉姆用魔法力量，解救了蠶寶寶動物寶寶，它已經住進你的牧場倉庫中了！");
               this.playsheepanm();
            }
            else
            {
               Alert.smileAlart("　　今天已經有3隻蠶寶寶跟你回家了，你明天再來領它們吧！");
            }
         }
         else if(evt.EventObj.ItemID == 0)
         {
            Alert.smileAlart("　　沒得到蠶");
         }
      }
      
      private function havetang(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.havetang);
         if(evt.EventObj.count == 1)
         {
            this.showsheep();
         }
         else
         {
            Alert.imagesBigAlert("　　這是桑蠶琥珀石，在琥珀中困著一隻可愛的蠶寶寶。只要超級拉姆或學過魔法的拉姆念魔法咒語就可以找到解救它的果實——苦苦的桑果。\n　　將桑果放到魔法閣樓的湯鍋中熬制出“桑果自由湯”，就可以幫助蠶寶寶恢復自由哦！","resource/allJob/AlertPic/map83/silkwormNeedHelp.swf");
            if(!this.getcuguoBool)
            {
               this.control_mc.sangguo.visible = true;
            }
         }
      }
   }
}

