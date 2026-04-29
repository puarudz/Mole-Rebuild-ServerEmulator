package com.logic.itemSystemLogic
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.task.TaskGetListProtocol;
   import com.mole.app.utils.GetItem;
   import flash.display.MovieClip;
   import org.taomee.bean.BaseBean;
   
   public class itemSystemLogic extends BaseBean
   {
      
      public var itemArray:Array;
      
      public var allitemArray:Array;
      
      public var myItemArray:Array;
      
      public var mapItemArr:Array;
      
      public var targetMC:MovieClip;
      
      private var timeNum:int;
      
      private var _itemnum:GetItem;
      
      public function itemSystemLogic()
      {
         super();
      }
      
      override public function start() : void
      {
         this.itemArray = new Array();
         var itemObj_0:Object = {
            "id":0,
            "map":[[17,190001],[19,190002],[24,190003],[32,190004]]
         };
         var itemObj_27:Object = {
            "id":27,
            "map":[[37,190013]]
         };
         var itemObj_8:Object = {
            "id":8,
            "map":[[5,190014],[26,190015],[27,190016],[7,190017]]
         };
         var itemObj_16:Object = {
            "id":16,
            "map":[[27,190037],[34,190036]]
         };
         this.itemArray.push(itemObj_0,itemObj_8,itemObj_27,itemObj_16);
         GV.onlineSocket.addEventListener("itemSelectHandler",this.init);
         finish();
      }
      
      public function init(evt:EventTaomee) : void
      {
         var map_mc:MovieClip = GV.MC_mapFrame;
         if(map_mc == null || map_mc["control_mc"] == null || map_mc["control_mc"]["allitem"] == null)
         {
            return;
         }
         this.nextInit();
      }
      
      public function nextInit(event:EventTaomee = null) : void
      {
         var _mc:* = undefined;
         this.targetMC = GV.MC_mapFrame["control_mc"]["allitem"];
         for(var i:int = 0; i < this.targetMC.numChildren; i++)
         {
            _mc = this.targetMC.getChildAt(i);
            _mc.visible = false;
         }
         GV.onlineSocket.addEventListener(TaskGetListProtocol.LIST_ITEM,this.getJobList);
         TaskGetListProtocol.send(LocalUserInfo.getUserID());
      }
      
      public function getJobList(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(TaskGetListProtocol.LIST_ITEM,this.getJobList);
         this.myItemArray = new Array();
         this.allitemArray = new Array();
         this.allitemArray = evt.EventObj.List;
         for(var i:int = 0; i < this.allitemArray.length; i++)
         {
            if(this.allitemArray[i] == 1)
            {
               this.myItemArray.push(i);
            }
         }
         this.getMapItemInfo();
      }
      
      public function getMapItemInfo(evt:EventTaomee = null) : void
      {
         this.mapItemArr = this.returnMapItem();
         this._itemnum = new GetItem();
         this._itemnum.addEventListener(GetItem.BACKITEMNUM,this.getItemNum);
         this._itemnum.itemNum(this.mapItemArr);
      }
      
      private function getItemNum(e:EventTaomee) : void
      {
         this._itemnum.removeEventListener(GetItem.BACKITEMNUM,this.getItemNum);
         var isItemarr:Array = e.EventObj.arr;
         for(var i:int = 0; i < isItemarr.length; i++)
         {
            if(isItemarr[i] == 0)
            {
               if(this.targetMC["item" + this.mapItemArr[i]] != null)
               {
                  this.targetMC["item" + this.mapItemArr[i]].item.itemID = this.mapItemArr[i];
                  this.targetMC["item" + this.mapItemArr[i]].visible = true;
               }
            }
         }
         this._itemnum.p = this.mapItemArr.length;
         this._itemnum.destroy();
         this._itemnum = null;
      }
      
      private function returnMapItem() : Array
      {
         var j:int = 0;
         var assignmentID:int = 0;
         var u:int = 0;
         var k:int = 0;
         var tempIempArray:Array = new Array();
         for(var i:int = 0; i < this.myItemArray.length; i++)
         {
            for(j = 0; j < this.itemArray.length; j++)
            {
               assignmentID = int(this.myItemArray[i]);
               if(assignmentID == this.itemArray[j].id)
               {
                  for(u = 0; u < this.itemArray[j].map.length; u++)
                  {
                     if(GV.MapInfo_mapID == this.itemArray[j].map[u][0])
                     {
                        for(k = 1; k < this.itemArray[j].map[u].length; k++)
                        {
                           tempIempArray.push(this.itemArray[j].map[u][k]);
                        }
                     }
                  }
               }
            }
         }
         return tempIempArray;
      }
   }
}

