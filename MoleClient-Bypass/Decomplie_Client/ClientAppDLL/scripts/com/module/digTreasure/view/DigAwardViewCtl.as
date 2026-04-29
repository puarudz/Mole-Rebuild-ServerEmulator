package com.module.digTreasure.view
{
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.view.PeopleView.PeopleManageView;
   import fl.motion.easing.Bounce;
   import fl.transitions.Tween;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class DigAwardViewCtl extends Sprite
   {
      
      private static const FlyToPoint:Point = new Point(700,500);
      
      public var Throw_selected:int = -1;
      
      public var userID:int = -1;
      
      private var _awardId:int;
      
      private var _awardCount:int;
      
      private var _endOffsetX:Number;
      
      public function DigAwardViewCtl(awardId:int, awardCount:int, pos:Point, endOffsetX:Number)
      {
         super();
         this.buttonMode = true;
         this.x = pos.x;
         this.y = pos.y - 90;
         this._endOffsetX = endOffsetX;
         this._awardId = awardId;
         this._awardCount = awardCount;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Clear);
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(GoodsInfo.GetFullURLByItemId(awardId)));
         this.addChild(loader);
         tip.tipTailDisPlayObject(this,GoodsInfo.getItemNameByID(this._awardId) + "x" + this._awardCount);
         BC.addOnceEvent(this,this,MouseEvent.CLICK,this.OnMouseClick);
         scaleX = scaleY = 0.8;
         TweenLite.to(this,1,{
            "y":pos.y + 30,
            "ease":Bounce.easeOut
         });
         setTimeout(this.MoveDownOver,550);
      }
      
      private function MoveDownOver() : void
      {
         new Tween(this,"x",null,this.x,this.x + this._endOffsetX,0.4,true);
      }
      
      private function OnMouseClick(e:MouseEvent) : void
      {
         var bevel:GlowFilter;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         bevel = new GlowFilter();
         bevel.color = 16310155;
         bevel.alpha = 1;
         bevel.blurX = 10;
         bevel.blurY = 10;
         bevel.strength = 3;
         bevel.quality = BitmapFilterQuality.LOW;
         bevel.inner = false;
         bevel.knockout = false;
         var _temp_10:* = TweenLite;
         var _temp_9:* = this;
         var _temp_8:* = 1;
         var _temp_7:* = "x";
         var _temp_6:* = FlyToPoint.x;
         var _temp_5:* = "y";
         var _temp_4:* = FlyToPoint.y;
         var _temp_3:* = "alpha";
         var _temp_2:* = 0.5;
         var _temp_1:* = "onComplete";
         with({})
         {
            _temp_10.to(_temp_9,_temp_8,{
               _temp_7:_temp_6,
               _temp_5:_temp_4,
               _temp_3:_temp_2,
               _temp_1:function h():void
               {
                  var mole:* = undefined;
                  GC.clearAll(this);
                  BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GetDigAwardCmd,GetAwardOver);
                  DigTreasureSocket.GetDigAward(_awardId,_awardCount);
                  if(GoodsInfo.getInfoById(_awardId).GoodItems == 1)
                  {
                     mole = GV.MAN_PEOPLE as PeopleManageView;
                     mole.say("/wx");
                  }
               }
            });
         }
         
         private function GetAwardOver(e:EventTaomee) : void
         {
            var getAwardMC:MovieClip = DigTreasureConfig.instance.GetMovieClip("num_effect");
            var award:Object = e.EventObj;
            getAwardMC.tipsTxt.value_txt.text = GoodsInfo.getItemNameByID(award.id) + "x" + award.count;
            getAwardMC.x = FlyToPoint.x;
            getAwardMC.y = FlyToPoint.y;
            MainManager.getAppLevel().addChild(getAwardMC);
            this.Clear();
         }
         
         private function Clear(e:Event = null) : void
         {
            try
            {
               BC.removeEvent(this);
               GC.clearAll(this);
            }
            catch(e:Error)
            {
            }
         }
      }
   }
   
   