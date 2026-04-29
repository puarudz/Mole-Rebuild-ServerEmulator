package com.module.digTreasure.view.spectialItem
{
   import com.core.info.MapInfo;
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.module.digTreasure.data.DigTreasureData;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class RayLineCtl_map189 implements IDigTreasureSpecialCtl
   {
      
      private static var DigTreasure_id:int = -1;
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _hideBoxMC:MovieClip;
      
      private var _tragger_1:IDigTreasureItemCtl;
      
      private var _tragger_2:IDigTreasureItemCtl;
      
      private var _tragger_3:IDigTreasureItemCtl;
      
      private var _tragger_4:IDigTreasureItemCtl;
      
      private var _tragger_5:IDigTreasureItemCtl;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _shape:Shape = new Shape();
      
      public function RayLineCtl_map189()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._hideBoxMC = this._mapUI.buttonLevel.hideBox_mc;
         this._viewCtl = View;
         this._tragger_1 = this._viewCtl.GetSpecialCtlItem(1);
         this._tragger_2 = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger_3 = this._viewCtl.GetSpecialCtlItem(3);
         this._tragger_4 = this._viewCtl.GetSpecialCtlItem(4);
         this._tragger_5 = this._viewCtl.GetSpecialCtlItem(5);
         this._boss = this._viewCtl.GetSpecialCtlItem(6);
         this._dataCtl = dataCtl;
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
         this.CheckState(null);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(DigTreasureConfig.instance,GV.onlineSocket,"wordMapChang_over",this.wordMapChangHandler);
      }
      
      private function wordMapChangHandler(e:Event) : void
      {
         if(MapInfo.getMapInfo(GV.MapInfo_mapID).digTreasureId <= 0)
         {
            DigTreasure_id = -1;
         }
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function CheckState(e:Event) : void
      {
         if(this._tragger_1.state == 2 && this._tragger_2.state == 2 && this._tragger_3.state == 2 && this._tragger_4.state == 2 && this._tragger_5.state == 2)
         {
            BC.removeEvent(this);
            this._tragger_1.ui.buttonMode = false;
            this._tragger_1.ui.mouseEnabled = false;
            this._tragger_1.ClearMouseEvent();
            this._tragger_2.ui.buttonMode = false;
            this._tragger_2.ui.mouseEnabled = false;
            this._tragger_2.ClearMouseEvent();
            this._tragger_3.ui.buttonMode = false;
            this._tragger_3.ui.mouseEnabled = false;
            this._tragger_3.ClearMouseEvent();
            this._tragger_4.ui.buttonMode = false;
            this._tragger_4.ui.mouseEnabled = false;
            this._tragger_4.ClearMouseEvent();
            this._tragger_5.ui.buttonMode = false;
            this._tragger_5.ui.mouseEnabled = false;
            this._tragger_5.ClearMouseEvent();
            if(DigTreasure_id == DigTreasureViewCtl.Pre_DigTreasure_Id)
            {
               this._hideBoxMC.visible = false;
               GC.clearAll(this._hideBoxMC);
            }
            else
            {
               this._hideBoxMC.gotoAndPlay(2);
               SoundManager.play("resource/digTreasure/sound/fa_guang.mp3");
            }
            DigTreasure_id = DigTreasureViewCtl.Pre_DigTreasure_Id;
         }
         this.showShape();
      }
      
      private function showShape() : void
      {
         var traggers:Array = null;
         var startPoint:Point = null;
         var tragger:Object = null;
         var endPoint:Point = null;
         var angel:Number = NaN;
         var bevel:GlowFilter = new GlowFilter();
         bevel.color = 65280;
         bevel.alpha = 0.9;
         bevel.blurX = 3;
         bevel.blurY = 3;
         bevel.strength = 50;
         bevel.quality = BitmapFilterQuality.LOW;
         bevel.inner = true;
         bevel.knockout = true;
         this._shape.filters = [bevel];
         this._shape.graphics.clear();
         this._shape.graphics.lineStyle(4,65535,0.8);
         this._mapUI.control_mc.addChild(this._shape);
         if(this._tragger_1.state == 2)
         {
            traggers = [this._tragger_2,this._tragger_3,this._tragger_4,this._tragger_5,this._boss];
            startPoint = new Point(this._tragger_1.x,this._tragger_1.y);
            for each(tragger in traggers)
            {
               endPoint = new Point(tragger.x,tragger.y);
               angel = Math.atan2(endPoint.y - startPoint.y,endPoint.x - startPoint.x);
               if(!(tragger.state == 2 || tragger == this._boss))
               {
                  this._shape.graphics.moveTo(startPoint.x,startPoint.y);
                  this._shape.graphics.lineTo(2000 * Math.cos(angel) + startPoint.x,2000 * Math.sin(angel) + startPoint.y);
                  return;
               }
               this._shape.graphics.moveTo(startPoint.x,startPoint.y);
               this._shape.graphics.lineTo(endPoint.x,endPoint.y);
               startPoint = endPoint;
            }
         }
      }
   }
}

