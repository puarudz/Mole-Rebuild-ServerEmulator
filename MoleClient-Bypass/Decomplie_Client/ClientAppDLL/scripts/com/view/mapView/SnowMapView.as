package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.module.activityModule.checkItem;
   import com.module.fight.FightEntry;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SnowMapView extends MapBase
   {
      
      private var _isHave:Boolean = false;
      
      public function SnowMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(12364);
         BC.addEvent(this,MovieClip(controlLevel["knight_6"]),MouseEvent.CLICK,this.clickknight6Handler);
         this.initRandomEvent();
         this.task556Event();
         BC.addEvent(this,GV.onlineSocket,"hideKnight",this.hideKnight);
      }
      
      private function hideKnight(e:*) : void
      {
         controlLevel["knight_6"].visible = false;
      }
      
      private function clickknight6Handler(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("NewAngelFightModule",0,"正在加載天使戰鬥",null,false,true);
      }
      
      private function task556Event() : void
      {
         GV.onlineSocket.addEventListener("Task556_angelPK",this.onShowChrisBoxHandle);
      }
      
      private function onShowChrisBoxHandle(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("Task556_angelPK",this.onShowChrisBoxHandle);
         ModuleManager.openPanel("NewAngelFightModule",500101,"正在加載天使戰鬥",null,false,true);
         FightEntry.instance.addEventListener(FightEntry.NEW_ANGEL_FIGHT_OVER,this.onShowPKOverHandle);
      }
      
      private function mapInitOver(evt:Event) : void
      {
         MapManageView.inst.removeEventListener(Event.INIT,this.mapInitOver);
         GV.onlineSocket.dispatchEvent(new Event("task556_getGiftOver"));
      }
      
      private function onShowPKOverHandle(e:EventTaomee) : void
      {
         FightEntry.instance.removeEventListener(FightEntry.NEW_ANGEL_FIGHT_OVER,this.onShowPKOverHandle);
         MapManageView.inst.addEventListener(Event.INIT,this.mapInitOver);
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type == 2)
         {
            this.gotoMayFun();
         }
      }
      
      private function gotoMayFun() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasAnimal)
         {
            Alert.smileAlart("    拉姆世界很危險，你要把動物送回家，才能進入拉姆世界哦！");
            return;
         }
         if(p.hasCar)
         {
            Alert.smileAlart("    拉姆世界很危險，你要把車開回家，才能進入拉姆世界哦！");
            return;
         }
         PlayMovie.play("resource/movie/gotoMap_1.swf",null,null,function():void
         {
            MapManager.enterMap(120);
         });
      }
      
      private function initRandomEvent() : void
      {
         for(var j:int = 0; j < 1; j++)
         {
            controlLevel.activMC["mc_" + j].mc.visible = false;
         }
         BC.addEvent(this,GV.onlineSocket,randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         for(var k:int = 0; k < 1; k++)
         {
            controlLevel.activMC["mc_" + k].mc.visible = false;
         }
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  controlLevel.activMC["mc_" + tempNum].mc.visible = true;
                  controlLevel.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num >= 1)
         {
            controlLevel.door_3.visible = true;
         }
      }
      
      override public function destroy() : void
      {
         FightEntry.instance.removeEventListener(FightEntry.NEW_ANGEL_FIGHT_OVER,this.onShowPKOverHandle);
         MapManageView.inst.addEventListener(Event.INIT,this.mapInitOver);
         super.destroy();
      }
   }
}

