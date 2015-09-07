package 
{
import com.riaidea.utils.zip.ZipArchive;
import com.riaidea.utils.zip.ZipEvent;
import com.riaidea.utils.zip.ZipFile;

import flash.display.*;
import flash.filesystem.File;

[SWF(width = 500, height = 400, frameRate = 24, backgroundColor = 0xFFFFFF)]
	public class Example extends Sprite 
	{		
		private var zip:ZipArchive;
		private var swc:ZipArchive;		
		
		public function Example() 
		{
			testZip();
			testSWC();
		}
		
		private function testZip():void
		{
			zip = new ZipArchive();
			handleEvents(zip, true);
			zip.load("test.zip");
		}
		
		private function processZip():void
		{
			//显示zip文件的详细文件信息
			trace(zip.toComplexString());
			
			//读取zip中的xml文件
			var xmlFile:ZipFile = zip.getFileByName("sample.xml");
			var xml:XML = new XML(xmlFile.data);
			trace(xml);
			
			//复制zip中的"girl.jpg"为"张曼玉.jpg"
			var zmy:ZipFile = zip.getFileByName("girl.jpg");
			zip.addFileFromBytes("张曼玉.jpg", zmy.data);
			
			//异步加载并显示zip中的新生成的图片"张曼玉.jpg"
			zip.getAsyncDisplayObject("张曼玉.jpg", 
			function(img:DisplayObject):void 
			{ 
				addChild(img);
				img.x = 10;
				img.y = 10;
			} );
			
			//删除zip中的文件"girl.jpg"
			zip.removeFileByName("girl.jpg");

			//异步加载并显示zip中的SWF文件"loading.swf"
			zip.getAsyncDisplayObject("loading.swf", 
			function(swf:DisplayObject):void 
			{ 
				addChild(swf);
				swf.x = 150;
				swf.y = 10;
			} );
			
			//根据字符串内容创建一个新的txt文件
			var txtContent:String = "这是一个测试文本文件";
			zip.addFileFromString("empty_dir/test.txt", txtContent);
			
			//显示修改后的zip文件信息
			trace(zip.toComplexString());
		}
		
		private function testSWC():void
		{
			swc = new ZipArchive();
			handleEvents(swc, true);
			swc.load("puremvc.swc");
		}
		
		private function processSWC():void
		{
			//显示swc文件的详细文件信息
			trace(swc.toComplexString());
			
			//读取swc文件中的所有类定义
			var catalog:ZipFile = swc.getFileByName("catalog.xml");
			var catalogXML:XML = XML(catalog.data);
			trace(catalogXML.(catalogXML.namespace())::def);
		}
		
		private function handleEvents(zip:ZipArchive, add:Boolean):void
		{
			if (add)
			{
				zip.addEventListener(ZipEvent.PROGRESS, onProgress);
				zip.addEventListener(ZipEvent.LOADED, onLoaded);
				zip.addEventListener(ZipEvent.INIT, onInit);
				zip.addEventListener(ZipEvent.ERROR, onError);
			}else
			{
				zip.removeEventListener(ZipEvent.PROGRESS, onProgress);
				zip.removeEventListener(ZipEvent.LOADED, onLoaded);
				zip.removeEventListener(ZipEvent.INIT, onInit);
				zip.removeEventListener(ZipEvent.ERROR, onError);
			}
		}
		
		private function onInit(evt:ZipEvent):void 
		{
			handleEvents(evt.target as ZipArchive, false);			
			switch(evt.target)
			{
				case zip: processZip(); break;
				case swc: processSWC(); break;
			}
		}		
		
		private function onProgress(evt:ZipEvent):void 
		{
			trace(evt.message.bytesLoaded, evt.message.bytesTotal);
		}
		
		private function onLoaded(evt:ZipEvent):void 
		{
			trace(evt);
		}
		
		private function onError(evt:ZipEvent):void 
		{
			trace(evt);
		}
	}
}
