package org.taomee.player.utils
{
   import flash.display.BitmapData;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import org.taomee.player.data.FrameInfo;
   import org.taomee.player.data.SheetInfo;
   import org.taomee.player.data.ValidFrameInfo;
   
   public class SheetUtil
   {
      
      public function SheetUtil()
      {
         super();
      }
      
      public static function makeSheetMap(domain:ApplicationDomain) : Dictionary
      {
         var sheetInfo:SheetInfo = null;
         var frameData:Object = getFrameData(domain);
         if(frameData == null)
         {
            return null;
         }
         var sheetVec:Vector.<SheetInfo> = getSheetVec(frameData.vec);
         var sheetMap:Dictionary = new Dictionary();
         for each(sheetInfo in sheetVec)
         {
            sheetMap[sheetInfo.id] = makeFrameVec(domain,sheetInfo);
         }
         return sheetMap;
      }
      
      public static function makeFrameVec(domain:ApplicationDomain, sheetInfo:SheetInfo) : Vector.<FrameInfo>
      {
         var frameInfo:FrameInfo = null;
         var info:ValidFrameInfo = null;
         var bmd:BitmapData = null;
         var frameVec:Vector.<FrameInfo> = new Vector.<FrameInfo>(sheetInfo.totalFrames,true);
         var bmdMap:Dictionary = new Dictionary();
         var validsFrameVec:Vector.<ValidFrameInfo> = sheetInfo.frames;
         for each(info in validsFrameVec)
         {
            frameInfo = new FrameInfo();
            if(info.index in bmdMap)
            {
               frameInfo.data = bmdMap[info.index];
            }
            else
            {
               bmd = getBitmapData(domain,"Frame_" + info.index.toString());
               bmdMap[info.index] = bmd;
               frameInfo.data = bmd;
            }
            frameInfo.x = info.x;
            frameInfo.y = info.y;
            frameVec[info.frame] = frameInfo;
         }
         validsFrameVec = null;
         bmdMap = null;
         return frameVec;
      }
      
      public static function getSheetVec(data:Vector.<int>) : Vector.<SheetInfo>
      {
         var info:SheetInfo = null;
         var frameLength:uint = 0;
         var i:int = 0;
         var frameInfo:ValidFrameInfo = null;
         var sheets:Vector.<SheetInfo> = new Vector.<SheetInfo>();
         var p:uint = 0;
         var length:uint = data.length;
         while(p < length)
         {
            info = new SheetInfo();
            info.id = data[p++];
            info.totalFrames = data[p++];
            frameLength = uint(data[p++]);
            info.frames = new Vector.<ValidFrameInfo>(frameLength,true);
            for(i = 0; i < frameLength; i++)
            {
               frameInfo = new ValidFrameInfo();
               frameInfo.frame = data[p++];
               frameInfo.index = data[p++];
               frameInfo.x = data[p++];
               frameInfo.y = data[p++];
               info.frames[i] = frameInfo;
            }
            sheets.push(info);
         }
         return sheets;
      }
      
      private static function getBitmapData(domain:ApplicationDomain, name:String) : BitmapData
      {
         var bmd:BitmapData = null;
         var classReference:Class = null;
         try
         {
            classReference = domain.getDefinition(name) as Class;
            bmd = new classReference(0,0) as BitmapData;
         }
         catch(e:Error)
         {
            trace("getBitmapData error:" + e.toString());
         }
         return bmd;
      }
      
      private static function getFrameData(domain:ApplicationDomain) : Object
      {
         var classReference:Class = null;
         try
         {
            classReference = domain.getDefinition("FrameData") as Class;
         }
         catch(e:Error)
         {
            trace("getFrameData error:" + e.toString());
         }
         if(classReference == null)
         {
            return null;
         }
         return new classReference();
      }
   }
}

