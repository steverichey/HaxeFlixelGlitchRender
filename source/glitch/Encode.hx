package glitch;

import flixel.FlxG;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;

import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;

#if flash
import flash.display.JPEGEncoderOptions;
#end

/**
 * A class of handy functions for encoding and working with BitmapData. Cross-platform.
 * 
 * @author Steve Richey
 */
class Encode
{
	/**
	 * We don't want to mess with the JPEG header.
	 * 
	 * @see http://en.wikipedia.org/wiki/JPEG_File_Interchange_Format#File_format_structure
	 */
	inline static public var JPEG_HEADER_LENGTH:Int = 18;
	/**
	 * Writing anywhere near the header causes some issues, so we add a safety margin.
	 * Basically, byteArrayToBitmapData returns null if the first 700 or so bytes are glitched.
	 */
	inline static public var SAFETY_MARGIN:Int = 650;
	
	/**
	 * Converts a BitmapData object to a JPEG-encoded ByteArray.
	 */
	static public function jpeg(Data:BitmapData, Quality:Float = 0.9):ByteArray
	{
		#if flash
		jpegEncode.quality = Std.int(Quality * 10);
		var encoded:ByteArray = new ByteArray();
		encoded = Data.encode(Data.rect, jpegEncode, encoded);
		return encoded;
		#else
		return Data.encode("jpg", Quality);
		#end
	}
	
	/**
	 * Encodes a BitmapData object to JPEG, inserts errors in the encoded data, and returns the damaged data as a BitmapData object.
	 */
	static public function jpegGlitch(Data:BitmapData, Quality:Float = 0.9, Errors:Int = 1, MinPercent:Float = 50):BitmapData
	{
		bytes = Encode.jpeg(Data, Quality);
		
		// we don't want to mess with the header!
		
		var len:Int = bytes.length;
		
		var minposition:Int = Std.int((len - (JPEG_HEADER_LENGTH + SAFETY_MARGIN)) * MinPercent / 100);
		var adjustedposition:Int = minposition + JPEG_HEADER_LENGTH + SAFETY_MARGIN;
		
		// insert errors
		
		for (i in 0...Errors)
		{
			bytes.position = FlxG.random.int(adjustedposition, len);
			bytes.writeByte(0);
		}
		
		bytes.position = 0;
		
		return byteArrayToBitmapData(bytes, Data.width, Data.height);
	}
	
	/**
	 * Encodes a BitmapData object to JPEG, then converts that back to BitmapData and returns it.
	 */
	static public function jpegRender(Data:BitmapData, Quality:Float = 0.9):BitmapData
	{
		return byteArrayToBitmapData(jpeg(Data, Quality), Data.width, Data.height);
	}
	
	/**
	 * Converts a ByteArray to a new BitmapData object.
	 */
	static public function byteArrayToBitmapData(Bytes:ByteArray, Width:Int, Height:Int):BitmapData
	{
		#if flash
		var result:BitmapData = new BitmapData(Width, Height);
		
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
			function(e:Event) { 
				result = e.target.content;
			});
		loader.loadBytes(Bytes);
		
		return result;
		#else
		return BitmapData.loadFromBytes(Bytes);
		#end
	}
	
	/**
	 * Converts a BitmapData object to a new ByteArray object.
	 */
	static public function bitmapDataToByteArray(Data:BitmapData):ByteArray
	{
		bytes = new ByteArray();
		
		#if (flash || neko || cpp)
		bytes.readBytes(cast Data, 0, Data.width * Data.height);
		#else
		Data.copyPixelsToByteArray(Data.rect, bytes);
		#end
		
		bytes.position = 0;
		
		return bytes;
	}
	
	#if flash
	static private var jpegEncode:JPEGEncoderOptions = new JPEGEncoderOptions();
	#end
	
	static private var result:BitmapData;
	static private var bytes:ByteArray;
}