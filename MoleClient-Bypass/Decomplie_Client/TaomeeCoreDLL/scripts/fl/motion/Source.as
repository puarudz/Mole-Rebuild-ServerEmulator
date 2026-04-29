package fl.motion
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Source
   {
      
      public var frameRate:Number = NaN;
      
      public var elementType:String = "";
      
      public var symbolName:String = "";
      
      public var instanceName:String = "";
      
      public var linkageID:String = "";
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var skewX:Number = 0;
      
      public var skewY:Number = 0;
      
      public var rotation:Number = 0;
      
      public var transformationPoint:Point;
      
      public var dimensions:Rectangle;
      
      public function Source(xml:XML = null)
      {
         super();
         this.parseXML(xml);
      }
      
      private function parseXML(xml:XML = null) : Source
      {
         var child:XML = null;
         var pointXML:XML = null;
         var dimXML:XML = null;
         if(!xml)
         {
            return this;
         }
         if(Boolean(xml.@instanceName))
         {
            this.instanceName = String(xml.@instanceName);
         }
         if(Boolean(xml.@symbolName))
         {
            this.symbolName = String(xml.@symbolName);
         }
         if(Boolean(xml.@linkageID))
         {
            this.linkageID = String(xml.@linkageID);
         }
         if(!isNaN(xml.@frameRate))
         {
            this.frameRate = Number(xml.@frameRate);
         }
         var elements:XMLList = xml.elements();
         for each(child in elements)
         {
            if(child.localName() == "transformationPoint")
            {
               pointXML = child.children()[0];
               this.transformationPoint = new Point(Number(pointXML.@x),Number(pointXML.@y));
            }
            else if(child.localName() == "dimensions")
            {
               dimXML = child.children()[0];
               this.dimensions = new Rectangle(Number(dimXML.@left),Number(dimXML.@top),Number(dimXML.@width),Number(dimXML.@height));
            }
         }
         return this;
      }
   }
}

