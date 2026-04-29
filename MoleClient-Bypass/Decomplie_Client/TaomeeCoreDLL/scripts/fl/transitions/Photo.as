package fl.transitions
{
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Photo extends Transition
   {
      
      protected var _alphaFinal:Number = 1;
      
      protected var _colorControl:ColorTransform;
      
      public function Photo(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         this._alphaFinal = this.manager.contentAppearance.alpha;
         this._colorControl = new ColorTransform();
      }
      
      override public function get type() : Class
      {
         return Photo;
      }
      
      override protected function _render(p:Number) : void
      {
         var s1:Number = 0.8;
         var s2:Number = 0.9;
         var t:Object = {};
         var bright:Number = 0;
         if(p <= s1)
         {
            this._colorControl.alphaMultiplier = this._alphaFinal * (p / s1);
         }
         else
         {
            this._colorControl.alphaMultiplier = this._alphaFinal;
            if(p <= s2)
            {
               bright = (p - s1) / (s2 - s1) * 256;
            }
            else
            {
               bright = (1 - (p - s2) / (1 - s2)) * 256;
            }
         }
         t.rb = t.gb = t.bb = bright;
         this._colorControl.redOffset = this._colorControl.greenOffset = this._colorControl.blueOffset = bright;
         this._content.transform.colorTransform = this._colorControl;
      }
   }
}

