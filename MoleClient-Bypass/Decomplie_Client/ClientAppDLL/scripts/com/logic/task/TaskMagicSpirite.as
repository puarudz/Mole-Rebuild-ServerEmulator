package com.logic.task
{
   import com.common.Alert.Alert;
   import com.common.data.UILibrary;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.ui.LoadingPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TaskMagicSpirite
   {
      
      private static var _instance:TaskMagicSpirite;
      
      public var step:uint = 1;
      
      private var _index:uint;
      
      public function TaskMagicSpirite()
      {
         super();
      }
      
      public static function get inst() : TaskMagicSpirite
      {
         if(_instance == null)
         {
            _instance = new TaskMagicSpirite();
         }
         return _instance;
      }
      
      public function isOverTask() : Boolean
      {
         if(this.step < 5)
         {
            return true;
         }
         return false;
      }
      
      public function setStep() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.cli_proto_get_limit_info,this.getStep);
         GF.sendSocket(CommandID.cli_proto_get_limit_info,1,11);
      }
      
      private function getStep(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.cli_proto_get_limit_info,this.getStep);
         var bytearr:ByteArray = e.data as ByteArray;
         if(bytearr == null)
         {
            return;
         }
         var count:uint = bytearr.readUnsignedInt();
         this.step = bytearr.readUnsignedInt();
      }
      
      public function taskOver() : void
      {
         GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,0,4);
      }
      
      public function playTaskByStep(id:uint) : void
      {
         this.step = id;
         switch(id)
         {
            case 1:
               this.doStep1();
               break;
            case 2:
               this.doStep2();
               break;
            case 3:
               this.doStep3();
               break;
            case 4:
               this.doStep4();
         }
      }
      
      private function doStep1() : void
      {
         this.step = 1;
         var url:String = "resource/task/TaskMagicSprite/step_1.swf";
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
         DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
         LoadingPanel.addRes(resID);
      }
      
      private function onLoadResComplete(e:DownLoadEvent) : void
      {
         var panel:MovieClip = null;
         var uil:UILibrary = new UILibrary(e.loader.contentLoaderInfo.applicationDomain);
         panel = e.data as MovieClip;
         LevelManager.alertLevel.addChild(panel);
         switch(this.step)
         {
            case 1:
               panel.addEventListener(MouseEvent.CLICK,this.onClickOneStep);
               break;
            case 2:
               MovieClipUtil.playEndAndFunc(panel,function():void
               {
                  Alert.smileAlart(" 恭喜你完成戰鬥引導，獲得一個新摩靈，快打開摩靈背包看看吧！",function():void
                  {
                     GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,0,3);
                     step = 3;
                     DisplayUtil.removeFromParent(panel);
                     playTaskByStep(step);
                  });
               });
               break;
            case 3:
               MovieClipUtil.playEndAndFunc(panel,function():void
               {
                  DisplayUtil.removeFromParent(panel);
                  Alert.smileAlart(" 隊伍設置好了，開始戰鬥吧",function():void
                  {
                     step = 4;
                     GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,0,step);
                     playTaskByStep(step);
                  });
               });
               break;
            case 4:
               MovieClipUtil.playEndAndFunc(panel,function():void
               {
                  DisplayUtil.removeFromParent(panel);
                  Alert.smileAlart(" 挑戰關卡必須設置隊長摩靈，再去背包中設置摩靈出戰吧",function():void
                  {
                     step = 5;
                     GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,0,step);
                     playTaskByStep(step);
                     GV.onlineSocket.dispatchEvent(new EventTaomee("MagciSpirite_guide_over",0));
                     ModuleManager.openPanel("BagMagicSpiritPanel",1);
                  });
               });
         }
      }
      
      private function onClickOneStep(e:MouseEvent) : void
      {
         var msg:String;
         var mc:MovieClip = null;
         var index:uint = 0;
         var str:String = null;
         mc = e.currentTarget as MovieClip;
         var btn:SimpleButton = e.target as SimpleButton;
         if(btn == null)
         {
            return;
         }
         msg = "你可以帶它戰鬥，培養它，讓變得更加強大哦！";
         switch(btn.name)
         {
            case "btn_0":
               index = 1;
               str = "你將選擇二星水母拉姆作為你的戰鬥夥伴" + msg;
               break;
            case "btn_1":
               index = 2;
               str = "你將選擇二星火石拉姆作為你的戰鬥夥伴" + msg;
               break;
            case "btn_2":
               index = 3;
               str = "你將選擇二星苗苗拉姆作為你的戰鬥夥伴" + msg;
         }
         if(index > 0)
         {
            Alert.showChooseAlart(str,function():void
            {
               DisplayUtil.removeFromParent(mc);
               GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,onGetSpirite);
               GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,1,index);
               _index = index;
            });
         }
      }
      
      private function onGetSpirite(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,this.onGetSpirite);
         var bytearr:ByteArray = e.data as ByteArray;
         GV.onlineSocket.addCmdListener(CommandID.cli_proto_get_limit_info,this.infoBack);
         GF.sendSocket(CommandID.cli_proto_get_limit_info,1,11);
      }
      
      private function onSetStep(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,this.onSetStep);
         var bytearr:ByteArray = e.data as ByteArray;
      }
      
      private function infoBack(e:SocketEvent) : void
      {
         var bytearr:ByteArray;
         var strArr:Array;
         var str:String;
         var count:uint;
         var num:uint;
         GV.onlineSocket.removeCmdListener(CommandID.cli_proto_get_limit_info,this.infoBack);
         bytearr = e.data as ByteArray;
         strArr = ["恭喜你獲得水母拉姆，下面我們來了解怎麼和摩靈一起對抗怪物吧","恭喜你獲得火石拉姆，下面我們來了解怎麼和摩靈一起對抗怪物吧","恭喜你獲得苗苗拉姆，下面我們來了解怎麼和摩靈一起對抗怪物吧"];
         str = "";
         if(bytearr == null)
         {
            return;
         }
         count = bytearr.readUnsignedInt();
         num = bytearr.readUnsignedInt();
         str = strArr[this._index - 1];
         Alert.smileAlart(str,function():void
         {
            GF.sendSocket(CommandID.MAGICSPIRIT_NEWBIE_GUIDE_STEP,0,2);
            step = 2;
            playTaskByStep(step);
         });
      }
      
      private function doStep2() : void
      {
         var url:String = "resource/task/TaskMagicSprite/step_2.swf";
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
         DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
         LoadingPanel.addRes(resID);
      }
      
      private function doStep3() : void
      {
         var url:String = "resource/task/TaskMagicSprite/step_3.swf";
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
         DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
         LoadingPanel.addRes(resID);
      }
      
      private function doStep4() : void
      {
         var url:String = "resource/task/TaskMagicSprite/step_4.swf";
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
         DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
         LoadingPanel.addRes(resID);
      }
      
      private function doStep(index:uint) : void
      {
         var url:String = "resource/task/TaskMagicSprite/step_" + index.toString() + ".swf";
         var resID:uint = DownLoadManager.add(url,ResType.DISPLAY_OBJECT,true,"正在加載模塊素材。");
         DownLoadManager.addEvent(resID,this.onLoadResComplete,null,null,this.onLoadResError);
         LoadingPanel.addRes(resID);
      }
      
      private function onLoadResError(e:DownLoadEvent) : void
      {
      }
   }
}

