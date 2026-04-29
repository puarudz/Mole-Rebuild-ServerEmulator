package com.module.elementKnight.view
{
   import com.core.manager.UIManager;
   import com.module.elementKnight.info.ElementKnightCardInfo;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.taomee.mole.library.ui.BaseTips;
   import flash.display.MovieClip;
   import org.taomee.loader.ContentInfo;
   import org.taomee.utils.DisplayUtil;
   
   public class ElementKnightCardTip extends BaseTips
   {
      
      private var _show:MovieClip;
      
      public function ElementKnightCardTip(_info:*)
      {
         super(_info);
      }
      
      override public function setup() : void
      {
         mcContainer = UIManager.getMovieClip("UI_ElementKnightCardTip");
         mcContainer["name_txt"].text = this.cardInfo.staticInfo.name;
         mcContainer["atk_txt"].text = this.cardInfo.minAtk + "-" + this.cardInfo.maxAtk;
         mcContainer["def_txt"].text = this.cardInfo.minDef + "-" + this.cardInfo.maxDef;
         mcContainer["lv_txt"].text = String(this.cardInfo.lv);
         mcContainer["star_mc"].gotoAndStop(this.cardInfo.staticInfo.star);
         mcContainer["type_mc"].gotoAndStop(this.cardInfo.staticInfo.type);
         mcContainer["isFight_mc"].visible = this.cardInfo.cardStatus == 1;
         MovieClip(mcContainer["bg_mc"]).gotoAndStop(this.cardInfo.staticInfo.star);
         addChild(mcContainer);
         CacheManager.getPhasorContent(URLUtil.getElementCardShowUrl(this.cardInfo.staticId),"item",this.onShowLoadComplete,null);
      }
      
      private function onShowLoadComplete(contentInfo:ContentInfo) : void
      {
         this._show = contentInfo.content as MovieClip;
         if(Boolean(mcContainer) && Boolean(this._show))
         {
            MovieClip(mcContainer["img_mc"]).addChild(this._show);
         }
      }
      
      private function get cardInfo() : ElementKnightCardInfo
      {
         return _info as ElementKnightCardInfo;
      }
      
      override public function detory() : void
      {
         if(Boolean(this._show))
         {
            DisplayUtil.removeFromParent(this._show);
            this._show = null;
         }
         CacheManager.cancelPhasor(URLUtil.getElementCardShowUrl(this.cardInfo.staticId),this.onShowLoadComplete);
         super.detory();
      }
   }
}

