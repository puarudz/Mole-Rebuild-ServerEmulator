package com.view.PeopleView.ChildPeople
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.view.PeopleView.BoneInfo;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.ColorTransform;
   import org.taomee.utils.DisplayUtil;
   
   public class BoyAvatar extends simplePeople
   {
      
      private var body_bones:MovieClip;
      
      private var body_kyte:MovieClip;
      
      private var body_shadow:MovieClip;
      
      private var danceCloth:DanceCloth;
      
      private var isPlayer:Boolean;
      
      public function BoyAvatar()
      {
         super();
         offset = 8;
      }
      
      override public function changeDirection(Dir:uint) : void
      {
         if(InstanceMC.hasDragonType4 == false && InstanceMC.hasDragon || Boolean(InstanceMC.specificObj["F12300"]))
         {
            showActionWithId(PlayerActionConstant.ACTION_STAND,Dir);
         }
         else
         {
            showActionWithId(PlayerActionConstant.ACTION_RUN,Dir);
         }
         currentDirection = LABEL_ACTION_ARR[Dir];
         dispatchEvent(new EventTaomee(PeopleManageView.ON_CHANGE_DIRECTION,{"dir":currentDirection}));
         if(Boolean(InstanceMC))
         {
            InstanceMC.dispatchEvent(new EventTaomee(PeopleManageView.ON_CHANGE_DIRECTION,{"dir":currentDirection}));
         }
      }
      
      public function init(instanceMC:MovieClip, mc:MovieClip) : void
      {
         initSimplePeople(instanceMC,mc);
      }
      
      override public function playMovieClip(E:Event) : void
      {
      }
      
      public function showSpecialMC(act:String, job:String) : void
      {
         var mc:MovieClip = null;
         var boneObj:Object = BoneInfo.LabelInfo[act + "_" + job + "_down"];
         if(Boolean(boneObj && boneObj.bones && boneObj.kyte && boneObj.shadow) && Boolean(this.danceCloth) && this.danceCloth.loadOver)
         {
            BC.removeEvent(this,BoneInfo);
            if(currentDirection == act + "_" + job + "_down" && !this.isPlayer)
            {
               this.isPlayer = true;
               showAction("special",false);
               this.body_bones = new boneObj.bones();
               this.body_kyte = new boneObj.kyte();
               this.body_shadow = new boneObj.shadow();
               this.body_bones.scaleX = this.body_bones.scaleY = 0.2;
               this.body_kyte.scaleX = this.body_kyte.scaleY = 0.2;
               this.body_shadow.scaleX = this.body_shadow.scaleY = 0.2;
               BC.addEvent(this,this,PeopleManageView.ON_CHANGE_CLOTHS,this.onClothsChange2);
               BC.addEvent(this,this,PeopleManageView.ON_CHANGE_CLOTHS,this.clearSpecialMC);
               BC.addEvent(this,this,PeopleManageView.ON_CHANGE_DIRECTION,this.clearSpecialMC);
               BC.addEvent(this,this,PeopleManageView.ON_GO_OVER,this.clearSpecialMC);
               BC.addEvent(this,this,PeopleManageView.ON_ACTION_SHOW_BEFORE,this.clearSpecialMC);
               this.body_bones.transform.colorTransform = new ColorTransform(InstanceMC.colorObj.red / 256,InstanceMC.colorObj.green / 256,InstanceMC.colorObj.blue / 256,1);
               body_mc.addChild(this.body_bones);
               body_mc.addChild(this.body_kyte);
               this.danceCloth.play(currentDirection);
               for each(mc in this.danceCloth.bodyMc)
               {
                  body_mc.addChild(mc);
               }
               shadowMC.addChild(this.body_shadow);
               this.body_bones.addEventListener(Event.ENTER_FRAME,this.enterFrame);
            }
         }
      }
      
      private function enterFrame(evt:Event) : void
      {
         var clothMc:MovieClip = null;
         var mc:MovieClip = null;
         this.body_shadow.gotoAndStop(this.body_bones.currentFrame);
         this.body_kyte.gotoAndStop(this.body_bones.currentFrame);
         for each(clothMc in this.danceCloth.bodyMc)
         {
            if(clothMc.numChildren >= 1)
            {
               mc = clothMc.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(this.body_bones.currentFrame);
               }
            }
         }
      }
      
      override public function specialAct(Actstr:String, Act:String, jobID:int) : void
      {
         this.isPlayer = false;
         ResetAndDisposeBmp();
         isdoAction = true;
         if(currentDirection == Actstr)
         {
            return;
         }
         currentDirection = Actstr;
         if(Boolean(this.body_bones))
         {
            DisplayUtil.removeFromParent(this.body_bones);
         }
         if(Boolean(this.body_kyte))
         {
            DisplayUtil.removeFromParent(this.body_kyte);
         }
         if(Boolean(this.body_shadow))
         {
            DisplayUtil.removeFromParent(this.body_shadow);
         }
         if(!this.danceCloth)
         {
            this.danceCloth = new DanceCloth();
            this.danceCloth.addEventListener(Event.COMPLETE,this.loadComplete);
         }
         else
         {
            this.danceCloth.destroy();
         }
         this.danceCloth.loaderCloth(Actstr,Act,jobID);
         if(Boolean(BoneInfo.LabelInfo[Actstr]))
         {
            this.showSpecialMC(Act,GoodsInfo.ClothObject[jobID]);
         }
         else
         {
            BC.addEvent(this,BoneInfo,Event.INIT,this.loadSBoneInit);
            BC.addEvent(this,BoneInfo,IOErrorEvent.IO_ERROR,this.loadSBoneError);
            BoneInfo.LabelInfo[Actstr] = {};
            BoneInfo.loadBone(Act,jobID,BoneInfo.Bones);
            BoneInfo.loadBone(Act,jobID,BoneInfo.Kyte);
            BoneInfo.loadBone(Act,jobID,BoneInfo.Shadow);
         }
         dispatchEvent(new Event(Actstr));
         if(Boolean(InstanceMC))
         {
            InstanceMC.dispatchEvent(new Event(Actstr));
         }
         dispatchEvent(new Event(Act));
         if(Boolean(InstanceMC))
         {
            InstanceMC.dispatchEvent(new Event(Act));
         }
      }
      
      private function loadComplete(evt:Event) : void
      {
         if(this.danceCloth.actstr == currentDirection)
         {
            this.danceCloth.loadOver = true;
            this.showSpecialMC(this.danceCloth.act,GoodsInfo.ClothObject[this.danceCloth.jobId]);
         }
      }
      
      override public function stopMovieClip(E:Event) : void
      {
      }
      
      private function clearSpecialMC(E:* = null) : void
      {
         multiEquipPlayer.visible = true;
         BC.removeEvent(this,null,null,this.clearSpecialMC);
         if(Boolean(this.body_bones))
         {
            this.body_bones.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         }
         if(Boolean(this.danceCloth))
         {
            this.danceCloth.destroy();
         }
         GC.stopAllMC(this.body_bones);
         GC.stopAllMC(this.body_kyte);
         GC.stopAllMC(this.body_shadow);
         if(Boolean(this.body_bones.parent))
         {
            this.body_bones.parent.removeChild(this.body_bones);
         }
         if(Boolean(this.body_kyte.parent))
         {
            this.body_kyte.parent.removeChild(this.body_kyte);
         }
         if(Boolean(this.body_shadow.parent))
         {
            this.body_shadow.parent.removeChild(this.body_shadow);
         }
      }
      
      private function loadSBoneError(E:EventTaomee) : void
      {
         throw new Error("骨骼加載出錯：" + E.EventObj.url + " " + E.EventObj.act + " " + E.EventObj.job + " " + E.EventObj.boneType);
      }
      
      private function loadSBoneInit(E:EventTaomee) : void
      {
         var loadObj:Object = E.EventObj;
         var bodyClass:* = loadObj.app.getDefinition("prop") as Class;
         if(Boolean(bodyClass))
         {
            BoneInfo.LabelInfo[loadObj.act + "_" + loadObj.job + "_down"][loadObj.boneType] = bodyClass;
            this.showSpecialMC(loadObj.act,loadObj.job);
            return;
         }
         throw new Error("骨骼找不到導出項prop：" + E.currentTarget.url);
      }
      
      private function onClothsChange2(E:Event) : void
      {
         this.stopAction("down");
      }
   }
}

import com.common.data.goodsInfo.GoodsInfo;
import com.mole.utils.URLUtil;
import com.taomee.mole.cache.CacheManager;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import org.taomee.loader.ContentInfo;
import org.taomee.utils.DisplayUtil;

class DanceCloth extends EventDispatcher
{
   
   public var bodyMc:Vector.<MovieClip>;
   
   public var actstr:String;
   
   public var act:String;
   
   public var jobId:uint;
   
   private var url:String;
   
   private var clothArr:Array;
   
   public var loadOver:Boolean;
   
   private var clothNum:int = 0;
   
   private var newCloth:Boolean = true;
   
   public function DanceCloth()
   {
      super();
   }
   
   public function loaderCloth(actVal:String, _act:String, jobID:uint) : void
   {
      var cloth:uint = 0;
      this.loadOver = false;
      this.actstr = actVal;
      this.jobId = jobID;
      this.act = _act;
      this.clothArr = GoodsInfo.ClothArray[this.jobId];
      this.bodyMc = new Vector.<MovieClip>();
      this.clothNum = this.clothArr.length;
      for each(cloth in this.clothArr)
      {
         if(cloth < 14755)
         {
            this.newCloth = false;
         }
      }
      if(GoodsInfo.ClothObject["ActName2_" + jobID].indexOf("祈禱") != -1 && GoodsInfo.ClothObject["ActName2_" + jobID].length > 2)
      {
         this.newCloth = true;
      }
      if(this.newCloth)
      {
         this.loadOver = true;
         return;
      }
      for each(cloth in this.clothArr)
      {
         if(cloth < 14755)
         {
            this.newCloth = false;
         }
         this.url = URLUtil.getOldClothSwf(cloth);
         CacheManager.getPhasorContent(this.url,"prop",this.loadComplete,this.errorFunc);
      }
   }
   
   public function destroy() : void
   {
      var cloth:uint = 0;
      var mc:MovieClip = null;
      for each(cloth in this.clothArr)
      {
         this.url = URLUtil.getOldClothSwf(cloth);
         CacheManager.cancelPhasor(this.url,this.loadComplete);
      }
      for each(mc in this.bodyMc)
      {
         DisplayUtil.removeFromParent(mc);
      }
   }
   
   private function loadComplete(contentInfo:ContentInfo) : void
   {
      --this.clothNum;
      this.bodyMc.push(contentInfo.content);
      this.bodyMc[this.bodyMc.length - 1].stop();
      if(this.clothNum == 0)
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
   
   private function errorFunc(... ret) : void
   {
      --this.clothNum;
      if(this.clothNum == 0)
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
   
   public function play(str:String) : void
   {
      var mc:MovieClip = null;
      if(this.newCloth)
      {
         return;
      }
      for each(mc in this.bodyMc)
      {
         try
         {
            mc.gotoAndStop(str);
         }
         catch(e:Error)
         {
         }
      }
   }
}
