package com.taomee.mole.library.utils
{
   import com.common.util.DisplayUtil;
   import com.common.util.Tick;
   import com.core.manager.LevelManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   
   public class ZoomUtil extends Sprite
   {
      
      private var _mask_mc:DisplayObject;
      
      private var _firefly_mc:DisplayObject;
      
      private var _tar_mc:DisplayObject;
      
      private var _tarBitmap:Bitmap;
      
      private var _tarBD:BitmapData;
      
      private var _scale:Number;
      
      private var _parent_mc:DisplayObjectContainer;
      
      public function ZoomUtil(firefly_mc:Sprite, tar_mc:DisplayObject, scale:Number = 2, parent_mc:Sprite = null)
      {
         super();
         if(Boolean(parent_mc))
         {
            this._parent_mc = parent_mc;
         }
         else
         {
            this._parent_mc = LevelManager.topLevel;
         }
         this._tar_mc = tar_mc;
         this._scale = scale;
         this._tarBD = new BitmapData(LevelManager.WIDTH,LevelManager.HEIGHT);
         this._tarBitmap = new Bitmap();
         this._tarBitmap.bitmapData = this._tarBD;
         addChild(this._tarBitmap);
         this._firefly_mc = firefly_mc;
         this._mask_mc = firefly_mc["mask_mc"];
         addChild(this._mask_mc);
         addChild(this._firefly_mc);
         this._tarBitmap.mask = this._mask_mc;
      }
      
      public function start() : void
      {
         this._parent_mc.addChild(this);
         Tick.instance.addCallback(this.onFrame);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onStop);
      }
      
      private function onFrame(delay:Number) : void
      {
         var tarX:Number = -(LevelManager.stage.mouseX * this._scale - LevelManager.stage.mouseX) + this._tar_mc.x * this._scale;
         var tarY:Number = -(LevelManager.stage.mouseY * this._scale - LevelManager.stage.mouseY) + this._tar_mc.y * this._scale;
         this._tarBD.fillRect(this._tarBD.rect,0);
         this._tarBD.draw(this._tar_mc,new Matrix(this._scale,0,0,this._scale,tarX,tarY));
         this._mask_mc.x = LevelManager.stage.mouseX;
         this._mask_mc.y = LevelManager.stage.mouseY;
         this._firefly_mc.x = LevelManager.stage.mouseX;
         this._firefly_mc.y = LevelManager.stage.mouseY;
      }
      
      private function onStop(e:MouseEvent) : void
      {
         this.stop();
      }
      
      public function stop() : void
      {
         DisplayUtil.removeForParent(this,false);
         Tick.instance.removeCallback(this.onFrame);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStop);
      }
      
      public function destroy() : void
      {
         this.stop();
         DisplayUtil.removeForParent(this);
         this._tarBD.dispose();
      }
   }
}

