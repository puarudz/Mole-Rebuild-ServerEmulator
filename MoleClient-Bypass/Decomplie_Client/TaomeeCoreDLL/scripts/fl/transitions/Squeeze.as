package fl.transitions
{
   import flash.display.MovieClip;
   
   public class Squeeze extends Transition
   {
      
      protected var _scaleProp:String = "scaleX";
      
      protected var _scaleFinal:Number = 1;
      
      public function Squeeze(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         if(Boolean(transParams.dimension))
         {
            this._scaleProp = "scaleY";
            this._scaleFinal = this.manager.contentAppearance.scaleY;
         }
         else
         {
            this._scaleProp = "scaleX";
            this._scaleFinal = this.manager.contentAppearance.scaleX;
         }
      }
      
      override public function get type() : Class
      {
         return Squeeze;
      }
      
      override protected function _render(p:Number) : void
      {
         if(p <= 0)
         {
            p = 0;
         }
         this._content[this._scaleProp] = p * this._scaleFinal;
      }
   }
}

