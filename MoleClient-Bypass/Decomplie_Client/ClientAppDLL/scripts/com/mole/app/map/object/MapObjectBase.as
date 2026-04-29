package com.mole.app.map.object
{
   import com.common.tip.tip;
   import com.event.EventTaomee;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.manager.MoleActionManager;
   import com.mole.app.map.MapLevel;
   import com.mole.debug.DebugManager;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.loader.ContentInfo;
   
   public class MapObjectBase
   {
      
      protected var _tar_mc:MovieClip;
      
      private var _tri_mc:DisplayObject;
      
      protected var _actionInfo:MoleActionInfo;
      
      protected var _frontPos:Point;
      
      protected var _tips:String;
      
      protected var _resName:String;
      
      protected var _levelName:String;
      
      protected var _configXML:XML;
      
      protected var _npcLoadCompleteHandler:Function;
      
      public function MapObjectBase(levelName:String, resName:String, config:XML)
      {
         var level_mc:DisplayObject = null;
         var res_mc:DisplayObject = null;
         super();
         this._actionInfo = new MoleActionInfo();
         this._actionInfo.initXML(config);
         var mapLevel:MapLevel = MapManageView.inst.mapLevel;
         this._levelName = levelName;
         this._resName = resName;
         this._configXML = config;
         if(mapLevel.hasOwnProperty(levelName))
         {
            level_mc = mapLevel[levelName];
            if(level_mc.hasOwnProperty(resName))
            {
               this._tar_mc = level_mc[resName];
               this.setTarAttribute(config);
            }
            else
            {
               DebugManager.traceMsg(levelName + "層中找不到元件：" + resName + "。開始創建該元件。");
               CacheManager.getPhasorContent(this.getObjectURL(),resName,this.onLoaderComplete);
            }
         }
         else
         {
            DebugManager.traceMsg("地圖中找不到層：" + levelName);
         }
         GV.onlineSocket.addEventListener("MapObjectDisappear",this.onMapObjectDisappearHandler);
      }
      
      protected function onMapObjectDisappearHandler(evt:EventTaomee) : void
      {
      }
      
      protected function getObjectURL() : String
      {
         return "";
      }
      
      protected function setTarAttribute(config:XML) : void
      {
         this._tar_mc.mouseChildren = false;
         this._tar_mc.gotoAndStop(1);
         this._tar_mc.buttonMode = true;
         this._tar_mc.stop();
         this._frontPos = new Point(uint(config.@Ex),uint(config.@Ey));
         if(config.@Layer == "depthLevel")
         {
            this._tri_mc = MapButtonView.regeditEvent(this._tar_mc,this.onDisClick);
         }
         else
         {
            this._tri_mc = this._tar_mc;
            this._tri_mc.addEventListener(MouseEvent.CLICK,this.onDisClick);
         }
         this._tri_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onDisOver);
         this._tri_mc.addEventListener(MouseEvent.MOUSE_OUT,this.onDisOut);
         this._tips = config.@Tips;
         if(Boolean(this._tips))
         {
            tip.tipTailDisPlayObject(this._tri_mc,this._tips);
         }
      }
      
      private function onLoaderComplete(contentInfo:ContentInfo) : void
      {
         var level_mc:MovieClip = null;
         this._tar_mc = contentInfo.content;
         this._tar_mc.x = this._configXML.@Px;
         this._tar_mc.y = this._configXML.@Py;
         var mapLevel:MapLevel = MapManageView.inst.mapLevel;
         if(mapLevel.hasOwnProperty(this._levelName))
         {
            level_mc = mapLevel[this._levelName];
            if(!level_mc.hasOwnProperty(this._resName))
            {
               level_mc.addChild(this._tar_mc);
               this._tar_mc.name = this._resName;
               this.setTarAttribute(this._configXML);
            }
            else
            {
               DebugManager.traceMsg(this._levelName + "層中存在npc：" + this._resName);
            }
            if(this._npcLoadCompleteHandler != null)
            {
               this._npcLoadCompleteHandler();
            }
         }
         else
         {
            DebugManager.traceMsg("地圖中找不到層：" + this._levelName);
         }
      }
      
      protected function onDisOver(e:MouseEvent) : void
      {
         this._tar_mc.gotoAndStop(2);
      }
      
      protected function onDisOut(e:MouseEvent) : void
      {
         this._tar_mc.gotoAndStop(1);
      }
      
      protected function onDisClick(e:MouseEvent) : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         var tmpDis:Number = Point.distance(new Point(peopleView.x,peopleView.y),this._frontPos);
         if(tmpDis < 15)
         {
            MoleActionManager.doAction(this._actionInfo);
         }
         else if(peopleView.moveTo(this._frontPos.x,this._frontPos.y) == false)
         {
            MoleActionManager.doAction(this._actionInfo);
            DebugManager.traceMsg("目標點為不可行走區，檢查素材吧！",false);
         }
         else
         {
            peopleView.addEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
            GV.onlineSocket.dispatchEvent(new EventTaomee(PeopleEvent.READY_MOVE));
         }
      }
      
      protected function onGoOver(e:Event) : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         if(peopleView.x == this._frontPos.x && peopleView.y == this._frontPos.y)
         {
            MoleActionManager.doAction(this._actionInfo);
         }
      }
      
      public function destroy() : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         if(Boolean(this._tri_mc))
         {
            this._tri_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.onDisOver);
            this._tri_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.onDisOut);
            this._tri_mc.removeEventListener(MouseEvent.CLICK,this.onDisClick);
            this._tri_mc = null;
         }
      }
   }
}

