package fl.motion
{
   import flash.utils.*;
   
   public class FunctionEase implements ITween
   {
      
      private var _functionName:String = "";
      
      public var easingFunction:Function = null;
      
      public var parameters:Array = null;
      
      private var _target:String = "";
      
      public function FunctionEase(xml:XML = null)
      {
         super();
         this.parseXML(xml);
      }
      
      public function get functionName() : String
      {
         return this._functionName;
      }
      
      public function set functionName(newName:String) : void
      {
         var parts:Array = newName.split(".");
         var methodName:String = parts.pop();
         var className:String = parts.join(".");
         var theClass:Class = getDefinitionByName(className) as Class;
         if(theClass[methodName] is Function)
         {
            this.easingFunction = theClass[methodName];
            this._functionName = newName;
         }
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(value:String) : void
      {
         this._target = value;
      }
      
      private function parseXML(xml:XML = null) : FunctionEase
      {
         if(!xml)
         {
            return this;
         }
         if(Boolean(xml.@functionName.length()))
         {
            this.functionName = xml.@functionName;
         }
         if(Boolean(xml.@target.length()))
         {
            this.target = xml.@target;
         }
         return this;
      }
      
      public function getValue(time:Number, begin:Number, change:Number, duration:Number) : Number
      {
         var args:Array = null;
         if(this.parameters is Array)
         {
            args = [time,begin,change,duration].concat(this.parameters);
            return this.easingFunction.apply(null,args);
         }
         return this.easingFunction(time,begin,change,duration);
      }
   }
}

