package com.view.mapView
{
   import com.common.Alert.*;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.PetClassLogic.PetClassLogic;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.footBall.*;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.module.deal.Deal;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class footballCloneView extends MapBase
   {
      
      public var top_mc:MovieClip;
      
      public var mouseArr:Array;
      
      public var buyItemReq:BuyItemReq;
      
      public var getItemCountReq:GetItemCountReq;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var joinAlert:*;
      
      public var quitAlert:*;
      
      public var shoeAlert:*;
      
      public var gameStart:Boolean = false;
      
      public var gaming:Boolean = false;
      
      public var getInfoReq:getBallInfoReq;
      
      public var goreq:goReq;
      
      public var BallInfo:Object;
      
      public var initBallInfo:Object;
      
      public var tempBallInfo:Object;
      
      public var ctrlBall:Boolean;
      
      public var ballMoveAngle:int;
      
      public var movingTime:*;
      
      public var startTime:*;
      
      public var endTime:*;
      
      private var Bool:Boolean = false;
      
      public var speed:Number = 6;
      
      public var res:Number = 1.8;
      
      public var preX:Number;
      
      public var preY:Number;
      
      public var moveX:Number;
      
      public var moveY:Number;
      
      public var ballClass:*;
      
      public var ballNum:Number = 0;
      
      public var minuteTimer:*;
      
      public var remainTimer:*;
      
      public var distance:Number;
      
      public var t:Number;
      
      public var s:Number;
      
      public var a:Number = 80;
      
      public var oldtime:*;
      
      public var ballMoveDate:*;
      
      public var node:*;
      
      public var ballArr:Array = new Array();
      
      public var gameTotalTime:Number = 600;
      
      public var moleaction:moleActionReq = new moleActionReq();
      
      public var playerCount:*;
      
      public var helpMC:*;
      
      public var btn_mc:*;
      
      public var getshoeBool:Boolean;
      
      public var gtcTimer:Timer;
      
      public var totalNumAA:int;
      
      public var ClassNum:int;
      
      public var quanjiNum:int;
      
      public function footballCloneView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.btn_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.target_mc.tipsBtn_new,MouseEvent.CLICK,this.leafageHandler);
         GV.onlineSocket.addEventListener(petClothRes.PET_GET_ITEM_SUCC,this.giveMeMoneyHandler);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MAN_PEOPLE.PetID,1200021,1200022,2);
         BC.addEvent(this,LamuMantra,LamuMantra.BIBOBIBO,this.getinitHandler);
         BC.addEvent(this,LamuMantra,LamuMantra.BIBOBIBO_OVER,this.getinitOvenHandler);
         this.initMagic();
         for(var j:int = 1; j < 5; j++)
         {
            this.target_mc["btn_10" + j].buttonMode = true;
            BC.addEvent(this,this.target_mc["btn_10" + j],MouseEvent.CLICK,this.btn_0EventHandler);
         }
      }
      
      private function btn_0EventHandler(event:MouseEvent) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlt:* = undefined;
         this.quanjiNum = int(String(event.currentTarget.name).slice(4));
         if((this.depth_mc["_test_mc" + this.quanjiNum] as MovieClip).currentFrame == 1)
         {
            this.depth_mc["_test_mc" + this.quanjiNum].gotoAndPlay(2);
         }
         if(PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.numChildren == 0)
         {
            url = "resource/allJob/AlertPic/petMagicClass/" + this.quanjiNum + ".swf";
            msg = "    嗯？你沒帶著你的拉姆嗎？當他完成了魔法課程第二課後就來找我吧，我有特別的東西給你哦。";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         }
         else
         {
            this.initGamicTestOne();
         }
      }
      
      private function initGamicTestOne() : void
      {
         var msg:String = null;
         var url:String = null;
         var myAlt:* = undefined;
         var i:int = 0;
         var obj:Object = null;
         var pet_arr:Array = GV.MyInfo_PetObj.Job as Array;
         if(!(Boolean(pet_arr) && pet_arr[0] == "null"))
         {
            for(i = 0; i < pet_arr.length; i++)
            {
               if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105 && pet_arr[i].classStep == 5)
               {
                  obj = pet_arr[i];
                  this.ClassNum = obj.ClassID;
               }
            }
         }
         if(this.quanjiNum == this.ClassNum)
         {
            url = "resource/allJob/AlertPic/petMagicClass/" + this.ClassNum + ".swf";
            msg = "    你用努力證明了你的決心。這支魔法棒是屬於你的！輸入魔咒“bibobibo變變變”就能發動魔法，試著讓拉姆草堆開滿鮮花吧。成功變化5次後就融會貫通了。";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
            BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.tipAddGame);
         }
         else
         {
            url = "resource/allJob/AlertPic/petMagicClass/" + this.quanjiNum + ".swf";
            msg = "    你的拉姆完成了第二階段的魔法課程記得來找我，拿著我給你的魔法棒就能在練習場練習魔法啦。";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         }
      }
      
      private function tipAddGame(eve:Event) : void
      {
         Deal.BuyItem(1200021,1,function(ItemnID:uint):*
         {
            Alert.getIconByID_Alart(ItemnID,"恭喜你！你得到了 " + GoodsInfo.getItemNameByID(ItemnID) + "，已經放入你的拉姆背包，趕快看看去吧!",function(E:*):void
            {
            });
         });
      }
      
      private function giveMeMoneyHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.Count != 0)
         {
            XMLInfo.DemandLamuArray[2] = 0;
         }
      }
      
      private function getinitOvenHandler(event:EventTaomee) : void
      {
         Mouse.show();
         this.top_mc.blackart_mc.x = 1500;
         GC.clearGInterval(this.gtcTimer);
         for(var i:int = 0; i < 4; i++)
         {
            this.target_mc["task_btn" + i].mouseEnabled = false;
            this.target_mc["task_btn" + i].mouseChildren = false;
         }
      }
      
      private function getinitHandler(event:EventTaomee) : void
      {
         var i:int = 0;
         if(event.EventObj == "bibobibo")
         {
            for(i = 0; i < 4; i++)
            {
               this.target_mc["task_btn" + i].mouseEnabled = true;
               this.target_mc["task_btn" + i].mouseChildren = true;
            }
            this.initMouseMove();
         }
      }
      
      private function initMouseMove() : void
      {
         Mouse.hide();
         GC.clearGInterval(this.gtcTimer);
         this.gtcTimer = GC.setGInterval(this.onGtcTimer,100);
         this.top_mc.blackart_mc.mouseEnabled = false;
         this.top_mc.blackart_mc.mouseChildren = false;
         this.top_mc.mouseEnabled = false;
      }
      
      private function onGtcTimer() : void
      {
         this.top_mc.blackart_mc.x = MainManager.getStage().stage.mouseX;
         this.top_mc.blackart_mc.y = MainManager.getStage().stage.mouseY;
      }
      
      private function initMagic() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            BC.addEvent(this,this.target_mc["task_btn" + i],MouseEvent.CLICK,this.taskHandler);
         }
      }
      
      private function taskHandler(event:MouseEvent) : void
      {
         var quanjiNum:int = int(String(event.currentTarget.name).slice(8));
         var num:Number = Math.random();
         if(this.depth_mc["task_mc" + quanjiNum].currentFrame < 2)
         {
            switch(quanjiNum)
            {
               case 0:
                  if(num < 0.8)
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(2);
                     setTimeout(this.initGameSucced,500);
                  }
                  else
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(47);
                  }
                  break;
               case 1:
                  if(num < 0.5)
                  {
                     setTimeout(this.initGameSucced,500);
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(2);
                  }
                  else if(num >= 0.5 && num < 0.8)
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(29);
                     setTimeout(this.initGameSucced,500);
                  }
                  else
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(58);
                  }
                  break;
               case 2:
                  if(num < 0.8)
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(49);
                     setTimeout(this.initGameSucced,500);
                  }
                  else
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(2);
                  }
                  break;
               case 3:
                  if(num < 0.8)
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(2);
                     setTimeout(this.initGameSucced,2000);
                  }
                  else
                  {
                     this.depth_mc["task_mc" + quanjiNum].gotoAndPlay(115);
                  }
            }
         }
      }
      
      private function initGameSucced() : void
      {
         ++this.totalNumAA;
         this.depth_mc.task_Game_mc.play();
         setTimeout(this.setPetJob,2000);
      }
      
      private function setPetJob() : void
      {
         var pet_arr:Array = null;
         var i:int = 0;
         var obj:Object = null;
         if(this.depth_mc.task_Game_mc.currentFrame > 74)
         {
            pet_arr = GV.MyInfo_PetObj.Job as Array;
            if(!(Boolean(pet_arr) && pet_arr[0] == "null"))
            {
               for(i = 0; i < pet_arr.length; i++)
               {
                  if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105 && pet_arr[i].classStep == 5)
                  {
                     obj = pet_arr[i];
                     this.Bool = true;
                     BC.addEvent(this,PetClassLogic.getPetClassLogics(),"get_class_data",this.get_class_data);
                     PetClassLogic.getPetClassLogics().getClassData(PeopleManageView(GV.MAN_PEOPLE).PetID,obj.ClassID);
                  }
               }
            }
         }
         else if(this.totalNumAA == 4)
         {
            if(this.depth_mc.task_Game_mc.currentFrame > 20)
            {
               this.depth_mc.task_Game_mc.gotoAndPlay(75);
               pet_arr = GV.MyInfo_PetObj.Job as Array;
               if(!(Boolean(pet_arr) && pet_arr[0] == "null"))
               {
                  for(i = 0; i < pet_arr.length; i++)
                  {
                     if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105 && pet_arr[i].Status == 1)
                     {
                        obj = pet_arr[i];
                        this.Bool = true;
                        BC.addEvent(this,PetClassLogic.getPetClassLogics(),"get_class_data",this.get_class_data);
                        PetClassLogic.getPetClassLogics().getClassData(PeopleManageView(GV.MAN_PEOPLE).PetID,obj.ClassID);
                        break;
                     }
                  }
               }
            }
         }
      }
      
      private function get_class_data(event:EventTaomee) : void
      {
         var pet_arr:Array = null;
         var i:int = 0;
         var objArr:Object = null;
         if(!this.Bool)
         {
            return;
         }
         this.Bool = false;
         Alert.showAlert(GV.MC_AppLever,"    恭喜你完成一次魔法練習！","",6,"E");
         var b:Boolean = true;
         var obj:Object = event.EventObj.obj;
         if(obj.arr[0] == 0)
         {
            obj.arr[0] = 1;
         }
         else if(obj.arr[1] == 0)
         {
            obj.arr[1] = 1;
         }
         else if(obj.arr[2] == 0)
         {
            obj.arr[2] = 1;
         }
         else if(obj.arr[3] == 0)
         {
            obj.arr[3] = 1;
         }
         else if(obj.arr[4] == 0)
         {
            obj.arr[4] = 1;
         }
         else
         {
            b = false;
         }
         if(b)
         {
            pet_arr = GV.MyInfo_PetObj.Job as Array;
            if(!(Boolean(pet_arr) && pet_arr[0] == "null"))
            {
               for(i = 0; i < pet_arr.length; i++)
               {
                  if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105 && pet_arr[i].classStep == 5)
                  {
                     objArr = pet_arr[i];
                     PetClassLogic.getPetClassLogics().setClassData(PeopleManageView(GV.MAN_PEOPLE).PetID,objArr.ClassID,obj.arr);
                  }
               }
            }
         }
      }
      
      private function leafageHandler(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("TEST_MC");
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         GC.clearGInterval(this.gtcTimer);
         XMLInfo.DemandLamuArray[2] = -1;
         this.target_mc = null;
         this.depth_mc = null;
         this.btn_mc = null;
         this.top_mc = null;
         super.destroy();
      }
   }
}

