package com.logic.socket.smc.expandItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class GetLoopJobRes extends EventDispatcher
   {
      
      public static var GET_BACK:String = "get_back_loopjob";
      
      private var _taskBuffer:ByteArray;
      
      public function GetLoopJobRes()
      {
         super();
      }
      
      public function getBackFun(buffer:ByteArray) : void
      {
         this._taskBuffer = buffer;
         var Obj:Object = new Object();
         Obj.job = this._taskBuffer.readUnsignedInt();
         if(Obj.job == 9)
         {
            this.makeJob9(Obj);
            return;
         }
         if(Obj.job == 62 || Obj.job == 63 || Obj.job == 64 || Obj.job == 66 || Obj.job == 175 || Obj.job == 255)
         {
            this.makeJob62(Obj);
            return;
         }
         if(Obj.job == 77 || Obj.job == 109 || Obj.job == 112 || Obj.job == 117 || Obj.job == 118 || Obj.job == 236 || Obj.job == 241 || Obj.job == 264)
         {
            this.makeJob77(Obj);
            return;
         }
         if(Obj.job == 243 || Obj.job == 248)
         {
            this.makeJob77(Obj);
            return;
         }
         if(Obj.job == 181 || Obj.job == 259 || Obj.job == 261)
         {
            this.makeJob92(Obj);
            return;
         }
         if(Obj.job == 81 || Obj.job == 110 || Obj.job == 180 || Obj.job == 271 || Obj.job == 183)
         {
            this.makeJob81(Obj);
            return;
         }
         if(Obj.job == 90)
         {
            this.makeJob90(Obj);
            return;
         }
         if(Obj.job == 91)
         {
            this.makeJob91(Obj);
            return;
         }
         if(Obj.job == 92 || Obj.job == 108 || Obj.job == 114 || Obj.job == 122 || Obj.job == 238 || Obj.job == 249)
         {
            this.makeJob92(Obj);
            return;
         }
         if(Obj.job == 93)
         {
            this.makeJob93(Obj);
            return;
         }
         if(Obj.job == 94 || Obj.job == 95 || Obj.job == 96 || Obj.job == 97 || Obj.job == 103 || Obj.job == 104 || Obj.job == 300 || Obj.job == 105 || Obj.job == 106 || Obj.job == 107 || Obj.job == 113 || Obj.job == 119 || Obj.job == 123 || Obj.job == 121 || Obj.job == 124 || Obj.job == 125 || Obj.job == 132 || Obj.job == 133 || Obj.job == 231 || Obj.job == 232 || Obj.job == 233 || Obj.job == 178 || Obj.job == 239 || Obj.job == 240 || Obj.job == 179 || Obj.job == 242 || Obj.job == 244 || Obj.job == 245 || Obj.job == 400 || Obj.job == 254 || Obj.job == 401)
         {
            this.makeJob94(Obj);
            return;
         }
         if(Obj.job == 234 || Obj.job == 235 || Obj.job == 246 || Obj.job == 247 || Obj.job == 250 || Obj.job == 251 || Obj.job == 252 || Obj.job == 253 || Obj.job == 268 || Obj.job == 267 || Obj.job == 269 || Obj.job == 276)
         {
            this.makeJob94(Obj);
            return;
         }
         if(Obj.job == 403 || Obj.job == 404 || Obj.job == 405 || Obj.job == 406 || Obj.job == 408 || Obj.job == 409 || Obj.job == 411)
         {
            this.makeJob94(Obj);
            return;
         }
         if(Obj.job == 301 || Obj.job == 237)
         {
            this.makeJob301(Obj);
            return;
         }
         if(Obj.job == 1006)
         {
            this.makeJob1006(Obj);
            return;
         }
         if(Obj.job == 120)
         {
            this.makeJob120(Obj);
            return;
         }
         this.MakeGeneralJobInfo(Obj);
      }
      
      private function makeJob62(Obj:Object) : void
      {
         Obj.Flag = this._taskBuffer.readUnsignedInt();
         Obj.Count = this._taskBuffer.readUnsignedInt();
         var lg:uint = 50 - 8;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         this._taskBuffer.readBytes(myArr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob9(Obj:Object) : void
      {
         Obj.Flag = this._taskBuffer.readUnsignedInt();
         Obj.mapID = this._taskBuffer.readUnsignedInt();
         var time_a:uint = this._taskBuffer.readUnsignedInt();
         var time_b:uint = this._taskBuffer.readUnsignedInt();
         Obj.times = time_a * 1000000 + time_b;
         var lg:uint = 50 - 16;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         this._taskBuffer.readBytes(myArr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob77(Obj:Object) : void
      {
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.arr = new Array();
         Obj.arr = [Obj.flag1,Obj.flag2,Obj.flag3];
         var lg:uint = 50 - 12;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         this._taskBuffer.readBytes(myArr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob81(Obj:Object) : void
      {
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.flag4 = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 16;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob90(Obj:Object) : void
      {
         Obj.lingFlag = this._taskBuffer.readUnsignedInt();
         Obj.lingFlag2 = this._taskBuffer.readUnsignedInt();
         Obj.treeFlag = this._taskBuffer.readUnsignedInt();
         Obj.gunFlag = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 16;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob91(Obj:Object) : void
      {
         Obj.isGet = this._taskBuffer.readUnsignedInt();
         Obj.redFlag1 = this._taskBuffer.readUnsignedInt();
         Obj.redFlag2 = this._taskBuffer.readUnsignedInt();
         Obj.redFlag3 = this._taskBuffer.readUnsignedInt();
         Obj.orangeFlag = this._taskBuffer.readUnsignedInt();
         Obj.pinkFlag = this._taskBuffer.readUnsignedInt();
         Obj.carFlag = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob92(Obj:Object) : void
      {
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.flag4 = this._taskBuffer.readUnsignedInt();
         Obj.flag5 = this._taskBuffer.readUnsignedInt();
         Obj.flag6 = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 24;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob93(Obj:Object) : void
      {
         Obj.isSearch = this._taskBuffer.readUnsignedInt();
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.flag4 = this._taskBuffer.readUnsignedInt();
         Obj.isOver = this._taskBuffer.readUnsignedInt();
         Obj.isNoJob = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob94(Obj:Object) : void
      {
         Obj.flag = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 4;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob301(Obj:Object) : void
      {
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.flag4 = this._taskBuffer.readUnsignedInt();
         Obj.flag5 = this._taskBuffer.readUnsignedInt();
         Obj.flag6 = this._taskBuffer.readUnsignedInt();
         Obj.flag7 = this._taskBuffer.readUnsignedInt();
         Obj.flag8 = this._taskBuffer.readUnsignedInt();
         Obj.flag9 = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 36;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob120(Obj:Object) : void
      {
         Obj.flag1 = this._taskBuffer.readUnsignedInt();
         Obj.flag2 = this._taskBuffer.readUnsignedInt();
         Obj.flag3 = this._taskBuffer.readUnsignedInt();
         Obj.flag4 = this._taskBuffer.readUnsignedInt();
         Obj.flag5 = this._taskBuffer.readUnsignedInt();
         Obj.flag6 = this._taskBuffer.readUnsignedInt();
         Obj.flag7 = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function makeJob1006(Obj:Object) : void
      {
         Obj.jobFlag = this._taskBuffer.readUnsignedInt();
         var lg:Number = 50 - 4;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":Obj}));
      }
      
      private function MakeGeneralJobInfo(Obj:Object) : void
      {
         Obj.jobInfo = new Array();
         var maxCount:int = 12;
         for(var i:int = 0; i < maxCount; i++)
         {
            Obj.jobInfo.push(this._taskBuffer.readUnsignedInt());
         }
         var lg:Number = 50 - 4 * maxCount;
         var arr:ByteArray = new ByteArray();
         for(var j:int = 0; j < lg; j++)
         {
            arr.writeByte(0);
         }
         this._taskBuffer.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK + "_" + Obj.job,{"obj":Obj}));
      }
   }
}

