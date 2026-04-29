package com.module.pig.view
{
   import com.common.tip.tip;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.module.LocusWork.MCContorl;
   import com.module.LocusWork.NumSprite;
   import com.module.pig.PigEvent;
   import com.module.pig.PigExtenalCtl;
   import com.module.pig.PigHouseEntrance;
   import com.module.pig.PigHouseUI;
   import com.module.pig.data.PigHouseData;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class PigHouseStageView
   {
      
      private static var _instance:PigHouseStageView;
      
      public static const Init_Map_Ok_Event:String = "Init_Map_Ok_Event";
      
      public static var bl:Boolean = false;
      
      private var _bgLoader:MCLoader;
      
      private var _workHouseMC:MovieClip;
      
      public function PigHouseStageView()
      {
         super();
      }
      
      public static function get instance() : PigHouseStageView
      {
         if(_instance == null)
         {
            _instance = new PigHouseStageView();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         var bgPath:String = "resource/pig/swf/" + PigHouseData.instance.bgId + ".swf";
         this._bgLoader = new MCLoader(bgPath,MainManager.getAppLevel(),Loading.MAIN_LOAD,"正在進入肥肥館...");
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
         PigEvent.instance.dispatchEvent(new Event(Init_Map_Ok_Event));
         BC.addEvent(this,PigEvent.instance,PigEvent.Go_Eat_Food,this.PlayFoodMovie);
         BC.addEvent(this,PigEvent.instance,PigEvent.Go_Bathe,this.PlayBatheMovie);
         var controlMC:MovieClip = GV.MC_mapFrame.control_mc;
         this.AddMouseEvent(controlMC.fenguan_btn,PigExtenalCtl.OpenTempHouse);
         if(PigHouseEntrance.instance.isMyPigHouse)
         {
            if(Boolean(controlMC) && Boolean(controlMC.qishi))
            {
               controlMC.qishi.visible = false;
               tip.tipTailDisPlayObject(controlMC.qishi,"摩爾大生產");
               BC.addEvent(this,controlMC.qishi,MouseEvent.CLICK,this.onOpenBigProduct);
            }
            this.InitWorkHouseMC();
            this.AddMouseEvent(controlMC.fightHouse_mc);
         }
         tip.tipTailDisPlayObject(controlMC.beautyHouse_mc,"美美屋");
         var beautyHouseMC:MovieClip = controlMC.beautyHouse_mc;
         if(Boolean(beautyHouseMC))
         {
            MCContorl.stopTo(beautyHouseMC,PigHouseData.instance.beautyHouseLvl,this.InitBeautyHouse);
         }
         this.AddMouseEvent(controlMC.msg_mc,PigExtenalCtl.OpenNotice);
         BC.addEvent(this,PigEvent.instance,PigEvent.Make_Goods_Over,this.PlayWorkHouseMovie);
         tip.tipTailDisPlayObject(GV.MC_mapFrame.control_mc.bathe_mc,"洗澡");
         GV.MC_mapFrame.control_mc.bathe_mc.buttonMode = true;
         BC.addEvent(this,GV.MC_mapFrame.control_mc.bathe_mc,MouseEvent.CLICK,PigsCtl.instance.Bathe);
         BC.addEvent(this,PigEvent.instance,PigEvent.Get_PigHouse_Data_OK,this.InitWorkHouseMC);
         this.addMachineEvent();
      }
      
      private function onOpenBigProduct(event:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.MOLE_PRODUCTION_PANEL);
      }
      
      private function getItemCountLogic(event:EventTaomee) : void
      {
         var arr:Array = event.EventObj.obj.arr;
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].id == 190915)
            {
               bl = true;
               break;
            }
         }
         this.addMachineEvent();
      }
      
      private function addMachineEvent() : void
      {
         var controlMC:MovieClip = GV.MC_mapFrame.control_mc;
         tip.tipTailDisPlayObject(controlMC.fightHouse_mc,this.getMachineLevel() + "機械工坊");
         var machineHouseMC:MovieClip = controlMC.fightHouse_mc;
         if(Boolean(machineHouseMC))
         {
            BC.addEvent(this,machineHouseMC,MouseEvent.CLICK,this.openMachineHouse);
         }
      }
      
      private function getMachineLevel() : String
      {
         var msg:String = null;
         var level:uint = uint(PigHouseData.instance.machineHouseLvl);
         if(level == 1)
         {
            msg = "初級";
         }
         else if(level == 2)
         {
            msg = "中級";
         }
         else if(level == 3)
         {
            msg = "高級";
         }
         return msg;
      }
      
      private function InitBeautyHouse() : void
      {
         var beautyHouseMC:MovieClip = GV.MC_mapFrame.control_mc.beautyHouse_mc;
         beautyHouseMC = beautyHouseMC.getChildAt(0) as MovieClip;
         this.AddMouseEvent(beautyHouseMC,this.openBeautyHouse);
      }
      
      private function openBeautyHouse(e:Event = null) : void
      {
         GF.switchToBeautyHouse(PigHouseEntrance.instance.userId);
      }
      
      private function openMachineHouse(event:MouseEvent) : void
      {
         GF.switchToMachinistSquare(PigHouseEntrance.instance.userId);
      }
      
      private function BackToMap(e:MouseEvent) : void
      {
         GF.switchMapDirectly(1);
      }
      
      private function AddMouseEvent(mc:DisplayObject, ClickFun:Function = null) : void
      {
         if(mc is MovieClip)
         {
            BC.addEvent(this,mc,MouseEvent.MOUSE_OVER,this.OnMouseOverHandler);
            BC.addEvent(this,mc,MouseEvent.MOUSE_OUT,this.OnMouseOutHandler);
            MovieClip(mc).buttonMode = true;
         }
         if(ClickFun != null)
         {
            BC.addEvent(this,mc,MouseEvent.CLICK,ClickFun);
         }
      }
      
      private function InitWorkHouseMC(e:Event = null) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private function PlayWorkHouseMovie(e:EventTaomee) : void
      {
         with({})
         {
            setTimeout(function h():void
            {
               var mc:MovieClip = PigHouseUI.instance.GetMovieClip("makePig_mc");
               new NumSprite(mc.num_mc,e.EventObj.gold,false,true);
               MainManager.getAppLevel().addChild(mc);
               MovieClipUtil.playEndAndRemove(mc);
            },9 * 1000);
         }
         
         private function OnMouseOverHandler(e:MouseEvent) : void
         {
            MovieClip(e.currentTarget).gotoAndStop(2);
         }
         
         private function OnMouseOutHandler(e:MouseEvent) : void
         {
            MovieClip(e.currentTarget).gotoAndStop(1);
         }
         
         private function GetToAngelPark(e:MouseEvent) : void
         {
            GF.switchMapDirectly(PigHouseEntrance.instance.userId,false,37);
         }
         
         private function GetHome(e:MouseEvent) : void
         {
            GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
            GF.switchMap(PigHouseEntrance.instance.userId + GV.TwentyBillion);
         }
         
         private function GetPigSeed(e:MouseEvent) : void
         {
            GF.switchMapDirectly(34);
         }
         
         public function PlayFoodMovie(e:EventTaomee) : void
         {
            var mc:MovieClip = null;
            mc = GV.MC_mapFrame.control_mc.foodMovie_mc;
            with({})
            {
               setTimeout(function h():void
               {
                  mc.gotoAndStop(1);
               },10 * 1000);
            }
            
            public function PlayBatheMovie(e:EventTaomee) : void
            {
               var mc:MovieClip = null;
               mc = GV.MC_mapFrame.control_mc.bathe_mc;
               with({})
               {
                  setTimeout(function h():void
                  {
                     mc.gotoAndStop(1);
                  },10 * 1000);
               }
               
               public function Clear() : void
               {
                  BC.removeEvent(this);
                  _instance = null;
               }
            }
         }
         
         