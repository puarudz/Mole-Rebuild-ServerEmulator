package com.view.PeopleView.ChildPeople
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.view.PeopleView.ClothAction;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   
   public class ChangeCloths
   {
      
      public static var GET_OFF:String = "getOffCloth";
      
      private var _InstanceMC:MovieClip;
      
      public var shadowMC:MovieClip;
      
      public var clothsObj:Object;
      
      private var target:MovieClip;
      
      private var clothsArray:Array;
      
      private var currentType:*;
      
      public function ChangeCloths()
      {
         super();
      }
      
      public function init(mc:MovieClip) : void
      {
         this.InstanceMC = mc;
         this.target = mc.avatarMC.Visualize_mc;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
         if(this.InstanceMC.clothsArray != null)
         {
            this.clothsArray = this.InstanceMC.clothsArray;
         }
         else
         {
            this.clothsArray = new Array();
         }
         if(this.InstanceMC.address == 0 || this.InstanceMC.address == "17003")
         {
            this.shadowMC = IndexManager.getInstance().getMovieClip("shadow");
            this.shadowMC.name = "0000";
            this.shadowMC.alpha = 1.5;
            this.showCloths();
         }
      }
      
      public function putOn(E:Object) : void
      {
         var tempBool:Boolean = false;
         for(var k:uint = 0; k < this.clothsArray.length; k++)
         {
            if(this.clothsArray[k].id == E.id)
            {
               tempBool = true;
               break;
            }
         }
         if(!tempBool)
         {
            this.getOffByLayer(E.layer);
            this.clothsArray.push(E);
            this.InstanceMC.clothsArray = this.clothsArray;
            if(LocalUserInfo.getUserID() == this.InstanceMC.id)
            {
               LocalUserInfo.setClothItem(this.clothsArray);
            }
         }
      }
      
      public function getOff(E:Object) : void
      {
         for(var k:uint = 0; k < this.clothsArray.length; k++)
         {
            if(this.clothsArray[k].id == E.id)
            {
               this.clothsArray.splice(k,1);
               this.InstanceMC.clothsArray = this.clothsArray;
               if(LocalUserInfo.getUserID() == this.InstanceMC.id)
               {
                  LocalUserInfo.setClothItem(this.clothsArray);
               }
               break;
            }
         }
      }
      
      public function getOffAll() : void
      {
         if(LocalUserInfo.getUserID() == this.InstanceMC.id)
         {
            this.clothsArray.length = 0;
            this.InstanceMC.clothsArray = this.clothsArray;
            LocalUserInfo.setClothItem(this.clothsArray);
         }
      }
      
      public function getOffByLayer(l:int) : void
      {
         for(var k:int = 0; k < this.clothsArray.length; k++)
         {
            if(this.clothsArray[k].layer == l)
            {
               this.clothsArray.splice(k,1);
               k--;
            }
         }
         this.InstanceMC.clothsArray = this.clothsArray;
         if(LocalUserInfo.getUserID() == this.InstanceMC.id)
         {
            LocalUserInfo.setClothItem(this.clothsArray);
         }
      }
      
      public function refurbishCloths(E:* = null) : void
      {
         if(this.InstanceMC.id == LocalUserInfo.getUserID())
         {
            this.clothsArray = LocalUserInfo.getClothItem().slice(0);
         }
         this.showCloths();
      }
      
      public function showCloths() : *
      {
         var tempArray:Array = null;
         if(Boolean(this.InstanceMC) && Boolean(this.InstanceMC.isActionMovie))
         {
            return;
         }
         var thisObj:ChangeCloths = this;
         if(this.InstanceMC.address == 0 || this.InstanceMC.address == "17003")
         {
            this.clothsArray.sortOn("layer",16);
            tempArray = this.clothsArray.slice(0);
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
               this.InstanceMC.avatarClass.changeCloth(tempArray);
            }
            else
            {
               this.InstanceMC.avatarClass.changeCloth(tempArray);
               this.target.addChild(this.shadowMC);
               this.InstanceMC.isNewPeople = true;
               this.InstanceMC.avatarClass["onClothsChange"]();
            }
         }
         ClothAction.checkCloth(this.InstanceMC);
      }
      
      private function setClothsXY(E:*, startNum:*, totalNum:*, tempStr:String = "") : void
      {
         var tempClass:* = undefined;
         var tempMC:MovieClip = null;
         if(tempStr != "")
         {
            tempClass = E.currentTarget.applicationDomain.getDefinition("prop") as Class;
            if(tempClass != null)
            {
               tempMC = new tempClass();
               if(int(tempStr) == 12991 || int(tempStr) == 13163 || int(tempStr) == 13569 || int(tempStr) == 14086 || int(tempStr) == 14085)
               {
                  tempMC.y = this.InstanceMC.avatarMC.nickName_txt.y - 10;
                  if(LocalUserInfo.getMapID() == 166)
                  {
                     tempMC.visible = false;
                  }
               }
               tempMC.name = tempStr;
               tempMC.gotoAndStop(1);
               this.InstanceMC.avatarClass.stopAction();
               this.clothsObj[tempStr] = tempMC;
               this.InstanceMC.dispatchEvent(new EventTaomee("onCloth_" + tempStr + "_loaded",tempMC));
            }
         }
         try
         {
            E.currentTarget.loader.unload();
         }
         catch(E:*)
         {
            trace(E);
         }
         if(startNum == totalNum)
         {
            this.showShaDow();
         }
      }
      
      private function clearProp(clothMC:MovieClip) : void
      {
      }
      
      private function showShaDow() : void
      {
         var tempMC2:MovieClip = null;
         var errorNum:uint = 0;
         var tempArr:Array = this.clothsArray.slice(0);
         tempArr.push({
            "layer":34,
            "id":"0000"
         });
         tempArr.sortOn("layer",16);
         while(Boolean(tempArr.length) && tempArr[0].layer <= 0)
         {
            tempArr.shift();
         }
         for(var i:uint = 0; i < tempArr.length; i++)
         {
            tempMC2 = this.clothsObj[String(tempArr[i].id)];
            if(tempMC2 != null)
            {
               this.target.addChild(tempMC2);
            }
         }
         this.InstanceMC.isNewPeople = true;
         this.InstanceMC.metier = PeopleManageView.checkWork(this.InstanceMC.clothsArray);
         this.InstanceMC.avatarClass["onClothsChange"]();
      }
      
      public function clearClass(E:* = null) : void
      {
         var item:String = null;
         BC.removeEvent(this);
         for(item in this.clothsObj)
         {
            try
            {
               this.clearProp(this.clothsObj[item]);
               GC.clearAll(this.clothsObj[item]);
            }
            catch(E:*)
            {
               continue;
            }
            this.clothsObj[item] = null;
         }
         this.clothsObj = null;
         this.InstanceMC = null;
         this.target = null;
         this.shadowMC = null;
         this.clothsArray = null;
      }
      
      public function get InstanceMC() : MovieClip
      {
         return this._InstanceMC;
      }
      
      public function set InstanceMC(value:MovieClip) : void
      {
         this._InstanceMC = value;
      }
   }
}

