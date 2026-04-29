package com.mole.app.manager
{
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.utils.setTimeout;
   
   public class KFCStatisticsManager
   {
      
      private static var _enter203Count:uint = 0;
      
      public function KFCStatisticsManager()
      {
         super();
      }
      
      public static function update() : void
      {
         var rnd:Number = NaN;
         if(_enter203Count++ > 10)
         {
            _enter203Count = 0;
            StatisticsClass.getInstance().init(67746808,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNs0&rt=2&o=");
            if(Math.random() > 0.5)
            {
               rnd = Math.random();
               if(rnd < 0.3)
               {
                  setTimeout(function():void
                  {
                     StatisticsClass.getInstance().init(67749159,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNt0&rt=2&o=");
                     setTimeout(function():void
                     {
                        StatisticsClass.getInstance().init(67749160,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNx0&rt=2&o=");
                     },60000);
                  },30000);
               }
               else if(rnd < 0.6)
               {
                  setTimeout(function():void
                  {
                     StatisticsClass.getInstance().init(67749161,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNv0&rt=2&o=");
                     setTimeout(function():void
                     {
                        StatisticsClass.getInstance().init(67749162,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNw0&rt=2&o=");
                     },60000);
                  },30000);
               }
               else
               {
                  setTimeout(function():void
                  {
                     sendCate();
                  },30000);
               }
            }
            else
            {
               rnd = Math.random();
               if(rnd < 0.35)
               {
                  kfcNewsPaperGo();
               }
               else
               {
                  setTimeout(function():void
                  {
                     kfcPairOver();
                  },60000 + Math.random() * 60000);
                  kfcPairStart();
               }
            }
         }
      }
      
      public static function sendCate() : void
      {
         StatisticsClass.getInstance().init(67749214,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3y2Fv0&rt=2&o=");
      }
      
      public static function kfcNewsPaperGo() : void
      {
         StatisticsClass.getInstance().init(67749231,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3y7I40&rt=2&o=");
      }
      
      public static function kfcPairStart() : void
      {
         StatisticsClass.getInstance().init(67749235,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3y7I50&rt=2&o=");
      }
      
      public static function kfcPairOver() : void
      {
         StatisticsClass.getInstance().init(67749236,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3y7I60&rt=2&o=");
      }
      
      public static function gasStart() : void
      {
         StatisticsClass.getInstance().init(67749249);
      }
      
      public static function gasOver() : void
      {
         StatisticsClass.getInstance().init(67749250);
      }
   }
}

