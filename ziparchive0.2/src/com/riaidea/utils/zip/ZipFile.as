/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip
{
	import flash.utils.ByteArray;
	
	/**
	 * ZipFile类用于表示Zip档案中的一个文件对象。
	 */
	public class ZipFile
	{		
		internal var _name:String;
		internal var _data:ByteArray;		
		internal var _size:int;
		internal var _compressedSize:int;
		internal var _crc32:uint;
		internal var _comment:String;
		internal var _extra:ByteArray;	
		internal var _version:int;
		internal var _dostime:uint;
		internal var _flag:int;
		internal var _encrypted:Boolean;
		internal var _encoding:String;
		internal var _compressionMethod:int = -1;
		
		
		/**
		 * 构造函数，创建一个ZipFile对象。
		 * @param	name 文件名称
		 * @param   encoding 文件的文本编码方式（文件名、评论及文本内容等）
		 */
		public function ZipFile(name:String = null, encoding:String = "utf-8")
		{
			if (name) _name = name;
			_encoding = encoding;
			_data = new ByteArray();
		}
		
		public function set name(value:String):void
		{
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get version():int 
		{
			return _version;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function get compressionMethod():int 
		{
			return _compressionMethod;
		}
		
		public function get crc32():uint 
		{
			return _crc32;
		}
		
		public function get compressedSize():int
		{
			return _compressedSize;
		}
		
		public function get encrypted():Boolean 
		{
			return _encrypted;
		}
		
		public function set comment(value:String):void
		{
			_comment = value;
		}		
		
		public function get comment():String 
		{
			return _comment;
		}		
		
		public function set data(value:ByteArray):void
		{
			_data = value;
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
		public function set date(date:Date):void 
		{
			this._dostime =
						(date.fullYear - 1980 & 0x7f) << 25
						| (date.month + 1) << 21
						| date.date << 16
						| date.hours << 11
						| date.minutes << 5
						| date.seconds >> 1;
		}
		
		public function get date():Date 
		{
			var sec:int = (_dostime & 0x1f) << 1;
			var min:int = (_dostime >> 5) & 0x3f;
			var hour:int = (_dostime >> 11) & 0x1f;
			var day:int = (_dostime >> 16) & 0x1f;
			var month:int = ((_dostime >> 21) & 0x0f) - 1;
			var year:int = ((_dostime >> 25) & 0x7f) + 1980;
			return new Date(year, month, day, hour, min, sec);
		}
		
		public function get extra():ByteArray 
		{ 
			return _extra; 
		}
		
		public function hasExtra():Boolean
		{
			return _extra != null && _extra.length > 0;
		}
		
		public function isDirectory():Boolean 
		{
			return _name.charAt(_name.length - 1) == "/";
		}
		
		public function toString():String 
		{
			var str:String = "[ZipFile Path=\"";
			str += _name + "\"]\rsize:" + _size + " compressedSize:" + _compressedSize + " CRC32:" + _crc32.toString(16).toLocaleUpperCase();
			str += "\rLast modify time:" + date + "\r";
			return str;
		}
	}
}
