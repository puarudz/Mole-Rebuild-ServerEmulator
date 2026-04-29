package com.module.changeClothsModule
{
   import com.common.util.DisplayUtil;
   import com.core.manager.UIManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class RoleViewLevel extends Sprite
   {
      
      private var _body_mc:Sprite;
      
      private var _bgCon:Sprite;
      
      private var _clothsCon:Sprite;
      
      private var _petCon:Sprite;
      
      public function RoleViewLevel(levelCon:Sprite)
      {
         super();
         var prev_mc:DisplayObjectContainer = levelCon["prev_mc"];
         DisplayUtil.removeAllChild(prev_mc);
         prev_mc.addChild(this);
         this._bgCon = levelCon["bg_body"];
         DisplayUtil.removeAllChild(this._bgCon);
         this._body_mc = UIManager.getMovieClip("UI003_moleshow_mc");
         this._clothsCon = new Sprite();
         this._petCon = new Sprite();
         this._petCon.x = this._body_mc.x + 52;
         this._petCon.y = this._body_mc.y;
         this.sort();
      }
      
      public function sort() : void
      {
         addChild(this._body_mc);
         addChild(this._clothsCon);
         addChild(this._petCon);
      }
      
      public function get body_mc() : Sprite
      {
         return this._body_mc;
      }
      
      public function get bgCon() : Sprite
      {
         return this._bgCon;
      }
      
      public function get clothsCon() : Sprite
      {
         return this._clothsCon;
      }
      
      public function get petCon() : Sprite
      {
         return this._petCon;
      }
   }
}

