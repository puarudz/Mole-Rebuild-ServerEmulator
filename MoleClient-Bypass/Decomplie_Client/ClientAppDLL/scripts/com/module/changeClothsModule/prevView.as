package com.module.changeClothsModule
{
   import com.common.data.HashMap;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.socket.useUserDItem.UseUserItemRigReq;
   import com.module.pet.petInMapLogic;
   import com.mole.app.ui.TransfigurationShowPanel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.net.SharedObject;
   
   [Event(name="change",type="flash.events.Event")]
   public class prevView extends EventDispatcher
   {
      
      public static var GET_OFF:String = "getOffCloth";
      
      private var _levelCon:RoleViewLevel;
      
      private var _color:*;
      
      private var _clothsArray:Array;
      
      private var _canSelect:Boolean = false;
      
      private var currentType:*;
      
      private var _moleObj:Object;
      
      private var my_UseUserItemRigReq:UseUserItemRigReq;
      
      private var _iconHash:HashMap;
      
      private var _equipHash:HashMap;
      
      public function prevView(mc:MovieClip, mycolor:* = "#ffffff", arr:Array = null, moleobj:Object = null, canSelect:Boolean = false, roleType:int = -1)
      {
         var newPre:TransfigurationShowPanel = null;
         this._equipHash = new HashMap();
         super();
         if(roleType < 0)
         {
            roleType = int(LocalUserInfo.roleType);
         }
         if(arr != null)
         {
            this._clothsArray = arr.slice(0);
         }
         else
         {
            this._clothsArray = new Array();
         }
         if(roleType == 0)
         {
            this._canSelect = canSelect;
            this._levelCon = new RoleViewLevel(mc);
            this._color = mycolor;
            this._moleObj = moleobj;
            this.init();
         }
         else if(Boolean(mc["prev_mc"]["newRoleContainer"]))
         {
            mc["prev_mc"].body_mc.visible = false;
            newPre = new TransfigurationShowPanel();
            newPre.modeType(roleType);
            mc["prev_mc"]["newRoleContainer"].addChild(newPre);
            newPre.updateCloth(arr);
         }
      }
      
      private function init() : void
      {
         this.setColor(this._color);
         this.showCloths();
         this.showPet();
      }
      
      public function getShowClothArray() : Array
      {
         return this._clothsArray;
      }
      
      public function setShowClothArray(tempArr:Array, isUpdate:Boolean = false) : void
      {
         this._clothsArray = tempArr;
         this.showCloths(isUpdate);
      }
      
      public function showPet() : void
      {
         var pet_mc:MovieClip = null;
         DisplayUtil.removeAllChild(this._levelCon.petCon);
         if(this._moleObj != null && Boolean(this._moleObj.PetID))
         {
            pet_mc = UIManager.getMovieClip("pet_model" + this._moleObj.Petlevel + "_" + this._moleObj.Skill_Type);
            if(Boolean(pet_mc))
            {
               pet_mc.PetID = this._moleObj.PetID;
               pet_mc.PetLevel = this._moleObj.Petlevel;
               pet_mc.PetColor = this._moleObj.PetColor;
               if(this._moleObj.UserID == LocalUserInfo.getUserID())
               {
                  BC.addEvent(this,pet_mc,MouseEvent.CLICK,this.petBackHome);
               }
               this.setPetColor(pet_mc.pet,this._moleObj.PetColor);
               this._levelCon.petCon.addChild(pet_mc);
            }
         }
      }
      
      public function petBackHome(e:MouseEvent) : void
      {
         if(GV.MyInfo_PetObj.Level > 1)
         {
            DisplayUtil.removeAllChild(this._levelCon.petCon);
            petInMapLogic.doPethome(this._moleObj.PetID);
         }
      }
      
      public function setPetColor(mc:*, colorNum:*) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      public function setColor(num:*) : void
      {
         var tempArray:Array = null;
         var myColor:Object = null;
         if(Boolean(num as String))
         {
            tempArray = this.getPrimitiveColors(num);
         }
         else if(!isNaN(num))
         {
            tempArray = this.getPrimitiveColors(num.toString(16));
         }
         var j:uint = 1;
         var tempMC:MovieClip = this._levelCon.body_mc["pv_color" + j];
         while(Boolean(tempMC))
         {
            myColor = {
               "red":tempArray[0],
               "green":tempArray[1],
               "blue":tempArray[2]
            };
            tempMC["pv_color"].transform.colorTransform = new ColorTransform(myColor.red / 256,myColor.green / 256,myColor.blue / 256,1);
            j++;
            tempMC = this._levelCon.body_mc["pv_color" + j];
         }
      }
      
      public function putOn(obj:Object) : void
      {
         this.currentType = obj.layer;
         for(var i:uint = 0; i < this._clothsArray.length; i++)
         {
            if(this._clothsArray[i].layer == this.currentType)
            {
               this.getOff(i,false);
               break;
            }
            if(this._clothsArray[i].layer == 0 && this.currentType == 88)
            {
               this.getOff(i,false);
               break;
            }
            if(this._clothsArray[i].layer == 88 && this.currentType == 0)
            {
               this.getOff(i,false);
               break;
            }
         }
         if(obj.id != null)
         {
            this._clothsArray.push(obj);
         }
         this.showCloths();
      }
      
      public function getOffAllCloths() : void
      {
         for(var i:int = this._clothsArray.length - 1; i >= 0; i--)
         {
            this.getOff(i,false);
         }
         this.showCloths();
      }
      
      public function getOff(num:uint, isUpdate:Boolean = true) : void
      {
         var tempCloth:Object = this._clothsArray[num];
         this._clothsArray.splice(num,1);
         dispatchEvent(new EventTaomee(GET_OFF,tempCloth));
         if(isUpdate)
         {
            this.showCloths();
         }
      }
      
      public function getOffById(id:uint) : Boolean
      {
         for(var i:uint = 0; i < this._clothsArray.length; i++)
         {
            if(this._clothsArray[i].id == id)
            {
               this.getOff(i);
               return true;
            }
         }
         return false;
      }
      
      public function checkAvater() : void
      {
         var tempBool:Boolean = false;
         var i:int = 0;
         DisplayUtil.removeAllChild(this._levelCon.petCon);
         if(this._clothsArray.length == GV.MAN_PEOPLE.clothsArray.length)
         {
            this._clothsArray.sortOn("layer",16);
            GV.MAN_PEOPLE.clothsArray.sortOn("layer",16);
            tempBool = false;
            for(i = 0; i < this._clothsArray.length; i++)
            {
               if(this._clothsArray[i].id != GV.MAN_PEOPLE.clothsArray[i].id)
               {
                  tempBool = true;
                  break;
               }
            }
            if(tempBool)
            {
               this.save();
            }
            else
            {
               dispatchEvent(new Event("onSave"));
            }
         }
         else
         {
            this.save();
         }
      }
      
      public function save() : void
      {
         var userShared:SharedObject = null;
         if(LocalUserInfo.roleType == 0)
         {
            GV.onlineSocket.addEventListener("use_user_item_rig",this.changeCloths);
            this._clothsArray.sortOn("layer",16);
            this.my_UseUserItemRigReq = new UseUserItemRigReq();
            this.my_UseUserItemRigReq.useUserItemRig(this._clothsArray.slice(0));
            LocalUserInfo.setClothItem(this._clothsArray.slice(0));
            GV.MAN_PEOPLE.clothsArray = LocalUserInfo.getClothItem();
            GV.onlineSocket.dispatchEvent(new EventTaomee("changeClothForMap"));
            userShared = MainManager.getGlobalObject();
            userShared.data.clothArray = this._clothsArray.slice();
            GV.MAN_PEOPLE.ChangeCloths();
         }
      }
      
      public function changeCloths(E:*) : void
      {
         GV.onlineSocket.removeEventListener("use_user_item_rig",this.changeCloths);
         dispatchEvent(new Event("onSave"));
      }
      
      public function showCloths(isUpdate:Boolean = false) : void
      {
         var iconResID:uint = 0;
         var clothsObj:Object = null;
         var equipObj:Object = null;
         var i:uint = 0;
         var equipResIDList:Array = null;
         var equip_mc:DisplayObject = null;
         if(isUpdate)
         {
            DisplayUtil.removeAllChild(this._levelCon.bgCon);
            DisplayUtil.removeAllChild(this._levelCon.clothsCon);
         }
         if(Boolean(this._iconHash))
         {
            equipResIDList = this._iconHash.values;
            for each(iconResID in equipResIDList)
            {
               DownLoadManager.remove(iconResID);
            }
         }
         var oldEquipList:Array = this._equipHash.values;
         for each(equipObj in oldEquipList)
         {
            equipObj.flag = false;
         }
         this._iconHash = new HashMap();
         for(i = 0; i < this._clothsArray.length; i++)
         {
            clothsObj = this._clothsArray[i];
            if(clothsObj.id != 0)
            {
               if(!isUpdate && this._equipHash.containsKey(clothsObj.layer))
               {
                  equipObj = this._equipHash.getValue(clothsObj.layer);
                  equipObj.flag = true;
                  if(equipObj.data.id == clothsObj.id)
                  {
                     continue;
                  }
                  equip_mc = equipObj.mc;
                  DisplayUtil.removeForParent(equip_mc);
               }
               iconResID = DownLoadManager.add("resource/cloth/prevIcon/" + clothsObj.id + ".swf",ResType.DISPLAY_OBJECT,false,"",null,clothsObj);
               DownLoadManager.addEvent(iconResID,this.onLoadIconComplete);
               this._iconHash.add(iconResID,clothsObj);
            }
         }
         for each(equipObj in oldEquipList)
         {
            if(!equipObj.flag)
            {
               DisplayUtil.removeForParent(equipObj.mc);
               this._equipHash.remove(equipObj.data.layer);
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onLoadIconComplete(e:DownLoadEvent) : void
      {
         var layer:Object = null;
         var iconCon:Sprite = new Sprite();
         var icon_mc:Sprite = e.data as Sprite;
         iconCon.addChild(icon_mc);
         var info:Object = e.resInfo.data;
         var tempMC:DisplayObject = icon_mc.getChildAt(0);
         tempMC.x = tempMC.y = 0;
         if(this._canSelect)
         {
            if(Boolean(info))
            {
               this.addEvents(iconCon,info);
            }
         }
         this._iconHash.remove(e.resInfo.resId);
         var equipObj:Object = new Object();
         equipObj.data = info;
         equipObj.mc = iconCon;
         this._equipHash.add(info.layer,equipObj);
         var equipKeyList:Array = this._equipHash.keys;
         equipKeyList.sort(Array.NUMERIC);
         for each(layer in equipKeyList)
         {
            iconCon = this._equipHash.getValue(layer)["mc"];
            if(layer == 0 || layer == 88)
            {
               if(Boolean(this._levelCon.bgCon))
               {
                  if(this._levelCon.bgCon.numChildren > 0)
                  {
                     DisplayUtil.removeAllChild(this._levelCon.bgCon);
                  }
                  this._levelCon.bgCon.addChild(iconCon);
               }
            }
            else if(Boolean(this._levelCon.clothsCon))
            {
               this._levelCon.clothsCon.addChild(iconCon);
            }
         }
      }
      
      private function addEvents(mc:Sprite, info:Object) : void
      {
         mc.buttonMode = true;
         BC.addEvent(this,mc,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            BC.removeEvent(mc);
            var idx:int = _clothsArray.indexOf(info);
            if(idx != -1)
            {
               getOff(idx);
            }
         });
         tip.tipTailDisPlayObject(mc,info.name);
         BC.addEvent(mc,mc,MouseEvent.MOUSE_OVER,this.onOverIcon);
         BC.addEvent(mc,mc,MouseEvent.MOUSE_OUT,this.onOutIcon);
      }
      
      private function onOverIcon(e:MouseEvent) : void
      {
         var target_mc:DisplayObject = e.currentTarget as DisplayObject;
         target_mc.filters = [new GlowFilter(16777215,2,5,5,50)];
      }
      
      private function onOutIcon(e:MouseEvent) : void
      {
         var target_mc:DisplayObject = e.currentTarget as DisplayObject;
         target_mc.filters = [];
      }
      
      public function getColor() : int
      {
         return this._color;
      }
      
      private function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var myObj:Object = {
            0:0,
            1:1,
            2:2,
            3:3,
            4:4,
            5:5,
            6:6,
            7:7,
            8:8,
            9:9,
            "a":10,
            "b":11,
            "c":12,
            "d":13,
            "e":14,
            "f":15
         };
         var a:String = colorStr;
         if(a.indexOf("#") > -1)
         {
            a = a.slice(1);
         }
         while(a.length < 6)
         {
            a = "0" + a;
         }
         a = a.toLocaleLowerCase();
         var tempArray:Array = [];
         for(var i:uint = 0; i < 6; i += 2)
         {
            tempStr = a.substr(i,2);
            A = tempStr.substr(0,1);
            B = tempStr.substr(1,1);
            tempArray.push(myObj[A] * 16 + myObj[B]);
         }
         return tempArray;
      }
      
      public function destroy() : void
      {
         var keyList:Array = null;
         var resID:uint = 0;
         if(LocalUserInfo.roleType == 0)
         {
            DisplayUtil.removeForParent(this._levelCon);
            keyList = this._iconHash.keys;
            for each(resID in keyList)
            {
               DownLoadManager.remove(resID);
            }
            this._iconHash.clear();
            BC.removeEvent(this);
            this.my_UseUserItemRigReq = null;
            this._clothsArray = null;
            this._moleObj = null;
         }
      }
      
      public function clearClass() : void
      {
         this.destroy();
      }
   }
}

