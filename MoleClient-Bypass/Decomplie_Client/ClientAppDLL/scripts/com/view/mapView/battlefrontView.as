package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.task.SummerActivityCtr;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.PeopleView.FlyType;
   import com.view.mapView.activity.Task83.HelpAngelsCtl;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   
   public class battlefrontView extends MapBase
   {
      
      private var ply:PlayMovie;
      
      private var changeMapTimer:Timer;
      
      public function battlefrontView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.KFCRed_mc.visible = false;
         tip.tipTailDisPlayObject(controlLevel.cloud_mc,"進入神秘湖雲海");
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         controlLevel["boat"].buttonMode = true;
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = controlLevel.angelHospital_btn;
         var _temp_1:* = MouseEvent.CLICK;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:Event):void
            {
               var loadGame:LoadGame = new LoadGame("module/external/angelPark/AngelHospital.swf","正在進入天使醫院...",MainManager.getAppLevel());
               loadGame = null;
            });
            BC.addEvent(this,controlLevel.open_btn,MouseEvent.CLICK,this.openHandler);
            BC.addEvent(this,controlLevel.helpBtn,MouseEvent.CLICK,this.onClickHelp);
            BC.addEvent(this,buttonLevel.map252,MouseEvent.CLICK,this.onGotoMap252);
            SummerActivityCtr.inst.goDesOver();
            BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
            BufferManager.getBuffer(BufferManager.KFC_MAGIC_DETECT_STEP);
            topLevel.mouseChildren = true;
            topLevel.mouseEnabled = true;
            depthLevel.task484MC.visible = false;
         }
         
         private function KFCMagicHandle(e:EventTaomee) : void
         {
            var movie1:PlayMovie = null;
            var movie2:PlayMovie = null;
            var magicStep:uint = e.EventObj as uint;
            if(magicStep == 1)
            {
               movie1 = PlayMovie.play("resource/map/cartoon/cartoon1.swf",null,null,function():void
               {
                  movie1.destroy();
                  BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,2);
                  BufferManager.getBuffer(BufferManager.KFC_MAGIC_DETECT_STEP);
               });
            }
            else if(magicStep == 2)
            {
               controlLevel.KFCRed_mc.visible = true;
               BC.addEvent(this,controlLevel.KFCRed_mc,MouseEvent.CLICK,this.clickKFCRed);
            }
            else if(magicStep == 5)
            {
               movie2 = PlayMovie.play("resource/map/cartoon/cartoon2.swf",null,null,function():void
               {
                  movie2.destroy();
                  BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,6);
                  MapManager.enterMap(203);
               });
            }
         }
         
         private function clickKFCRed(e:Event) : void
         {
            if(this.wearingMask() > 0)
            {
               controlLevel.KFCRed_mc.scaleX = 1.5;
               controlLevel.KFCRed_mc.scaleY = 1.5;
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,3);
               Alert.smileAlart("KFC？難道與奇奇有關？快去看看吧！",function():void
               {
                  MapManager.enterMap(203);
               });
            }
            else
            {
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,3);
               Alert.angryAlart("  快戴上KFC放大鏡，找找菩提留下的線索吧！放大鏡參與“消失的紅鼻子”就可得到喔",function():void
               {
                  MapManager.enterMap(203);
               });
            }
         }
         
         private function wearingMask() : int
         {
            var obj:Object = null;
            var arr:Array = LocalUserInfo.getClothItem();
            for each(obj in arr)
            {
               if(obj.ItemID == 14986)
               {
                  return obj.ItemID;
               }
            }
            return 0;
         }
         
         private function onGotoMap252(event:MouseEvent) : void
         {
            this.ply = PlayMovie.play("resource/task/switchMap252Movie.swf",null,null,this.playOver);
         }
         
         private function playOver() : void
         {
            this.ply.destroy();
            this.ply = null;
            GF.switchMap(252,true);
         }
         
         private function onClickHelp(e:MouseEvent) : void
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckTask);
            finishSomethingReq.sendReq(40008);
         }
         
         private function onCheckTask(e:EventTaomee) : void
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckTask);
            if(e.EventObj.Type == 40008)
            {
               if(e.EventObj.Done > 0)
               {
                  Alert.smileAlart("    你已經成功拯救了一個小怪物，魔法石的能量需要恢復，明天再來吧！");
               }
               else if(LocalUserInfo.isVIP())
               {
                  HelpAngelsCtl.getInstance().loaderPanel();
               }
               else
               {
                  Alert.SLAlart("    擁有超級拉姆的小摩爾，才可以啟動魔法石拯救怪物們！快點加入超級拉姆大家庭吧！");
               }
            }
         }
         
         private function openHandler(evt:MouseEvent) : void
         {
            AngelsAndDemonsCtl.instance.LoadExchangePanelFun();
         }
         
         private function boatHandlerFun(evt:MouseEvent) : void
         {
            BC.addEvent(this,GV.onlineSocket,"sMap176_179",this.switchMapFun);
            var mcloader:MCLoader = new MCLoader("module/external/sMap176_179.swf",MainManager.getAppLevel(),Loading.TITLE_AND_PERCENT,"請耐心等待....");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadOver);
            mcloader.addEventListener(MCLoadEvent.ERROR,this.failLoadUI);
            mcloader.load();
         }
         
         private function onLoadOver(evt:MCLoadEvent) : void
         {
            var currMc:MovieClip = MovieClip(evt.getContent());
            MainManager.getAppLevel().addChild(currMc);
         }
         
         private function failLoadUI(evt:MCLoadEvent) : void
         {
            trace(evt.toString());
         }
         
         private function switchMapFun(evt:Event) : void
         {
            if(GV.MapInfo_mapID != 179)
            {
               GV.Room_DefaultRoomID = 0;
               LocalUserInfo.setMapID(0);
               GF.switchMap(179,true);
            }
         }
         
         private function lookHandler(evt:EventTaomee) : void
         {
            if(evt.EventObj.type == 2)
            {
               depthLevel.fly_mc.gotoAndPlay(2);
               MoveTo.CanMove = false;
               new moleActionReq().sendAction(77,GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
               GV.MAN_PEOPLE.fly(FlyType.PET);
               BC.addEvent(this,GV.MAN_PEOPLE,"onFlyComPlete",this.gotoAirMap);
               this.changeMapTimer = GC.setGTimeout(this.gotoAirMap,4000,1);
            }
         }
         
         private function gotoAirMap(E:*) : void
         {
            GC.clearGTimeout(this.changeMapTimer);
            BC.removeEvent(this,GV.MAN_PEOPLE,"onFlyComPlete",this.gotoAirMap);
            GF.switchMap(178,true);
         }
         
         override public function destroy() : void
         {
            GC.clearGTimeout(this.changeMapTimer);
            BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
            super.destroy();
         }
      }
   }
   
   