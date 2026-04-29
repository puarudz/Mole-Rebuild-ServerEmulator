package com.module.lahmClassRoom
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.ServerUpTime;
   import com.global.staticData.XMLInfo;
   
   public class lahmClassRoomTool
   {
      
      public function lahmClassRoomTool()
      {
         super();
      }
      
      public function teachLevelExpChangeTeachLevel(teachLevelExp:int) : int
      {
         var ret:int = 0;
         var levelArr:Array = XMLInfo.lahmClassRoom.level;
         for(var i:int = 0; i < levelArr.length; i++)
         {
            if(teachLevelExp < levelArr[i])
            {
               return i;
            }
         }
         return levelArr.length;
      }
      
      public function GetLevelUpExpByNowExp(exp:int) : int
      {
         var lvl:int = this.teachLevelExpChangeTeachLevel(exp);
         var levelArr:Array = XMLInfo.lahmClassRoom.level;
         if(exp >= levelArr[levelArr.length - 2])
         {
            return exp;
         }
         return levelArr[lvl];
      }
      
      public function GetTeachingLvlUpNeedExpByNowExp(exp:int) : int
      {
         var lvl:int = this.teachLevelExpChangeTeachLevel(exp);
         var levelArr:Array = XMLInfo.lahmClassRoom.level;
         if(levelArr[lvl] > exp)
         {
            return levelArr[lvl] - exp;
         }
         if(levelArr[lvl] == exp)
         {
            if(Boolean(levelArr[lvl + 1]))
            {
               return levelArr[lvl + 1] - exp;
            }
            return 0;
         }
         return 0;
      }
      
      public function GetMaxTeacherLvl() : int
      {
         var levelArr:Array = XMLInfo.lahmClassRoom.level;
         return levelArr.length - 1;
      }
      
      public function GetTeacherTitleByExp(exp:int) : String
      {
         var lvl:int = this.teachLevelExpChangeTeachLevel(exp);
         var titleArray:Array = XMLInfo.lahmClassRoom.levelTitle;
         return titleArray[lvl];
      }
      
      public function GetTeacherEvaluation(value:int) : String
      {
         var teacherEvaluation:Array = XMLInfo.lahmClassRoom.teacherEvaluation;
         if(value >= 1 && value <= 5)
         {
            return teacherEvaluation[value];
         }
         return teacherEvaluation[0];
      }
      
      public function GetCourseNameById(value:int) : String
      {
         var courseList:Array = XMLInfo.lahmClassRoom.courses;
         if(Boolean(courseList[value]))
         {
            return courseList[value];
         }
         return "";
      }
      
      public function coursesLevelBycoursesCount(coursesCount:int) : int
      {
         var ret:int = 1;
         var coursesLevelArr:Array = XMLInfo.lahmClassRoom.coursesLevel;
         for(var i:int = 0; i < coursesLevelArr.length; i++)
         {
            if(coursesCount <= coursesLevelArr[i])
            {
               ret = i;
               break;
            }
         }
         return ret;
      }
      
      public function GetCourseLevelUpNeedCound(coursesCount:int) : int
      {
         var lvl:int = this.coursesLevelBycoursesCount(coursesCount);
         var coursesLevelArr:Array = XMLInfo.lahmClassRoom.coursesLevel;
         return coursesLevelArr[lvl] - coursesCount + 1;
      }
      
      public function GetMaxCourseLVL() : int
      {
         var coursesLevelArr:Array = XMLInfo.lahmClassRoom.coursesLevel;
         return coursesLevelArr.length - 1;
      }
      
      public function checkClassOverTimer(timerDifference:int = 0) : Boolean
      {
         var day:int = 0;
         var hours:int = 0;
         var date:Date = null;
         var time:Number = NaN;
         var addTime:Number = NaN;
         var ret:Boolean = true;
         var d:Date = ServerUpTime.getInstance().date;
         if(timerDifference == 0)
         {
            day = d.getDay();
            hours = d.getHours();
            if(hours >= 0 && hours < 6)
            {
               ret = false;
            }
         }
         else
         {
            date = new Date(d.time);
            time = date.getTime();
            addTime = time + timerDifference * 1000;
            date.setTime(addTime);
            if(date.getHours() >= 0 && date.getHours() < 6)
            {
               ret = false;
            }
         }
         return ret;
      }
      
      public function GetTeachingMemoriesInfo() : Array
      {
         var mem:XML = null;
         var memTypeInfo:Array = null;
         var item:XML = null;
         var info:Array = new Array();
         var data:XML = XMLInfo.lahmClassRoomTeachingMemory;
         for each(mem in data.children())
         {
            memTypeInfo = new Array();
            for each(item in mem.children())
            {
               memTypeInfo.push({
                  "id":item.@id.toString(),
                  "type":mem.@type.toString(),
                  "name":item.@name.toString(),
                  "description":item.@description.toString(),
                  "vip":item.@VipOnly.toString()
               });
            }
            info[mem.@type] = memTypeInfo;
         }
         return info;
      }
      
      public function getURLByItem(id:uint) : String
      {
         var url:String = "";
         if(id >= 1230001 && id < 1231000)
         {
            url = GoodsInfo.getIconPath_Seed(id);
         }
         else if(id >= 1200001 && id < 1209999)
         {
            url = "resource/petcloth/icon/" + id + ".swf";
         }
         else if(id >= 1270001 && id < 1279999)
         {
            url = "resource/farm/icon/" + id + ".swf";
         }
         else if(id == 0)
         {
            url = "resource/allJob/mainJobIcon/small/dou.swf";
         }
         else if(id >= 1300001 && id < 1309999)
         {
            url = "resource/car/icon/" + id + ".swf";
         }
         else if(id <= 10)
         {
            url = "resource/allJob/icon/" + id + ".swf";
         }
         else if(GoodsInfo.getType(id) == 26)
         {
            url = "resource/restaurant/icon/" + id + ".swf";
         }
         else
         {
            url = GoodsInfo.getItemPathByID(id) + id + ".swf";
         }
         return url;
      }
      
      public function clearBeenAllStudentData() : void
      {
         var studentArr:Array = lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().studentArr;
         var stuNum:int = int(studentArr.length);
         lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().studentCount = 0;
         while(studentArr.length > 0)
         {
            studentArr.pop();
         }
      }
      
      public function haveItemByArr(arr:Array, itemId:int) : Boolean
      {
         var ret:Boolean = false;
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].itemId == itemId && arr[i].itemCount > 0)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      public function GetTeacherHonerListByType(type:int) : Array
      {
         var xml:XML = null;
         var honers:Array = null;
         var honerList:XML = null;
         var item:XML = null;
         xml = XMLInfo.lahmClassRoomTeacherHoner.copy();
         honers = new Array();
         honerList = xml.honer.(@type == type)[0];
         if(Boolean(honerList))
         {
            for each(item in honerList.children())
            {
               honers.push(this.ParseTeacherHonerXmlToObj(item));
            }
         }
         return honers;
      }
      
      public function GetTeacherHonerByID(id:int) : Object
      {
         var honerType:XML = null;
         var itemList:XMLList = null;
         var xml:XML = XMLInfo.lahmClassRoomTeacherHoner.copy();
         for each(honerType in xml.honer)
         {
            itemList = honerType.item.(@id == id);
            if(Boolean(itemList))
            {
               return this.ParseTeacherHonerXmlToObj(itemList[0]);
            }
         }
         return null;
      }
      
      private function ParseTeacherHonerXmlToObj(xml:XML) : Object
      {
         var awardsInfo:Array = null;
         var obj:Object = new Object();
         obj.id = int(xml.@id);
         obj.name = xml.@name.toString();
         obj.description = xml.@description.toString();
         obj.unlock = xml.@unlock.toString();
         var awards:Array = [];
         if(xml.hasOwnProperty("@award1") && xml.@award1 != "")
         {
            awardsInfo = xml.@award1.toString().split(":");
            if(awardsInfo.length == 2)
            {
               awards.push({
                  "id":awardsInfo[0],
                  "count":awardsInfo[1]
               });
            }
         }
         if(xml.hasOwnProperty("@award2") && xml.@award2 != "")
         {
            awardsInfo = xml.@award2.toString().split(":");
            if(awardsInfo.length == 2)
            {
               awards.push({
                  "id":awardsInfo[0],
                  "count":awardsInfo[1]
               });
            }
         }
         if(xml.hasOwnProperty("@award3") && xml.@award3 != "")
         {
            awardsInfo = xml.@award3.toString().split(":");
            if(awardsInfo.length == 2)
            {
               awards.push({
                  "id":awardsInfo[0],
                  "count":awardsInfo[1]
               });
            }
         }
         obj.awards = awards;
         return obj;
      }
   }
}

