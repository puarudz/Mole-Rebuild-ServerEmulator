package com.common.Alert
{
   import com.common.Alert.childAlert.GetItemsAlert;
   import com.common.Alert.childAlert.changAlert;
   import com.common.Alert.childAlert.commonAlert;
   import com.common.Alert.childAlert.customAlert;
   import com.common.Alert.childAlert.gameAlert;
   import com.common.Alert.childAlert.icoAlert;
   import com.common.Alert.childAlert.icoAlert2;
   import com.common.Alert.childAlert.iknowAlert;
   import com.common.Alert.childAlert.rightAlert;
   import com.common.Alert.childAlert.selectAlert;
   import com.common.Alert.childAlert.simpleAlert;
   import com.common.Alert.childAlert.sizeAlert;
   import com.common.Alert.childAlert.sureAlert;
   import com.common.Alert.childAlert.wrongAlert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.manager.IndexManager;
   import com.core.manager.LevelManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class Alert
   {
      
      public static var hasAlert:Boolean;
      
      public static var FACE_SMILE:String = "smile";
      
      public static var FACE_ANGRY:String = "angry";
      
      public static var FACE_REST_1:String = "rest1";
      
      public static var FACE_REST_2:String = "rest2";
      
      public static var CLOSED:String = "closed";
      
      public static var CLICK_:String = "CLICK";
      
      public static var ON_CUSTOM_LOADED:String = "onLoad";
      
      public static var ON_CUSTOM_ADDED:String = "added";
      
      public static var AlertArray:Array = new Array();
      
      public static var COMMON_ALERT:uint = 0;
      
      public static var CUSTOM_ALERT:uint = 1;
      
      public static var RIGHT_ALERT:uint = 2;
      
      public static var WRONG_ALERT:uint = 3;
      
      public static var REGISTER_ALERT:uint = 4;
      
      public static var ICO_ALERT:uint = 5;
      
      public static var ICO_ALERT2:uint = 6;
      
      public static var SELECT_ALERT:uint = 7;
      
      public static var IKNOW_ALERT:uint = 8;
      
      public static var PAGE_ALERT:uint = 9;
      
      public static var SURE_ALERT:uint = 10;
      
      public static var SIZE_ALERT:uint = 11;
      
      public static var CHANG_ALERT:uint = 100;
      
      public static var GAME_ALERT:uint = 101;
      
      public static var TEXT_THREE_LINE_HEIGHT:uint = 112;
      
      public static var back_tit:String = "";
      
      public static var back_msg:String = "";
      
      public function Alert()
      {
         super();
      }
      
      public static function showAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true, SizeString_Or_ShowBtnBoolean:* = false, picTip:String = "A", WH:String = "298,228") : *
      {
         switch(style)
         {
            case SIZE_ALERT:
               return new sizeAlert(obj,title,content,style,bottomArray,closeB,SizeString_Or_ShowBtnBoolean);
            case COMMON_ALERT:
               return new commonAlert(obj,title,content,style,bottomArray,closeB);
            case CUSTOM_ALERT:
               return new customAlert(obj,title,content,0,bottomArray,closeB);
            case RIGHT_ALERT:
               return new rightAlert(obj,title,content,style,bottomArray,closeB);
            case WRONG_ALERT:
               return new wrongAlert(obj,title,content,style,bottomArray,closeB);
            case REGISTER_ALERT:
            case ICO_ALERT:
               return new icoAlert(obj,title,content,style,bottomArray,closeB);
            case ICO_ALERT2:
               return new icoAlert2(obj,title,content,style,bottomArray,closeB);
            case SURE_ALERT:
               return new sureAlert(obj,title,content,style,bottomArray,closeB);
            case SELECT_ALERT:
               return new selectAlert(obj,title,content,style,bottomArray,closeB);
            case IKNOW_ALERT:
               return new iknowAlert(obj,title,content,style,bottomArray,closeB);
            case CHANG_ALERT:
               return new changAlert(obj,title,content,style,bottomArray,closeB,SizeString_Or_ShowBtnBoolean,picTip,WH);
            case GAME_ALERT:
               return new gameAlert(obj,title,content,0,bottomArray,closeB);
            default:
               return;
         }
      }
      
      public static function closeAlert(instanceAleart:*, type:String = "") : void
      {
         for(var i:uint = 0; i < AlertArray.length; i++)
         {
            if(Boolean(AlertArray[i]))
            {
               if(AlertArray[i] == instanceAleart)
               {
                  AlertArray.splice(i,1);
                  if(type == "")
                  {
                     instanceAleart.parent.removeChild(DisplayObject(instanceAleart));
                  }
                  break;
               }
            }
            else
            {
               AlertArray.splice(i,1);
               i--;
            }
         }
         if(AlertArray.length > 0)
         {
            hasAlert = true;
         }
         else
         {
            hasAlert = false;
         }
      }
      
      public static function closeAllAlert() : void
      {
         var element:* = undefined;
         for each(element in AlertArray)
         {
            element.parent.removeChild(DisplayObject(element));
         }
         AlertArray = new Array();
         hasAlert = false;
      }
      
      public static function showChooseAlart(msg:String, sure_Handle:Function = null, cancel_Handle:Function = null, iconType:String = "E", ButtonType:String = "sure,cancel", url:String = "") : simpleAlert
      {
         var alt:simpleAlert = null;
         var _temp_2:* = alt;
         var _temp_1:* = CLICK_ + "1";
         with({})
         {
            var _temp_4:* = alt;
            var _temp_3:* = CLICK_ + "2";
            with({})
            {
               _temp_4.addEventListener(_temp_3,function cancel(e:Event):void
               {
                  alt.removeEventListener(CLICK_ + "2",cancel);
                  if(cancel_Handle != null)
                  {
                     cancel_Handle();
                  }
               });
               return alt;
            }
            
            public static function smileAlart(msg:String, closeHandle:Function = null, ButtonType:String = "iknow", textHeight:int = 125) : sizeAlert
            {
               return imagesAlert(msg,"smile",closeHandle,ButtonType,textHeight);
            }
            
            public static function angryAlart(msg:String, closeHandle:Function = null, ButtonType:String = "iknow", textHeight:int = 125) : sizeAlert
            {
               return imagesAlert(msg,"angry",closeHandle,ButtonType,textHeight);
            }
            
            public static function imagesAlert(msg:String, path:String, click_1_Handle:Function = null, ButtonType:String = "iknow", textHeight:int = 125, size:String = "298,228") : sizeAlert
            {
               var closeHandle:Function;
               var tipsStr:String;
               var tempAlert:sizeAlert = null;
               var clickHandle:Function = null;
               trace(msg.slice(0,2));
               if(msg.slice(0,2) != "  ")
               {
                  msg = "　　" + msg;
                  trace(msg);
               }
               closeHandle = click_1_Handle;
               tipsStr = msg;
               path = path.indexOf(".") == -1 ? "resource/alertIco/" + path + ".swf" : path;
               tempAlert = Alert.showAlert(MainManager.getAlertLevel(),"",tipsStr,Alert.SIZE_ALERT,ButtonType,true,size + "," + path);
               tempAlert.changePanel_TextField_To_Bottom();
               tempAlert.getTargetMC()["ico_mc"].x = 104;
               if(textHeight >= 125)
               {
                  tempAlert.getTargetMC()["ico_mc"].y = 25;
               }
               else
               {
                  tempAlert.getTargetMC()["ico_mc"].y = 20;
               }
               tempAlert.getContentTextField().y = textHeight;
               if(closeHandle != null)
               {
                  clickHandle = function(E:Event):void
                  {
                     tempAlert.removeEventListener(Alert.CLICK_ + "1",clickHandle);
                     closeHandle(E);
                  };
                  tempAlert.addEventListener(Alert.CLICK_ + "1",clickHandle);
               }
               return tempAlert;
            }
            
            public static function imagesBigAlert(msg:String, path:String, click_1_Handle:Function = null, ButtonType:String = "otherJob_konw") : changAlert
            {
               var tempAlert:* = undefined;
               var clickHandle:Function = null;
               var closeHandle:Function = click_1_Handle;
               tempAlert = Alert.showAlert(MainManager.getAlertLevel(),path,msg,Alert.CHANG_ALERT,ButtonType,true,false,"SMCUI");
               if(closeHandle != null)
               {
                  clickHandle = function(E:Event):void
                  {
                     tempAlert.removeEventListener(Alert.CLICK_ + "1",clickHandle);
                     closeHandle(E);
                  };
                  tempAlert.addEventListener(Alert.CLICK_ + "1",clickHandle);
               }
               return tempAlert;
            }
            
            public static function getIconByID_Alart(itemID:int, msg:String = "", click_1_Handle:Function = null, ButtonType:String = "ok", textHeight:int = 125) : sizeAlert
            {
               var path:String;
               var ico:MovieClip;
               var tempAlert:sizeAlert = null;
               var clickHandle:Function = null;
               var closeHandle:Function = click_1_Handle;
               var tipsStr:String = msg;
               if(msg == "")
               {
                  tipsStr = "　　恭喜你！你得到了" + GoodsInfo.getItemNameByID(itemID) + "，趕快看看去吧!";
               }
               path = GoodsInfo.GetFullURLByItemId(itemID);
               tempAlert = Alert.showAlert(MainManager.getAlertLevel(),"",tipsStr,Alert.SIZE_ALERT,ButtonType,true,"298,228," + path);
               tempAlert.changePanel_TextField_To_Bottom();
               ico = tempAlert.getTargetMC()["ico_mc"];
               ico.scaleX = ico.scaleY = 1.6;
               ico.x = 110;
               if(textHeight >= 125)
               {
                  tempAlert.getTargetMC()["ico_mc"].y = 25;
               }
               else
               {
                  tempAlert.getTargetMC()["ico_mc"].y = 20;
               }
               tempAlert.getContentTextField().y = textHeight;
               if(closeHandle != null)
               {
                  clickHandle = function(E:Event):void
                  {
                     tempAlert.removeEventListener(Alert.CLICK_ + "1",clickHandle);
                     closeHandle(E);
                  };
                  tempAlert.addEventListener(Alert.CLICK_ + "1",clickHandle);
               }
               return tempAlert;
            }
            
            public static function SLAlart(msg:String, closeHandle:Function = null, ButtonType:String = "super,knowSuperPet", textHeight:int = 55) : sizeAlert
            {
               var tempAlert:sizeAlert = null;
               var ico:SimpleButton = null;
               var clickHandle2:Function = null;
               var clickHandle:Function = null;
               var clickHandle3:Function = null;
               clickHandle2 = function(E:Event):void
               {
                  Alert.closeAlert(tempAlert.getTargetMC());
                  ico.removeEventListener(MouseEvent.CLICK,clickHandle2);
               };
               clickHandle = function(E:Event):void
               {
                  var superPetLogin:* = getDefinitionByName("com.module.activityModule::superPetLogin") as Class;
                  superPetLogin.gotoPay();
                  tempAlert.removeEventListener(Alert.CLICK_ + "1",clickHandle);
               };
               clickHandle3 = function(E:Event):void
               {
                  var superPetLogin:* = getDefinitionByName("com.module.activityModule::superPetLogin") as Class;
                  superPetLogin.openSLPetSecret();
                  tempAlert.removeEventListener(Alert.CLICK_ + "2",clickHandle3);
               };
               tempAlert = imagesAlert(msg,"super",closeHandle,ButtonType,textHeight,"424,336");
               var t:TextField = tempAlert.getContentTextField();
               t.width = 285;
               t.x = 50;
               ico = IndexManager.getInstance().getSimpleButton("UI_close_btn");
               ico.x = tempAlert.getTargetMC().width - 50;
               ico.y = 35;
               ico.width = ico.height = 32;
               tempAlert.getTargetMC().addChild(ico);
               ico.addEventListener(MouseEvent.CLICK,clickHandle2);
               tempAlert.addEventListener(Alert.CLICK_ + "1",clickHandle);
               tempAlert.addEventListener(Alert.CLICK_ + "2",clickHandle3);
               return tempAlert;
            }
            
            public static function ShowGetItemsAlert(itemList:Array, click_1_Handle:Function = null) : GetItemsAlert
            {
               return new GetItemsAlert(itemList,MainManager.getAlertLevel(),click_1_Handle);
            }
         }
      }
      
      