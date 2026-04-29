package com.module.newHouse.ModelShowCloths
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.logic.socket.house.HouseSocket;
   import com.module.newHouse.newHouseView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ModelShowCloths
   {
      
      private static var instance:ModelShowCloths;
      
      private static var canotNew:Boolean = true;
      
      private var mainObj:Object;
      
      private var tepobj:Object;
      
      private var modeArr:Array = new Array();
      
      public function ModelShowCloths()
      {
         super();
         if(canotNew)
         {
            throw new Error("ModelShowCloths不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : ModelShowCloths
      {
         if(!instance)
         {
            canotNew = false;
            instance = new ModelShowCloths();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(tempObj:Object) : void
      {
         var a:int = 0;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeHandler);
         for(var i:int = 160549; i <= 160598; i++)
         {
            a = i - 160549;
            this.modeArr[a] = i;
         }
         if(this.modeArr.indexOf(tempObj.ID) != -1)
         {
            this.tepobj = tempObj;
            this.mainObj = tempObj;
            BC.addEvent(this,GV.onlineSocket,"read_" + 1939,this.onRead1939);
            HouseSocket.getModelShowCloths();
         }
      }
      
      private function onRead1939(evt:EventTaomee) : void
      {
         var clothObjArr:Array = null;
         var coa:Array = null;
         var x:int = 0;
         var y:int = 0;
         var ca:Array = null;
         var bgArr:Array = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1939,this.onRead1939);
         var eventArr:Array = evt.EventObj.arr;
         if(eventArr.length != 0)
         {
            clothObjArr = new Array();
            coa = new Array();
            for(x = 0; x < eventArr.length; x++)
            {
               if(eventArr[x].modelId == this.tepobj.ID)
               {
                  clothObjArr = eventArr[x].modelArr;
               }
            }
            for(y = 0; y < clothObjArr.length; y++)
            {
               trace(clothObjArr[y]);
               coa.push(GoodsInfo.getInfoById(clothObjArr[y]));
            }
            ca = coa.slice();
            ca.sortOn("layer",16);
            bgArr = [];
            while(Boolean(ca.length))
            {
               if(ca[0].layer != 0)
               {
                  break;
               }
               bgArr.push(ca.shift());
            }
            this.showCloths(ca);
         }
      }
      
      public function showBtnPanel(tempObject:Object) : void
      {
         this.mainObj = null;
         this.mainObj = tempObject.currentTarget;
         if(newHouseView.houseID == LocalUserInfo.getUserID())
         {
            BC.addEvent(this,MovieClip(this.mainObj.btnPanel),MouseEvent.MOUSE_OUT,this.onMOUSE_OUT);
            this.mainObj.btnPanel.visible = true;
            BC.addEvent(this,this.mainObj.btnPanel.getClothBtn,MouseEvent.CLICK,this.onGetClothBtn);
            BC.addEvent(this,this.mainObj.btnPanel.setClothBtn,MouseEvent.CLICK,this.onSetClothBtn);
         }
      }
      
      private function onMOUSE_OUT(evt:MouseEvent) : void
      {
         BC.removeEvent(this,MovieClip(this.mainObj.btnPanel),MouseEvent.MOUSE_OUT,this.onMOUSE_OUT);
         this.mainObj.btnPanel.visible = false;
      }
      
      private function onGetClothBtn(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.mainObj.btnPanel.getClothBtn,MouseEvent.CLICK,this.onGetClothBtn);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1940,this.onRead1940);
         HouseSocket.modelClothsTomoleCloths(this.mainObj.ID);
      }
      
      private function onRead1940(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1940,this.onRead1940);
         GC.clearAllChildren(this.mainObj.mc2.getChildAt(0).clothMc);
      }
      
      private function onSetClothBtn(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.mainObj.btnPanel.setClothBtn,MouseEvent.CLICK,this.onSetClothBtn);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1941,this.onRead1941);
         HouseSocket.moleClothsToModelCloths(this.mainObj.ID);
      }
      
      private function onRead1941(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1941,this.onRead1941);
         GC.clearAllChildren(this.mainObj.mc2.getChildAt(0).clothMc);
         var ca:Array = LocalUserInfo.getClothItem().slice();
         ca.sortOn("layer",16);
         var bgArr:Array = [];
         while(Boolean(ca.length))
         {
            if(ca[0].layer != 0)
            {
               break;
            }
            bgArr.push(ca.shift());
         }
         this.showCloths(ca);
      }
      
      public function showCloths(tempClothArr:Array) : *
      {
         var tempArray:Array;
         var i:uint = 0;
         var tempLoader:Loader = null;
         var clothsArray:Array = tempClothArr;
         clothsArray.sortOn("layer",16);
         tempArray = clothsArray.slice(0);
         while(Boolean(tempArray.length))
         {
            if(tempArray[0].layer != 0)
            {
               break;
            }
            tempArray.shift();
         }
         if(tempArray.length > 0)
         {
            for(i = 0; i < tempArray.length; i++)
            {
               tempLoader = new Loader();
               try
               {
                  LoaderList.getInstance().addItem(tempLoader,VL.getURLRequest("resource/cloth/swf/" + tempArray[i].id + ".swf"),LoaderList.LOW);
               }
               catch(E:*)
               {
                  continue;
               }
               BC.addEvent(this,tempLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
               {
                  var tempMC:MovieClip = null;
                  var tempClass:* = E.currentTarget.applicationDomain.getDefinition("prop") as Class;
                  if(tempClass != null)
                  {
                     tempMC = new tempClass();
                     tempMC.gotoAndStop(1);
                     mainObj.mc2.getChildAt(0).clothMc.addChild(tempMC);
                  }
               });
            }
         }
      }
      
      public function removeHandler(e:Event) : void
      {
         BC.removeEvent(this);
         this.mainObj = null;
      }
   }
}

