package com.module.pig
{
   import com.common.util.MovieClipUtil;
   import com.module.LocusWork.NumSprite;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PigEffectCtl
   {
      
      private static var _effects:Array;
      
      private static var _timer:Timer;
      
      public static const Type_effect_deleteTime:String = "effect_deleteTime";
      
      public static const Type_effect_exp:String = "effect_exp";
      
      public static const Type_effect_glamour:String = "effect_glamour";
      
      public static const Type_effect_gold:String = "effect_gold";
      
      public static const Type_effect_strength:String = "effect_strength";
      
      public static const Type_effect_variation:String = "effect_variation";
      
      public static const Type_effect_weight:String = "effect_weight";
      
      public static const Type_effect_age:String = "effect_age";
      
      public static const Type_effect_growup:String = "effect_growup";
      
      public static const Type_effect_addPig:String = "effect_addPig";
      
      public static const Type_effect_twoBaby:String = "effect_twoBaby";
      
      private var _ui:MovieClip;
      
      private var _type:String;
      
      private var _value:int;
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function PigEffectCtl(type:String, value:int, x:Number, y:Number, isPlayNow:Boolean = true)
      {
         super();
         this._type = type;
         this._value = value;
         this._x = x;
         this._y = y;
         if(isPlayNow)
         {
            this.Play();
         }
      }
      
      public static function AddEffectToPlayQueue(type:String, value:int, x:Number, y:Number) : void
      {
         if(_effects == null)
         {
            _effects = new Array();
         }
         if(_timer == null)
         {
            _timer = new Timer(1.3 * 1000,1);
            BC.addEvent(_timer,_timer,TimerEvent.TIMER_COMPLETE,PlayNext);
         }
         _effects.push(new PigEffectCtl(type,value,x,y,false));
         if(_timer.running == false)
         {
            PlayNext();
         }
      }
      
      private static function PlayNext(e:TimerEvent = null) : void
      {
         if(_effects.length > 0)
         {
            PigEffectCtl(_effects.shift()).Play();
            _timer.start();
         }
      }
      
      public static function Clear() : void
      {
         BC.removeEvent(_timer);
         if(Boolean(_timer))
         {
            _timer.stop();
            _timer = null;
            _effects = null;
         }
      }
      
      public function Play() : void
      {
         this._ui = PigHouseUI.instance.GetMovieClip(this._type);
         MovieClipUtil.playEndAndRemove(this._ui);
         if(Boolean(this._ui.num_mc))
         {
            new NumSprite(this._ui.num_mc,this._value,false,true);
         }
         this._ui.x = this._x;
         this._ui.y = this._y;
         GV.MC_mapTop.addChild(this._ui);
      }
   }
}

