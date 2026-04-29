package com.common.newAlert
{
   import com.core.MainManager;
   import com.core.manager.IndexManager;
   import com.taomee.component.MButton;
   import com.taomee.component.MLoadPane;
   import com.taomee.component.MTextField;
   import com.taomee.component.event.LoadPaneEvent;
   import flash.display.DisplayObject;
   
   public class MAlert
   {
      
      public static const SMILE:int = 0;
      
      public static const SAD:int = 1;
      
      private var simleClass:Class;
      
      private var sadClass:Class;
      
      public function MAlert()
      {
         super();
      }
      
      public static function showBuyAlert(str:String, icon:*, applyFun:Function = null, cancelFun:Function = null) : IAlert
      {
         var alert:IAlert = new BuyBox(str,icon,applyFun,cancelFun);
         alert.getLoadPane().setAdjustType(MLoadPane.ADJUST_NONE);
         alert.getLoadPane().addEventListener(LoadPaneEvent.ON_LOAD_CONTENT,onLoadContent);
         alert.getLoadPane().reLoad();
         alert.setMiniWidthEnabled(false);
         alert.getTextField().setPreferredWidth(265);
         alert.updateUI();
         MainManager.centerObj(DisplayObject(alert));
         return alert;
      }
      
      private static function onLoadContent(event:LoadPaneEvent) : void
      {
         MLoadPane(event.target).setContentScale(1.5,1.5);
      }
      
      public static function showBuySucessAlert(str:String, icon:*, applyFun:Function = null, cancelFun:Function = null) : IAlert
      {
         var alert:IAlert = new BuyBox(str,icon,applyFun,cancelFun);
         var btn:MButton = alert.getButtonPanel().getChildAt(1) as MButton;
         alert.setMiniWidthEnabled(false);
         alert.getTextField().setAlign(MTextField.CENTER);
         alert.getTextField().setPreferredWidth(265);
         alert.getLoadPane().setAdjustType(MLoadPane.ADJUST_NONE);
         alert.getLoadPane().addEventListener(LoadPaneEvent.ON_LOAD_CONTENT,onLoadContent);
         alert.getLoadPane().reLoad();
         alert.getButtonPanel().remove(btn);
         alert.getMainPanel().appendAt(alert.getLoadPane(),0);
         MainManager.centerObj(DisplayObject(alert));
         return alert;
      }
      
      public static function showEmotionAlert(str:String, emotion:int = 0, applyFun:Function = null) : IAlert
      {
         var icon:DisplayObject = null;
         switch(emotion)
         {
            case MAlert.SAD:
               icon = IndexManager.getInstance().getMovieClip("icon_sad");
               break;
            case MAlert.SMILE:
               icon = IndexManager.getInstance().getMovieClip("icon_smile");
               break;
            default:
               icon = IndexManager.getInstance().getMovieClip("icon_smile");
         }
         icon.cacheAsBitmap = true;
         var alert:IAlert = new BuyBox(str,icon);
         alert.setMiniWidthEnabled(false);
         alert.getTextField().setAlign(MTextField.CENTER);
         alert.getTextField().setPreferredWidth(250);
         alert.getLoadPane().setPreferredHeight(85);
         var btn:MButton = alert.getButtonPanel().getChildAt(1) as MButton;
         alert.getButtonPanel().remove(btn);
         MainManager.centerObj(DisplayObject(alert));
         return alert;
      }
   }
}

