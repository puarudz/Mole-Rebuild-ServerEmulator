package com.module.pig.view
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.pig.MachinistSquareEntrance;
   import com.module.pig.PigEvent;
   import com.module.pig.data.MachinistSquareData;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import com.view.MapManageView.MapManageView;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class MachinistSquareStageView
   {
      
      private static var _instance:MachinistSquareStageView;
      
      public static const Init_MachinistSquare_Map_Ok_Event:String = "Init_MachinistSquare_Map_Ok_Event";
      
      private var control_mc:Sprite;
      
      private var depth_mc:Sprite;
      
      private var button_mc:Sprite;
      
      private var _bgLoader:MCLoader;
      
      private var _loader:Loader;
      
      private var ths:MachinistSquareStageView;
      
      private var obj:Object;
      
      public function MachinistSquareStageView()
      {
         super();
      }
      
      public static function get instance() : MachinistSquareStageView
      {
         if(_instance == null)
         {
            _instance = new MachinistSquareStageView();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         this.ths = this;
         var bgPath:String = "resource/pig/swf/MachinistSquare.swf";
         this._bgLoader = new MCLoader(bgPath,MainManager.getAppLevel(),1,"正在進入機械工坊...");
         BC.addEvent(this,this._bgLoader,MCLoadEvent.ON_SUCCESS,this.onBGLoadOver);
         LoaderList.getInstance().addItem(this._bgLoader,null,LoaderList.HIGH);
      }
      
      private function onBGLoadOver(e:MCLoadEvent) : void
      {
         BC.removeEvent(this,this._bgLoader);
         var mapLoader:Loader = this._bgLoader.getLoader();
         MapManageView.inst.initMap(mapLoader);
         MapManageView.inst.initFindPath();
         MapManageView.inst.mapLevel.depthLevel.mouseChildren = true;
         MapManageView.inst.mapLevel.depthLevel.mouseEnabled = true;
         this.control_mc = GV.MC_mapFrame.control_mc;
         this.depth_mc = GV.MC_mapFrame.depth_mc;
         this.button_mc = GV.MC_mapFrame.buttonLevel;
         PigEvent.instance.dispatchEvent(new Event(Init_MachinistSquare_Map_Ok_Event));
         tip.tipTailDisPlayObject(this.control_mc["door"],"返回肥肥館");
         BC.addEvent(this,this.control_mc["door"],MouseEvent.CLICK,this.onBackToPigHouse);
         tip.tipTailDisPlayObject(this.control_mc["superBtn"],"超能機器");
         tip.tipTailDisPlayObject(this.control_mc["line_mc"],"組裝線");
         BC.addEvent(this,this.control_mc["line_mc"],MouseEvent.CLICK,this.onOpenAssemblyLine);
         tip.tipTailDisPlayObject(this.control_mc["box_mc"],"倉庫");
         BC.addEvent(this,this.control_mc["box_mc"],MouseEvent.CLICK,this.onOpenWarehouse);
         tip.tipTailDisPlayObject(this.button_mc["mapBtn"],"探礦");
         tip.tipTailDisPlayObject(this.control_mc["friend_btn"],"    友誼寶箱\n即將開放敬請期待");
         if(MachinistSquareEntrance.instance.isMyHouse)
         {
            this.control_mc["superBtn"].buttonMode = true;
            BC.addEvent(this,this.control_mc["superBtn"],MouseEvent.CLICK,this.onOpenSuperMachine);
            BC.addEvent(this,this.button_mc["mapBtn"],MouseEvent.CLICK,this.onOpenExploreMine);
            BC.addEvent(this,PigEvent.instance,PigEvent.Intensify_Pig,this.onIntensifyPig);
            BC.addEvent(this,PigEvent.instance,PigEvent.Make_Assembly_Line_Suc,this.onMakeAssemblyLineSuc);
            BC.addEvent(this,PigEvent.instance,PigEvent.Make_Special_Suc,this.onMakeSpecialSuc);
         }
      }
      
      private function onOpenExploreMine(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         ModuleManager.openPanel(ModuleType.PIG_EXPLORE_MINE_PANEL);
      }
      
      private function onIntensifyPig(event:Event) : void
      {
         with({})
         {
            setTimeout(function h():void
            {
               MachinistSquareData.instance.GetMachinistSquareData();
            },5000);
         }
         
         private function onMakeAssemblyLineSuc(event:EventTaomee) : void
         {
            BC.removeEvent(this,this.control_mc["line_mc"],MouseEvent.CLICK,this.onOpenAssemblyLine);
            this.obj = event.EventObj;
            with({})
            {
               setTimeout(function h():void
               {
                  BC.addEvent(ths,control_mc["line_mc"],MouseEvent.CLICK,onOpenAssemblyLine);
                  var msg:String = "    恭喜你組裝出" + obj.arr[0].count + "個" + GoodsInfo.getItemNameByID(obj.arr[0].itemID) + "已放入你的" + GoodsInfo.getItemCollectionBoxNameByID(obj.arr[0].itemID) + "中！";
                  Alert.smileAlart(msg);
               },2000);
            }
            
            private function onMakeSpecialSuc(event:EventTaomee) : void
            {
               BC.removeEvent(this,this.control_mc["line_mc"],MouseEvent.CLICK,this.onOpenAssemblyLine);
               this.obj = event.EventObj;
               with({})
               {
                  setTimeout(function h():void
                  {
                     MachinistSquareData.instance.GetMachinistSquareData();
                     BC.addEvent(ths,control_mc["line_mc"],MouseEvent.CLICK,onOpenAssemblyLine);
                     var msg:String = "    恭喜你組裝出" + GoodsInfo.getItemNameByID(obj.chooseID);
                     Alert.smileAlart(msg);
                  },2500);
               }
               
               private function onOpenWarehouse(event:MouseEvent) : void
               {
                  ModuleManager.openPanel(ModuleType.PIG_BAG_PANEL);
               }
               
               private function onBackToPigHouse(event:MouseEvent) : void
               {
                  GF.switchToPigHouse(MachinistSquareEntrance.instance.userId);
               }
               
               private function onOpenAssemblyLine(event:MouseEvent) : void
               {
                  ModuleManager.openModule("MachineSquareAssemblyLineMain",null,"module/pig/");
               }
               
               private function onOpenSuperMachine(event:MouseEvent) : void
               {
                  var loadGame:LoadGame = new LoadGame("module/pig/SuperMachine.swf","正在加載...",MainManager.getAppLevel());
                  loadGame = null;
               }
               
               public function Clear() : void
               {
                  BC.removeEvent(this);
                  _instance = null;
               }
            }
         }
         
         