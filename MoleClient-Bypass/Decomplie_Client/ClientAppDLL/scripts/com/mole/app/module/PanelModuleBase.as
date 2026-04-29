package com.mole.app.module
{
   import com.common.util.AlignType;
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import com.greensock.TweenLite;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.superPetLogin;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.debug.DebugManager;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PanelModuleBase extends AppModuleBase implements IAppModule
   {
      
      protected var _panel:Sprite;
      
      protected var _close_btn:SimpleButton;
      
      public function PanelModuleBase(panel:Sprite, moduleID:uint = 0)
      {
         super(moduleID);
         this._panel = panel;
         if(Boolean(this._panel))
         {
            this.initEvent();
            this.initView();
            this.initStart();
         }
      }
      
      protected function initStart() : void
      {
      }
      
      override public function init(data:Object = null) : void
      {
         super.init(data);
      }
      
      protected function initEvent() : void
      {
         try
         {
            if(this._panel.hasOwnProperty("close_btn"))
            {
               this._close_btn = this._panel["close_btn"];
               this._close_btn.addEventListener(MouseEvent.CLICK,this.onClose);
            }
         }
         catch(err:Error)
         {
            if(DebugManager.DEBUG)
            {
               DebugManager.traceMsg("模塊代碼有錯，請找對應模塊開發者修復！\n" + err.getStackTrace());
            }
            close();
         }
         this._panel.addEventListener(MouseEvent.CLICK,this.onClickPanelHandler);
      }
      
      protected function onClickPanelHandler(evt:MouseEvent) : void
      {
         var moduleName:String = null;
         var spoName:String = null;
         var mapIndex:uint = 0;
         var targetName:String = evt.target.name;
         if(targetName.indexOf("openModule_") != -1)
         {
            moduleName = targetName.substring(11,targetName.length);
            _moduleName = targetName.slice(11);
            if(_moduleName == "LianLianKanPanel")
            {
               MapManager.clearMap();
            }
            moduleNameCheck(_moduleName,1);
            return;
         }
         if(targetName.indexOf("spo_") != -1)
         {
            spoName = targetName.slice(4);
            _moduleName = spoName;
            moduleNameCheck(_moduleName,2);
            return;
         }
         if(targetName.indexOf("goto_") != -1)
         {
            mapIndex = uint(targetName.substring(5,targetName.length));
            switchMapLogic.switchMapLogicHandler(mapIndex);
            return;
         }
         if(targetName == "applyLamu_btn")
         {
            superPetLogin.gotoPay();
            return;
         }
         if(targetName == "open_YS")
         {
            ModuleManager.openPanel("WeenActivityPanel");
         }
      }
      
      protected function initView() : void
      {
         DisplayUtil.align(this._panel,LevelManager.stageRect,AlignType.MIDDLE_CENTER);
         addChild(LevelManager.drawBG());
         addChild(this._panel);
         TweenLite.from(this,0.3,{"alpha":0});
      }
      
      protected function onClose(e:Event) : void
      {
         close();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._close_btn))
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this._panel.removeEventListener(MouseEvent.CLICK,this.onClickPanelHandler);
            this._close_btn = null;
         }
         super.destroy();
      }
   }
}

