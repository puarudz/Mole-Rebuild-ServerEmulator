package com.logic.socket.lahmClassRoomSocket
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class lahmClassRoomSocket
   {
      
      public static const GetStudentArchiveCommand:int = 1283;
      
      public static const GetTeacherArchiveCommand:int = 1284;
      
      public static const GetFriendsRankInfoCommand:int = 1268;
      
      public static const GetTeacherHonerInfoCommand:int = 1264;
      
      public function lahmClassRoomSocket()
      {
         super();
      }
      
      public static function queryLahmClassRoomGrid(userid:int) : void
      {
         MsgHead.Command = 1275;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryLahmClassRoomGrid() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.startGrid = output.readUnsignedInt();
         obj.endGrid = output.readUnsignedInt();
         obj.myGrid = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1275,obj));
      }
      
      public static function getGridOfClassRoomInfo(gridID:int) : void
      {
         MsgHead.Command = 1276;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(gridID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getGridOfClassRoomInfo() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var classRoomArr:Array = new Array();
         obj.islEndGrid = output.readUnsignedInt();
         obj.classRoomCount = output.readUnsignedInt();
         for(var i:int = 0; i < obj.classRoomCount; i++)
         {
            obj1 = new Object();
            obj1.classRoomStyle = output.readUnsignedInt();
            obj1.classRoomUserId = output.readUnsignedInt();
            obj1.classRoomId = output.readUnsignedInt();
            obj1.classRoomName = output.readUTFBytes(16);
            classRoomArr[i] = obj1;
         }
         obj.classRoomArr = classRoomArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1276,obj));
      }
      
      public static function setClassRoomName(classRoomId:int, classRoomName:String) : void
      {
         MsgHead.Command = 1277;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classRoomId);
         tempByteArray.writeBytes(supplyZero(classRoomName,16));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setClassRoomName() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.classRoomName = output.readUTFBytes(16);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1277,obj));
      }
      
      public static function setClassRoomInnerStyle(classRoomId:int, classRoomInnerStyle:int) : void
      {
         MsgHead.Command = 1278;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classRoomId);
         tempByteArray.writeUnsignedInt(classRoomInnerStyle);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setClassRoomInnerStyle() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.classRoomInnerStyle = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1278,obj));
      }
      
      public static function getClassRoomInfo(userId:int) : void
      {
         MsgHead.Command = 1279;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getClassRoomInfo() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var studentArr:Array = new Array();
         obj.classRoomUserId = output.readUnsignedInt();
         obj.classRoomId = output.readUnsignedInt();
         obj.classRoomName = output.readUTFBytes(16);
         obj.classRoomInnerStyle = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.energy = output.readUnsignedInt();
         obj.lovely = output.readUnsignedInt();
         obj.classRoomFlag = output.readUnsignedInt();
         obj.coursesId = output.readUnsignedInt();
         obj.overClassTimer = output.readUnsignedInt();
         obj.questionClassCount = output.readUnsignedInt();
         obj.studentCount = output.readUnsignedInt();
         for(var i:int = 0; i < obj.studentCount; i++)
         {
            obj1 = new Object();
            obj1.studentId = output.readUnsignedInt();
            obj1.studentName = output.readUnsignedInt();
            obj1.studentLevel = output.readUnsignedInt();
            obj1.studentColor = output.readUnsignedInt();
            obj1.studentSkill = output.readUnsignedInt();
            obj1.SLFlag = output.readUnsignedInt();
            studentArr[i] = obj1;
         }
         obj.studentArr = studentArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1279,obj));
      }
      
      public static function creatClassRoom(classRoomName:String) : void
      {
         MsgHead.Command = 1274;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeBytes(supplyZero(classRoomName,16));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_creatClassRoom() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1274));
      }
      
      public static function getStudentInfo() : void
      {
         MsgHead.Command = 1280;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getStudentInfo() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var studentArr:Array = new Array();
         obj.teachLevelExp = output.readUnsignedInt();
         obj.nowStudentCount = output.readUnsignedInt();
         obj.nowSLStudentCount = output.readUnsignedInt();
         obj.test = output.readUnsignedInt();
         obj.teachDifficulty = output.readUnsignedInt();
         obj.studentCount = output.readUnsignedInt();
         for(var i:int = 0; i < obj.studentCount; i++)
         {
            obj1 = new Object();
            obj1.studentId = output.readUnsignedInt();
            obj1.studentLatent = output.readUnsignedInt();
            obj1.studentMoral = output.readUnsignedInt();
            obj1.studentIQ = output.readUnsignedInt();
            obj1.studentSport = output.readUnsignedInt();
            obj1.studentArt = output.readUnsignedInt();
            obj1.studentLabor = output.readUnsignedInt();
            obj1.studentType = output.readUnsignedInt();
            studentArr[i] = obj1;
         }
         obj.studentArr = studentArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1280,obj));
      }
      
      public static function setStudentInfo(studentArr:Array) : void
      {
         MsgHead.Command = 1281;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(studentArr.length);
         for(var i:int = 0; i < studentArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(studentArr[i].studentId);
            tempByteArray.writeUnsignedInt(studentArr[i].studentName);
            tempByteArray.writeUnsignedInt(studentArr[i].studentNature);
            tempByteArray.writeUnsignedInt(studentArr[i].studentLevel);
            tempByteArray.writeUnsignedInt(studentArr[i].studentColor);
            tempByteArray.writeUnsignedInt(studentArr[i].studentSkill);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setStudentInfo() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1281));
      }
      
      public static function delAllStudentInfo() : void
      {
         MsgHead.Command = 1282;
         GF.writeHead();
      }
      
      public static function res_delAllStudentInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.delStudentCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1282,obj));
      }
      
      public static function getCoursePlan() : void
      {
         MsgHead.Command = 1285;
         GF.writeHead();
      }
      
      public static function res_getCoursePlan() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var courseArr:Array = new Array();
         obj.todayLeft = output.readUnsignedInt();
         obj.termLeft = output.readUnsignedInt();
         obj.courseCur = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.count; i++)
         {
            obj1 = new Object();
            obj1.courseId = output.readUnsignedInt();
            obj1.isSL = output.readUnsignedInt();
            obj1.isLock = output.readUnsignedInt();
            obj1.courseTimer = output.readUnsignedInt();
            obj1.courseNum = output.readUnsignedInt();
            obj1.courseType = output.readUnsignedInt();
            courseArr[i] = obj1;
         }
         obj.courseArr = courseArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1285,obj));
      }
      
      public static function getCourseCount() : void
      {
         MsgHead.Command = 1289;
         GF.writeHead();
      }
      
      public static function res_getCourseCount() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var courseArr:Array = new Array();
         obj.count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.count; i++)
         {
            obj1 = new Object();
            obj1.courseId = output.readUnsignedInt();
            obj1.courseNum = output.readUnsignedInt();
            courseArr[i] = obj1;
         }
         obj.courseArr = courseArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1289,obj));
      }
      
      public static function startClass(courseId:int) : void
      {
         MsgHead.Command = 1286;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(courseId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_startClass() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.courseId = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         obj.classFlag = output.readUnsignedInt();
         obj.questionClassCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1286,obj));
      }
      
      public static function classOver(courseId:int) : void
      {
         MsgHead.Command = 1288;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(courseId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_classOver() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.courseId = output.readUnsignedInt();
         obj.classFlag = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1288,obj));
      }
      
      public static function classBaseInfo() : void
      {
         MsgHead.Command = 1290;
         GF.writeHead();
      }
      
      public static function res_classBaseInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.exp = output.readUnsignedInt();
         obj.energy = output.readUnsignedInt();
         obj.lovely = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1290,obj));
      }
      
      public static function classEvent() : void
      {
         MsgHead.Command = 1291;
         GF.writeHead();
      }
      
      public static function res_classEvent() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.eventid = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1291,obj));
      }
      
      public static function courseTest(course:Array, courseCount:int) : void
      {
         MsgHead.Command = 1292;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(courseCount);
         for(var i:int = 0; i < courseCount; i++)
         {
            tempByteArray.writeUnsignedInt(course[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_courseTest() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1292,obj));
      }
      
      public static function queryClassState() : void
      {
         MsgHead.Command = 1296;
         GF.writeHead();
      }
      
      public static function res_queryClassState() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.classFlag = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1296,obj));
      }
      
      public static function getCourseTestInfo(textNum:int = 0) : void
      {
         MsgHead.Command = 1293;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(textNum);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getCourseTestInfo() : void
      {
         var obj1:Object = null;
         var n:int = 0;
         var obj2:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var itemArr:Array = new Array();
         var studentArr:Array = new Array();
         obj.quality = output.readUnsignedInt();
         obj.score = output.readUnsignedInt();
         obj.difficulty = output.readUnsignedInt();
         obj.level_s = output.readUnsignedInt();
         obj.level_a = output.readUnsignedInt();
         obj.level_b = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.test_Exp = output.readUnsignedInt();
         obj.evaluate = output.readUnsignedInt();
         obj.itemCount = output.readUnsignedInt();
         for(var i:int = 0; i < obj.itemCount; i++)
         {
            obj1 = new Object();
            obj1.itemId = output.readUnsignedInt();
            obj1.itemCount = output.readUnsignedInt();
            itemArr[i] = obj1;
         }
         obj.itemArr = itemArr;
         obj.studentCount = output.readUnsignedInt();
         for(var j:int = 0; j < obj.studentCount; j++)
         {
            obj1 = new Object();
            obj1.studentId = output.readUnsignedInt();
            obj1.studentName = output.readUnsignedInt();
            obj1.studentNature = output.readUnsignedInt();
            obj1.studentStage = output.readUnsignedInt();
            obj1.studentColor = output.readUnsignedInt();
            obj1.studentSkill = output.readUnsignedInt();
            obj1.totalScore = output.readUnsignedInt();
            obj1.courseCount = output.readUnsignedInt();
            obj1.courseArr = new Array();
            for(n = 0; n < obj1.courseCount; n++)
            {
               obj2 = new Object();
               obj2.courseId = output.readUnsignedInt();
               obj2.courseScore = output.readUnsignedInt();
               obj1.courseArr[n] = obj2;
            }
            studentArr[j] = obj1;
         }
         obj.studentArr = studentArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1293,obj));
      }
      
      public static function queryhaveClass(userId:int) : void
      {
         MsgHead.Command = 1294;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryhaveClass() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         obj.ishaveClass = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1294,obj));
      }
      
      public static function getUserIdByLamuClassRoom() : void
      {
         MsgHead.Command = 1295;
         GF.writeHead();
      }
      
      public static function res_getUserIdByLamuClassRoom() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1295,obj));
      }
      
      public static function queryGraduation() : void
      {
         MsgHead.Command = 1273;
         GF.writeHead();
      }
      
      public static function res_queryGraduation() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var directArr:Array = new Array();
         obj.classFlag = output.readUnsignedInt();
         obj.graduateTime = output.readUnsignedInt();
         obj.graduateCnt = output.readUnsignedInt();
         obj.greatStCnt = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         for(var j:int = 0; j < obj.count; j++)
         {
            obj1 = new Object();
            obj1.directId = output.readUnsignedInt();
            obj1.directCnt = output.readUnsignedInt();
            obj1.isNew = output.readUnsignedInt();
            directArr[j] = obj1;
         }
         obj.directArr = directArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1273,obj));
      }
      
      public static function queryTeachRecall(userid:int) : void
      {
         MsgHead.Command = 1272;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryTeachRecall() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var directArr:Array = new Array();
         obj.count = output.readUnsignedInt();
         for(var j:int = 0; j < obj.count; j++)
         {
            obj1 = new Object();
            obj1.directId = output.readUnsignedInt();
            obj1.directTime = output.readUnsignedInt();
            obj1.directCnt = output.readUnsignedInt();
            directArr[j] = obj1;
         }
         obj.directArr = directArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1272,obj));
      }
      
      public static function usingItem(itemId:int, petId:int = 0) : void
      {
         MsgHead.Command = 1270;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         tempByteArray.writeUnsignedInt(petId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_usingItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.petId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1270,obj));
      }
      
      public static function queryClassRoomGoods() : void
      {
         MsgHead.Command = 1271;
         GF.writeHead();
      }
      
      public static function res_queryClassRoomGoods() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var itenArr:Array = new Array();
         obj.uid = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         for(var j:int = 0; j < obj.count; j++)
         {
            obj1 = new Object();
            obj1.itemId = output.readUnsignedInt();
            obj1.itemCount = output.readUnsignedInt();
            itenArr[j] = obj1;
         }
         obj.itenArr = itenArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1271,obj));
      }
      
      public static function res_honorChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.honorId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1265,obj));
      }
      
      public static function lahmQuestion(petId:int, questionId:int, answerId:int) : void
      {
         MsgHead.Command = 1266;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(petId);
         tempByteArray.writeUnsignedInt(questionId);
         tempByteArray.writeUnsignedInt(answerId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_lahmQuestion() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Petid = output.readUnsignedInt();
         obj.type = output.readUnsignedInt();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1266,obj));
      }
      
      public static function unlockClassRoomInnerStyle() : void
      {
         MsgHead.Command = 1263;
         GF.writeHead();
      }
      
      public static function res_unlockClassRoomInnerStyle() : void
      {
         var objR:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.goodsArr = new Array();
         obj.count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.count; i++)
         {
            objR = new Object();
            objR.itemid = output.readUnsignedInt();
            objR.enable = output.readUnsignedInt();
            obj.goodsArr.push(objR);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1263,obj));
      }
      
      public static function toHappy(userID:int) : void
      {
         MsgHead.Command = 6002;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_toHappy() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.toHappyId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6002,obj));
      }
      
      public static function supplyZero(str:String, len:uint) : ByteArray
      {
         var t:ByteArray = new ByteArray();
         t.writeUTFBytes(str);
         while(t.length < len)
         {
            t.writeByte(0);
         }
         t.position = 0;
         return t;
      }
      
      public static function queryStudentArchive(userid:int) : void
      {
         MsgHead.Command = GetStudentArchiveCommand;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryStudentArchive() : void
      {
         var studentInfo:Object = null;
         var courseInfos:Array = null;
         var j:int = 0;
         var courseInfo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.UID = output.readUnsignedInt();
         obj.Exam_time = output.readUnsignedInt();
         obj.StudentCound = output.readUnsignedInt();
         var students:Array = new Array();
         for(var i:int = 0; i < obj.StudentCound; i++)
         {
            studentInfo = new Object();
            studentInfo.lamu_id = output.readUnsignedInt();
            studentInfo.name_id = output.readUnsignedInt();
            studentInfo.nature = output.readUnsignedInt();
            studentInfo.mood = output.readUnsignedInt();
            studentInfo.level = output.readUnsignedInt();
            studentInfo.color = output.readUnsignedInt();
            studentInfo.skill = output.readUnsignedInt();
            studentInfo.latent = output.readUnsignedInt();
            studentInfo.moral = output.readUnsignedInt();
            studentInfo.Iq = output.readUnsignedInt();
            studentInfo.sport = output.readUnsignedInt();
            studentInfo.art = output.readUnsignedInt();
            studentInfo.labor = output.readUnsignedInt();
            studentInfo.vip_flag = output.readUnsignedInt();
            studentInfo.courseCount = output.readUnsignedInt();
            courseInfos = new Array();
            for(j = 0; j < studentInfo.courseCount; j++)
            {
               courseInfo = new Object();
               courseInfo.course_id = output.readUnsignedInt();
               courseInfo.course_degree = output.readUnsignedInt();
               courseInfos.push(courseInfo);
            }
            studentInfo.courseInfos = courseInfos;
            students.push(studentInfo);
         }
         obj.students = students;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetStudentArchiveCommand,obj));
      }
      
      public static function queryTeacherArchive(userid:int) : void
      {
         MsgHead.Command = GetTeacherArchiveCommand;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryTeacherArchive() : void
      {
         var courseInfo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.UID = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.difficulty = output.readUnsignedInt();
         obj.S_evaluate = output.readUnsignedInt();
         obj.graduate_sum = output.readUnsignedInt();
         obj.outstand_sum = output.readUnsignedInt();
         obj.evaluate = output.readUnsignedInt();
         obj.class_sum = output.readUnsignedInt();
         obj.course_sum = output.readUnsignedInt();
         obj.courseCount = output.readUnsignedInt();
         var courseInfos:Array = new Array();
         for(var j:int = 0; j < obj.courseCount; j++)
         {
            courseInfo = new Object();
            courseInfo.course_id = output.readUnsignedInt();
            courseInfo.course_cnt = output.readUnsignedInt();
            courseInfos.push(courseInfo);
         }
         obj.courseInfos = courseInfos;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTeacherArchiveCommand,obj));
      }
      
      public static function GetFriendsRankInfo(firendArr:Array) : void
      {
         MsgHead.Command = GetFriendsRankInfoCommand;
         if(firendArr == null)
         {
            return;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(firendArr.length + 1);
         for(var i:int = 0; i < firendArr.length; i++)
         {
            if(firendArr[i].friend != 0)
            {
               tempByteArray.writeUnsignedInt(firendArr[i].friend);
            }
         }
         tempByteArray.writeUnsignedInt(LocalUserInfo.getUserID());
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetFriendsRankInfo() : void
      {
         var userObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.firendArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            userObj = new Object();
            userObj.UserID = output.readUnsignedInt();
            userObj.Teach_exp = int(output.readUnsignedInt());
            userObj.Great_student = int(output.readInt());
            if(userObj.UserID == LocalUserInfo.getUserID())
            {
               obj.selfInfo = userObj;
            }
            else
            {
               obj.firendArr.push(userObj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFriendsRankInfoCommand,obj));
      }
      
      public static function GetTeacherHonerInfo() : void
      {
         MsgHead.Command = GetTeacherHonerInfoCommand;
         GF.writeHead();
      }
      
      public static function res_GetTeacherHonerInfo() : void
      {
         var honerObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.honerArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            honerObj = new Object();
            honerObj.id = output.readUnsignedInt();
            honerObj.flag = int(output.readUnsignedInt());
            obj.honerArr.push(honerObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTeacherHonerInfoCommand,obj));
      }
   }
}

