package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _916c2b36e20cca896887ca499e433dbae36ac4732db9d1d5c58c83948982511b_flash_display_Sprite extends Sprite
   {
      
      public function _916c2b36e20cca896887ca499e433dbae36ac4732db9d1d5c58c83948982511b_flash_display_Sprite()
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

