package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _fb830095dfd4359607c4614890e114a7cc234c7430f00a7acfed749f125c030c_flash_display_Sprite extends Sprite
   {
      
      public function _fb830095dfd4359607c4614890e114a7cc234c7430f00a7acfed749f125c030c_flash_display_Sprite()
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

