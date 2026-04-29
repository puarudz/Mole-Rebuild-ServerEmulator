package com.mole.app.module
{
   import com.common.data.UILibrary;
   import com.common.util.AlignType;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.mole.app.ui.InfoBox;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.debug.DebugManager;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ExternalModuleBase extends AppModuleBase
   {
      
      protected var _uiLibrary:UILibrary;
      
      protected var _panel:Sprite;
      
      protected var _close_btn:SimpleButton;
      
      public function ExternalModuleBase(uiUrl:String = "", moduleID:uint = 0)
      {
         var resID:uint = 0;
         super(moduleID);
         if(uiUrl != "")
         {
            resID = DownLoadManager.add(uiUrl,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
            DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
            LoadingPanel.addRes(resID);
         }
      }
      
      override public function init(data:Object = null) : void
      {
         var resID:uint = 0;
         super.init(data);
         if(Boolean(_initData) && _initData.hasOwnProperty("url"))
         {
            resID = DownLoadManager.add(_initData.url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
            DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
            LoadingPanel.addRes(resID);
         }
      }
      
      private function onLoadResComplete(e:DownLoadEvent) : void
      {
         this._uiLibrary = new UILibrary(e.loader.contentLoaderInfo.applicationDomain);
         this.panel = e.data as Sprite;
         this.initView();
         this.initPanel();
      }
      
      private function onClose(e:MouseEvent) : void
      {
         close();
      }
      
      protected function initView() : void
      {
         DisplayUtil.align(this.panel,LevelManager.stageRect,AlignType.MIDDLE_CENTER);
         addChildAt(LevelManager.drawBG(),0);
         addChild(this.panel);
      }
      
      protected function initPanel() : void
      {
      }
      
      private function onLoadResError(e:DownLoadEvent) : void
      {
         close();
      }
      
      protected function get panel() : Sprite
      {
         return this._panel;
      }
      
      protected function set panel(value:Sprite) : void
      {
         this._panel = value;
         try
         {
            this._close_btn = this._panel["close_btn"];
            if(Boolean(this._close_btn))
            {
               this._close_btn.addEventListener(MouseEvent.CLICK,this.onClose);
            }
         }
         catch(err:Error)
         {
            if(DebugManager.DEBUG)
            {
               InfoBox.show("模塊代碼有錯，請找對應模塊開發者修復！");
               DebugManager.outMsg(err.getStackTrace());
            }
            close();
         }
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._close_btn))
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this._close_btn = null;
         }
         this._uiLibrary = null;
         this._panel = null;
         super.destroy();
      }
      
      public function get uiLibrary() : UILibrary
      {
         return this._uiLibrary;
      }
   }
}

