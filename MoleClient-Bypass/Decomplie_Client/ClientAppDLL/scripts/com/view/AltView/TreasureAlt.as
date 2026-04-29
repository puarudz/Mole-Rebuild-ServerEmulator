package com.view.AltView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class TreasureAlt extends Sprite
   {
      
      private var alt_obj:Object;
      
      private var myAlert:*;
      
      private var exchangeID:uint;
      
      private var payID:Array;
      
      private var payNum:Array;
      
      private var nowPayItem:Array;
      
      private var currentCheckIndex:int;
      
      private var alertLevel:uint;
      
      public function TreasureAlt()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function setInfo(ITEM_ID:String, level:uint = 0) : void
      {
         this.alertLevel = level;
         this.alt_obj = XMLInfo.AltXML[ITEM_ID];
         this.showAlt(this.alt_obj.ExchangeID,this.alt_obj.PayID,this.alt_obj.PayNum,this.alt_obj.isLimit,this.alt_obj.isNeedSL);
      }
      
      public function showAlt(_exchangeID:uint, _payID:Array, _payNum:Array, _isLimit:Boolean = false, _isNeedSL:Boolean = false) : void
      {
         var _msg:String = null;
         this.exchangeID = _exchangeID;
         this.payID = _payID;
         this.payNum = _payNum;
         this.nowPayItem = new Array();
         if(_isNeedSL)
         {
            if(!LocalUserInfo.isVIP())
            {
               _msg = this.alt_obj.SLTip;
               if(this.alertLevel == 1)
               {
                  GF.showAlert(MainManager.getGameLevel(),_msg,"",100,"iknow",true,false,"E");
               }
               else
               {
                  GF.showAlert(MainManager.getAppLevel(),_msg,"",100,"iknow",true,false,"E");
               }
               return;
            }
         }
         if(_isLimit)
         {
            GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.checkLimitHandler);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this.exchangeID,2);
         }
         else
         {
            this.getPayNum();
         }
      }
      
      private function checkLimitHandler(eve:EventTaomee = null) : void
      {
         var _msg:String = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.checkLimitHandler);
         var obj:Object = eve.EventObj.obj;
         if(obj.Count != 0)
         {
            _msg = this.alt_obj.LimitTip;
            if(this.alertLevel == 1)
            {
               GF.showAlert(MainManager.getGameLevel(),_msg,"",100,"iknow",true,false,"D");
            }
            else
            {
               GF.showAlert(MainManager.getAppLevel(),_msg,"",100,"iknow",true,false,"D");
            }
         }
         else
         {
            this.getPayNum();
         }
      }
      
      private function getPayNum(index:int = 0) : void
      {
         this.currentCheckIndex = index;
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this.payID[index],2);
      }
      
      private function getPayNumHandler(eve:EventTaomee = null) : void
      {
         var msg:String = null;
         var infoObj:Object = null;
         var exchangeName:String = null;
         var payObj:Object = null;
         var payName:String = null;
         var _url:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         var obj:Object = eve.EventObj.obj;
         if(obj.Count == 0)
         {
            msg = this.alt_obj.ErrorTip;
            if(this.alertLevel == 1)
            {
               GF.showAlert(MainManager.getGameLevel(),msg,"",100,"iknow",true,false,"D");
            }
            else
            {
               GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"D");
            }
         }
         else if(obj.arr[0].itemCount < this.payNum[this.currentCheckIndex])
         {
            msg = this.alt_obj.ErrorTip;
            if(this.alertLevel == 1)
            {
               GF.showAlert(MainManager.getGameLevel(),msg,"",100,"iknow",true,false,"D");
            }
            else
            {
               GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"D");
            }
         }
         else
         {
            ++this.currentCheckIndex;
            if(this.currentCheckIndex != this.payID.length)
            {
               this.getPayNum(this.currentCheckIndex);
            }
            else
            {
               infoObj = GoodsInfo.getInfoById(this.exchangeID);
               exchangeName = infoObj.name;
               payObj = GoodsInfo.getInfoById(this.payID[this.currentCheckIndex]);
               payName = payObj.name;
               _url = this.alt_obj.StorePath + this.exchangeID + ".swf";
               msg = this.alt_obj.ConfirmTip;
               if(this.alertLevel == 1)
               {
                  this.myAlert = Alert.showAlert(MainManager.getGameLevel(),_url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
               }
               else
               {
                  this.myAlert = Alert.showAlert(MainManager.getAppLevel(),_url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
               }
               this.myAlert.addEventListener(Alert.CLICK_ + "1",this.exchangeItemHandler,false,0,true);
            }
         }
      }
      
      private function exchangeItemHandler(eve:Event = null) : void
      {
         if(this.alt_obj.CSReqID == 0 || this.alt_obj.CSReqID == 1 || this.alt_obj.CSReqID == 2 || this.alt_obj.CSReqID == 3)
         {
            BC.addEvent(this,GV.onlineSocket,CSEXRes.EX_FINISH,this.getExItemOkHandler);
            BC.addEvent(this,GV.onlineSocket,"ex_brave_errorID",this.errorHandler);
            CSEXReq.GetExItem(this.alt_obj.CSReqID);
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
            CSReq.Info(this.alt_obj.CSReqID);
         }
      }
      
      private function getItemOkHandler(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
         var _msg:String = "    兌換成功啦，寶貝已經放入你的" + this.alt_obj.StoreHouse + "了哦！";
         var _url:String = this.alt_obj.StorePath + this.exchangeID + ".swf";
         if(this.alertLevel == 1)
         {
            this.myAlert = Alert.showAlert(MainManager.getGameLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         else
         {
            this.myAlert = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
      }
      
      private function getExItemOkHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CSEXRes.EX_FINISH,this.getExItemOkHandler);
         BC.removeEvent(this,GV.onlineSocket,"ex_brave_errorID",this.errorHandler);
         var _msg:String = "    兌換成功啦，寶貝已經放入你的" + this.alt_obj.StoreHouse + "了哦！";
         var _url:String = this.alt_obj.StorePath + this.exchangeID + ".swf";
         if(this.alertLevel == 1)
         {
            this.myAlert = Alert.showAlert(MainManager.getGameLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         else
         {
            this.myAlert = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
      }
      
      private function errorHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CSEXRes.EX_FINISH,this.getExItemOkHandler);
         BC.removeEvent(this,GV.onlineSocket,"ex_brave_errorID",this.errorHandler);
         GF.showAlert(MainManager.getGameLevel(),"    你還沒到足夠等級兌換此物哦！","",100,"iknow",true,false,"D");
      }
      
      private function removeEventHandler(eve:EventTaomee) : void
      {
         BC.removeEvent(this);
      }
   }
}

