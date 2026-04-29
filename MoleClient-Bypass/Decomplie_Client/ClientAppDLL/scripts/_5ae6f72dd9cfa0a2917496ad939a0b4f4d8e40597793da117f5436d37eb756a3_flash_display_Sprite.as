package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _5ae6f72dd9cfa0a2917496ad939a0b4f4d8e40597793da117f5436d37eb756a3_flash_display_Sprite extends Sprite
   {
      
      public function _5ae6f72dd9cfa0a2917496ad939a0b4f4d8e40597793da117f5436d37eb756a3_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

