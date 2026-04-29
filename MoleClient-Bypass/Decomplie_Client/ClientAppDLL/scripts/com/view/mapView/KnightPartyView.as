package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.customAlert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.soundControl.soundControl;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.StageActionLogic.StageActionLogic;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class KnightPartyView extends BasicMapView
   {
      
      private var plum_blossom_mc:MovieClip;
      
      private var mask_mc:MovieClip;
      
      private var saveTime:uint;
      
      private var saveFrame:uint = 84;
      
      private var plum_blossom_Index:int;
      
      private var start_Index:int;
      
      private var gameTimer:Timer;
      
      private var pan1:customAlert;
      
      private var pan2:customAlert;
      
      private var startPoint:Point;
      
      private var myArray:Array;
      
      private var myArray2:Array;
      
      private var difficulty:int = 5;
      
      private var moveAction:moleActionReq;
      
      private var lamuClass:Class;
      
      private var goodLuck:Boolean = false;
      
      public function KnightPartyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var i:int;
         var p:MovieClip = null;
         target_mc.soldie_1.buttonMode = true;
         this.plum_blossom_mc = target_mc["plum_blossom_mc"];
         this.mask_mc = target_mc.mask_mc;
         this.plum_blossom_Index = this.plum_blossom_mc.getChildIndex(this.plum_blossom_mc.end_mc);
         this.start_Index = this.plum_blossom_mc.getChildIndex(this.plum_blossom_mc.start_mc);
         this.moveAction = new moleActionReq();
         this.lamuClass = GV.Lib_Map.getClass("fly_lamu");
         this.startPoint = new Point(this.plum_blossom_mc.start_mc.x,this.plum_blossom_mc.start_mc.y);
         this.myArray = [];
         for(i = 0; i < this.plum_blossom_mc.numChildren; i++)
         {
            p = this.plum_blossom_mc.getChildAt(i) as MovieClip;
            p.buttonMode = true;
            BC.addEvent(this,p,MouseEvent.MOUSE_OVER,this.MOver);
            BC.addEvent(this,p,MouseEvent.MOUSE_DOWN,this.MDown);
            BC.addEvent(this,p,MouseEvent.MOUSE_OUT,this.MOut);
            BC.addEvent(this,p,MouseEvent.MOUSE_UP,this.Mup);
         }
         BC.removeEvent(this,this.plum_blossom_mc.start_mc);
         this.plum_blossom_mc.start_mc.buttonMode = false;
         this.plum_blossom_mc.mouseChildren = false;
         BC.addEvent(this,StageActionLogic,"p_b",this.rise);
         BC.addEvent(this,StageActionLogic,"p_t",this.thFun);
         BC.addEvent(this,target_mc.cb_mc,"onHit",function():void
         {
            moveAction.sendAction(1,128,340);
            GV.onlineClass.chating(0,"/tag:p_t:0");
         });
         BC.addEvent(this,GV.onlineSocket,"fireAction_suc",function():void
         {
            startGame();
         });
         BC.addEvent(this,this.mask_mc,MouseEvent.CLICK,this.closeGame);
         BC.addEvent(this,top_mc.h2_mc.start_mc,MouseEvent.CLICK,this.addZhuZiGame);
         BC.addEvent(this,target_mc.hitMC2,"onHit",this.leverMap);
      }
      
      private function leverMap(E:*) : void
      {
         GF.switchPrevMap();
      }
      
      private function thFun(E:EventTaomee) : void
      {
         this.th1Fun(E.EventObj.p);
      }
      
      private function th1Fun(p:*) : void
      {
         target_mc.comeBack_mc.mc = p;
         target_mc.comeBack_mc.gotoAndPlay(2);
         target_mc.th_mc.play();
      }
      
      private function loadBankEvent(evt:MouseEvent) : void
      {
         var owner:* = undefined;
         var f1:Function = null;
         if(Boolean(this.pan2) || Boolean(target_mc.door_mc.mc) && Boolean(target_mc.door_mc.mc.currentFrame != 1))
         {
            return;
         }
         this.pan2 = new customAlert(MainManager.getGameLevel(),"main_mc,正在打開石頭剪刀布...","module/game/SevenGame9.swf",1);
         owner = this;
         f1 = function(E:*):void
         {
            BC.removeEvent(owner,E.currentTarget,null,f1);
            BC.addEvent(owner,pan2.getTargetMC(),"win",function(E:*):void
            {
               target_mc.door_mc.mc.play();
               GC.setGTimeout(getRandomProp2,800);
               BC.addEvent(owner,target_mc.soldie_1,MouseEvent.CLICK,loadBankEvent);
               GC.clearAll(pan2.getTargetMC());
               pan2 = null;
            });
            BC.addEvent(owner,pan2.getTargetMC(),"fail",function(E:*):void
            {
               GC.clearAll(pan2.getTargetMC());
               pan2 = null;
            });
            pan2.getTargetMC().x = pan2.getTargetMC().y = 0;
         };
         BC.addEvent(owner,this.pan2,Alert.ON_CUSTOM_LOADED,f1);
         this.pan2.load();
      }
      
      private function getRandomProp2() : void
      {
         PresentGoodsReq.req(3);
         BC.addEvent(this,GV.onlineSocket,PresentGoodsRes.PRESENT_GOODS_SUCC,this.getRandomProp);
      }
      
      private function getRandomProp(E:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var obj:Object = E.EventObj;
         if(obj.Flag == 1)
         {
            url = GoodsInfo.getItemPathByID(obj.ItemID) + obj.ItemID + ".swf";
            msg = "　  恭喜你，" + obj.count + "個" + GoodsInfo.getInfoById(obj.ItemID).name + "已經放入你的牧場倉庫中了！";
            if(obj.ItemID == 180046)
            {
               msg = "　  恭喜你，" + obj.count + "份" + GoodsInfo.getInfoById(obj.ItemID).name + "已經放入你的拉姆背包中了！";
            }
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         }
      }
      
      public function closeGame(E:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var i:int = 0;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(!target_mc || !p || !target_mc.hitMC || !target_mc.hitMC.hitTestPoint(p.x,p.y,true))
         {
            return;
         }
         if(this.mask_mc.currentFrame == 2)
         {
            GC.clearGInterval(this.gameTimer);
            p.changeLayer(MapModelLogic.FLOOR_LAYER);
            this.mask_mc.gotoAndStop(1);
            MoveTo.AutoFind(E.stageX,E.stageY,p);
            target_mc.join_btn.mouseEnabled = true;
            this.plum_blossom_mc.start_mc.buttonMode = false;
            this.plum_blossom_mc.mouseChildren = false;
            MoveTo.CanMove = true;
            for(i = 0; i < this.plum_blossom_mc.numChildren; i++)
            {
               mc = this.plum_blossom_mc.getChildAt(i) as MovieClip;
               mc.enabled = true;
               mc.filters = [];
               mc.gotoAndStop(1);
            }
         }
      }
      
      public function startGame() : void
      {
         var tempArray:Array = null;
         var index:int = 0;
         var i:int = 0;
         var j:int = 0;
         var p:MovieClip = null;
         if(!target_mc.join_btn)
         {
            return;
         }
         target_mc.join_btn.mouseEnabled = false;
         this.mask_mc.gotoAndStop(2);
         this.goodLuck = false;
         this.myArray2 = [];
         tempArray = [];
         for(i = 1; i < this.difficulty; i++)
         {
            index = this.getDepthNum(tempArray);
            tempArray.push(index);
         }
         tempArray.push(this.plum_blossom_Index);
         this.myArray = tempArray;
         j = 0;
         GC.clearGInterval(this.gameTimer);
         this.gameTimer = GC.setGInterval(function():void
         {
            var tp:* = undefined;
            var mySoundLib:* = undefined;
            if(!target_mc)
            {
               return;
            }
            for(i = 0; i < plum_blossom_mc.numChildren; ++i)
            {
               p = plum_blossom_mc.getChildAt(i) as MovieClip;
               p.enabled = true;
               p.filters = [];
            }
            if(j < tempArray.length)
            {
               tp = plum_blossom_mc.getChildAt(tempArray[j]) as MovieClip;
               tp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
               GV.soundCon.getSound("S_hitWoodBlock",0,1);
            }
            else
            {
               mySoundLib = GV.soundCon as soundControl;
               mySoundLib.stopSound("S_drum");
               MoveTo.CanMove = false;
               plum_blossom_mc.mouseChildren = true;
            }
            ++j;
         },"800:" + (tempArray.length + 1));
      }
      
      public function getDepthNum(tempArray:Array) : int
      {
         var index:int = int(Math.random() * this.plum_blossom_mc.numChildren);
         if(index == this.plum_blossom_Index || index == this.start_Index || tempArray.indexOf(index) > -1)
         {
            return this.getDepthNum(tempArray);
         }
         return index;
      }
      
      public function rise(E:EventTaomee) : void
      {
         var RiseArray:Array = String(E.EventObj.d).split(",");
         var EI:int = int(RiseArray.shift());
         var type:int = int(RiseArray.shift());
         RiseArray.unshift(this.start_Index);
         var p:PeopleManageView = E.EventObj.p;
         if(!target_mc || !p || !target_mc.hitMC || !target_mc.hitMC.hitTestPoint(p.x,p.y,true))
         {
            return;
         }
         var tempLamu:MovieClip = new this.lamuClass();
         tempLamu.x = 988;
         tempLamu.y = -50;
         tempLamu.gotoAndStop(2);
         tempLamu.action_mc.gotoAndStop(2);
         GV.MC_mapFrame.addChild(tempLamu);
         GC.setGTimeout(this.risePeo,1500,p,RiseArray,RiseArray[0],0,tempLamu,EI,type);
      }
      
      public function risePeo(p:PeopleManageView, RiseArray:Array, id:int, index:int, tempLamu:MovieClip, ei:int, type:int) : void
      {
         var m1:MovieClip = null;
         var tc:Class = null;
         var tm:MovieClip = null;
         var gp:Point = null;
         var m2:MovieClip = null;
         var p1:Point = null;
         var p2:Point = null;
         var dir:int = 0;
         var delay:Number = NaN;
         var depth:int = 0;
         if(!target_mc)
         {
            return;
         }
         p.avatarClass.dispatchEvent(new Event(PeopleManageView.ON_GO_START));
         tempLamu.x = 5;
         tempLamu.y = -45;
         p.avatarMC.addChild(tempLamu);
         p.changeLayer(this.plum_blossom_mc);
         m1 = this.plum_blossom_mc.getChildAt(id) as MovieClip;
         this.plum_blossom_mc.setChildIndex(p,this.plum_blossom_mc.numChildren - 1);
         if(index == ei && id == this.plum_blossom_Index)
         {
            if(p.id == GV.MyInfo_userID)
            {
               MoveTo.CanMove = true;
               if(this.goodLuck)
               {
                  this.getRandomProp2();
                  this.goodLuck = false;
               }
               BC.addEvent(this,target_mc.soldie_1,MouseEvent.CLICK,this.loadBankEvent);
            }
            GC.setGTimeout(function():void
            {
               GC.clearAll(tempLamu);
               if(!target_mc)
               {
                  return;
               }
               p.x = 741;
               p.y = 239;
               p.alpha = 1;
               p.changeLayer(MapModelLogic.FLOOR_LAYER);
               if(p.id == GV.MyInfo_userID)
               {
                  moveAction.sendAction(1,p.x,p.y);
                  mask_mc.gotoAndStop(1);
               }
            },200);
         }
         else if(index + 1 == RiseArray.length)
         {
            if(p.id == GV.MyInfo_userID)
            {
               this.difficulty = 5;
               MoveTo.CanMove = true;
            }
            GC.clearAll(tempLamu);
            if(type == 1)
            {
               top_mc.tieqou_mc.play();
               tc = GV.Lib_Map.getClass("sx_mc");
               gp = m1.parent.localToGlobal(new Point(m1.x,m1.y));
               tm = new tc();
               p.changeLayer(MapModelLogic.FLOOR_LAYER);
               tm.x = gp.x;
               tm.y = gp.y;
               depth_mc.addChildAt(tm,depth_mc.getChildIndex(p));
               p.x = -1000;
               GC.setGTimeout(function():void
               {
                  if(!target_mc)
                  {
                     return;
                  }
                  TweenLite.to(tm,1,{
                     "x":-100,
                     "y":252,
                     "rotation":359 * 2 * (Math.random() < 0.5 ? 1 : -1)
                  });
               },800);
               GC.setGTimeout(function():void
               {
                  if(!target_mc)
                  {
                     return;
                  }
                  if(p.id == GV.MyInfo_userID)
                  {
                     plum_blossom_mc.start_mc.buttonMode = false;
                     plum_blossom_mc.mouseChildren = false;
                     GF.switchMap(62,true);
                  }
               },2200);
            }
            else if(type == 2)
            {
               p.changeLayer(MapModelLogic.FLOOR_LAYER);
               m1.gotoAndPlay(2);
               gp = m1.parent.localToGlobal(new Point(m1.x,m1.y));
               tc = GV.Lib_Map.getClass("sj_mc");
               tm = new tc();
               tm.x = gp.x;
               tm.y = gp.y;
               depth_mc.addChildAt(tm,depth_mc.getChildIndex(p));
               TweenLite.to(p,1,{
                  "y":p.y + 150,
                  "alpha":0,
                  "rotation":359 * 2 * (Math.random() < 0.5 ? 1 : -1)
               });
               GC.setGTimeout(function():void
               {
                  if(!target_mc)
                  {
                     return;
                  }
                  m1.gotoAndStop(1);
                  p.alpha = 1;
                  p.rotation = 0;
                  if(p.id == GV.MyInfo_userID)
                  {
                     moveAction.sendAction(1,p.x,p.y);
                     mask_mc.gotoAndStop(1);
                     plum_blossom_mc.start_mc.buttonMode = false;
                     plum_blossom_mc.mouseChildren = false;
                     GF.switchMap(62,true);
                  }
               },1200);
            }
            else
            {
               m1.gotoAndPlay(2);
               TweenLite.to(p,1,{
                  "y":p.y + 150,
                  "alpha":0,
                  "rotation":359 * 2 * (Math.random() < 0.5 ? 1 : -1)
               });
               GC.setGTimeout(function():void
               {
                  if(!target_mc)
                  {
                     return;
                  }
                  m1.gotoAndStop(1);
                  var gp:Point = plum_blossom_mc.localToGlobal(startPoint);
                  p.x = gp.x - 100;
                  p.y = gp.y + Math.random() * 100;
                  p.alpha = 1;
                  p.rotation = 0;
                  p.changeLayer(MapModelLogic.FLOOR_LAYER);
                  if(p.id == GV.MyInfo_userID)
                  {
                     moveAction.sendAction(1,p.x,p.y);
                     mask_mc.gotoAndStop(1);
                     plum_blossom_mc.start_mc.buttonMode = false;
                     plum_blossom_mc.mouseChildren = false;
                  }
               },2000);
            }
         }
         else if(index < RiseArray.length - 1)
         {
            GV.soundCon.getSound("S_trampleWoodBlock",0,1);
            m2 = this.plum_blossom_mc.getChildAt(RiseArray[index + 1]) as MovieClip;
            p1 = new Point(m1.x,m1.y);
            p2 = new Point(m2.x,m2.y);
            p.x = p1.x;
            p.y = p1.y;
            dir = int(this.getDirection(p1,p2));
            p.avatarClass.stopAction(p.avatarClass.getDirectionString(dir),true);
            tempLamu.gotoAndStop(dir + 1);
            delay = Point.distance(p1,p2) / 200;
            delay = int(delay * 10) / 10;
            TweenLite.to(p,delay,{
               "x":p2.x,
               "y":p2.y
            });
            depth = int(RiseArray[index + 1]);
            if(id == 7)
            {
               this.goodLuck = true;
            }
            GC.setGTimeout(function():void
            {
               if(!target_mc)
               {
                  return;
               }
               try
               {
                  plum_blossom_mc.setChildIndex(p,depth + 1);
               }
               catch(E:*)
               {
               }
               risePeo(p,RiseArray,depth,index + 1,tempLamu,ei,type);
            },delay * 1000);
         }
      }
      
      private function MOver(E:MouseEvent) : void
      {
         E.currentTarget.filters = [new GlowFilter(13625071,1,15,15,3)];
      }
      
      private function MDown(E:MouseEvent) : void
      {
         var i:int = 0;
         GV.soundCon.getSound("S_button",0,1);
         E.currentTarget.filters = [new GlowFilter(13625071,1,15,15,3)];
         E.currentTarget.enabled = true;
         this.myArray2.push(this.plum_blossom_mc.getChildIndex(MovieClip(E.currentTarget)));
         if(this.myArray2.length == this.myArray.length)
         {
            for(i = 0; i < this.myArray.length; i++)
            {
               if(this.myArray[i] != this.myArray2[i])
               {
                  this.myArray2.splice(i + 1,this.myArray2.length - i - 1);
                  GV.onlineClass.chating(0,"/tag:p_b:" + this.difficulty + "," + (int(Math.random() * 3) + 1) + "," + this.myArray2);
                  this.myArray2 = [];
                  break;
               }
            }
            if(Boolean(this.myArray2.length))
            {
               GV.onlineClass.chating(0,"/tag:p_b:" + this.difficulty + ",0," + this.myArray2);
               this.myArray2 = [];
            }
            this.plum_blossom_mc.mouseChildren = false;
            target_mc.join_btn.mouseEnabled = true;
         }
      }
      
      private function Mup(E:MouseEvent) : void
      {
         E.currentTarget.filters = [];
      }
      
      private function MOut(E:MouseEvent) : void
      {
         E.currentTarget.filters = [];
      }
      
      public function getDirection(obj1:Point, obj2:Point) : uint
      {
         var myAngle:Number = Math.atan2(obj1.y - obj2.y,obj1.x - obj2.x) / Math.PI * 180 + 180;
         var angle:Number = myAngle + 22.5 + 270;
         return int(angle % 360 / 45);
      }
      
      public function addZhuZiGame(E:* = null) : void
      {
         var owner:* = undefined;
         var f1:Function = null;
         if(!target_mc.join_btn)
         {
            return;
         }
         if(Boolean(MainManager.getGameLevel().getChildByName("zhuzi_mc")))
         {
            return;
         }
         this.pan1 = new customAlert(MainManager.getGameLevel(),"main_mc,正在打開圓盤機關...","module/game/KnightGame.swf",1);
         owner = this;
         f1 = function(E:*):void
         {
            BC.removeEvent(owner,E.currentTarget,null,f1);
            var tc:Class = pan1.getLoader().contentLoaderInfo.applicationDomain.getDefinition("gameCore") as Class;
            var tg:* = new tc(pan1.getTargetMC());
            pan1.getTargetMC().name = "zhuzi_mc";
            BC.addEvent(owner,tg,"win",winFun);
            BC.addEvent(owner,tg,"fail",failFun);
         };
         BC.addEvent(owner,this.pan1,Alert.ON_CUSTOM_LOADED,f1);
         this.pan1.load();
      }
      
      private function winFun(E:Event) : void
      {
         target_mc.door_mc.gotoAndStop(2);
         BC.addEvent(this,target_mc.door_mc,"getProp1",this.p1f);
         BC.addEvent(this,target_mc.door_mc,"getProp2",this.p2f);
         GC.clearAll(this.pan1.getTargetMC());
      }
      
      private function p1f(E:Event) : void
      {
         var msg:String = null;
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            this.otherPipEvent();
         }
         else
         {
            msg = "　　趕快帶著你的拉姆來領取拉姆頭盔吧！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function otherPipEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MyInfo_PetObj.SpriteID,1200014,1200015,2);
      }
      
      private function getPetOtherEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         GV.onlineSocket.removeEventListener(petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         if(evt.EventObj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.getPetItemSUC);
            petClothReq.buyItem(GV.MAN_PEOPLE.PetID,1200014,1);
         }
         else
         {
            msg = "　　這個小拉姆已經有了拉姆頭盔了哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function getPetItemSUC(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petClothRes.PET_BUY_ITEM_SUCC,this.getPetItemSUC);
         var awardMsg:String = "　  恭喜你，拉姆頭盔已經放入你的拉姆背包中了！";
         var awardPath:String = "resource/petcloth/icon/1200014.swf";
         var tempAlert:* = Alert.showAlert(MainManager.getGameLevel(),"",awardMsg,Alert.SIZE_ALERT,"iknow",true,"298,228," + awardPath);
         tempAlert.changePanel_TextField_To_Bottom();
         tempAlert.getContentTextField().y = tempAlert.getContentTextField().y - 18;
         var ico:MovieClip = tempAlert.getTargetMC().ico_mc;
         ico.scaleX = ico.scaleY = 1.6;
         ico.x = 110;
         ico.y = 20;
      }
      
      private function p2f(E:Event) : void
      {
         if(!LocalUserInfo.isVIP())
         {
            return;
         }
         var throwArr:Array = [];
         var getArr:Array = [{
            "kind":160302,
            "num":1
         }];
         BC.addEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.getYFSure);
         new giveMeMoneyReq(throwArr,getArr);
      }
      
      private function getYFSure(E:EventTaomee) : void
      {
         var awardMsg:String = "　  恭喜你，騎士面具已經放入你的小屋倉庫中了！";
         var awardPath:String = GoodsInfo.getItemPathByID(160302) + "160302.swf";
         var tempAlert:* = Alert.showAlert(MainManager.getGameLevel(),"",awardMsg,Alert.SIZE_ALERT,"iknow",true,"298,228," + awardPath);
         tempAlert.changePanel_TextField_To_Bottom();
         tempAlert.getContentTextField().y = tempAlert.getContentTextField().y - 18;
         var ico:MovieClip = tempAlert.getTargetMC().ico_mc;
         ico.scaleX = ico.scaleY = 1.6;
         ico.x = 110;
         ico.y = 20;
      }
      
      private function failFun(E:Event) : void
      {
         GC.clearAll(this.pan1.getTargetMC());
      }
   }
}

