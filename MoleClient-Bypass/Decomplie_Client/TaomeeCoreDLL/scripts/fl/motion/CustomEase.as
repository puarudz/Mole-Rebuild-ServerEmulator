package fl.motion
{
   import flash.geom.Point;
   
   [DefaultProperty("points")]
   public class CustomEase implements ITween
   {
      
      [ArrayElementType("flash.geom.Point")]
      public var points:Array;
      
      private var firstNode:Point;
      
      private var lastNode:Point;
      
      private var _target:String = "";
      
      public function CustomEase(xml:XML = null)
      {
         super();
         this.points = [];
         this.parseXML(xml);
         this.firstNode = new Point(0,0);
         this.lastNode = new Point(1,1);
      }
      
      internal static function getYForPercent(percent:Number, pts:Array) : Number
      {
         var bi:int = 0;
         var bez:BezierSegment = null;
         var bez0:BezierSegment = new BezierSegment(pts[0],pts[1],pts[2],pts[3]);
         var beziers:Array = [bez0];
         for(var i:int = 3; i < pts.length - 3; i += 3)
         {
            beziers.push(new BezierSegment(pts[i],pts[i + 1],pts[i + 2],pts[i + 3]));
         }
         var theRightBez:BezierSegment = bez0;
         if(pts.length >= 5)
         {
            for(bi = 0; bi < beziers.length; bi++)
            {
               bez = beziers[bi];
               if(bez.a.x <= percent && percent <= bez.d.x)
               {
                  theRightBez = bez;
                  break;
               }
            }
         }
         return theRightBez.getYForX(percent);
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(value:String) : void
      {
         this._target = value;
      }
      
      private function parseXML(xml:XML = null) : CustomEase
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
         var pts:Array = [this.firstNode].concat(this.points);
         pts.push(this.lastNode);
         var easedPercent:Number = getYForPercent(percent,pts);
         return begin + easedPercent * change;
      }
   }
}

