package com.view.mapView
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.module.activityModule.SoundControlModule;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class NierLaTowerSecView extends MapBase
   {
      
      private static var hasPlayMovie:Boolean = false;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var type_mc:MovieClip;
      
      private var test_mc:MovieClip;
      
      public var dragBool:Boolean;
      
      public var get2stone:Boolean;
      
      public var hitnum:uint = 0;
      
      public var stonePosArr:Array;
      
      private var mcloader:MCLoader;
      
      private var loadPath:String = "module/external/taskMc/";
      
      public function NierLaTowerSecView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.test_mc = GV.MC_mapFrame["test_mc"];
         this.stonePosArr = new Array();
         this.target_mc.hammer.buttonMode = true;
         BC.addEvent(this,this.botton_mc.stone_tip.close_btn,MouseEvent.CLICK,this.closeTip);
         BC.addEvent(this,this.botton_mc.move_MC,MouseEvent.CLICK,this.opennierla);
         BC.addEvent(this,this.target_mc.stone_tip,MouseEvent.CLICK,this.showTip);
         BC.addEvent(this,this.target_mc.hammer,MouseEvent.CLICK,this.clickhammer);
         for(var i:uint = 0; i < 5; i++)
         {
            this.stonePosArr.push(new Point(this.target_mc["stone" + i].x,this.target_mc["stone" + i].y));
            this.target_mc["stone" + i].buttonMode = true;
            BC.addEvent(this,this.target_mc["stone" + i],MouseEvent.CLICK,this.clickstone);
            if(i < 4)
            {
               BC.addEvent(this,this.target_mc["down" + i],MouseEvent.CLICK,this.clickdownstone);
            }
         }
         this.target_mc.map184_btn.buttonMode = true;
         BC.addEvent(this,this.target_mc.map184_btn,MouseEvent.CLICK,this.gotoMapMcFun);
      }
      
      private function gotoMapMcFun(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"switchMap",this.gotoMap184Fun);
         this.loadSwf(MainManager.getAppLevel(),"map93to184");
      }
      
      private function gotoMap184Fun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"switchMap",this.gotoMap184Fun);
         this.switchMap(184);
      }
      
      private function loadSwf(targetMc:DisplayObjectContainer, mcName:String, _fun:Function = null) : void
      {
         this.mcloader = new MCLoader(this.loadPath + mcName + ".swf",targetMc,Loading.TITLE_AND_PERCENT,"正在加載。。。");
         this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadOver);
         this.mcloader.addEventListener(MCLoadEvent.ERROR,this.failLoadUI);
         this.mcloader.load();
      }
      
      private function onLoadOver(evt:MCLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(MovieClip(evt.getContent()));
      }
      
      private function failLoadUI(evt:MCLoadEvent) : void
      {
      }
      
      private function switchMap(mapID:int) : void
      {
         if(GV.MapInfo_mapID != mapID)
         {
            GF.switchMap(mapID,true);
         }
      }
      
      private function opennierla(e:MouseEvent) : void
      {
         if(this.botton_mc.move_MC.currentFrame == this.botton_mc.move_MC.totalFrames)
         {
            SoundControlModule.getInstance().stopSund();
            new LoadGame("resource/movie/nierla.swf","正在加載拉姆王的故事",MainManager.getTopLevel());
         }
      }
      
      private function showTip(e:MouseEvent) : void
      {
         this.botton_mc.stone_tip.y = 225.6;
      }
      
      private function closeTip(e:MouseEvent) : void
      {
         this.botton_mc.stone_tip.y = -1000;
      }
      
      private function clickdownstone(e:MouseEvent) : void
      {
         var i:uint = 0;
         var down:MovieClip = e.currentTarget as MovieClip;
         if(Boolean(down.currentLabel))
         {
            if(down.currentLabel.slice(-8) == "downstop")
            {
               i = uint(down.currentLabel.slice(-9,-8));
               this.target_mc["stone" + i].visible = true;
               this.target_mc["stone" + i].x = this.stonePosArr[i].x;
               this.target_mc["stone" + i].y = this.stonePosArr[i].y;
               down.play();
               this.target_mc.snd.gotoAndPlay(2);
               this.target_mc.arrow.prevFrame();
            }
         }
      }
      
      private function clickstone(e:MouseEvent) : void
      {
         var i:uint = 0;
         var stone:* = e.currentTarget;
         if(!stone.dragBool)
         {
            stone.dragBool = true;
            stone.startDrag(true);
         }
         else
         {
            stone.dragBool = false;
            stone.stopDrag();
            for(i = 0; i < 4; i++)
            {
               if(Boolean(this.target_mc["down" + i].touch) && Boolean(this.target_mc["down" + i].touch.hitTestObject(stone)))
               {
                  stone.visible = false;
                  this.target_mc["down" + i].gotoAndPlay(stone.name + "down");
                  this.target_mc.snd.gotoAndPlay(2);
                  if(this.target_mc.arrow.currentFrame == 4)
                  {
                     this.win();
                  }
                  this.target_mc.arrow.nextFrame();
                  return;
               }
            }
         }
      }
      
      private function win() : void
      {
         this.botton_mc.move_MC.gotoAndPlay(2);
         this.topMC.shadow.visible = false;
      }
      
      private function clickhammer(e:MouseEvent) : void
      {
         if(!this.get2stone)
         {
            if(!this.dragBool)
            {
               this.target_mc.hammer.startDrag();
               this.dragBool = true;
            }
            else
            {
               this.dragBool = false;
               this.target_mc.hammer.gotoAndPlay(2);
               if(Boolean(this.target_mc.stone4.visible) && Boolean(this.target_mc.stone4.hitTestObject(this.target_mc.hammer)))
               {
                  this.get2stone = true;
                  setTimeout(this.show2stone,1200);
               }
            }
         }
      }
      
      private function show2stone() : void
      {
         this.target_mc.hammer.visible = false;
         this.target_mc.stone4.visible = false;
         this.target_mc.stone2.visible = true;
         this.target_mc.stone3.visible = true;
      }
      
      override public function destroy() : void
      {
         this.target_mc.hammer.stopDrag();
         BC.removeEvent(this);
         super.destroy();
      }
   }
}

