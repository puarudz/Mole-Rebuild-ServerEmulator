package com.view.noticeView
{
   import com.core.info.LocalUserInfo;
   import com.mole.app.utils.PlayMovie;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.events.EventDispatcher;
   
   public class msgView extends EventDispatcher
   {
      
      private var _infoList:Array;
      
      public function msgView()
      {
         super();
         this._infoList = new Array();
      }
      
      public function info(e:*) : void
      {
         var messagelg:uint = 0;
         var p:uint = 0;
         if(Boolean(this._infoList[0] as Object))
         {
            messagelg = this._infoList.length;
            for(p = 0; p < messagelg; p++)
            {
               if(this._infoList[p].InfoMsg == e.InfoMsg)
               {
                  this._infoList.splice(p,1);
                  break;
               }
            }
         }
         this._infoList.push(e);
      }
      
      public function showTip() : void
      {
         var curObj:Object = this._infoList.shift();
         var titStr:String = "";
         var titInfo:String = "";
         var url_str:String = "";
         var anType:uint = 0;
         switch(curObj.Type)
         {
            case 0:
            case 1:
            case 2:
               titStr = curObj.year + "." + curObj.month + "." + curObj.day;
               titInfo = "親愛的" + LocalUserInfo.getNickName() + "：\r　　" + curObj.InfoMsg;
               if(curObj.Pic == 0)
               {
                  url_str = "resource/allJob/AlertPic/roc.swf";
               }
               else
               {
                  url_str = "resource/allJob/AlertPic/roc" + curObj.Pic + ".swf";
               }
               break;
            case 3:
            case 4:
               titStr = curObj.year + "." + curObj.month + "." + curObj.day;
               titInfo = "親愛的" + LocalUserInfo.getNickName() + "：\r　　" + curObj.InfoMsg;
               url_str = "resource/allJob/AlertPic/molePact/momo.swf";
               break;
            case 5:
               titStr = curObj.year + "." + curObj.month + "." + curObj.day;
               titInfo = "親愛的" + LocalUserInfo.getNickName() + "：\r　　" + curObj.InfoMsg;
               if(curObj.Pic == 0)
               {
                  url_str = "resource/allJob/AlertPic/roc.swf";
               }
               else
               {
                  url_str = "resource/allJob/AlertPic/roc" + curObj.Pic + ".swf";
               }
               anType = 1;
         }
      }
      
      private function playEyeExercises(e:*) : void
      {
         var eyeMovie:PlayMovie = null;
         SoundManager.stopAll();
         eyeMovie = PlayMovie.play("module/external/MoleTime/EyeExercises.swf",null,null,function():void
         {
            eyeMovie.movie_mc.stop();
            eyeMovie.destroy();
            SoundManager.openAll();
         });
      }
      
      private function playCartoon(e:*) : void
      {
         var eyeMovie:PlayMovie = null;
         SoundManager.stopAll();
         eyeMovie = PlayMovie.play("module/external/MoleTime/noticeMV01.swf",null,null,function():void
         {
            eyeMovie.movie_mc.stop();
            eyeMovie.destroy();
            SoundManager.openAll();
         },null,null,true,"正在打開廣播操");
      }
      
      public function get nowLg() : int
      {
         return this._infoList.length;
      }
   }
}

