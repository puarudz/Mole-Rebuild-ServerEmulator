package com.view.mapView.activity
{
   public class TryMoleClothes
   {
      
      private static var instance:TryMoleClothes;
      
      private static var canotNew:Boolean = true;
      
      private var properClothesArr:Array;
      
      private var tryMachineShareObject:Object;
      
      private var thisPeopleMC:Object;
      
      public function TryMoleClothes()
      {
         super();
         if(canotNew)
         {
            throw new Error("TryMoleClothes不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : TryMoleClothes
      {
         if(!instance)
         {
            canotNew = false;
            instance = new TryMoleClothes();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(peopleMC:Object) : void
      {
         this.thisPeopleMC = peopleMC;
         this.tryMachineShareObject = creatShareObject.getInstance().getTryMachine();
         this.checkUserClothes();
      }
      
      private function checkUserClothes() : void
      {
         var i:uint = 0;
         var AbcStr:String = this.tryMachineShareObject.AbcStr;
         var AbcStrRound:int = 0;
         var joinLai:Boolean = true;
         var indexofs:String = AbcStr;
         var fishArr:Array = indexofs.split("");
         for(AbcStrRound = 0; AbcStrRound < AbcStr.length; AbcStrRound++)
         {
            if(this.againCheckUserClothes(AbcStr.charCodeAt(AbcStrRound)))
            {
               if(this.tryMachineShareObject.AbcArr.indexOf(AbcStr.charAt(AbcStrRound)) == -1)
               {
                  this.tryMachineShareObject.AbcArr.push(AbcStr.charAt(AbcStrRound));
                  this.tryMachineShareObject.UserArr.push(this.thisPeopleMC.id);
                  creatShareObject.getInstance().setTryMachine(this.tryMachineShareObject);
                  joinLai = false;
               }
               break;
            }
         }
         if(joinLai && !this.tryMachineShareObject.islai)
         {
            if(this.thisPeopleMC.PetCloth == 1200027)
            {
               for(i = 0; i < fishArr.length; i++)
               {
                  if(this.tryMachineShareObject.AbcArr.indexOf(fishArr[i]) < 0)
                  {
                     this.tryMachineShareObject.AbcArr.push(fishArr[i]);
                     this.tryMachineShareObject.UserArr.push(this.thisPeopleMC.id);
                     this.tryMachineShareObject.islai = true;
                     creatShareObject.getInstance().setTryMachine(this.tryMachineShareObject);
                     break;
                  }
               }
            }
         }
      }
      
      private function againCheckUserClothes(charCode:int) : Boolean
      {
         var ret:Boolean = false;
         var matchClothesId:int = charCode + 12822;
         var userClothsArray:Array = this.thisPeopleMC.clothsArray;
         for(var clothsArrayRound:int = 0; clothsArrayRound < userClothsArray.length; clothsArrayRound++)
         {
            if(matchClothesId == userClothsArray[clothsArrayRound].ItemID)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
   }
}

