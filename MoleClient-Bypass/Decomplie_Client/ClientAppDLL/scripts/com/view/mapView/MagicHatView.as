package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class MagicHatView extends MapBase
   {
      
      public var YinFuArray:Array = [];
      
      public function MagicHatView()
      {
         super();
         BC.addEvent(this,controlLevel.hitMC,"onHit",this.leverMap);
         BC.addEvent(this,GV.onlineClass,"get_yinfu",this.getItems);
         BC.addEvent(this,GV.onlineClass,"newYF_Array",this.newYFArray);
         BC.addEvent(this,GV.onlineClass,"showPop",this.showPop);
         BC.addEvent(this,throwHitTest.throwObj,"hitTest",this.hitTestFun);
         var obj1:Object = {
            "btn":controlLevel.y1_mc,
            "mc":controlLevel.y1_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj2:Object = {
            "btn":controlLevel.y2_mc,
            "mc":controlLevel.y2_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj3:Object = {
            "btn":controlLevel.y3_mc,
            "mc":controlLevel.y3_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj4:Object = {
            "btn":controlLevel.y4_mc,
            "mc":controlLevel.y4_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj5:Object = {
            "btn":controlLevel.y5_mc,
            "mc":controlLevel.y5_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj6:Object = {
            "btn":controlLevel.y6_mc,
            "mc":controlLevel.y6_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         var obj7:Object = {
            "btn":controlLevel.y7_mc,
            "mc":controlLevel.y7_mc,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         throwHitTest.HitTestMC(obj1,obj2,obj3,obj4,obj5,obj6,obj7);
         if(!LocalUserInfo.isVIP())
         {
            controlLevel.noLamu = true;
            depthLevel.noLamu = true;
            controlLevel.l5_mc.visible = false;
         }
      }
      
      override protected function initView() : void
      {
         super.initView();
         depthLevel.mouseChildren = depthLevel.mouseEnabled = false;
      }
      
      private function leverMap(E:*) : void
      {
         GF.switchPrevMap();
      }
      
      private function getItems(E:*) : void
      {
         if(E.EventObj == 1200012)
         {
            this.gethat();
            return;
         }
         if(!LocalUserInfo.isVIP())
         {
            return;
         }
         var itemID:uint = uint(E.EventObj);
         GV.itemID = 0;
         if(itemID == 1220037)
         {
            itemID = 12618;
            GV.itemID = itemID;
            GV.ErrorMSG = "非常抱歉，你已經得到這件寶貝了，所以不能再拿了哦。";
         }
         else if(itemID == 1220031)
         {
            GV.itemID = itemID;
            GV.ErrorMSG = null;
         }
         else if(itemID == 1220030 || itemID == 1220032)
         {
            GV.itemID = itemID;
            GV.ErrorMSG = "非常抱歉，你已經得到這件寶貝了，所以不能再拿了哦。";
         }
         else if(itemID > 1220032)
         {
            GV.itemID = itemID;
            GV.ErrorMSG = "　  非常抱歉，泡泡裡的物品被魔術師變沒有了哦~";
         }
         var getYF:BuyItemReq = new BuyItemReq();
         getYF.buyItems(itemID,1);
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.getYFSure);
      }
      
      private function gethat() : void
      {
         var msg:String = null;
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            this.otherPipEvent();
         }
         else
         {
            msg = "    帶著你的小拉姆，來領取拉姆星形面具吧！快樂要一起分享哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function otherPipEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MyInfo_PetObj.SpriteID,1200012,1200013,2);
      }
      
      private function getPetOtherEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         GV.onlineSocket.removeEventListener(petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         if(evt.EventObj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.getPetItemSUC);
            petClothReq.buyItem(GV.MAN_PEOPLE.PetID,1200012,1);
         }
         else
         {
            msg = "你的拉姆喜歡它的拉姆星形面具嗎？記得經常幫它戴上哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function getPetItemSUC(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petClothRes.PET_BUY_ITEM_SUCC,this.getPetItemSUC);
         var url:String = "resource/petcloth/icon/1200012.swf";
         var msg:String = "    拉姆星形面具已經放入拉姆背包，趕快幫它戴上吧！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
      }
      
      private function newYFArray(E:*) : void
      {
         this.YinFuArray = E.EventObj;
      }
      
      private function getYFSure(E:EventTaomee) : void
      {
         var str:String = null;
         if(GV.itemID == 12618)
         {
            str = "　  恭喜你！一個百變魔幻斗篷已經放入你的背包中了！";
            Alert.showAlert(GV.MC_AppLever,str,"",6,"E");
         }
         else
         {
            str = "　  恭喜你！一個魔幻音符已經放入你的家園倉庫中了！";
            Alert.showAlert(GV.MC_AppLever,str,"",6,"E");
         }
         GV.itemID = 0;
      }
      
      private function showPop(E:EventTaomee) : void
      {
         depthLevel.l5_mc.gotoAndPlay(2);
      }
      
      private function hitTestFun(E:EventTaomee) : void
      {
         var hitMC:MovieClip = null;
         var i:int = 0;
         var y:int = 0;
         var str:String = null;
         var o:Object = E.EventObj;
         var userID:uint = uint(o.userID);
         var ThrowID:uint = uint(o.id);
         var p:Point = o.po;
         if(userID == GV.MyInfo_userID && ThrowID == 150001 && Boolean(this.YinFuArray.length))
         {
            for(i = 1; i <= 7; i++)
            {
               hitMC = controlLevel["y" + i + "_mc"];
               if(hitMC.hitTestPoint(p.x,p.y,true))
               {
                  y = this.YinFuArray.shift();
                  if(y != i)
                  {
                     str = "　  真可惜，你沒有投擲到正確的音符，繼續努力吧！";
                     Alert.showAlert(GV.MC_AppLever,str,"",6,"D");
                     controlLevel.game_mc.start_mc.gotoAndStop(1);
                     controlLevel.game_mc.gotoAndStop(1);
                     this.YinFuArray = [];
                  }
                  else if(!this.YinFuArray.length)
                  {
                     controlLevel.game_mc.nextFrame();
                  }
                  else
                  {
                     controlLevel.game_mc.nextFrame();
                  }
                  break;
               }
            }
         }
      }
   }
}

