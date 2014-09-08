package glitch;

import openfl.Assets;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.geom.Matrix;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.utils.ByteArray;
import openfl.Vector;

import flixel.FlxG;
import flixel.FlxGame;

class RenderLayer
{
	/**
	 * Whether or not to even bother processing the render.
	 */
	public static var active:Bool = false;
	/**
	 * Whether or not to apply a JPG compression glitch effect to the output BitmapData.
	 */
	public static var jpegGlitch:Bool = false;
	/**
	 * How many JPG compression errors to insert.
	 */
	public static var jpegErrors:Int = 1;
	/**
	 * The quality of the JPEG compression.
	 */
	public static var jpegQuality:Float = 1;
	/**
	 * How likely it is that the JPEG glitch effect will be applied. 10% by default.
	 */
	public static var jpegGlitchChance:Float = 10;
	/**
	 * The minimum position, as a percentage, of JPEG glitch positions. 50% = middle of the screen.
	 * Low percentages can prevent output entirely, as it will mess with the JPEG header info.
	 */
	public static var jpegGlitchPositionPercent:Float = 50;
	/**
	 * The width of the flixel game.
	 */
	public static var gameWidth:Int = 0;
	/**
	 * The height of the flixel game.
	 */
	public static var gameHeight:Int = 0;
	/**
	 * The width of the game screen.
	 */
	public static var screenWidth:Int = 0;
	/**
	 * The height of the game screen.
	 */
	public static var screenHeight:Int = 0;
	/**
	 * Set to true after init() is called.
	 */
	public static var initialized(default, null):Bool = false;
	/**
	 * Stores the flixel camera data every frame.
	 */
	private static var cameraData:BitmapData;
	/**
	 * The visible on-screen Bitmap to which all data is rendered.
	 */
	private static var displayMap:Bitmap;
	
	public static function init():Void
	{
		if (!initialized)
		{
			gameWidth = FlxG.width;
			gameHeight = FlxG.height;
			
			screenWidth = Lib.current.stage.stageWidth;
			screenHeight = Lib.current.stage.stageHeight;
			
			cameraData = gameData();
			
			// This will actually render our game to the screen.
			
			displayMap = new Bitmap(screenData());
			displayMap.smoothing = false;
			displayMap.scaleX = displayMap.scaleY = FlxG.camera.zoom;
			
			// Add the displayMap to the stage
			
			Lib.current.stage.addChild(displayMap);
			
			// Then call our update() function once per frame
			
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
			
			initialized = true;
		}
		else
		{
			clearFX();
		}
	}
	
	public static function update(?e:Event):Void
	{
		// Grab the on-screen data from flixel
		
		#if flash
		cameraData = FlxG.camera.buffer;
		#else
		// This is slow! Try to only call draw() once per frame
		cameraData.draw(FlxG.camera.canvas);
		#end
		
		if (active)
		{
			// JPG glitch render data if needed
			
			if (jpegGlitch && FlxG.random.bool(jpegGlitchChance))
			{
				// there's not a good way to do this in flash! sadly.
				// unless you know of a way... let me know!
				
				#if !flash
				cameraData = Encode.jpegGlitch(cameraData, jpegQuality, jpegErrors, jpegGlitchPositionPercent);
				#end
			}
			else
			{
				cameraData = Encode.jpegRender(cameraData, jpegQuality);
			}
			
			// This is where you could apply other FX
			
			/*
			if (myGlitchType)
			{
				cameraData = MyGlitchClass.apply(cameraData);
			}
			*/
		}
		
		displayMap.bitmapData = cameraData;
	}
	
	/**
	 * Disable all of the glitch effects at once.
	 */
	public static function clearFX():Void
	{
		active = false;
		jpegGlitch = false;
		jpegErrors = 1;
		jpegQuality = 1;
		jpegGlitchChance = 10;
		jpegGlitchPositionPercent = 50;
		cameraData = gameData();
		displayMap.bitmapData = screenData();
	}
	
	inline private static function screenData():BitmapData
	{
		return new BitmapData(screenWidth, screenHeight, false, 0xff000000);
	}
	
	inline private static function gameData():BitmapData
	{
		return new BitmapData(gameWidth, gameHeight, false, 0xff000000);
	}
}