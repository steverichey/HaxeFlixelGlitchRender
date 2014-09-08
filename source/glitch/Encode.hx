package glitch;

import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import flixel.FlxG;

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
	 * Converts a BitmapData object to a JPEG-encoded ByteArray.
	 */
	inline static public function jpeg(Data:BitmapData, Quality:Float = 0.9):ByteArray
	{
		#if flash
		return Data.encode(Data.rect, jpegEncode);
		#else
		return Data.encode("jpg", Quality);
		#end
	}
	
	/**
	 * Encodes a BitmapData object to JPEG, inserts errors in the encoded data, and returns the damaged data as a BitmapData object.
	 */
	inline static public function jpegGlitch(Data:BitmapData, Quality:Float = 0.9, Errors:Int = 1, MinPercent:Float = 50):BitmapData
	{
		bytes = Encode.jpeg(Data, Quality);
		
		for (i in 0...Errors)
		{
			bytes.position = FlxG.random.int(Std.int(bytes.length * MinPercent / 100), bytes.length);
			bytes.writeByte(0);
		}
		
		bytes.position = 0;
		
		return byteArrayToBitmapData(bytes, Data.width, Data.height);
	}
	
	/**
	 * Encodes a BitmapData object to JPEG, then converts that back to BitmapData and returns it.
	 */
	inline static public function jpegRender(Data:BitmapData, Quality:Float = 0.9):BitmapData
	{
		return byteArrayToBitmapData(jpeg(Data, Quality), Data.width, Data.height);
	}
	
	/**
	 * Converts a ByteArray to a new BitmapData object.
	 */
	inline static public function byteArrayToBitmapData(Bytes:ByteArray, Width:Int, Height:Int):BitmapData
	{
		#if flash
		result = new BitmapData(Width, Height);
		
		Bytes.position = 0;
		result.setPixels(result.rect, Bytes);
		
		return result;
		#else
		return BitmapData.loadFromBytes(Bytes);
		#end
	}
	
	/**
	 * Converts a BitmapData object to a new ByteArray object.
	 */
	inline static public function bitmapDataToByteArray(Data:BitmapData):ByteArray
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