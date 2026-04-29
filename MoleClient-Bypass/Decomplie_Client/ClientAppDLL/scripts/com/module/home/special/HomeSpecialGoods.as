package com.module.home.special
{
   import com.module.home.HomeCarLoad;
   import com.module.home.HomeView;
   import com.module.home.itemCon.ChangeMap;
   import com.module.home.itemCon.FriendlyBox;
   import com.module.home.itemCon.Item1220425Logic;
   import com.module.home.itemCon.MatherPanel;
   import com.module.home.itemCon.SmallSnowPanel;
   import com.module.home.itemCon.neighbour;
   import com.module.home.itemCon.neighbour1;
   import com.module.home.itemCon.neighbour2;
   import com.module.home.itemCon.neighbour3;
   
   public class HomeSpecialGoods
   {
      
      public function HomeSpecialGoods()
      {
         super();
      }
      
      public static function specialgood(mc:*) : void
      {
         switch(mc.ID)
         {
            case 1220096:
               Bodhi1220096.getInstance().init(mc);
               break;
            case 1220118:
               WishBalloonGoods.getInstance().init(mc);
               break;
            case 1220115:
            case 1220116:
            case 1220289:
            case 1220290:
            case 1220291:
               HomeGoodsLogic.getInstance().init(mc);
               break;
            case 1220008:
               new neighbour(mc);
               break;
            case 1220367:
               new neighbour1(mc);
               break;
            case 1220368:
               new neighbour2(mc);
               break;
            case 1220369:
               new neighbour3(mc);
               break;
            case 1220018:
               FriendlyBox.getInstance().init(mc);
               break;
            case 1220097:
               new HomeCarLoad(mc);
               break;
            case 1220192:
               if(HomeView.ismyhome)
               {
                  MatherPanel.getInstance().init(mc);
               }
               break;
            case 1220193:
               if(HomeView.ismyhome)
               {
                  MatherPanel.getInstance().init(mc);
               }
               break;
            case 1220352:
               SmallSnowPanel.getInstance().init(mc);
               break;
            case 1220428:
               new ChangeMap(mc,390);
               break;
            case 1220429:
               new ChangeMap(mc,391);
               break;
            case 1220430:
               new ChangeMap(mc,393);
               break;
            case 1220431:
               new ChangeMap(mc,394);
               break;
            case 1220432:
               new ChangeMap(mc,397);
               break;
            case 1220433:
               new ChangeMap(mc,398);
               break;
            case 1220434:
               new ChangeMap(mc,400);
               break;
            case 1220435:
               new ChangeMap(mc,401);
               break;
            case 1220425:
               Item1220425Logic.getInstance().init(mc);
               break;
            default:
               new BasicGood(mc);
         }
      }
   }
}

