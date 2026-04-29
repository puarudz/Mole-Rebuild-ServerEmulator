package com.view.PeopleView
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   
   public class BoneInfo
   {
      
      public static var LabelInfo:Dictionary;
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var Bones:String = "bones";
      
      public static var Kyte:String = "kyte";
      
      public static var Shadow:String = "shadow";
      
      public function BoneInfo()
      {
         super();
      }
      
      public static function Init() : void
      {
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
      }
      
      public static function popBoneInfo() : void
      {
         var tempMC:MovieClip = null;
         var labels:Array = null;
         var i:uint = 0;
         var label:FrameLabel = null;
         if(!LabelInfo)
         {
            LabelInfo = new Dictionary(true);
            tempMC = IndexManager.getInstance().getMovieClip("body1") as MovieClip;
            labels = tempMC.currentLabels;
            for(i = 0; i < labels.length; i++)
            {
               label = labels[i];
               LabelInfo[label.name] = {
                  "frame":label.frame,
                  "isCommonlyFrame":true
               };
            }
         }
      }
      
      public static function loadBone(Act:String, JobID:int, BoneType:String) : void
      {
         var tempLoader:Loader = new Loader();
         var url:String = "resource/body/" + Act + "/" + GoodsInfo.ClothObject["ActName_" + JobID] + "/" + BoneType + ".swf";
         tempLoader.load(VL.getURLRequest(url));
         BC.addEvent(BoneInfo,tempLoader.contentLoaderInfo,IOErrorEvent.IO_ERROR,function(E:IOErrorEvent):void
         {
            BC.removeEvent(BoneInfo,E.currentTarget);
            BoneInfo.dispatchEvent(new EventTaomee(IOErrorEvent.IO_ERROR,{
               "url":E.text,
               "app":E.currentTarget.applicationDomain,
               "act":Act,
               "job":GoodsInfo.ClothObject[JobID],
               "boneType":BoneType
            }));
         });
         BC.addEvent(BoneInfo,tempLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
         {
            BC.removeEvent(BoneInfo,E.currentTarget);
            BoneInfo.dispatchEvent(new EventTaomee(Event.INIT,{
               "app":E.currentTarget.applicationDomain,
               "act":Act,
               "job":GoodsInfo.ClothObject[JobID],
               "boneType":BoneType
            }));
         });
      }
   }
}

