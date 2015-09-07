/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 *
 * ZipArchive是一个Zip档案处理类，可读写各种zip格式文件。
 * 功能：1)轻松创建或加载一个zip档案；2)多种方式读取和删除zip档案中的文件；3)支持中文文件名；
 * 4)非常容易序列化一个zip档案，如有AIR、PHP等的支持下就可以把生成的zip档案保存在本地或服务器上。
 *
 * 如有任何意见或建议，可联系我：MSN:flashlizi@hotmail.com
 *
 * @version 0.1
 */

package riaidea.utils.zip {
	
	/**
	 * Zip文件标记
	 * @private
	 */
	internal class ZipTag {
		
		/* The local file header */
		internal static const LOCSIG:uint = 0x04034b50;	// "PK\003\004"
		internal static const LOCHDR:uint = 30;	// LOC header size
		internal static const LOCVER:uint = 4;	// version needed to extract
		internal static const LOCNAM:uint = 26; // filename length
		
		/* The Data descriptor */
		internal static const EXTSIG:uint = 0x08074b50;	// "PK\007\008"
		internal static const EXTHDR:uint = 16;	// EXT header size
		
		/* The central directory file header */
		internal static const CENSIG:uint = 0x02014b50;	// "PK\001\002"
		internal static const CENHDR:uint = 46;	// CEN header size
		internal static const CENVER:uint = 6; // version needed to extract
		internal static const CENNAM:uint = 28; // filename length
		internal static const CENOFF:uint = 42; // LOC header offset
		
		/* The entries in the end of central directory */
		internal static const ENDSIG:uint = 0x06054b50;	// "PK\005\006"
		internal static const ENDHDR:uint = 22; // END header size
		internal static const ENDTOT:uint = 10;	// total number of entries
		internal static const ENDOFF:uint = 16; // offset of first CEN header
		
		/* Compression methods */
		internal static const STORED:uint = 0;
		internal static const DEFLATED:uint = 8;
	}
}
