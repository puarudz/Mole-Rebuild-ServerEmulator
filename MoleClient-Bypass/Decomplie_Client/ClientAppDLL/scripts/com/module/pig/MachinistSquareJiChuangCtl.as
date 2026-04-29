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
   
   public class MachinistSquareJiChuangCtl
   {
      
      private static var _instance:MachinistSquareJiChuangCtl;
      
      public static var isOpen:Boolean = false;
      
      private var _level:uint;
      
      private var loader:Loader;
      
      private var _jiChuangSWF:Object;
      
      private var _jiChuangPanel:Object;
      
      private var currentRonglu_lvl:uint;
      
      private var _ready_smelt:Boolean;
      
      private var _readySmeltInfo:HashMap;
      
      public function MachinistSquareJiChuangCtl()
      {
         super();
      }
      
      public static function get instance() : MachinistSquareJiChuangCtl
      {
         if(_instance == null)
         {
            _instance = new MachinistSquareJiChuangCtl();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         this._level = MachinistSquareData.instance.machineSquareLvl;
         this._readySmeltInfo = new HashMap();
         BC.addEvent(this,PigEvent.instance,PigEvent.Click_JiChuang,this.onOpenJiChuangPanel);
         BC.addEvent(this,PigEvent.instance,PigEvent.Ready_To_Machine,this.onReadyMachine);
         this.showJiChuang();
      }
      
      public function removeReadySmeltInfo(value:Object) : void
      {
         var tmp:HashMap = null;
         var obj:Object = null;
         var arr:Array = null;
         var l:Object = null;
         var i:int = 0;
         if(value.result == 0)
         {
            tmp = value.machine;
            obj = this._readySmeltInfo.getValue(tmp.getValue("tool_index"));
            this._readySmeltInfo.remove(tmp.getValue("tool_index"));
            arr = obj.target.itemIn;
            for(i = 0; i < arr.length; i++)
            {
               l = MachinistSquareData.instance.lockGoods.getValue(String(arr[i].id));
               l = int(l) - arr[i].count * obj.target.count;
               MachinistSquareData.instance.lockGoods.add(String(arr[i].id),l);
            }
         }
      }
      
      private function onReadyMachine(event:EventTaomee) : void
      {
         var tmp:Object = null;
         this._readySmeltInfo.add(event.EventObj.id,event.EventObj);
         var arr:Array = event.EventObj.target.itemIn;
         var len:uint = arr.length;
         for(var i:uint = 0; i < len; i++)
         {
            tmp = MachinistSquareData.instance.lockGoods.getValue(String(arr[i].id));
            if(tmp == null)
            {
               MachinistSquareData.instance.lockGoods.add(arr[i].id,arr[i].count * event.EventObj.target.count);
            }
            else
            {
               tmp = int(tmp) + arr[i].count * event.EventObj.target.count;
               MachinistSquareData.instance.lockGoods.add(arr[i].id,int(tmp));
            }
         }
      }
      
      private function showJiChuang() : void
      {
         var url:String = "module/pig/MachineJiChuang.swf";
         this.loader = new Loader();
         BC.addEvent(this,this.loader.contentLoaderInfo,Event.COMPLETE,this.onLoaderSuc);
         this.loader.load(VL.getURLRequest(url));
      }
      
      private function onLoaderSuc(event:Event) : void
      {
         this._jiChuangSWF = this.loader.content;
         this._jiChuangSWF.Init();
      }
      
      private function onOpenJiChuangPanel(event:EventTaomee) : void
      {
         this.currentRonglu_lvl = event.EventObj.lvl;
         this.loaderJiChuangPanel();
      }
      
      private function loaderJiChuangPanel() : void
      {
         if(isOpen)
         {
            return;
         }
         isOpen = true;
         var url:String = "module/pig/MachineJiChuangPanel.swf";
         var ldr:Loader = new Loader();
         BC.addEvent(this,ldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderRongluPanelSuc);
         ldr.load(VL.getURLRequest(url));
      }
      
      private function onLoaderRongluPanelSuc(event:Event) : void
      {
         var info:LoaderInfo = LoaderInfo(event.currentTarget);
         this._jiChuangPanel = info.content;
         this._jiChuangPanel.Init(this.currentRonglu_lvl);
         MainManager.getAppLevel().addChild(Sprite(this._jiChuangPanel));
      }
      
      public function HitPigAndJiChuang(pig:MachinistSquarePig) : Boolean
      {
         var tmp:Object = null;
         var rl:* = undefined;
         var arr:Array = this.readySmeltInfo.values;
         var len:uint = arr.length;
         for(var i:int = len - 1; i >= 0; i--)
         {
            tmp = arr[i];
            rl = this._jiChuangSWF.GetJiChuangViewByID(tmp.id);
            if(pig.pigView.pigUI.hitTestObject(rl.mc))
            {
               if(pig.pigData.energy < arr[i].target.energy)
               {
                  PopupMsgCtl.PopupMsg("本次生產需要消耗" + arr[i].target.energy + "點能量值！");
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
            if(pig.pigData.energy >= arr[i].target.energy)
            {
               tmp = arr[i];
               rl = this._jiChuangSWF.GetJiChuangViewByID(tmp.id);
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
         if(Boolean(this._jiChuangSWF))
         {
            this._jiChuangSWF.destroy();
            this._jiChuangSWF = null;
         }
         this._jiChuangPanel = null;
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

