package com.module.home.itemCon
{
   import com.common.Alert.*;
   import com.event.EventTaomee;
   import com.module.home.HomeView;
   import com.mole.app.utils.PlayMovie;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SmallSnowPanel
   {
      
      private static var instance:SmallSnowPanel = null;
      
      public var Obj:Object;
      
      public var MeAlert:*;
      
      private var targetMC:MovieClip;
      
      private var isMe:Boolean;
      
      private var buyItemReq:*;
      
      private var buyItemRes:*;
      
      public var ListUIClass:Class;
      
      public var ListUI:Sprite;
      
      public var Man:Class;
      
      public var visitorPanel:*;
      
      private var len:uint;
      
      private var arrMC:Array = new Array();
      
      private var ScrollBar:*;
      
      private var myTimeout:*;
      
      private var MC:MovieClip;
      
      private var Panel:MovieClip;
      
      public var VisitorArr:Array;
      
      public var GoodsName:String = "友誼小樹葉";
      
      private var movie:PlayMovie;
      
      public function SmallSnowPanel()
      {
         super();
      }
      
      public static function getInstance() : SmallSnowPanel
      {
         return instance = instance || new SmallSnowPanel();
      }
      
      public function init(_targetMC:MovieClip) : void
      {
         this.arrMC = new Array();
         this.isMe = HomeView.ismyhome;
         this.targetMC = _targetMC;
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.ClickBox);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function ClickBox(e:MouseEvent) : void
      {
         if(!HomeView.getInstance().EditMode)
         {
            if(!this.movie)
            {
               this.movie = PlayMovie.play("resource/lucas/20131226/fallSnow.swf",null,null,function():void
               {
                  movie.destroy();
               },null,null,false);
            }
            else if(Boolean(this.movie) && this.movie.actived == false)
            {
               this.movie = PlayMovie.play("resource/lucas/20131226/fallSnow.swf",null,null,function():void
               {
                  movie.destroy();
               },null,null,false);
            }
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         if(Boolean(this.movie))
         {
            this.movie.destroy();
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         this.visitorPanel = null;
         this.Panel = null;
         BC.removeEvent(this);
      }
   }
}

