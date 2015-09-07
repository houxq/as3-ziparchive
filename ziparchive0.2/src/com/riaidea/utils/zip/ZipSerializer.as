/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip 
{
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @private
	 */
	internal class ZipSerializer 
	{
		private var stream:ByteArray;
		
		public function ZipSerializer() 
		{
			
		}
		
		public function serialize(zip:ZipArchive, method:uint = 8):ByteArray 
		{
			if (zip.numFiles <= 0) return null;
			var stream:ByteArray = new ByteArray();
			var centralData:ByteArray = new ByteArray();
			stream.endian = centralData.endian = Endian.LITTLE_ENDIAN;
			
			var offset:int;
			for (var i:int = 0; i < zip.numFiles; i++) 
			{
				var file:ZipFile = zip.getFileAt(i);
				//生成文件数据the local file data
				var data:ByteArray = serializeContent(file, method);
				//写入zip文件头the local file header
				serializeFile(stream, file, true);
				//写入文件数据
				stream.writeBytes(data);
				//写入中央目录到临时centralData中
				serializeFile(centralData, file, false, offset);
				offset = stream.position;
			}
			//写入中央目录central directory file header
			stream.writeBytes(centralData);
			//写入中央目录尾the end of central directory
			serializeEnd(stream, offset, stream.length - offset, zip.numFiles);
			return stream;
		}
		
		/**
		 * 序列化zip文件头和中央目录
		 * @param   stream 指定写入的ByteArray对象
		 * @param	file 指定串行化文件
		 * @param	local 指定是zip文件头还是中央目录
		 * @param	offset 指定文件位置偏移量
		 */
		private function serializeFile(stream:ByteArray, file:ZipFile, local:Boolean = true, offset:uint = 0):void 
		{
			if (local) 
			{
				stream.writeUnsignedInt(ZipConstants.LOCSIG);
			}else 
			{
				stream.writeUnsignedInt(ZipConstants.CENSIG);
				stream.writeShort(file._version);
			}
			
			stream.writeShort(file._version);
			stream.writeShort(file._flag);
			stream.writeShort(file._compressionMethod);
			stream.writeUnsignedInt(file._dostime);
			stream.writeUnsignedInt(file._crc32);
			stream.writeUnsignedInt(file._compressedSize);
			stream.writeUnsignedInt(file._size);
			
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(file._name, file._encoding);			
			stream.writeShort(ba.position);
			stream.writeShort(file.hasExtra() ? file._extra.length : 0);
			if (!local) 
			{
				stream.writeShort(file._comment ? file._comment.length : 0);
				stream.writeShort(0);
				stream.writeShort(0);
				stream.writeUnsignedInt(0);
				stream.writeUnsignedInt(offset);
			}
			stream.writeBytes(ba);
			if (file.hasExtra()) stream.writeBytes(file._extra);
			if (!local && file._comment) stream.writeUTFBytes(file._comment);
		}
		
		/**
		 * 根据压缩方式序列化文件数据
		 * @param	file 指定序列化文件
		 * @param   compressionMethod 指定压缩方法，一般为DEFLATE和STORE两种方式
		 */
		private function serializeContent(file:ZipFile, compressionMethod:uint = 8):ByteArray 
		{
			file._compressionMethod = compressionMethod;
			file._flag = 0;
			var data:ByteArray = new ByteArray();
			data.writeBytes(file.data);
			
			if (compressionMethod == ZipConstants.DEFLATED) 
			{
				try {
					data.compress();
				}catch (e:Error) { }				
				var tmpdata:ByteArray = new ByteArray();
				if (data.length - 6 > 0)
				{
					file._compressedSize = data.length - 6;
					tmpdata.writeBytes(data, 2, data.length - 6);
				}				
				return tmpdata;
			}else if (compressionMethod == ZipConstants.STORED) 
			{
				file._compressedSize = data.length;
			}
			return data;
		}
		
		/**
		 * 序列化zip文件尾
		 */
		private function serializeEnd(stream:ByteArray, offset:uint, length:uint, filenum:uint):void 
		{
			//写入主要文件尾
			stream.writeUnsignedInt(ZipConstants.ENDSIG);
			stream.writeShort(0);
			stream.writeShort(0);
			//写入当前磁盘文件总数
			stream.writeShort(filenum);
			//写入文件总数
			stream.writeShort(filenum);
			//写入文件总长度
			stream.writeUnsignedInt(length);
			stream.writeUnsignedInt(offset);
			//写入注释长度，总为0
			stream.writeShort(0);
		}
	}
}
