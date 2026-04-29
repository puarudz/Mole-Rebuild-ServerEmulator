package com.module.pig.view
{
   import com.common.data.HashMap;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.pig.MachinistSquareEntrance;
   import com.module.pig.PigEvent;
   import com.module.pig.PigHouseUI;
   import com.module.pig.data.MachinistSquareData;
   import com.module.pig.view.pig.MachinistSquarePig;
   import com.module.popupMsg.PopupMsgCtl;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MachinistSquarePigsCtl
   {
      
      private static var _instance:MachinistSquarePigsCtl;
      
      private var tip_mc:MovieClip;
      
      private var clickPig:MachinistSquarePig;
      
      private var _pigs:HashMap;
      
      public function MachinistSquarePigsCtl()
      {
         super();
      }
      
      public static function get instance() : MachinistSquarePigsCtl
      {
         if(_instance == null)
         {
            _instance = new MachinistSquarePigsCtl();
         }
         return _instance;
      }
      
      public function get pigs() : HashMap
      {
         return this._pigs;
      }
      
      public function get pigCount() : int
      {
         if(this._pigs == null)
         {
            return 0;
         }
         return this._pigs.length;
      }
      
      public function Init(e:Event = null) : void
      {
         this._pigs = new HashMap();
         BC.addEvent(this,PigEvent.instance,PigEvent.Click_MachinePig,this.onClickMachinePig);
         BC.addEvent(this,PigEvent.instance,PigEvent.Get_MachinistSquare_Data_OK,this.UpdatePigData);
         BC.addEvent(this,PigEvent.instance,PigEvent.Delete_Pig,this.onDeletPig);
         this.UpdatePigData();
      }
      
      private function onClickMachinePig(event:EventTaomee) : void
      {
         event.stopImmediatePropagation();
         this.clickPig = event.EventObj.target;
         if(this.tip_mc == null)
         {
            this.tip_mc = PigHouseUI.instance.GetMovieClip("machinePigTip_mc");
         }
         this.tip_mc.x = this.clickPig.pigView.x + 20;
         this.tip_mc.y = this.clickPig.pigView.y - this.clickPig.pigView.height / 2;
         BC.addOnceEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN,this.onTip_mcMouseDown,true);
         MainManager.getAppLevel().addChild(this.tip_mc);
      }
      
      private function onTip_mcMouseDown(event:MouseEvent) : void
      {
         var point:Point = new Point(MainManager.getStage().mouseX,MainManager.getStage().mouseY);
         if(MovieClip(this.tip_mc["btn0"]).hitTestPoint(point.x,point.y))
         {
            this.clickPig.ShowInfo();
            this.clearTipMC();
            return;
         }
         if(MovieClip(this.tip_mc["btn1"]).hitTestPoint(point.x,point.y))
         {
            if(MachinistSquareEntrance.instance.isMyHouse)
            {
               this.clearTipMC();
               this.clickPig.SetPigToWork();
               return;
            }
         }
         if(MovieClip(this.tip_mc["btn2"]).hitTestPoint(point.x,point.y))
         {
            if(MachinistSquareEntrance.instance.isMyHouse)
            {
               this.clickPig.SetPigToPigHouse();
               this.clearTipMC();
               return;
            }
         }
         this.clearTipMC();
      }
      
      private function clearTipMC() : void
      {
         if(this.tip_mc == null)
         {
            return;
         }
         if(MainManager.getAppLevel().contains(this.tip_mc))
         {
            MainManager.getAppLevel().removeChild(this.tip_mc);
         }
      }
      
      public function UpdatePigData(e:Event = null) : void
      {
         var pig:MachinistSquarePig = null;
         var pigs:Array = null;
         var data:HashMap = null;
         var pigId:int = 0;
         var oldPig:MachinistSquarePig = null;
         var currentPigs:Array = this._pigs.values;
         for each(pig in currentPigs)
         {
            if(MachinistSquareData.instance.pigsHashMap.containsKey(pig.pigData.id) == false)
            {
               this._pigs.remove(pig.pigData.id);
               pig.Clear();
            }
         }
         pigs = MachinistSquareData.instance.pigs;
         for each(data in pigs)
         {
            pigId = data.getValue("id");
            if(this._pigs.containsKey(pigId))
            {
               oldPig = this._pigs.getValue(pigId);
               oldPig.UpdateData(data);
            }
            else
            {
               this.AddPig(data);
            }
         }
      }
      
      private function AddPig(data:HashMap) : MachinistSquarePig
      {
         var pig:MachinistSquarePig = null;
         var id:uint = data.getValue("id");
         if(MachinistSquareData.instance.lockPigs != null)
         {
            if(MachinistSquareData.instance.lockPigs.getValue(String(id)) != null)
            {
               return null;
            }
         }
         pig = new MachinistSquarePig(data);
         this._pigs.add(pig.pigData.id,pig);
         if(!MachinistSquareData.noEnergy)
         {
            if(pig.pigData.energy == 0)
            {
               PopupMsgCtl.PopupMsg("有一隻超級豬能量耗盡不能工作了，把它放出機械工坊吧！");
               MachinistSquareData.noEnergy = true;
            }
         }
         var randomPoint:Point = MoveTo.getRandomFloorPoint();
         pig.pigView.x = randomPoint.x;
         pig.pigView.y = randomPoint.y;
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Update_Pig_Count));
         return pig;
      }
      
      private function deletePigByID(id:uint) : void
      {
         var pig:MachinistSquarePig = null;
         if(Boolean(this._pigs))
         {
            pig = this._pigs.getValue(String(id));
            this._pigs.remove(id);
            pig.Clear();
         }
      }
      
      private function onDeletPig(event:EventTaomee) : void
      {
         var pig:MachinistSquarePig = event.EventObj.pig;
         MachinistSquareData.instance.SetLockPig(pig);
         this.deletePigByID(pig.pigData.id);
      }
      
      public function Clear() : void
      {
         var pigs:Array = null;
         var pigCount:int = 0;
         var i:int = 0;
         var pig:MachinistSquarePig = null;
         if(Boolean(this._pigs))
         {
            pigs = this._pigs.values;
            pigCount = int(pigs.length);
            for(i = 0; i < pigCount; i++)
            {
               pig = pigs[i];
               pig.Clear();
            }
         }
         BC.removeEvent(this);
         GC.clearAll(this.tip_mc);
         this.tip_mc = null;
         _instance = null;
      }
   }
}

