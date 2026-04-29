package com.module.lamu
{
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import flash.events.Event;
   
   public class SportMagicBook
   {
      
      private static var instance:SportMagicBook;
      
      private var bookAssets:AssetsManage;
      
      private var hasPushfoodPan:Boolean = false;
      
      private var _chapter:int = 1;
      
      public function SportMagicBook()
      {
         super();
      }
      
      public static function getInstance() : SportMagicBook
      {
         return Boolean(instance) ? instance : new SportMagicBook();
      }
      
      public function showMagicBookByChapter(chapter:int = 1) : void
      {
         this._chapter = chapter;
         this.loadBook();
      }
      
      public function loadBook() : void
      {
         if(this.hasPushfoodPan)
         {
            return;
         }
         if(!this.bookAssets)
         {
            this.bookAssets = new AssetsManage();
         }
         this.bookAssets.IncludeLib("SportMagicBook_Lib","module/external/BooksUI/SportsMagicBook.swf","正在打開...",true);
         MainManager.getGameLevel().addChild(this.bookAssets.getLoader());
         this.hasPushfoodPan = true;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         this.bookAssets.addEventListener(AssetsManage.ON_COMPLETE,this.showChapterFun);
         this.bookAssets.getLoader().contentLoaderInfo.sharedEvents.addEventListener("close",this.closeFun);
      }
      
      private function showChapterFun(E:*) : void
      {
         this.bookAssets.removeEventListener(AssetsManage.ON_COMPLETE,this.showChapterFun);
         this.bookAssets.getLoader().contentLoaderInfo.sharedEvents.dispatchEvent(new EventTaomee("turnToChapter","d" + this._chapter));
      }
      
      private function closeFun(E:*) : void
      {
         this.bookAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("close",this.closeFun);
         this.hasPushfoodPan = false;
         GC.clearAll(this.bookAssets.getLoader());
         this.bookAssets = null;
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         this.hasPushfoodPan = false;
         if(Boolean(this.bookAssets))
         {
            this.bookAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("close",this.closeFun);
            GC.clearAll(this.bookAssets.getLoader());
            this.bookAssets = null;
         }
      }
      
      public function untieSeal(gameID:uint, levelOrScore:uint) : void
      {
         var tc:SportMagicBook;
         var obj:Object = null;
         var f:Function = null;
         obj = {};
         obj.levelArr = [];
         obj.levelArr[1] = [];
         obj.levelArr[2] = [];
         obj.levelArr[3] = [false,false,false];
         obj.levelArr[4] = [false,false,false];
         obj.levelArr[5] = [false,false];
         obj.levelArr[6] = [false,false];
         obj.levelArr[7] = [false,false];
         tc = this;
         if(gameID == 1)
         {
            if(levelOrScore >= 2)
            {
               f = function(e:EventTaomee):void
               {
                  var d:Object = null;
                  if(e.EventObj.type == 2)
                  {
                     d = e.EventObj.data;
                     if(!d)
                     {
                        d = obj;
                     }
                     if(levelOrScore >= 3)
                     {
                        d.levelArr[5] = [true,true];
                     }
                     else if(levelOrScore >= 2)
                     {
                        d.levelArr[5][0] = true;
                     }
                     ephemeralDataSocket.setObjData(2,d);
                     tc = null;
                     f = null;
                  }
               };
               BC.addEvent(tc,GV.onlineSocket,"read_" + 1098,f);
               ephemeralDataSocket.getObjData(2);
            }
         }
         else if(gameID == 2)
         {
            if(levelOrScore >= 3)
            {
               f = function(e:EventTaomee):void
               {
                  var d:Object = null;
                  if(e.EventObj.type == 2)
                  {
                     d = e.EventObj.data;
                     if(!d)
                     {
                        d = obj;
                     }
                     if(levelOrScore >= 5)
                     {
                        d.levelArr[4] = [true,true,true];
                     }
                     else if(levelOrScore >= 4)
                     {
                        d.levelArr[4][0] = true;
                        d.levelArr[4][1] = true;
                     }
                     else if(levelOrScore >= 3)
                     {
                        d.levelArr[4][0] = true;
                     }
                     ephemeralDataSocket.setObjData(2,d);
                     tc = null;
                     f = null;
                  }
               };
               BC.addEvent(tc,GV.onlineSocket,"read_" + 1098,f);
               ephemeralDataSocket.getObjData(2);
            }
         }
         else if(gameID == 3)
         {
            if(levelOrScore >= 3)
            {
               f = function(e:EventTaomee):void
               {
                  var d:Object = null;
                  if(e.EventObj.type == 2)
                  {
                     d = e.EventObj.data;
                     if(!d)
                     {
                        d = obj;
                     }
                     if(levelOrScore >= 5)
                     {
                        d.levelArr[3] = [true,true,true];
                     }
                     else if(levelOrScore >= 4)
                     {
                        d.levelArr[3][0] = true;
                        d.levelArr[3][1] = true;
                     }
                     else if(levelOrScore >= 3)
                     {
                        d.levelArr[3][0] = true;
                     }
                     ephemeralDataSocket.setObjData(2,d);
                     tc = null;
                     f = null;
                  }
               };
               BC.addEvent(tc,GV.onlineSocket,"read_" + 1098,f);
               ephemeralDataSocket.getObjData(2);
            }
         }
         else if(gameID == 4)
         {
            levelOrScore = 120 - levelOrScore;
            if(levelOrScore <= 50)
            {
               f = function(e:EventTaomee):void
               {
                  var d:Object = null;
                  if(e.EventObj.type == 2)
                  {
                     d = e.EventObj.data;
                     if(!d)
                     {
                        d = obj;
                     }
                     if(levelOrScore <= 50)
                     {
                        d.levelArr[7] = [true,true];
                     }
                     else if(levelOrScore <= 65)
                     {
                        d.levelArr[7][0] = true;
                     }
                     ephemeralDataSocket.setObjData(2,d);
                     tc = null;
                     f = null;
                  }
               };
               BC.addEvent(tc,GV.onlineSocket,"read_" + 1098,f);
               ephemeralDataSocket.getObjData(2);
            }
         }
         else if(gameID == 5)
         {
            if(levelOrScore >= 200)
            {
               f = function(e:EventTaomee):void
               {
                  var d:Object = null;
                  if(e.EventObj.type == 2)
                  {
                     d = e.EventObj.data;
                     if(!d)
                     {
                        d = obj;
                     }
                     if(levelOrScore >= 300)
                     {
                        d.levelArr[6] = [true,true];
                     }
                     else
                     {
                        d.levelArr[6][0] = true;
                     }
                     ephemeralDataSocket.setObjData(2,d);
                     tc = null;
                     f = null;
                  }
               };
               BC.addEvent(tc,GV.onlineSocket,"read_" + 1098,f);
               ephemeralDataSocket.getObjData(2);
            }
         }
      }
   }
}

