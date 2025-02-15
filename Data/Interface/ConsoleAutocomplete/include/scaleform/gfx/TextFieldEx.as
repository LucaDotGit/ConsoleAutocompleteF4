package scaleform.gfx
{
	import flash.display.*;
	import flash.text.*;

	public final class TextFieldEx
	{
		public static const VALIGN_NONE:String = "none";
		public static const VALIGN_TOP:String = "top";
		public static const VALIGN_CENTER:String = "center";
		public static const VALIGN_BOTTOM:String = "bottom";

		public static const TEXTAUTOSZ_NONE:String = "none";
		public static const TEXTAUTOSZ_SHRINK:String = "shrink";
		public static const TEXTAUTOSZ_FIT:String = "fit";

		public static const VAUTOSIZE_NONE:String = "none";
		public static const VAUTOSIZE_TOP:String = "top";
		public static const VAUTOSIZE_CENTER:String = "center";
		public static const VAUTOSIZE_BOTTOM:String = "bottom";

		public native function TextFieldEx();

		public static native function appendHtml(textField:TextField, newHtml:String):void;

		public static native function setIMEEnabled(textField:TextField, isEnabled:Boolean):void;

		public static native function setVerticalAlign(textField:TextField, valign:String):void;

		public static native function getVerticalAlign(textField:TextField):String;

		public static native function setVerticalAutoSize(textField:TextField, vautoSize:String):void;

		public static native function getVerticalAutoSize(textField:TextField):String;

		public static native function setTextAutoSize(textField:TextField, autoSz:String):void;

		public static native function getTextAutoSize(textField:TextField):String;

		public static native function setImageSubstitutions(textField:TextField, substInfo:Object):void;

		public static native function updateImageSubstitution(textField:TextField, id:String, image:BitmapData):void;

		public static native function setNoTranslate(textField:TextField, noTranslate:Boolean):void;

		public static native function getNoTranslate(textField:TextField):Boolean;

		public static native function setBidirectionalTextEnabled(textField:TextField, en:Boolean):void;

		public static native function getBidirectionalTextEnabled(textField:TextField):Boolean;

		public static native function setSelectionTextColor(textField:TextField, selColor:uint):void;

		public static native function getSelectionTextColor(textField:TextField):uint;

		public static native function setSelectionBkgColor(textField:TextField, selColor:uint):void;

		public static native function getSelectionBkgColor(textField:TextField):uint;

		public static native function setInactiveSelectionTextColor(textField:TextField, selColor:uint):void;

		public static native function getInactiveSelectionTextColor(textField:TextField):uint;

		public static native function setInactiveSelectionBkgColor(textField:TextField, selColor:uint):void;

		public static native function getInactiveSelectionBkgColor(textField:TextField):uint;
	}
}
