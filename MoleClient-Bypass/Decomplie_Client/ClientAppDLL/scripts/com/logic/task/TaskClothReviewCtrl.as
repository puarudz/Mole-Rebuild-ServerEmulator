package com.logic.task
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.clothReview2008.ClothReviewSocket;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import flash.events.MouseEvent;
   
   public class TaskClothReviewCtrl
   {
      
      private static var _instance:TaskClothReviewCtrl;
      
      private var _appModuleCtl:AppModuleControl;
      
      private var _path:String = "module/external/";
      
      public function TaskClothReviewCtrl()
      {
         super();
      }
      
      public static function get inst() : TaskClothReviewCtrl
      {
         if(_instance == null)
         {
            _instance = new TaskClothReviewCtrl();
         }
         return _instance;
      }
      
      public function initBtn() : void
      {
         if(LocalUserInfo.getMapID() == 20)
         {
            BC.addEvent(this,GV.MC_mapFrame["buttonLevel"]["btn_book"],MouseEvent.CLICK,this.clickBook,false,0,true);
            tip.tipTailDisPlayObject(GV.MC_mapFrame["buttonLevel"]["btn_book"],"2008年經典服裝回顧展下");
         }
      }
      
      private function clickBook(e:MouseEvent) : void
      {
         BC.removeEvent(this,GV.MC_mapFrame["buttonLevel"]["btn_book"],MouseEvent.CLICK,this.clickBook);
         this.openPanel(ModuleType.CLOTH_REVIEW_2008_DO,2008001,2008025);
      }
      
      public function openPanel(name:String, idStart:int, idEnd:int, params:Array = null, watchMode:Boolean = false, arr:Array = null) : void
      {
         var getInfoOver:Function = null;
         var arr0:Array = null;
         var i:int = 0;
         var initData:Object = null;
         getInfoOver = function(e:EventTaomee):void
         {
            BC.removeEvent(_instance,GV.onlineSocket,"read_" + ClothReviewSocket.GET_VOTE_INFO_CMD,getInfoOver);
            var initData:Object = {
               "arr0":e.EventObj.arr,
               "watchMode":watchMode,
               "idStart":idStart,
               "idEnd":idStart
            };
            initData.url = _path + name + ".swf";
            open(initData);
         };
         if(arr == null)
         {
            BC.addEvent(_instance,GV.onlineSocket,"read_" + ClothReviewSocket.GET_VOTE_INFO_CMD,getInfoOver,false,0,true);
            ClothReviewSocket.getVoteInfo.apply(null,params);
         }
         else
         {
            arr0 = [];
            for(i = idStart; i <= idEnd; i++)
            {
               arr0.push({
                  "itemID":i,
                  "score":arr[i - idStart]
               });
            }
            initData = {
               "arr0":arr0,
               "watchMode":watchMode,
               "idStart":idStart,
               "idEnd":idStart
            };
            initData.url = this._path + name + ".swf";
            this.open(initData);
         }
      }
      
      private function open(initData:Object) : void
      {
         if(this._appModuleCtl != null)
         {
            this._appModuleCtl.destroy();
            this._appModuleCtl = null;
         }
         this._appModuleCtl = ModuleManager.openPanel(ModuleType.CLOTH_REVIEW_PANEL_Ctrl,initData,"正在加載面板，請耐心等待......",MainManager.getTopLevel());
         this._appModuleCtl.addEventListener(ModuleEvent.DESTROY,this.addBtnEvent,false,0,true);
      }
      
      private function addBtnEvent(e:ModuleEvent) : void
      {
         this.initBtn();
      }
   }
}

