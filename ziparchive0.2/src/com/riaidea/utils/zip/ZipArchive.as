/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip
{	
	import flash.display.*;
	import flash.events.*;
import flash.system.LoaderContext;
import flash.utils.*;
	
	
	/**
	 * 使用ZipArchive类，你可以轻松操作各种Zip文件，如zip/swc/air/docx/xlsx等。
	 * @langversion ActionScript 3.0
	 * @playerversion Flash Player 9.0
	 */
	public class ZipArchive extends EventDispatcher
	{		
		private var _name:String;
		private var _comment:String;
		private var _encoding:String;
		
		private var _list:Array;
		private var _entry:Dictionary;
		
		
		/**
		 * 构造函数，创建一个新的Zip档案。
		 */
		public function ZipArchive(name:String = null, encoding:String = "utf-8") 
		{			
			_name = name;
			_encoding = encoding;
			_list = [];
			_entry = new Dictionary();
		}
		
		/**
		 * 加载一个zip档案，与此方法的事件有ProgressEvent.PROGRESS、ZipEvent.ZIP_INIT、ZipEvent.ZIP_FAILED、IOErrorEvent.IO_ERROR。
		 * @param	request 要加载的zip档案地址。
		 */
		public function load(url:String):void 
		{
			try {
				if (!_name) _name = url;
				var parser:ZipParser = new ZipParser();
				parser.loadZipFromFile(this, url);
			}catch (e:Error) { }
		}
		
		/**
		 * 打开一个二进制流的zip档案。
		 * @param	data 二进制流的zip档案。
		 * @return  成功打开返回true，否则返回false。
		 */
		public function open(data:ByteArray):Boolean 
		{
			try {
				if (data == null || data.length == 0) return false;
				var parser:ZipParser = new ZipParser();
				parser.loadZipFromBytes(this, data);
				return true;
			}catch (e:Error) { }
			return false;
		}
		
		/**
		 * 添加指定的zip文件到档案。
		 * @param	file 指定添加到zip档案的文件。
		 * @param	index 指定添加到zip档案中的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFile(file:ZipFile, index:int = -1):ZipFile 
		{
			if (file != null) 
			{
				if (index < 0 || index >= _list.length) _list.push(file);
				else _list.splice(index, 0, file);
				_entry[file.name] = file;
				return file;
			}
			return null;
		}
		
		/**
		 * 根据指定的名称和二进制数据添加文件到zip档案。
		 * @param	name 指定文件的名字。
		 * @param	data 指定文件的二进制数据。
		 * @param	index 指定添加到zip档案中的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFileFromBytes(name:String, data:ByteArray = null, index:int = -1):ZipFile 
		{
			if (_entry[name] != null) dispatchEvent(new ZipEvent(ZipEvent.ERROR, "File: " + name + " already exists."));
			
			//uncompress file data
			try {
				data.position = 0;
				data.uncompress();
			}catch (e:Error) { };
			
			var file:ZipFile = new ZipFile(name);
			file._data = data;
			file._size = data.length;				
			file._version = 20;
			file._flag = 0;
			file._crc32 = CRC32.getCRC32(data);
			file.date = new Date();
			return addFile(file, index);
		}
		
		/**
		 * 根据指定的字符串内容添加文件到zip档案。
		 * @param	name 指定文件的名字。
		 * @param	content 指定的字符串内容。
		 * @param	index 指定添加到zip档案中的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFileFromString(name:String, content:String, index:int = -1):ZipFile 
		{
			if (content == null) return null;
			//encodes by utf-8
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(content);
			var file:ZipFile = addFileFromBytes(name, data, index);
			file._encoding = "utf-8";
			return file;
		}
		
		/**
		 * 根据文件名获取Zip档案中的文件。
		 * @param	name 名称。
		 * @return
		 */
		public function getFileByName(name:String):ZipFile 
		{
			return _entry[name];
		}
		
		/**
		 * 根据文件位置获取Zip档案中的文件。
		 * @param	index 位置。
		 * @return
		 */
		public function getFileAt(index:int):ZipFile 
		{
			if (index < 0 || index > _list.length) return null;
			return _list[index];
		}
		
		/**
		 * 异步获取Zip档案中的SWF文件或图像（JPG、PNG 或 GIF）文件。
		 * @param	name 名称。
		 * @param   onLoad 图片加载完毕后的回调方法，此方法接受一个参数（data:DisplayObject）
		 */
		public function getAsyncDisplayObject(name:String, onLoad:Function = null):void
		{
			var file:ZipFile = getFileByName(name);
			if (file == null) dispatchEvent(new ZipEvent(ZipEvent.ERROR, "Can't find file with name: " + name));
			
			//starts a loader to load the bitmap raw data
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAsyncBitmap);

			var lc:LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			loader.loadBytes(file.data, lc);
			function onAsyncBitmap(evt:Event):void 
			{
				var info:LoaderInfo = evt.target as LoaderInfo;
				evt.target.removeEventListener(Event.COMPLETE, onAsyncBitmap);
				onLoad.call(null, info.content);
				loader = null;
			}
		}
		
		/**
		 * 删除Zip档案中的指定名称的文件。
		 * @param	name 指定文件的名字。
		 * @return
		 */
		public function removeFileByName(name:String):ZipFile 
		{
			if (_entry[name] != null) 
			{
				for (var i:int = 0; i < _list.length; i++)
				{
					if (name == _list[i].name) return removeFileAt(i);
				}
			}
			return null;
		}
		
		/**
		 * 删除Zip档案中的指定位置的文件。
		 * @param	index 指定的位置。
		 * @return
		 */
		public function removeFileAt(index:int):ZipFile 
		{
			var file:ZipFile = getFileAt(index);
			
			if (file != null)
			{
				_list.splice(index, 1);
				delete _entry[file.name];
				return file;
			}
			return null;
		}
		
		/**
		 * 输出序列化的Zip档案。
		 * @param	method 指定压缩模式，一般为DEFLATED或STORED。
		 */
		public function output(method:uint = 8):ByteArray 
		{
			var zs:ZipSerializer = new ZipSerializer();
			return zs.serialize(this, method) as ByteArray;
		}
		
		/**
		 * 指示ZipArchive实例的名称。
		 */
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(name:String):void
		{
			this._name = name;
		}
		
		/**
		 * [只读 (read-only)] 返回Zip档案里的文件数目。
		 */
		public function get numFiles():int 
		{
			return _list.length;
		}
		
		/**
		 * ZipArchive档案的评论。
		 */
		public function get comment():String 
		{ 
			return _comment; 
		}
		
		public function set comment(value:String):void 
		{
			_comment = value;
		}
		
		/**
		 * ZipArchive档案的文件名称编码。
		 */
		public function get encoding():String 
		{ 
			return _encoding;
		}
		
		public function set encoding(value:String):void 
		{
			_encoding = value;
		}
		
		/**
		 * 返回ZipArchive对象的字符串表示形式。
		 * @return ZipArchive对象的字符串表现形式。
		 */
		override public function toString():String 
		{
			return '[ZipArchive name="' + name + '" files=' + numFiles + ']';
		}
		
		/**
		 * 返回ZipArchive对象的具体内容的字符串表示形式。
		 * @return ZipArchive对象的具体内容的字符串表现形式。
		 */
		public function toComplexString():String
		{
			var str:String = toString() + '\r';
			for (var i:int = 0; i < numFiles; i++)
			str += 'Index:' + i + ' --> ' + _list[i].toString();
			return str;
		}
	}
}
