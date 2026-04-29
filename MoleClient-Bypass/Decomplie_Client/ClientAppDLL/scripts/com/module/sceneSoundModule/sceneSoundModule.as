package com.module.sceneSoundModule
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class sceneSoundModule
   {
      
      private static var soundHao:Sound;
      
      private static var haoChanler:SoundChannel;
      
      private static var typeID:int = 0;
      
      private static var soundArry_1:Array = [18,7,1,3,9];
      
      private static var isFirst:Boolean = false;
      
      public static var PLAY_MAPACTION:String = "play_mapaction";
      
      public function sceneSoundModule()
      {
         super();
      }
      
      public static function addEventSound() : void
      {
         var soundBool:Boolean = false;
         isFirst = false;
         typeID = 0;
         var mapID:Number = LocalUserInfo.getMapID();
         for(var j:int = 0; j < soundArry_1.length; j++)
         {
            if(soundArry_1[j] == mapID)
            {
               soundBool = true;
               break;
            }
         }
         if(mapID == 2)
         {
            typeID = 1;
         }
         else if(soundBool)
         {
            typeID = 2;
         }
         else if(mapID == 27)
         {
            typeID = 3;
         }
         else if(mapID == 32)
         {
            typeID = 4;
         }
         if(typeID != 0)
         {
            GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
            GV.onlineSocket.addEventListener(trafficRes.TRAFFIC_OVER,soundHandler);
            trafficReq.trafficSend(2);
         }
      }
      
      private static function soundHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type != 2)
         {
            return;
         }
         if(!isFirst)
         {
            isFirst = true;
            return;
         }
         switch(typeID)
         {
            case 1:
               playSoundHandler(2);
               break;
            case 2:
               playSoundHandler(2,1);
               break;
            case 3:
               playSoundHandler(27);
               break;
            case 4:
               playSoundHandler(32);
         }
      }
      
      private static function removeHandler(evt:EventTaomee) : void
      {
         isFirst = false;
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         try
         {
            GV.onlineSocket.removeEventListener(trafficRes.TRAFFIC_OVER,soundHandler);
         }
         catch(E:*)
         {
         }
         if(!isFirst)
         {
            return;
         }
         try
         {
            haoChanler.stop();
            soundHao = null;
            haoChanler = null;
         }
         catch(E:*)
         {
         }
      }
      
      private static function playSoundHandler(soundID:int, type:int = 0) : void
      {
         var Stransform:SoundTransform = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee(PLAY_MAPACTION));
         soundHao = UIManager.getSound("sound_" + soundID);
         haoChanler = soundHao.play();
         if(type == 1)
         {
            try
            {
               Stransform = haoChanler.soundTransform;
               Stransform.volume = 0.5;
               haoChanler.soundTransform = Stransform;
            }
            catch(E:*)
            {
            }
         }
      }
   }
}

