package fl.motion
{
   import flash.geom.Point;
   
   public class BezierSegment
   {
      
      public var a:Point;
      
      public var b:Point;
      
      public var c:Point;
      
      public var d:Point;
      
      public function BezierSegment(a:Point, b:Point, c:Point, d:Point)
      {
         super();
         this.a = a;
         this.b = b;
         this.c = c;
         this.d = d;
      }
      
      public static function getSingleValue(t:Number, a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0) : Number
      {
         return (t * t * (d - a) + 3 * (1 - t) * (t * (c - a) + (1 - t) * (b - a))) * t + a;
      }
      
      public static function getCubicCoefficients(a:Number, b:Number, c:Number, d:Number) : Array
      {
         return [-a + 3 * b - 3 * c + d,3 * a - 6 * b + 3 * c,-3 * a + 3 * b,a];
      }
      
      public static function getCubicRoots(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0) : Array
      {
         var theta:Number = NaN;
         var qSqrt:Number = NaN;
         var root1:Number = NaN;
         var root2:Number = NaN;
         var root3:Number = NaN;
         var tmp:Number = NaN;
         var rSign:int = 0;
         var root:Number = NaN;
         if(!a)
         {
            return BezierSegment.getQuadraticRoots(b,c,d);
         }
         if(a != 1)
         {
            b /= a;
            c /= a;
            d /= a;
         }
         var q:Number = (b * b - 3 * c) / 9;
         var qCubed:Number = q * q * q;
         var r:Number = (2 * b * b * b - 9 * b * c + 27 * d) / 54;
         var diff:Number = qCubed - r * r;
         if(diff >= 0)
         {
            if(!q)
            {
               return [0];
            }
            theta = Math.acos(r / Math.sqrt(qCubed));
            qSqrt = Math.sqrt(q);
            root1 = -2 * qSqrt * Math.cos(theta / 3) - b / 3;
            root2 = -2 * qSqrt * Math.cos((theta + 2 * Math.PI) / 3) - b / 3;
            root3 = -2 * qSqrt * Math.cos((theta + 4 * Math.PI) / 3) - b / 3;
            return [root1,root2,root3];
         }
         tmp = Math.pow(Math.sqrt(-diff) + Math.abs(r),1 / 3);
         rSign = r > 0 ? 1 : (r < 0 ? -1 : 0);
         root = -rSign * (tmp + q / tmp) - b / 3;
         return [root];
      }
      
      public static function getQuadraticRoots(a:Number, b:Number, c:Number) : Array
      {
         var tmp:Number = NaN;
         var roots:Array = [];
         if(!a)
         {
            if(!b)
            {
               return [];
            }
            roots[0] = -c / b;
            return roots;
         }
         var q:Number = b * b - 4 * a * c;
         var signQ:int = q > 0 ? 1 : (q < 0 ? -1 : 0);
         if(signQ < 0)
         {
            return [];
         }
         if(!signQ)
         {
            roots[0] = -b / (2 * a);
         }
         else
         {
            roots[0] = roots[1] = -b / (2 * a);
            tmp = Math.sqrt(q) / (2 * a);
            roots[0] -= tmp;
            roots[1] += tmp;
         }
         return roots;
      }
      
      public function getValue(t:Number) : Point
      {
         var ax:Number = this.a.x;
         var x:Number = (t * t * (this.d.x - ax) + 3 * (1 - t) * (t * (this.c.x - ax) + (1 - t) * (this.b.x - ax))) * t + ax;
         var ay:Number = this.a.y;
         var y:Number = (t * t * (this.d.y - ay) + 3 * (1 - t) * (t * (this.c.y - ay) + (1 - t) * (this.b.y - ay))) * t + ay;
         return new Point(x,y);
      }
      
      public function getYForX(x:Number, coefficients:Array = null) : Number
      {
         var root:Number = NaN;
         if(this.a.x < this.d.x)
         {
            if(x <= this.a.x + 1e-16)
            {
               return this.a.y;
            }
            if(x >= this.d.x - 1e-16)
            {
               return this.d.y;
            }
         }
         else
         {
            if(x >= this.a.x + 1e-16)
            {
               return this.a.y;
            }
            if(x <= this.d.x - 1e-16)
            {
               return this.d.y;
            }
         }
         if(!coefficients)
         {
            coefficients = getCubicCoefficients(this.a.x,this.b.x,this.c.x,this.d.x);
         }
         var roots:Array = getCubicRoots(coefficients[0],coefficients[1],coefficients[2],coefficients[3] - x);
         var time:Number = NaN;
         if(roots.length == 0)
         {
            time = 0;
         }
         else if(roots.length == 1)
         {
            time = Number(roots[0]);
         }
         else
         {
            for each(root in roots)
            {
               if(0 <= root && root <= 1)
               {
                  time = root;
                  break;
               }
            }
         }
         if(isNaN(time))
         {
            return NaN;
         }
         return getSingleValue(time,this.a.y,this.b.y,this.c.y,this.d.y);
      }
   }
}

