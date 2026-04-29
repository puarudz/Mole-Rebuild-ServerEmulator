package com.logic.mapEvent
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.ServerListManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.mole.app.map.MapManager;
   import com.view.toolView.toolView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.Tick;
   
   public class WordMapLogic_DXSL
   {
      
      private var mapMC:MovieClip;
      
      private var hoverMap:DisplayObject;
      
      public function WordMapLogic_DXSL(map:*)
      {
         var dobj:DisplayObject = null;
         var mapId:uint = 0;
         super();
         this.mapMC = map.content.root;
         var serID:* = GV.serverID;
         var serName:String = ServerListManager.getServerName(serID);
         this.mapMC.serAdd.text = "你所在的伺服器是:" + serID + "." + serName;
         BC.addEvent(this,this.mapMC.closeBtn,MouseEvent.CLICK,this.closeBtnClick);
         var len:int = MovieClip(this.mapMC.map_btn).numChildren;
         var inCurMapSet:Boolean = false;
         for(var ix:int = 0; ix < len; ix++)
         {
            dobj = MovieClip(this.mapMC.map_btn).getChildAt(ix);
            mapId = uint(int(dobj.name.substring(4)));
            if(mapId == LocalUserInfo.getMapID())
            {
               this.mapMC.mole_mc.x = this.mapMC.map_btn["btn_" + mapId].x;
               this.mapMC.mole_mc.y = this.mapMC.map_btn["btn_" + mapId].y;
               inCurMapSet = true;
            }
            dobj.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            dobj.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            dobj.addEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         }
         if(!inCurMapSet)
         {
            this.mapMC.mole_mc.x = this.mapMC.map_btn["btn_1"].x;
            this.mapMC.mole_mc.y = this.mapMC.map_btn["btn_1"].y;
         }
      }
      
      private function closeMap(evt:EventTaomee) : void
      {
         this.closeBtnClick();
      }
      
      private function mouseOverHandler(evt:MouseEvent) : void
      {
         this.hoverMap = DisplayObject(evt.currentTarget);
         Tick.instance.addTimeout(500,this.showTip);
      }
      
      private function showTip() : void
      {
         var mapinfo:MapInfo = null;
         var tempMap:int = 0;
         var firstMap:int = 0;
         if(Boolean(this.hoverMap))
         {
            this.mapMC.tips.visible = true;
            mapinfo = MapInfo.getMapInfo(int(this.hoverMap.name.substring(4)));
            this.mapMC.tips.title.title_txt.text = mapinfo.name;
            if(int(this.hoverMap.name.substring(4)) == 120)
            {
               this.mapMC.tips.title.title_txt.text = "黑森林";
            }
            tempMap = LocalUserInfo.getMapID();
            if(tempMap < 1000)
            {
               firstMap = int(MapsConfig.MapsInfo[LocalUserInfo.getMapID()].firstMap);
               if(firstMap == int(this.hoverMap.name.substring(4)))
               {
                  this.mapMC.tips.dec_txt.text = "我在這裡";
                  this.mapMC.tips.dec_txt.textColor = 26316;
               }
               else
               {
                  this.mapMC.tips.dec_txt.text = "點擊前往";
                  this.mapMC.tips.dec_txt.textColor = 6710886;
               }
            }
            else
            {
               this.mapMC.tips.dec_txt.text = "點擊前往";
               this.mapMC.tips.dec_txt.textColor = 6710886;
            }
            this.mapMC.tips.x = this.hoverMap.x - this.hoverMap.width / 2;
            this.mapMC.tips.y = this.hoverMap.y;
         }
      }
      
      private function mouseOutHandler(evt:MouseEvent) : void
      {
         this.hoverMap = null;
         if(Boolean(this.mapMC.tips))
         {
            this.mapMC.tips.visible = false;
         }
      }
      
      private function mouseClickHandler(evt:MouseEvent) : void
      {
         this.closeBtnClick();
         var clickObj:DisplayObject = evt.currentTarget as DisplayObject;
         if(int(clickObj.name.substring(4)) == 120)
         {
            toolView.getInstance().goMapFunc(2);
         }
         else if(int(clickObj.name.substring(4)) == 1)
         {
            toolView.getInstance().goMapFunc(1);
         }
         else
         {
            MapManager.enterMap(int(clickObj.name.substring(4)));
         }
      }
      
      private function closeBtnClick(event:MouseEvent = null) : void
      {
         var dobj:DisplayObject = null;
         Tick.instance.removeTimeout(this.showTip);
         BC.removeEvent(this);
         var len:int = MovieClip(this.mapMC.map_btn).numChildren;
         for(var ix:int = 0; ix < len; ix++)
         {
            dobj = MovieClip(this.mapMC.map_btn).getChildAt(ix);
            dobj.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            dobj.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            dobj.removeEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         }
         try
         {
            if(event.target.name == "closeBtn")
            {
               GV.JobViews.del("close_worldMapUI");
            }
         }
         catch(e:*)
         {
         }
         GC.clearAll(MainManager.getGameLevel().getChildByName("mapMC"));
      }
   }
}

