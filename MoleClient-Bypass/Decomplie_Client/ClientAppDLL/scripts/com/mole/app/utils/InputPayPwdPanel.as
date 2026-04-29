package com.mole.app.utils
{
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.utils.DisplayUtil;
   
   public class InputPayPwdPanel extends Sprite
   {
      
      private var _bkFunc:Function;
      
      private var _ui:MovieClip;
      
      public function InputPayPwdPanel(bkFunc:Function)
      {
         super();
         this._bkFunc = bkFunc;
         this._ui = UIManager.getMovieClip("UI_InputPayPwdPanel");
         this._ui.x = (TaomeeManager.stageWidth - this._ui.width) / 2;
         this._ui.y = (TaomeeManager.stageHeight - this._ui.height) / 2;
         addChild(LevelManager.drawBG());
         addChild(this._ui);
         TaomeeManager.stage.addChild(this);
         TextField(this._ui["pwd_txt"]).text = "";
         TextField(this._ui["pwd_txt"]).displayAsPassword = true;
         this._ui["close_btn"].addEventListener(MouseEvent.CLICK,this.destroy);
         this._ui["cancel_btn"].addEventListener(MouseEvent.CLICK,this.destroy);
         this._ui["yes_btn"].addEventListener(MouseEvent.CLICK,this.clickYesHandler);
      }
      
      private function clickYesHandler(evt:MouseEvent) : void
      {
         if(Boolean(this._bkFunc))
         {
            this._bkFunc(TextField(this._ui["pwd_txt"]).text);
         }
         this.destroy();
      }
      
      private function destroy(evt:MouseEvent = null) : void
      {
         this._ui["close_btn"].removeEventListener(MouseEvent.CLICK,this.destroy);
         this._ui["cancel_btn"].removeEventListener(MouseEvent.CLICK,this.destroy);
         this._ui["yes_btn"].removeEventListener(MouseEvent.CLICK,this.clickYesHandler);
         DisplayUtil.removeFromParent(this);
      }
   }
}

