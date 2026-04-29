package fl.motion
{
   import flash.geom.Point;
   
   [DefaultProperty("points")]
   public class BezierEase implements ITween
   {
      
      [ArrayElementType("flash.geom.Point")]
      public var points:Array;
      
      private var firstNode:Point;
      
      private var lastNode:Point;
      
      private var _target:String = "";
      
      public function BezierEase(xml:XML = null)
      {
         super();
         this.points = [];
         this.parseXML(xml);
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(value:String) : void
      {
         this._target = value;
      }
      
      private function parseXML(xml:XML = null) : BezierEase
      {
         var child:XML = null;
         if(!xml)
         {
            return this;
         }
         if(Boolean(xml.@target.length()))
         {
            this.target = xml.@target;
         }
         var elements:XMLList = xml.elements();
         for each(child in elements)
         {
            this.points.push(new Point(Number(child.@x),Number(child.@y)));
         }
         return this;
      }
      
      public function getValue(time:Number, begin:Number, change:Number, duration:Number) : Number
      {
         if(duration <= 0)
         {
            return NaN;
         }
         var percent:Number = time / duration;
         if(percent <= 0)
         {
            return begin;
         }
         if(percent >= 1)
         {
            return begin + change;
         }
         this.firstNode = new Point(0,begin);
         this.lastNode = new Point(1,begin + change);
         var pts:Array = [this.firstNode].concat(this.points);
         pts.push(this.lastNode);
         return CustomEase.getYForPercent(percent,pts);
      }
   }
}

