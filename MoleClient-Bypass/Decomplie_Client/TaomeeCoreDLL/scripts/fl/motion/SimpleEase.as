package fl.motion
{
   public class SimpleEase implements ITween
   {
      
      private var _ease:Number = 0;
      
      private var _target:String = "";
      
      public function SimpleEase(xml:XML = null)
      {
         super();
         this.parseXML(xml);
      }
      
      public static function easeQuadPercent(time:Number, begin:Number, change:Number, duration:Number, percent:Number) : Number
      {
         if(duration <= 0)
         {
            return NaN;
         }
         if(time <= 0)
         {
            return begin;
         }
         time = time / duration;
         if(time >= 1)
         {
            return begin + change;
         }
         if(!percent)
         {
            return change * time + begin;
         }
         if(percent > 1)
         {
            percent = 1;
         }
         else if(percent < -1)
         {
            percent = -1;
         }
         if(percent < 0)
         {
            return change * time * (time * -percent + (1 + percent)) + begin;
         }
         return change * time * ((2 - time) * percent + (1 - percent)) + begin;
      }
      
      public static function easeNone(time:Number, begin:Number, change:Number, duration:Number) : Number
      {
         if(duration <= 0)
         {
            return NaN;
         }
         if(time <= 0)
         {
            return begin;
         }
         if(time >= duration)
         {
            return begin + change;
         }
         return change * time / duration + begin;
      }
      
      public function get ease() : Number
      {
         return this._ease;
      }
      
      public function set ease(value:Number) : void
      {
         this._ease = value > 1 ? 1 : (value < -1 ? -1 : (isNaN(value) ? 0 : value));
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(value:String) : void
      {
         this._target = value;
      }
      
      private function parseXML(xml:XML = null) : SimpleEase
      {
         if(Boolean(xml))
         {
            if(Boolean(xml.@ease.length()))
            {
               this.ease = Number(xml.@ease);
            }
            if(Boolean(xml.@target.length()))
            {
               this.target = xml.@target;
            }
         }
         return this;
      }
      
      public function getValue(time:Number, begin:Number, change:Number, duration:Number) : Number
      {
         return easeQuadPercent(time,begin,change,duration,this.ease);
      }
   }
}

