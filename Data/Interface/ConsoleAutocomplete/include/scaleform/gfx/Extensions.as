package scaleform.gfx
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;

	public final class Extensions
	{
		public static const EDGEAA_INHERIT:uint = 0;
		public static const EDGEAA_ON:uint = 1;
		public static const EDGEAA_OFF:uint = 2;
		public static const EDGEAA_DISABLE:uint = 3;

		public static var isGFxPlayer:Boolean;

		public static var CLIK_addedToStageCallback:Function;
		public static var gfxProcessSound:Function;

		public native function Extensions();

		public native static function set enabled(value:Boolean):void;

		public native static function get enabled():Boolean;

		public native static function set noInvisibleAdvance(value:Boolean):void;

		public native static function get noInvisibleAdvance():Boolean;

		public native static function getTopMostEntity(x:Number, y:Number, testAll:Boolean = true):DisplayObject;

		public native static function getMouseTopMostEntity(testAll:Boolean = true, mouseIndex:uint = 0):DisplayObject;

		public native static function setMouseCursorType(cursor:String, mouseIndex:uint = 0):void;

		public native static function getMouseCursorType(mouseIndex:uint = 0):String;

		public native static function get numControllers():uint;

		public native static function get visibleRect():Rectangle;

		public native static function getEdgeAAMode(dispObj:DisplayObject):uint;

		public native static function setEdgeAAMode(dispObj:DisplayObject, mode:uint):void;

		public native static function setIMEEnabled(textField:TextField, isEnabled:Boolean):void;

		public native static function get isScaleform():Boolean;
	}
}
