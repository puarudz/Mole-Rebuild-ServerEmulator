package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.event.EventTaomee;
   import com.logic.socket.MoleShop.MoleShopSelect;
   import com.logic.socket.MoleShop.MoleShopSocket;
   import com.mole.debug.DebugManager;
   import com.mole.net.events.SocketEvent;
   import com.view.mapView.activity.Task83.GolBdeansView;
   import flash.events.Event;
   
   public class UseGoldFuncManager
   {
      
      private static var _goodId:uint;
      
      private static var _num:uint;
      
      private static var _actIndex:uint;
      
      private static var _tipTxt:String;
      
      private static var _speTxt:String;
      
      private static var _cancelFunc:Function;
      
      private static var _noGoldFunc:Function;
      
      private static var _backFunc:Function;
      
      private static var _costNum:int;
      
      public function UseGoldFuncManager()
      {
         super();
      }
      
      public static function useGoldFunc(goodId:uint, num:uint, backFunc:Function, actIndex:uint = 0, tipTxt:String = "", specialTip:String = "", cancelFunc:Function = null, noGoldFunc:Function = null, costNum:int = 0) : void
      {
         _goodId = goodId;
         _num = num;
         _actIndex = actIndex;
         _tipTxt = tipTxt;
         _speTxt = specialTip;
         _cancelFunc = cancelFunc;
         _noGoldFunc = noGoldFunc;
         _backFunc = backFunc;
         _costNum = costNum;
         MoleShopSelect.selectDou();
         GV.onlineSocket.addEventListener("read_" + 2032,getGoldDouBack);
         GV.onlineSocket.addEventListener(SocketEvent.ERROR + 2031,buyErrorHandler);
      }
      
      private static function getGoldDouBack(evt:EventTaomee) : void
      {
         var obj:Object;
         var temp:int = 0;
         var alert:* = undefined;
         GV.onlineSocket.removeEventListener("read_" + 2032,getGoldDouBack);
         obj = evt.EventObj;
         if(_goodId != 102016)
         {
            temp = _costNum;
         }
         else
         {
            temp = int(_num);
         }
         if(obj.count >= temp)
         {
            if(!_speTxt)
            {
               Alert.smileAlart("　　你是否願意花" + temp + "金豆" + _tipTxt + "?",function(e:Event):void
               {
                  GV.onlineSocket.addEventListener("read_" + 2031,_backFunc);
                  MoleShopSocket.buyCommodity(_goodId,_num,_actIndex);
               },AlertType.SURE + "," + AlertType.CANCEL);
            }
            else
            {
               alert = Alert.smileAlart(_speTxt,null,"sure,cancel");
               alert.addEventListener(Alert.CLICK_ + "1",function(e:Event):void
               {
                  _speTxt = null;
                  _cancelFunc = null;
                  GV.onlineSocket.addEventListener("read_" + 2031,_backFunc);
                  MoleShopSocket.buyCommodity(_goodId,_num,_actIndex);
               });
               alert.addEventListener(Alert.CLICK_ + "2",function(e:Event):void
               {
                  _speTxt = null;
                  if(_cancelFunc != null)
                  {
                     _cancelFunc.apply();
                     _cancelFunc = null;
                  }
               });
            }
         }
         else
         {
            if(Boolean(_noGoldFunc))
            {
               _noGoldFunc();
            }
            Alert.angryAlart("　　金豆不足,是否現在去用米幣兌換金豆？",function(e:Event):void
            {
               GolBdeansView.getInstance().init();
            },AlertType.SURE + "," + AlertType.CANCEL);
         }
      }
      
      private static function buyErrorHandler(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeEventListener(SocketEvent.ERROR + 2031,buyErrorHandler);
         DebugManager.traceMsg("  返回錯誤碼，2031協議");
      }
      
      public static function clearUseGoldFunc(backFunc:Function) : void
      {
         _noGoldFunc = null;
         _cancelFunc = null;
         GV.onlineSocket.removeEventListener("read_" + 2031,backFunc);
         GV.onlineSocket.removeEventListener(SocketEvent.ERROR + 2031,buyErrorHandler);
         GV.onlineSocket.removeEventListener("read_" + 2032,getGoldDouBack);
      }
   }
}

