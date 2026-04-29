package com.global.staticData.database
{
   public class InfoNPCTalkXML
   {
      
      public static const NPCTalkXML:XML = <npclist>
		<!--face 字段為英文識別其他種類語言，互轉字段，支持任何種類語言-->
		<face angry='生氣' humdrum='無聊' sorrow='悲傷' afflatus='靈感' despond='失望' happy='開心' doubt='疑惑' anxious='焦急' surprised='驚訝' normal='正常' moving='感動' fear='害怕'/>
		
		<!--
		en_name：英文名唯一   
		race:種族分為(mole,animal,lamu,other) 
		選擇按鈕圖標：{$icon:task} 任務， {$icon:say}隨便聊聊，{$icon:deal}交易，{$icon:leave}離開.
		突出顯示文字：普通變色{$font_1_ffff00:黑森林未知世界:font}
					濾鏡發光變色{$font_2_00ff00:黑森林未知世界:font}
		文本中插入表情：{$font_face_wx:2:font}   wx表情關鍵字.(wx微笑，ku酷.....)
		-->
	
		<npc id='1' en_name='yoyo' name='尤尤' race='mole' sex='girl' birthday='11月12號' work='動物飼養專家' usebigpan='1' mapID='79'>
			<!-- location: NPC時間段所在的場景.   t0:代表time時間0點之後都在t0的場景,如果後面有tn,代表n點後面在tn的場景 -->
		</npc>

        <npc id='1139' en_name='newPets' name='拉姆' race='lamu' sex='boy' birthday='?' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
		<npc id='5' en_name='didila' name='西索' race='mole' sex='girl' birthday='6月6日' work='服裝設計師' usebigpan='1' mapID='20'>
		</npc>		
		
		<npc id='100' en_name='crow' name='克勞' race='mole' sex='boy' birthday='?' work='神父' usebigpan='1' mapID='-1'>
		</npc>
		
		<npc id='101' en_name='roc' name='洛克' race='mole' sex='boy' birthday='?' work='大使' usebigpan='1' mapID='-1'>
		</npc>
	

		<npc id='999' en_name='lamubone' name='拉姆' race='lamu' sex='?' birthday='?月?號' work='?' mapID='-1'>
		</npc>
		
		
		<npc id='103' en_name='silky' name='絲爾特' race='mole' sex='girl' birthday='' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
		
		<npc id='104' en_name='snail' name='神秘蝸牛先生' race='animal' sex='' birthday='' work='?' mapID='-1'>
		</npc>   

		<npc id='1038' en_name='mysticPeople' name='神秘商人' race='mole' sex='boy' birthday='?' work='' usebigpan='1' mapID='-1'>
		</npc>

		
		<npc id='108' en_name='sheik' name='火系酋長' race='lamu' sex='？' birthday='?月?號' work='?' mapID='126'>
		</npc>
	
		<npc id='110' en_name='tree' name='木系酋長' race='lamu' sex='？' birthday='?月?號' work='?' mapID='130'>
		</npc>
		
		<npc id='114' en_name='water' name='水系酋長' race='lamu' sex='？' birthday='?月?號' work='?' mapID='134'>
		</npc>
	
		<npc id='4' en_name='mason' name='梅森' race='mole' sex='boy' birthday='?月?號' work='植物專家' usebigpan='1' mapID='56'>
		</npc>
		
		<npc id='1025' en_name='defend' name='阿七' race='animal' sex='boy' birthday='?' work='?' usebigpan='1' mapID='-1'>
		</npc>
		
		<npc id='8' en_name='tommy2' name='湯米' race='mole' sex='boy' birthday='?' work='工頭' usebigpan='1' mapID='143'>
		</npc>
	
		<npc id='1044' en_name='fatRaccoon' name='胖胖浣熊' race='animal' sex='boy' birthday='?' work='?' mapID='-1'>
		</npc>
		
		<npc id='1048' en_name='defend3' name='阿七' race='other' sex='boy' birthday='?' work='超拉地圖出售的阿七' usebigpan='1' mapID='-1'>
		</npc>
		
		<npc id='1060' en_name='momAutumn' name='麼麼' race='mole' sex='girl' birthday='?月?號' work='?' mapID='-1'>
		</npc>
	
		<npc id='1066' en_name='max' name='馬渴斯' race='mole' sex='boy' birthday='?月?號' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
		<npc id='1067' en_name='neal' name='尼爾' race='mole' sex='boy' birthday='?月?號' work='?' usebigpan='1' mapID='-1'>
		</npc>
		
		<npc id='1070' en_name='henghengPig' name='哼哼野豬' race='animal' sex='boy' birthday='?月?號' work='?' mapID='-1'>
		</npc>
	
		<npc id='1071' en_name='sofia' name='索菲亞' race='mole' sex='girl' birthday='?月?號' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
		<npc id='1154' en_name='count' name='彩羽伯爵' race='mole' sex='girl' birthday='?月?號' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
		<npc id='1072' en_name='frank' name='法蘭克' race='mole' sex='boy' birthday='?月?號' work='?' usebigpan='1' mapID='-1'>
		</npc>
		
		<npc id='1124' en_name='cottage' name='善哉阿七' race='animal' sex='boy' birthday='?' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
      <npc id='1125' en_name='wizard' name='快樂小精靈' race='animal' sex='boy' birthday='?' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
      <npc id='1126' en_name='anday' name='安迪' race='mole' sex='boy' birthday='?' work='?' usebigpan='1' mapID='-1'>
		</npc>
	
</npclist>;
      
      public function InfoNPCTalkXML()
      {
         super();
      }
   }
}

