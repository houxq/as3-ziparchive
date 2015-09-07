/**
 * Created by houxiaoqing on 2015/9/7.
 */
package {
import com.riaidea.utils.zip.ZipArchive;
import com.riaidea.utils.zip.ZipEvent;
import com.riaidea.utils.zip.ZipFile;

import flash.display.Sprite;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class UnzipFile extends Sprite{
    private var zip:ZipArchive;
    private var swc:ZipArchive;
    public function UnzipFile() {
        testZip();
    }

    private function testZip():void
    {
        zip = new ZipArchive();
        handleEvents(zip, true);
        zip.load("test.zip");
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
        }
    }

    private function processZip():void
    {
        //显示zip文件的详细文件信息
        trace(zip.toComplexString());

//        //读取zip中的xml文件
//        var xmlFile:ZipFile = zip.getFileByName("sample.xml");
//        var xml:XML = new XML(xmlFile.data);
//        trace(xml);

        var len:int = zip.numFiles;
        for(var i:int = 0; i<len; i++){
            var newZipFile:ZipFile = zip.getFileAt(i);
            var byteArray:ByteArray = new ByteArray();
            byteArray = newZipFile.data;
            var fileStr:FileStream = new FileStream();
            var file:File = new File;//C:\Documents and Settings\username
            file = file.resolvePath("C:/temp/" + newZipFile.name);
            trace(newZipFile.name + newZipFile.isDirectory());
            if(newZipFile.isDirectory == false){ //判断是否为文件夹，不是文件夹时候向下进行，按照文件的目录结构依次生成文件夹、文件
                fileStr.open(file, FileMode.WRITE); //以写形式打开文件，准备更新
                fileStr.writeBytes(byteArray, 0, byteArray.length); //在文件中写入新下载的数据
                fileStr.close();//关闭文件流
            }else{

            }
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
