package fl.transitions
{
   import flash.display.MovieClip;
   
   public class Zoom extends Transition
   {
      
      protected var _scaleXFinal:Number = 1;
      
      protected var _scaleYFinal:Number = 1;
      
      public function Zoom(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         this._scaleXFinal = this.manager.contentAppearance.scaleX;
         this._scaleYFinal = this.manager.contentAppearance.scaleY;
      }
      
      override public function get type() : Class
      {
         return Zoom;
      }
      
      override protected function _render(p:Number) : void
      {
         if(p < 0)
         {
            p = 0;
         }
         this._content.scaleX = p * this._scaleXFinal;
         this._content.scaleY = p * this._scaleYFinal;
      }
   }
}

