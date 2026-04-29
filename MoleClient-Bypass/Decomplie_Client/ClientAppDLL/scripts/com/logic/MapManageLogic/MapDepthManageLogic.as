package com.logic.MapManageLogic
{
   import com.event.EventTaomee;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MapDepthManageLogic extends EventDispatcher
   {
      
      public static var owner:MapDepthManageLogic;
      
      private static var currentChangeDepthMC:*;
      
      private static var joinArray:Array = new Array();
      
      public static var ADD_ARRAY:String = "AddArray";
      
      public static var ON_CHANGE_DEPTH:String = "onChangeDepth";
      
      public static var ON_DESTROY:String = "onDestroy";
      
      public function MapDepthManageLogic()
      {
         super();
         owner = this;
      }
      
      public static function compositorMapDepth() : void
      {
         var oldOwner:MapDepthManageLogic = null;
         var tempObj:MovieClip = null;
         if(Boolean(owner))
         {
            oldOwner = owner;
            new MapDepthManageLogic();
            oldOwner.dispatchEvent(new Event(ON_DESTROY));
         }
         else
         {
            new MapDepthManageLogic();
         }
         MapModelLogic.ManageLever.GoodsArray = new Array();
         for(var i:int = 0; i < MapModelLogic.ManageLever.numChildren; i++)
         {
            tempObj = MapModelLogic.ManageLever.getChildAt(i) as MovieClip;
            if(Boolean(tempObj) && !tempObj.isDynamic)
            {
               MapModelLogic.ManageLever.GoodsArray.push({
                  "depth":int(tempObj.y * 1000 + tempObj.x),
                  "Instance":tempObj
               });
            }
         }
         MapModelLogic.ManageLever.GoodsArray.sortOn("depth",Array.NUMERIC);
         MapModelLogic.ManageLever.GoodsArray.forEach(sortForDepth);
      }
      
      public static function sortForDepth(element:*, index:int, arr:Array) : void
      {
         MapModelLogic.ManageLever.setChildIndex(element.Instance,index);
      }
      
      public static function setPeopleDepth(changeDepthMC:*) : void
      {
         var arr2:Array = null;
         var tempObj:* = undefined;
         var temp1_array:Array = null;
         var item:DisplayObjectContainer = null;
         if(changeDepthMC.parent != MapModelLogic.ManageLever)
         {
            return;
         }
         currentChangeDepthMC = changeDepthMC;
         MapModelLogic.ManageLever.peopleArray = new Array();
         for(var i:int = 0; i < PeopleCountLogic.FloorLayerPList.length; i++)
         {
            arr2 = PeopleCountLogic.FloorLayerPList;
            tempObj = arr2[i].Instance;
            MapModelLogic.ManageLever.peopleArray.push({
               "depth":Math.round(tempObj.y * 1000 + tempObj.x),
               "Instance":tempObj
            });
         }
         var TempArray:Array = MapModelLogic.ManageLever.GoodsArray.concat(MapModelLogic.ManageLever.peopleArray);
         joinArray = new Array();
         owner.dispatchEvent(new EventTaomee(ADD_ARRAY,pushJoinArray));
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_ARRAY,pushJoinArray));
         if(Boolean(joinArray.length))
         {
            temp1_array = new Array();
            for each(item in joinArray)
            {
               if(Boolean(item) && item.parent != null)
               {
                  temp1_array.push({
                     "depth":Math.round(item.y * 1000 + int(item.x)),
                     "Instance":item
                  });
               }
            }
            TempArray = TempArray.concat(temp1_array);
            TempArray.sortOn("depth",Array.NUMERIC);
            for(i = 0; i < TempArray.length; i++)
            {
               tempObj = TempArray[i].Instance;
               if(tempObj.parent != MapModelLogic.ManageLever)
               {
                  TempArray.splice(i,1);
                  i--;
               }
               else
               {
                  try
                  {
                     if(Boolean(tempObj.parent))
                     {
                        tempObj.parent.setChildIndex(tempObj,i);
                     }
                  }
                  catch(E:*)
                  {
                     continue;
                  }
               }
            }
         }
         else
         {
            TempArray.sortOn("depth",Array.NUMERIC);
            TempArray.every(findChangeDepthMC);
         }
         if(owner != null)
         {
            owner.dispatchEvent(new Event(ON_CHANGE_DEPTH));
         }
      }
      
      public static function setAllPeopleDepth() : void
      {
         var tempObj:* = undefined;
         var i:int = 0;
         var TempArray:Array = null;
         var temp1_array:Array = null;
         var item:DisplayObject = null;
         try
         {
            MapModelLogic.ManageLever.peopleArray = new Array();
            for(i = 0; i < PeopleCountLogic.FloorLayerPList.length; i++)
            {
               tempObj = PeopleCountLogic.FloorLayerPList[i].Instance;
               MapModelLogic.ManageLever.peopleArray.push({
                  "depth":Math.round(tempObj.y * 1000 + tempObj.x),
                  "Instance":tempObj
               });
            }
            TempArray = MapModelLogic.ManageLever.GoodsArray.concat(MapModelLogic.ManageLever.peopleArray);
            joinArray = new Array();
            owner.dispatchEvent(new EventTaomee(ADD_ARRAY,pushJoinArray));
            GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_ARRAY,pushJoinArray));
            if(Boolean(joinArray.length))
            {
               temp1_array = new Array();
               for each(item in joinArray)
               {
                  if(item.parent != null)
                  {
                     temp1_array.push({
                        "depth":Math.round(item.y * 1000 + int(item.x)),
                        "Instance":item
                     });
                  }
               }
               TempArray = TempArray.concat(temp1_array);
            }
            TempArray.sortOn("depth",Array.NUMERIC);
            for(i = 0; i < TempArray.length; i++)
            {
               tempObj = TempArray[i].Instance;
               tempObj.parent.setChildIndex(tempObj,i);
            }
         }
         catch(E:*)
         {
         }
         if(owner != null)
         {
            owner.dispatchEvent(new Event(ON_CHANGE_DEPTH));
         }
      }
      
      private static function pushJoinArray(_arr:Array) : void
      {
         joinArray = joinArray.concat(_arr);
      }
      
      private static function findChangeDepthMC(element:*, index:int, arr:Array) : Boolean
      {
         var Bool:Boolean = element.Instance != currentChangeDepthMC;
         if(!Bool)
         {
            try
            {
               currentChangeDepthMC.parent.setChildIndex(currentChangeDepthMC,index);
            }
            catch(E:*)
            {
            }
         }
         return Bool;
      }
   }
}

