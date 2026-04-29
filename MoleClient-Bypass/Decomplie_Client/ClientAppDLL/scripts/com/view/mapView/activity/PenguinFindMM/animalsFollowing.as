package com.view.mapView.activity.PenguinFindMM
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.module.farm.FieldView;
   import com.module.farm.IAnimal;
   import com.module.farm.IAnimal_Follow;
   import com.view.PeopleView.ClothAction;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class animalsFollowing
   {
      
      private static var instance:animalsFollowing;
      
      public var animal:Dictionary = new Dictionary(true);
      
      public function animalsFollowing()
      {
         super();
         instance = this;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      public static function getInstance() : animalsFollowing
      {
         if(!instance)
         {
            instance = new animalsFollowing();
         }
         return instance;
      }
      
      public function delAnimal(uid:uint, _id:int) : void
      {
         if(Boolean(this.animal[String(uid) + _id]))
         {
            if(Boolean(this.animal[String(uid) + _id] as IAnimal))
            {
               IAnimal(this.animal[String(uid) + _id]).clearClass();
            }
            this.animal[String(uid) + _id] = false;
         }
      }
      
      public function addAnimal(uid:uint, _id:int) : void
      {
         var loadLibcomplete:Function = null;
         this.delAnimal(uid,_id);
         loadLibcomplete = function(E:Event):void
         {
            BC.removeEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
            flowPeople(uid,_id);
         };
         BC.addEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         FieldView.Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在召喚...",false);
      }
      
      private function flowPeople(uid:uint, animalID:uint) : void
      {
         var fieldAnimalClass:Class = FieldView.Field_Lib.getClass("LandAnimal_Follow");
         var anm:Object = new Object();
         anm.NO = animalID;
         anm.ID = animalID;
         anm.Flag = 0;
         anm.Value = 1;
         anm.Type = 1;
         var tobj:Object = GoodsInfo.getInfoById(animalID);
         anm.typeObject = tobj.typeObject;
         anm.id = anm.ID;
         anm.name = tobj.name;
         anm.price = tobj.price;
         anm.Class = tobj.Class;
         anm.LevelArray = tobj.LevelArray;
         anm.quantifier = tobj.quantifier;
         anm.Fruit = tobj.Fruit;
         anm.growth = tobj.growth;
         if(anm.ID == 1270054)
         {
            anm.growth = 2000000;
            anm.Value = 2000000;
         }
         anm.water = tobj.water;
         anm.speed = tobj.speed;
         anm.floatSpeed = tobj.floatSpeed;
         anm.floatMoveTime = tobj.floatMoveTime;
         anm.baseMoveTime = tobj.baseMoveTime;
         anm.acedia = tobj.acedia;
         var fieldAnimal:IAnimal_Follow = new fieldAnimalClass() as IAnimal_Follow;
         fieldAnimal.showAnimal(new AnimalInfo(anm));
         fieldAnimal.followMole(PeopleManageView(GV.MAN_PEOPLE));
         if(Boolean(this.animal[String(uid) + animalID]))
         {
            return;
         }
         this.animal[String(uid) + animalID] = fieldAnimal;
         this.animal[String(uid) + animalID].visible = true;
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         var i:* = undefined;
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         BC.removeEvent(this);
         for each(i in this.animal)
         {
            if(Boolean(i as IAnimal))
            {
               IAnimal(i).clearClass();
            }
         }
      }
   }
}

