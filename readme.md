# [HaxeFlixel Glitch Render Example](https://github.com/steverichey/HaxeFlixelGlitchRender)

![](https://raw.github.com/steverichey/HaxeFlixelGlitchRender/master/src/screen.png")

Just an example of using JPEG compression glitching to mess with a [HaxeFlixel](http://www.haxeflixel.com) game.

The `RenderLayer` class handles all of the logic. The `Encode` class is mostly just a wrapper for various ways of handling `BitmapData` and `ByteArray` objects.

None of this is supported in Flash, largely because the `BitmapData.loadFromBytes()` function is not available there.

# License

Shared under an MIT license. See [license.md](https://github.com/steverichey/HaxeFlixelGlitchRender/blob/master/license.md) for details.