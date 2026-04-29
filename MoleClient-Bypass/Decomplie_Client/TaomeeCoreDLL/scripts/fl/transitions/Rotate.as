package fl.transitions
{
   import flash.display.*;
   
   public class Rotate extends Transition
   {
      
      protected var _rotationFinal:Number = NaN;
      
      protected var _degrees:Number = 360;
      
      public function Rotate(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         if(isNaN(this._rotationFinal))
         {
            this._rotationFinal = this.manager.contentAppearance.rotation;
         }
         if(Boolean(transParams.degrees))
         {
            this._degrees = transParams.degrees;
         }
         if(Boolean(transParams.ccw ^ this.direction))
         {
            this._degrees *= -1;
         }
      }
      
      override public function get type() : Class
      {
         return Rotate;
      }
      
      override protected function _render(p:Number) : void
      {
         this._content.rotation = this._rotationFinal - this._degrees * (1 - p);
      }
   }
}

