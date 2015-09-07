package {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import riaidea.utils.zip.ZipArchive;
	import riaidea.utils.zip.ZipEvent;
	import riaidea.utils.zip.ZipFile;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;


	public class Example extends Sprite {
		
		private var zip1:ZipArchive = new ZipArchive();
		
		public function Example() {
			//加载一个zip档案
			zip1.load("test.zip");
			zip1.addEventListener(ProgressEvent.PROGRESS, loading);
			zip1.addEventListener(ZipEvent.ZIP_INIT, inited);
			zip1.addEventListener(ZipEvent.ZIP_FAILED, failed);
			zip1.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
		}
		private function inited(evt:ZipEvent):void {
			zip1.removeEventListener(ProgressEvent.PROGRESS, loading);
			zip1.removeEventListener(ZipEvent.ZIP_INIT, inited);
			zip1.removeEventListener(ZipEvent.ZIP_FAILED, failed);
			//添加ZIP_CONTENT_LOADED事件侦听器
			zip1.addEventListener(ZipEvent.ZIP_CONTENT_LOADED, imgloaded);
			trace("原始zip文件内容\r", zip1);
			//读取zip1中的xml文件
			var xmlFile:ZipFile = zip1.getFileByName("sample.xml");
			var xml:XML = new XML(xmlFile.data);
			trace(xml);
			//根据字符串内容创建一个新的txt文件
			var txtContent:String = "这是一个测试文本文件";
			zip1.addFileFromString("测试.txt", txtContent);
			//trace(zip1.getFileByName("测试.txt").data);
			//复制zip1中的"girl.jpg"为"张曼玉.jpg"
			var zmy:ZipFile = zip1.getFileByName("girl.jpg");
			zip1.addFileFromBytes("张曼玉.jpg", zmy.data);
			//加载zip1中的新生成的图片文件的Bitmap对象
			zip1.getBitmapByName("张曼玉.jpg");
			//删除图片文件logo.gif
			zip1.removeFileByName("logo.gif");
			trace("\r修改后的zip文件内容\r", zip1);
			//输出更改后的文件
			var ba:ByteArray = zip1.output();
			var f:File = new File(File.applicationDirectory.resolvePath("outputTest.zip").nativePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(f, FileMode.WRITE);
			fileStream.writeBytes(ba);
			fileStream.close();
		}
		private function imgloaded(evt:ZipEvent):void {
			zip1.removeEventListener(ZipEvent.ZIP_CONTENT_LOADED, imgloaded);
			var img:Bitmap = evt.content as Bitmap;
			addChild(img);
		}
		private function loading(evt:ProgressEvent):void {
			//trace(evt.currentTarget, evt.bytesLoaded, evt.bytesTotal);
		}
		private function failed(evt:ZipEvent):void {
			//trace(evt.content);
		}
		private function ioError(evt:IOErrorEvent):void {
			//trace(evt);
		}
	}
}
