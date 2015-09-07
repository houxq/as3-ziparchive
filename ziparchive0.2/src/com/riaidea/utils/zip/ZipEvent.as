/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 * @version 0.2
 */

package com.riaidea.utils.zip
{
	import flash.events.Event;
	
	/**
	 * ZipEvent类定义与ZipArchive类相关的事件。
	 */
	public class ZipEvent extends Event 
	{
		public static const PROGRESS:String = "progress";
		public static const LOADED:String = "loaded";		
		public static const INIT:String = "init";
		public static const ERROR:String = "error";	
		
		
		/**
		 * 构造函数，使用指定的参数创建新的ZipEvent对象。
		 * @param	type 事件类型
		 * @param	message 事件相关内容
		 * @param	bubbles 确定ZipEvent对象是否参与事件流的冒泡阶段。 默认值为false。
		 * @param	cancelable 确定是否可以取消ZipEvent对象。 默认值为false。
		 */
		public function ZipEvent(type:String, message:*= null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			_message = message;
		}
		
		/**
		 * ZipEvent对象的相关信息。
		 */
		public function get message():* 
		{
			return _message;
		}
		
		override public function toString():String
		{
			return formatToString("ZipEvent", "type", "message");
		}
		
		private var _message:*;
	}
}
