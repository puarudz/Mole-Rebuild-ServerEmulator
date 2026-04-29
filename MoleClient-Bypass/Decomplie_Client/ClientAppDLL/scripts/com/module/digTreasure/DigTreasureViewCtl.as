package com.module.digTreasure
{
   import com.common.LibLogic.LibLogic;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.event.EventTaomee;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.module.digTreasure.data.DigTreasureData;
   import com.module.digTreasure.view.DigTreasureBossItem;
   import com.module.digTreasure.view.DigTreasureEventItem;
   import com.module.digTreasure.view.DigTreasureMineItem;
   import com.module.digTreasure.view.DigTreasureToolView;
   import com.module.digTreasure.view.DigTreasureTriggerItem;
   import com.module.popupMsg.PopupMsgCtl;
   import com.view.PeopleView.PeopleManageView;
   import com.view.noticeView.noticeView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class DigTreasureViewCtl
   {
      
      public static var Pre_DigTreasure_Id:int = 0;
      
      private static const Config_Url:String = "resource/xml/digTreasure/DigTreasureMap_";
      
      private var _data:DigTreasureData;
      
      private var _viewItemCtlDic:Dictionary;
      
      private var _specialItemCtlDic:Dictionary;
      
      private var _toolView:DigTreasureToolView;
      
      private var _mapUI:MovieClip;
      
      private var _mapId:int;
      
      private var _screenId:int;
      
      private var _digTreasureId:int;
      
      private var _config:XML;
      
      public function DigTreasureViewCtl()
      {
         super();
         noticeView.owner.GetUI().visible = false;
         GV.MC_ToolView.y = 10000;
         this._data = new DigTreasureData();
         this._specialItemCtlDic = new Dictionary();
         this._viewItemCtlDic = new Dictionary();
         this._toolView = new DigTreasureToolView();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Clear);
         BC.addEvent(DigTreasureConfig.instance,GV.onlineSocket,"wordMapChang_over",this.wordMapChangHandler);
         var _mole:* = GV.MAN_PEOPLE;
         var vMC:MovieClip = _mole.avatarMC.Visualize_mc;
         vMC.graphics.beginFill(0,0);
         vMC.graphics.drawRect(vMC.x,vMC.y,-vMC.width,-vMC.height);
      }
      
      private function wordMapChangHandler(e:Event) : void
      {
         if(MapInfo.getMapInfo(GV.MapInfo_mapID).digTreasureId <= 0)
         {
            Pre_DigTreasure_Id = 0;
         }
      }
      
      public function Init(mapUI:MovieClip, mapId:int) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GIFTITEM,this.giftItemHandelr);
         this._mapUI = mapUI;
         this._mapId = mapId;
         GV.MC_Depth.mouseChildren = false;
         GV.MC_Depth.mouseEnabled = false;
         this._digTreasureId = MapInfo.getMapInfo(this._mapId).digTreasureId;
         BC.addOnceEvent(this,DigTreasureConfig.instance,DigTreasureConfig.InitOverEvent,this.ConfigInitOkHandler);
         DigTreasureConfig.instance.Init();
      }
      
      private function giftItemHandelr(evt:EventTaomee) : void
      {
         var obj:Object;
         var str:String;
         var url:String;
         var effloader:Loader = null;
         var f:Function = null;
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GIFTITEM,this.giftItemHandelr);
         obj = evt.EventObj;
         str = "　　恭喜你獲得" + obj.count + "個" + GoodsInfo.getItemNameByID(obj.id);
         PopupMsgCtl.PopupMsg(str);
         if(!obj)
         {
            return;
         }
         url = "resource/ui/getItemEffect.swf";
         effloader = new Loader();
         LibLogic.addLibEvent_getIcon(effloader,"showIcon",obj.id);
         f = function(E:Event):void
         {
            var p:PeopleManageView = GF.getPeopleByID(LocalUserInfo.getUserID()) as PeopleManageView;
            if(Boolean(p))
            {
               p.addEffect(effloader);
            }
            effloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,f);
         };
         effloader.contentLoaderInfo.addEventListener(Event.COMPLETE,f);
         effloader.load(VL.getURLRequest(url));
      }
      
      private function ConfigInitOkHandler(e:Event) : void
      {
         trace("init DigTreasure config ok ");
         var loader:URLLoader = new URLLoader();
         loader.load(VL.getURLRequest(Config_Url + this._digTreasureId + ".xml"));
         BC.addOnceEvent(this,loader,Event.COMPLETE,this.OnLoadDigMapConfig);
      }
      
      private function OnLoadDigMapConfig(e:Event) : void
      {
         var posList:XMLList;
         var treasures:XML;
         var xml:XML = new XML(e.target.data);
         this._config = xml.Screen.(@mapId == _mapId)[0];
         this._screenId = this._config.@screenId;
         if(this._config == null)
         {
            throw new Error(this._mapId + "地圖挖寶配置解析錯誤");
         }
         if(Pre_DigTreasure_Id != this._digTreasureId)
         {
            Pre_DigTreasure_Id = this._digTreasureId;
            PopupMsgCtl.ShowMapNameEffect("digTreasure_" + this._digTreasureId);
         }
         posList = this._config.child("RandTable");
         DigTreasureConfig.instance.posConfig = posList;
         treasures = this._config.child("treasures")[0];
         DigTreasureConfig.instance.treasuresInfo = treasures;
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GetDigMapInfoCmd,this.GetMapDigTreasureInfoHandler);
         DigTreasureSocket.GetDigMapInfo(this._digTreasureId,this._screenId);
      }
      
      private function GetMapDigTreasureInfoHandler(e:EventTaomee) : void
      {
         var itemCtl:IDigTreasureItemCtl = null;
         var itemObj:Object = null;
         var specialCtls:XMLList = null;
         var specialCtl:XML = null;
         var item:XML = null;
         var cls:Class = null;
         var digSpecialCtl:IDigTreasureSpecialCtl = null;
         this._toolView.Init(this._data);
         this.ShowDigToolView();
         var buttonMC:MovieClip = this._mapUI.buttonLevel;
         var controlMC:MovieClip = this._mapUI.control_mc;
         var areas:XMLList = this._config.child("Area");
         for(var i:int = 0; i < areas.length(); i++)
         {
            item = areas[i];
            itemCtl = this.CreateItemCtl(item);
            itemCtl.SetConfig(item,i);
            this._viewItemCtlDic[i] = itemCtl;
            itemCtl.Init(this,this._data);
            if(item.hasOwnProperty("@specialCtlId"))
            {
               this._specialItemCtlDic[int(item.@specialCtlId)] = itemCtl;
            }
            if(item.hasOwnProperty("@addTo") && item.@addTo == "upMole")
            {
               buttonMC.addChild(itemCtl.ui);
            }
            else
            {
               controlMC.addChild(itemCtl.ui);
            }
         }
         var data:Object = e.EventObj;
         for each(itemObj in data.areas)
         {
            itemCtl = this._viewItemCtlDic[itemObj.index];
            if(Boolean(itemCtl))
            {
               itemCtl.UpdateData(itemObj);
            }
         }
         specialCtls = this._config.child("SpecialCtl");
         for each(specialCtl in specialCtls)
         {
            cls = getDefinitionByName("com.module.digTreasure.view.spectialItem." + specialCtl.@cls) as Class;
            digSpecialCtl = new cls() as IDigTreasureSpecialCtl;
            digSpecialCtl.Init(this._mapUI,this,this._data);
         }
      }
      
      private function CreateItemCtl(data:XML) : IDigTreasureItemCtl
      {
         var itemCtl:IDigTreasureItemCtl = null;
         var type:int = int(data.@Type);
         switch(type)
         {
            case DigTreasureConfig.TYPE_MINE:
               itemCtl = new DigTreasureMineItem();
               break;
            case DigTreasureConfig.TYPE_BOSS:
               itemCtl = new DigTreasureBossItem();
               break;
            case DigTreasureConfig.TYPE_EVENT:
               itemCtl = new DigTreasureEventItem();
               break;
            case DigTreasureConfig.TYPE_TRIGGER:
               itemCtl = new DigTreasureTriggerItem();
               break;
            default:
               throw new Error(type + ":未定義的挖寶類型");
         }
         return itemCtl;
      }
      
      public function GetSpecialCtlItem(id:int) : IDigTreasureItemCtl
      {
         return this._specialItemCtlDic[id];
      }
      
      private function Clear(e:Event) : void
      {
         var item:IDigTreasureItemCtl = null;
         try
         {
            Mouse.show();
            BC.removeEvent(this);
            this.HideDigToolView();
            this._data.Clear();
            this._data = null;
            for each(item in this._viewItemCtlDic)
            {
               item.Clear();
               item = null;
            }
            this._viewItemCtlDic = null;
            this._toolView.Clear();
         }
         catch(e:Error)
         {
         }
      }
      
      private function ShowDigToolView() : void
      {
         noticeView.owner.GetUI().visible = false;
         this._toolView.ui.event_mc.buttonMode = true;
         GV.MC_ToolView.y = 10000;
         MainManager.getAppLevel().addChild(this._toolView.ui);
      }
      
      private function HideDigToolView() : void
      {
         GV.MC_ToolView.y = 340;
         this._toolView.Clear();
      }
   }
}

