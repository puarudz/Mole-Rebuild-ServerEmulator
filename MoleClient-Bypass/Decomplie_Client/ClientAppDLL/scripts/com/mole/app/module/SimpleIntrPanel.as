package com.mole.app.module
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.Presented;
   import com.module.activityModule.superPetLogin;
   import com.module.coin.CoinBuyNewModle;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.ui.InfoBox;
   import com.mole.app.ui.LoadingPanel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SimpleIntrPanel extends Sprite
   {
      
      private var _resID:uint;
      
      private var _url:String;
      
      private var intrContent:DisplayObject;
      
      private var _close_btn:DisplayObject;
      
      public function SimpleIntrPanel(url:String)
      {
         super();
         this._url = url;
         this._resID = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載資源，請稍等.......");
         DownLoadManager.addEvent(this._resID,this.onLoaderModuleSucceed,null,null,this.onLoaderModuleFail);
         LoadingPanel.isShowClose = false;
         LoadingPanel.addRes(this._resID);
      }
      
      private function onLoaderModuleSucceed(e:DownLoadEvent) : void
      {
         this.intrContent = e.data;
         var mc:MovieClip = this.intrContent as MovieClip;
         if(Boolean(mc))
         {
            mc.gotoAndStop(1);
         }
         addChild(LevelManager.drawBG());
         if(this.intrContent.width < TaomeeManager.stageWidth)
         {
            this.intrContent.x = (TaomeeManager.stageWidth - this.intrContent.width) / 2;
         }
         if(this.intrContent.height < TaomeeManager.stageHeight)
         {
            this.intrContent.y = (TaomeeManager.stageHeight - this.intrContent.height) / 2;
         }
         addChild(this.intrContent);
         MainManager.getAppLevel().addChild(this);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(this.intrContent.hasOwnProperty("close_btn"))
         {
            this._close_btn = this.intrContent["close_btn"];
            this._close_btn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         this.intrContent.addEventListener(MouseEvent.CLICK,this.clickPanelHandler);
      }
      
      private function onLoaderModuleFail(e:DownLoadEvent) : void
      {
         InfoBox.show("加載模塊失敗。");
         this.onClose();
      }
      
      protected function clickPanelHandler(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var moduleName:String = null;
         var exchangeTypeId:int = 0;
         var mapIndex:uint = 0;
         var buyInfoArr:Array = null;
         var intrSwf:String = null;
         var targetName:String = evt.target.name;
         if(targetName == "next_btn")
         {
            mc = this.intrContent as MovieClip;
            if(Boolean(mc))
            {
               mc.nextFrame();
            }
            return;
         }
         if(targetName == "pre_btn")
         {
            mc = this.intrContent as MovieClip;
            if(Boolean(mc))
            {
               mc.prevFrame();
            }
            return;
         }
         if(targetName.indexOf("openModule_") != -1)
         {
            moduleName = targetName.substring(11,targetName.length);
            ModuleManager.openPanel(moduleName);
            this.onClose();
            return;
         }
         if(targetName.indexOf("exchange_") != -1)
         {
            exchangeTypeId = int(targetName.substring(9,targetName.length));
            Presented.getInstance().celebrate1225(exchangeTypeId);
            this.onClose();
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
         if(targetName.indexOf("shopBuy_") != -1)
         {
            buyInfoArr = targetName.substring(8,targetName.length).split("_");
            if(buyInfoArr.length == 1)
            {
               buyInfoArr[1] = 1;
            }
            new CoinBuyNewModle().BuyModle(buyInfoArr[0],buyInfoArr[1]);
            return;
         }
         if(targetName.indexOf("spo_") != -1)
         {
            intrSwf = targetName.substring(4,targetName.length);
            SimpleIntrPanelManager.show(intrSwf);
            return;
         }
      }
      
      private function onClose(evt:MouseEvent = null) : void
      {
         SimpleIntrPanelManager.destroyPanel(this._url);
      }
      
      public function destroy() : void
      {
         if(Boolean(this._close_btn))
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this._close_btn = null;
         }
         if(Boolean(this.intrContent))
         {
            this.intrContent.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         }
         DownLoadManager.remove(this._resID);
         DisplayUtil.removeFromParent(this);
      }
   }
}

