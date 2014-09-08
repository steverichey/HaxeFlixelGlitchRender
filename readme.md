# [OpenFL GIF Extension](https://github.com/steverichey/openfl-gif) (WIP)

Make GIFs in any OpenFL project.

## Usage

````
import sys.io.File;
import openfl.display.BitmapData;
import extension.gif.GIFEncoder;

class MyClass
{
	static public function myFunction(FirstFrame:BitmapData, SecondFrame:BitmapData):Void
	{
		var encoder:GIFEncoder = new GIFEncoder();
		encoder.addFrame(FirstFrame);
		encoder.addFrame(SecondFrame);
		encoder.finish();
		
		File.saveBytes("myGif.gif", encoder.output);
	}
}
````

## Credits

Based on [AS3Gif](https://code.google.com/p/as3gif/) by [Thibault Imbert](https://github.com/thibaultimbert), which in turn was based on [AnimatedGifEncoder](http://www.java2s.com/Code/Java/2D-Graphics-GUI/AnimatedGifEncoder.htm) by [Kevin Weiner](http://www.fmsware.com/stuff/gif.html).

* Lempel–Ziv–Welch (LZW) encoding originally by Jef Poskanzer by way of J.M.G. Elliott.
* NeuQuant neural net quantization by Anthony Dekker (see copyright notice in `NeuQuant.hx`).
* Haxe neural net code by [Nickolay Grebenshikov](https://github.com/ngrebenshikov/HaxeNeuQuant).

# License

Shared under an MIT license. See `license.md` for details.