package com.module.farm
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FarmWarehouseBar
   {
      
      public static const AddAnimalToFarmEvent:String = "AddAnimalToFarmEvent";
      
      private var Kind:int = 0;
      
      private const NUM:Number = 10;
      
      private var _ui:MovieClip;
      
      private var currentPage:uint = 1;
      
      private var depotGoodsArr:Array;
      
      public function FarmWarehouseBar(ui:MovieClip)
      {
         super();
         this._ui = ui;
         BC.addEvent(this,this._ui.close_btn,MouseEvent.CLICK,this.OpenOrCloseBar);
         for(var i:uint = 0; i < 3; i++)
         {
            if(i != 0)
            {
               this._ui["kind" + i].gotoAndStop(2);
            }
            BC.addEvent(this,this._ui["kind" + i].btn,MouseEvent.CLICK,this.showKindGoods);
         }
         BC.addEvent(this,this._ui.prev_btn,MouseEvent.CLICK,this.prevPage);
         BC.addEvent(this,this._ui.next_btn,MouseEvent.CLICK,this.nextPage);
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
      
      public function GetItemByIndex(value:int) : MovieClip
      {
         return this._ui["I" + value] as MovieClip;
      }
      
      public function OpenOrCloseBar(e:MouseEvent = null) : void
      {
         this.visible = !this.visible;
      }
      
      public function updateWarehouseData(e:EventTaomee) : void
      {
         var temp:MovieClip = null;
         var id:int = int(e.EventObj.anmID);
         if(Boolean(e.EventObj.data))
         {
            if(e.EventObj.data.rawId != id)
            {
               id = int(e.EventObj.data.rawId);
               this.PlayEggToAnimalMovie(e.EventObj.data.rawId,e.EventObj.anmID,e.EventObj.data.starLvl);
            }
         }
         for(var i:uint = 0; i < this.NUM; i++)
         {
            temp = this.GetItemByIndex(i);
            if(temp.ID > 0 && temp.ID == id)
            {
               this.moveGoodsToHouse(temp);
               return;
            }
         }
      }
      
      private function PlayEggToAnimalMovie(eggId:int, aniamlId:int, star:int) : void
      {
         var eggPath:String;
         var eggLoad:Loader;
         var animalPath:String;
         var sprite:Sprite = null;
         var animalLoad:Loader = null;
         sprite = new Sprite();
         sprite.graphics.beginFill(0,0.8);
         sprite.graphics.drawRect(0,0,1000,600);
         var _temp_4:* = BC;
         var _temp_3:* = sprite;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "farm_egg_to_animal_movie_over";
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:Event):void
            {
               BC.removeEvent(sprite);
               sprite.visible = false;
               if(Boolean(sprite.parent))
               {
                  sprite.parent.removeChild(sprite);
               }
            });
            eggPath = "resource/lamuPKSys/farm/egg/";
            eggLoad = new Loader();
            eggLoad.x = 400;
            eggLoad.y = 150;
            eggLoad.load(VL.getURLRequest(eggPath + eggId + ".swf"));
            sprite.addChild(eggLoad);
            animalPath = GoodsInfo.GetAnimalSwfPath(aniamlId,star);
            var _temp_8:* = BC;
            var _temp_7:* = animalLoad;
            var _temp_6:* = animalLoad.contentLoaderInfo;
            var _temp_5:* = Event.COMPLETE;
            with({})
            {
               _temp_8.addEvent(_temp_7,_temp_6,_temp_5,function handler(e:Event):void
               {
                  BC.removeEvent(animalLoad);
                  var cls:Class = animalLoad.contentLoaderInfo.applicationDomain.getDefinition("animal_mc") as Class;
                  var animal:MovieClip = NewClass(cls);
                  animal.x = 464;
                  animal.y = 230;
                  sprite.addChildAt(animal,0);
               });
               animalLoad.load(VL.getURLRequest(animalPath));
               MainManager.getAppLevel().addChild(sprite);
            }
            
            private function NewClass(cls:Class) : MovieClip
            {
               return new cls();
            }
            
            private function moveGoodsToHouse(temp:Object) : void
            {
               var id:int = int(temp.ID);
               var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
               var objkind:Number = Number(temp.Type);
               var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
               for(var i:uint = 0; i < thisKindLen; i++)
               {
                  if(this.depotGoodsArr[objkind][i].ID == id)
                  {
                     --this.depotGoodsArr[objkind][i].Count;
                     temp.Count = this.depotGoodsArr[objkind][i].Count;
                     if(this.depotGoodsArr[objkind][i].Count < 1)
                     {
                        this.depotGoodsArr[objkind].splice(i,1);
                        this.removeOneInAll(id);
                        if(this.depotGoodsArr[this.Kind].length % this.NUM != 0)
                        {
                           this.showGoods(this.Kind,this.currentPage);
                        }
                        else
                        {
                           if(this.currentPage > 1)
                           {
                              --this.currentPage;
                           }
                           this.showGoods(this.Kind,this.currentPage);
                        }
                     }
                     else
                     {
                        temp.num_txt.text = this.depotGoodsArr[objkind][i].Count;
                     }
                     break;
                  }
               }
            }
            
            public function get visible() : Boolean
            {
               return this._ui.visible;
            }
            
            public function set visible(value:Boolean) : void
            {
               this._ui.visible = value;
               if(this._ui.visible)
               {
                  BC.addEvent(this,FieldLogic.getInstance(),FieldLogic.GET_FARM_DEPOT_GOODS,this.getDepotGoods);
                  FieldLogic.getInstance().DepotReq();
                  this.changeBtn(0);
               }
            }
            
            private function AddAnimalToFarm(e:MouseEvent) : void
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(AddAnimalToFarmEvent,e.target.parent.ID));
            }
            
            private function changeBtn(j:uint) : void
            {
               for(var i:uint = 0; i < 3; i++)
               {
                  if(i == j)
                  {
                     this._ui["kind" + i].gotoAndStop(1);
                  }
                  else
                  {
                     this._ui["kind" + i].gotoAndStop(2);
                  }
               }
            }
            
            private function clearItems() : void
            {
               var temp:MovieClip = null;
               for(var i:uint = 0; i < this.NUM; i++)
               {
                  temp = this.GetItemByIndex(i);
                  if(temp.num != null)
                  {
                     temp.loadimg.removeChildAt(0);
                     temp.num = null;
                     temp.type = null;
                     temp.btn.visible = false;
                     temp.num_txt.text = "";
                  }
               }
            }
            
            private function getDepotGoods(e:EventTaomee) : void
            {
               BC.removeEvent(this,FieldLogic.getInstance(),FieldLogic.GET_FARM_DEPOT_GOODS,this.getDepotGoods);
               this.depotGoodsArr = e.EventObj.arr;
               this.showGoods(0,1);
            }
            
            private function prevPage(E:MouseEvent) : void
            {
               if(this.currentPage > 1)
               {
                  this.showGoods(this.Kind,--this.currentPage);
               }
            }
            
            private function nextPage(E:MouseEvent) : void
            {
               if(this.depotGoodsArr[this.Kind].length > this.currentPage * this.NUM)
               {
                  this.showGoods(this.Kind,++this.currentPage);
               }
            }
            
            private function onBtnOut(E:MouseEvent) : void
            {
               E.target.parent.gotoAndStop(1);
            }
            
            private function onBtnOver(e:MouseEvent) : void
            {
               e.target.parent.gotoAndStop(2);
               var goods:Object = e.currentTarget.parent;
               GF.showTip(goods.Name,{
                  "noDelay":true,
                  "x":goods.x + 64,
                  "y":goods.y + 430
               });
            }
            
            private function removeOneInAll(id:int) : void
            {
               var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
               for(var i:uint = 0; i < totalArrlen; i++)
               {
                  if(id == this.depotGoodsArr[0][i].ID)
                  {
                     this.depotGoodsArr[0].splice(i,1);
                     break;
                  }
               }
            }
            
            private function showGoods(tempkind:uint, pagenum:uint) : void
            {
               var temp:MovieClip = null;
               var tempLoader:Loader = null;
               this.Kind = tempkind;
               this.currentPage = pagenum;
               try
               {
                  this.clearItems();
               }
               catch(e:Error)
               {
               }
               for(var i:int = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
               {
                  temp = this.GetItemByIndex(i - (this.currentPage - 1) * this.NUM);
                  try
                  {
                     BC.removeEvent(this,temp.btn,MouseEvent.CLICK,this.AddAnimalToFarm);
                  }
                  catch(e:Error)
                  {
                  }
                  if(this.depotGoodsArr[this.Kind][i] != null)
                  {
                     temp.num = i;
                     temp.ID = this.depotGoodsArr[this.Kind][i].ID;
                     try
                     {
                        temp.num_txt.text = this.depotGoodsArr[this.Kind][i].Count;
                     }
                     catch(e:Error)
                     {
                     }
                     temp.obj = this.depotGoodsArr[this.Kind][i];
                     temp.Type = this.depotGoodsArr[this.Kind][i].Type;
                     temp.Name = this.depotGoodsArr[this.Kind][i].name;
                     temp.Count = this.depotGoodsArr[this.Kind][i].Count;
                     temp.Layer = this.depotGoodsArr[this.Kind][i].Layer;
                     temp.Price = this.depotGoodsArr[this.Kind][i].price;
                     temp.Class = this.depotGoodsArr[this.Kind][i].Class;
                     temp.Grade = this.depotGoodsArr[this.Kind][i].Grade;
                     temp.btn.visible = true;
                     BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OVER,this.onBtnOver);
                     BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OUT,this.onBtnOut);
                     BC.addEvent(this,temp.btn,MouseEvent.CLICK,this.AddAnimalToFarm);
                     tempLoader = new Loader();
                     tempLoader.load(VL.getURLRequest("resource/farm/icon/" + this.depotGoodsArr[this.Kind][i].ID + ".swf"));
                     temp.loadimg.addChild(tempLoader);
                  }
                  else
                  {
                     temp.btn.enabled = false;
                  }
               }
            }
            
            private function showKindGoods(e:MouseEvent) : void
            {
               var tempkind:Number = Number(e.target.parent.name.slice(4,5));
               if(this.Kind != tempkind)
               {
                  this.Kind = tempkind;
                  this.changeBtn(this.Kind);
                  this.showGoods(this.Kind,1);
               }
            }
         }
      }
      
      