/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip 
{
	
	/**
	 * @private
	 */
	public class ZipConstants 
	{
		
		/*
		 * Header signatures
		 */
		internal static const LOCSIG:uint = 0x04034b50;	// "PK\003\004"
		internal static const EXTSIG:uint = 0x08074b50;	// "PK\007\008"
		internal static const CENSIG:uint = 0x02014b50;	// "PK\001\002"
		internal static const ENDSIG:uint = 0x06054b50;	// "PK\005\006"

		/*
		 * Header sizes in bytes (including signatures)
		 */
		internal static const LOCHDR:int = 30;	// LOC header size
		internal static const EXTHDR:int = 16;	// EXT header size
		internal static const CENHDR:int = 46;	// CEN header size
		internal static const ENDHDR:int = 22;	// END header size

		/*
		 * Local file (LOC) header field offsets
		 */
		internal static const LOCVER:int = 4;	// version needed to extract
		internal static const LOCFLG:int = 6;	// general purpose bit flag
		internal static const LOCHOW:int = 8;	// compression method
		internal static const LOCTIM:int = 10;	// modification time
		internal static const LOCCRC:int = 14;	// uncompressed file crc-32 value
		internal static const LOCSIZ:int = 18;	// compressed size
		internal static const LOCLEN:int = 22;	// uncompressed size
		internal static const LOCNAM:int = 26;	// filename length
		internal static const LOCEXT:int = 28;	// extra field length

		/*
		 * Extra local (EXT) header field offsets
		 */
		internal static const EXTCRC:int = 4;	// uncompressed file crc-32 value
		internal static const EXTSIZ:int = 8;	// compressed size
		internal static const EXTLEN:int = 12;	// uncompressed size

		/*
		 * Central directory (CEN) header field offsets
		 */
		internal static const CENVEM:int = 4;	// version made by
		internal static const CENVER:int = 6;	// version needed to extract
		internal static const CENFLG:int = 8;	// encrypt, decrypt flags
		internal static const CENHOW:int = 10;	// compression method
		internal static const CENTIM:int = 12;	// modification time
		internal static const CENCRC:int = 16;	// uncompressed file crc-32 value
		internal static const CENSIZ:int = 20;	// compressed size
		internal static const CENLEN:int = 24;	// uncompressed size
		internal static const CENNAM:int = 28;	// filename length
		internal static const CENEXT:int = 30;	// extra field length
		internal static const CENCOM:int = 32;	// comment length
		internal static const CENDSK:int = 34;	// disk number start
		internal static const CENATT:int = 36;	// internal file attributes
		internal static const CENATX:int = 38;	// external file attributes
		internal static const CENOFF:int = 42;	// LOC header offset

		/*
		 * End of central directory (END) header field offsets
		 */
		internal static const ENDSUB:int = 8;	// number of entries on this disk
		internal static const ENDTOT:int = 10;	// total number of entries
		internal static const ENDSIZ:int = 12;	// central directory size in bytes
		internal static const ENDOFF:int = 16;	// offset of first CEN header
		internal static const ENDCOM:int = 20;	// zip file comment length
		
		/* 
		 * Compression methods
		 */
		public static const STORED:int = 0;
		public static const DEFLATED:int = 8;
	}
}
