package com.module.clothBuyBook
{
   import com.mole.app.manager.ModuleManager;
   
   public class OpenClothBuyBook
   {
      
      private static var owner:OpenClothBuyBook;
      
      public function OpenClothBuyBook()
      {
         super();
         owner = this;
      }
      
      public static function getInstance() : OpenClothBuyBook
      {
         return Boolean(owner) ? owner : new OpenClothBuyBook();
      }
      
      public function openClothsBook() : void
      {
         ModuleManager.openPanel("ClothBookShopPanel");
      }
      
      public function openBookEvent() : void
      {
         ModuleManager.openPanel("ClothBookShopPanel");
      }
   }
}

