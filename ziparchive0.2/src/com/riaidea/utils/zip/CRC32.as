/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip 
{
	import flash.utils.ByteArray;
	
	/**
	 * @private
	 */
	public class CRC32 
	{
		
		private static var crcTable:Array = makeCrcTable();
		
		public static function getCRC32(data:ByteArray, start:int = 0, len:int = 0):uint 
		{
			if (start >= data.length) start = data.length;
			if (len == 0) len = data.length - start;
			if (len + start > data.length) len = data.length - start;
			
			var c:int = 0xffffffff;
			for (var i:int = start; i < len; i++) 
			c = int(crcTable[(c ^ data[i]) & 0xff]) ^ (c >>> 8);			
			return (c ^ 0xffffffff);
		}		
		
		private static function makeCrcTable():Array 
		{
			var p:int = 0xEDB88320;
			var crcTable:Array = [];

			var i:int = 256;			
			while (i--)
			{				
				var crc:uint = i;
				var j:int = 8;
				while (j--) crc = (crc & 1) ? (crc >>> 1) ^ p : (crc >>> 1);
				crcTable[i] = crc;		
			}
			return crcTable;
		}
	}
}
