package com.view.mapView.activity.map066
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.debug.DebugManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Tick;
   
   public class RiddlesActivity extends EventDispatcher
   {
      
      private var _mc:MovieClip;
      
      private var _flag:uint;
      
      private var _isJionGame:uint = 1;
      
      private var _count:uint;
      
      private var _timeText:TextField;
      
      private var _url:String = "resource/xml/Riddle.xml";
      
      private var _subjectObj:Object;
      
      private var _answerIndex:uint;
      
      private var _isRight:uint = 1;
      
      public function RiddlesActivity(mc:MovieClip)
      {
         super();
         Tick.instance.addRender(this.onTime,1000);
         Tick.instance.stop();
      }
      
      private function onTime(num:uint) : void
      {
         --this._count;
         this._timeText.text = this._count.toString();
         if(this._count <= 0)
         {
            Tick.instance.stop();
         }
      }
      
      public function init() : void
      {
      }
      
      private function addXml() : void
      {
         var urlloader:URLLoader = new URLLoader();
         urlloader.addEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         urlloader.load(VL.getURLRequest(this._url));
      }
      
      private function XmlCompleteHandler(e:Event) : void
      {
         var id:String = null;
         var summaryXML:XML = null;
         var xmlList:XMLList = null;
         var taskInfoXml:XML = null;
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         this._subjectObj = new Object();
         try
         {
            summaryXML = XML(e.target.data);
            xmlList = summaryXML.children();
            for each(taskInfoXml in xmlList)
            {
               id = taskInfoXml.@No;
               this._subjectObj[id] = String(taskInfoXml.@Puzzle);
               this._subjectObj["answer" + id] = String(taskInfoXml.@Answer);
            }
         }
         catch(err:Error)
         {
            DebugManager.traceMsg("謎語xml表有錯，\n" + err.message,false);
         }
      }
      
      private function addEvents() : void
      {
      }
      
      private function activityBroadcast(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         this._flag = recData.readUnsignedInt();
         this._count = recData.readUnsignedInt();
         var index:uint = recData.readUnsignedInt();
         switch(this._flag)
         {
            case 0:
               this._mc["waitMc"].visible = false;
               this._mc["answerMc"].visible = false;
               this._mc["actTimeMc"].visible = true;
               break;
            case 1:
               this._mc["waitMc"].visible = true;
               this._mc["actTimeMc"].visible = false;
               this._mc["answerMc"].visible = false;
               this._timeText = this._mc["waitMc"]["timeText"];
               if(this._answerIndex != 0)
               {
                  this._mc["waitMc"]["answerText"].text = this._subjectObj["answer" + this._answerIndex];
               }
               break;
            case 2:
               this._mc["waitMc"].visible = false;
               this._mc["actTimeMc"].visible = false;
               this._mc["answerMc"].visible = true;
               this._timeText = this._mc["answerMc"]["timeText"];
               this._answerIndex = index;
               if(this._isJionGame == 0)
               {
                  ModuleManager.openPanel("GuessRiddlePanel",this._answerIndex);
               }
         }
         if(this._flag != 0)
         {
            Tick.instance.start();
         }
      }
      
      private function jionGame(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         var flag:uint = recData.readUnsignedInt();
         var arr:Array = [732,414,464,381];
         if(flag == 1)
         {
            this._isJionGame = recData.readUnsignedInt();
            this.setMoleToPos(LocalUserInfo.getUserID(),this.randomWait(arr),true);
         }
         else
         {
            this._isRight = recData.readUnsignedInt();
         }
      }
      
      private function setMoleToPos(userId:uint, pos:Point, isMove:Boolean = false) : void
      {
         var moleMc:PeopleManageView = GF.getPeopleByID(userId) as PeopleManageView;
         if(Boolean(moleMc))
         {
            moleMc.moveTo(pos.x,pos.y);
         }
         if(isMove)
         {
            MoveTo.CanMove = false;
         }
      }
      
      private function randomWait(arr:Array) : Point
      {
         var x:uint = 0;
         var y:uint = 0;
         x = arr[0] + Math.random() * (arr[1] - arr[0]);
         y = arr[2] + Math.random() * (arr[3] - arr[2]);
         return new Point(x,y);
      }
      
      private function getReward(evt:SocketEvent) : void
      {
         var isHaveReward:Boolean = false;
         var userId:uint = 0;
         var id:uint = 0;
         var n:uint = 0;
         var msg:String = "";
         var recData:ByteArray = evt.data as ByteArray;
         var count:uint = recData.readUnsignedInt();
         var arr:Array = new Array();
         for(var i:uint = 0; i < count; i++)
         {
            userId = recData.readUnsignedInt();
            arr.push(userId);
            if(LocalUserInfo.getUserID() == userId)
            {
               isHaveReward = true;
            }
         }
         var num:uint = recData.readUnsignedInt();
         for(var j:uint = 0; j < num; j++)
         {
            id = recData.readUnsignedInt();
            n = recData.readUnsignedInt();
            msg += n.toString() + "個" + GoodsInfo.getItemNameByID(id);
         }
         if(isHaveReward)
         {
            Alert.smileAlart("  恭喜你獲得" + msg);
         }
         else
         {
            if(this._isJionGame == 0)
            {
               if(this._isRight == 0)
               {
                  Alert.smileAlart("  很遺憾你這次沒有進入前50名，請再接再厲哦！");
               }
               else
               {
                  Alert.smileAlart("  很遺憾你答錯了，請再接再厲");
               }
            }
            this._isRight = 1;
         }
      }
      
      private function onJionGame(e:MouseEvent) : void
      {
         if(this._isJionGame == 0)
         {
            Alert.smileAlart("     已經參加遊戲");
            return;
         }
         switch(this._flag)
         {
            case 0:
               Alert.smileAlart("      猜燈謎晚上7點~8點開啟哦");
               break;
            case 1:
               GF.sendSocket(CommandID.GUESS_GAME_ANSWER,1);
               break;
            case 2:
               Alert.smileAlart("        答題中");
         }
      }
      
      private function onQuitGame(e:MouseEvent) : void
      {
         if(this._isJionGame == 0)
         {
            this.setMoleToPos(LocalUserInfo.getUserID(),new Point(470,480));
            this._isJionGame = 1;
            MoveTo.CanMove = true;
         }
      }
      
      private function onExplainGame(e:MouseEvent) : void
      {
         SimpleIntrPanelManager.show("guessRiddle");
      }
      
      public function destroy() : void
      {
         this._isJionGame = 1;
         this._count = 0;
      }
   }
}

