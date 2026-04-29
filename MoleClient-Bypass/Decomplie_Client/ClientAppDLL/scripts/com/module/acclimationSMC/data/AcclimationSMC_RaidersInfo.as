package com.module.acclimationSMC.data
{
   public class AcclimationSMC_RaidersInfo
   {
      
      public var id:uint = 0;
      
      public var name:String = "";
      
      public var extreme:Array;
      
      public var extreme_time:uint = 0;
      
      public var cream:Array;
      
      public var cream_time:uint = 0;
      
      public var superfine:Array;
      
      public var superfine_time:uint = 0;
      
      public var senior:Array;
      
      public var senior_time:uint = 0;
      
      public var middle:Array;
      
      public var middle_time:uint = 0;
      
      public var primary:Array;
      
      public var listArr:Array;
      
      public function AcclimationSMC_RaidersInfo(xml:XML)
      {
         super();
         this.id = xml.@id;
         this.name = xml.@name;
         var e:String = xml.@extreme;
         this.extreme = e.split("/");
         this.extreme_time = xml.@extreme_time;
         var c:String = xml.@cream;
         this.cream = c.split("/");
         this.cream_time = xml.@cream_time;
         var s:String = xml.@superfine;
         this.superfine = s.split("/");
         this.superfine_time = xml.@superfine_time;
         var se:String = xml.@senior;
         this.senior = se.split("/");
         this.senior_time = xml.@senior_time;
         var m:String = xml.@middle;
         this.middle = m.split("/");
         this.middle_time = xml.@middle_time;
         var p:String = xml.@primary;
         this.primary = p.split("/");
         this.listArr = this.getListArr();
      }
      
      public function getListArr() : Array
      {
         var arr:Array = new Array();
         if(this.extreme[0] != "")
         {
            arr.push({
               "IdArr":this.extreme,
               "Time":this.extreme_time
            });
         }
         if(this.cream[0] != "")
         {
            arr.push({
               "IdArr":this.cream,
               "Time":this.cream_time
            });
         }
         if(this.superfine[0] != "")
         {
            arr.push({
               "IdArr":this.superfine,
               "Time":this.superfine_time
            });
         }
         if(this.senior[0] != "")
         {
            arr.push({
               "IdArr":this.senior,
               "Time":this.senior_time
            });
         }
         if(this.middle[0] != "")
         {
            arr.push({
               "IdArr":this.middle,
               "Time":this.middle_time
            });
         }
         if(this.primary[0] != "")
         {
            arr.push({
               "IdArr":this.primary,
               "Time":0
            });
         }
         return arr;
      }
   }
}

