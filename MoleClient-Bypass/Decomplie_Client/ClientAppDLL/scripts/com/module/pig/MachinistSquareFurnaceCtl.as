package com.module.pig
{
   import com.common.data.HashMap;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.pig.data.MachinistSquareData;
   import com.module.pig.view.pig.MachinistSquarePig;
   import com.module.popupMsg.PopupMsgCtl;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MachinistSquareFurnaceCtl
   {
      
      private static var _instance:MachinistSquareFurnaceCtl;
      
      public static var isOpen:Boolean = false;
      
      private var _level:uint;
      
      private var loader:Loader;
      
      private var _rongluSWF:Object;
      
      private var _rongluPanel:Object;
      
      private var currentRonglu_lvl:uint;
      
      private var _ready_smelt:Boolean;
      
      private var _readySmeltInfo:HashMap;
      
      public function MachinistSquareFurnaceCtl()
      {
         super();
      }
      
      public static function get instance() : MachinistSquareFurnaceCtl
      {
         if(_instance == null)
         {
            _instance = new MachinistSquareFurnaceCtl();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         this._level = MachinistSquareData.instance.machineSquareLvl;
         this._readySmeltInfo = new HashMap();
         BC.addEvent(this,PigEvent.instance,PigEvent.Click_Ronglu,this.onOpenRongluPanel);
         BC.addEvent(this,PigEvent.instance,PigEvent.Ready_To_Smelt,this.onReadySmelt);
         this.showRonglu();
      }
      
      public function removeReadySmeltInfo(value:Object) : void
      {
         var tmp:HashMap = null;
         var obj:Object = null;
         var l:Object = null;
         if(value.result == 0)
         {
            tmp = value.machine;
            obj = this._readySmeltInfo.getValue(tmp.getValue("tool_index"));
            this._readySmeltInfo.remove(obj.id);
            l = MachinistSquareData.instance.lockGoods.getValue(String(obj.itemID));
            l = int(l) - obj.lock;
            MachinistSquareData.instance.lockGoods.add(String(obj.itemID),l);
         }
      }
      
      private function onReadySmelt(event:EventTaomee) : void
      {
         this._readySmeltInfo.add(event.EventObj.id,event.EventObj);
         var tmp:Object = MachinistSquareData.instance.lockGoods.getValue(String(event.EventObj.itemID));
         if(tmp == null)
         {
            MachinistSquareData.instance.lockGoods.add(event.EventObj.itemID,event.EventObj.lock);
         }
         else
         {
            tmp = int(tmp) + event.EventObj.lock;
            MachinistSquareData.instance.lockGoods.add(event.EventObj.itemID,int(tmp));
         }
      }
      
      private function showRonglu() : void
      {
         var url:String = "module/pig/MachineRonglu.swf";
         this.loader = new Loader();
         BC.addEvent(this,this.loader.contentLoaderInfo,Event.COMPLETE,this.onLoaderSuc);
         this.loader.load(VL.getURLRequest(url));
      }
      
      private function onLoaderSuc(event:Event) : void
      {
         this._rongluSWF = this.loader.content;
         this._rongluSWF.Init();
      }
      
      private function onOpenRongluPanel(event:EventTaomee) : void
      {
         this.currentRonglu_lvl = event.EventObj.lvl;
         this.loaderRongluPanel();
      }
      
      private function loaderRongluPanel() : void
      {
         if(isOpen)
         {
            return;
         }
         isOpen = true;
         var url:String = "module/pig/MachineRongluPanel.swf";
         var ldr:Loader = new Loader();
         BC.addEvent(this,ldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderRongluPanelSuc);
         ldr.load(VL.getURLRequest(url));
      }
      
      private function onLoaderRongluPanelSuc(event:Event) : void
      {
         var info:LoaderInfo = LoaderInfo(event.currentTarget);
         this._rongluPanel = info.content;
         this._rongluPanel.Init(this.currentRonglu_lvl);
         MainManager.getAppLevel().addChild(Sprite(this._rongluPanel));
      }
      
      public function HitPigAndRonglu(pig:MachinistSquarePig) : Boolean
      {
         var tmp:Object = null;
         var rl:* = undefined;
         var arr:Array = this.readySmeltInfo.values;
         var len:uint = arr.length;
         for(var i:int = len - 1; i >= 0; i--)
         {
            tmp = arr[i];
            rl = this._rongluSWF.GetRongluViewByID(tmp.id);
            if(pig.pigView.pigUI.hitTestObject(rl.mc))
            {
               if(pig.pigData.energy < arr[i].energy)
               {
                  PopupMsgCtl.PopupMsg("本次生產需要消耗" + arr[i].energy + "點能量值！");
                  return false;
               }
               rl.addPigWorking(pig.pigData);
               return true;
            }
         }
         return false;
      }
      
      public function PigToWork(pig:MachinistSquarePig) : void
      {
         var tmp:Object = null;
         var rl:* = undefined;
         var arr:Array = this.readySmeltInfo.values;
         var len:uint = arr.length;
         for(var i:int = len - 1; i >= 0; i--)
         {
            if(pig.pigData.energy >= arr[i].energy)
            {
               tmp = arr[i];
               rl = this._rongluSWF.GetRongluViewByID(tmp.id);
               rl.addPigWorking(pig.pigData);
               PigEvent.instance.dispatchEvent(new EventTaomee(PigEvent.Delete_Pig,{"pig":pig}));
               return;
            }
         }
         PopupMsgCtl.PopupMsg("暫時沒有適合你的工作哦！");
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         if(Boolean(this.loader))
         {
            this.loader.unload();
            this.loader = null;
         }
         if(Boolean(this._rongluSWF))
         {
            this._rongluSWF.destroy();
            this._rongluSWF = null;
         }
         this._rongluPanel = null;
         this._readySmeltInfo = null;
         _instance = null;
         isOpen = false;
      }
      
      public function get readySmeltInfo() : HashMap
      {
         return this._readySmeltInfo;
      }
      
      public function get ready_smelt() : Boolean
      {
         return this._readySmeltInfo.length > 0;
      }
      
      public function GetReadySmeltByID(id:uint) : Object
      {
         return this._readySmeltInfo.getValue(id.toString());
      }
   }
}

