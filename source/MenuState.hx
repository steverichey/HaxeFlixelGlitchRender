package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

import glitch.RenderLayer;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var activeText:FlxText;
	private var glitch:FlxText;
	private var errors:FlxText;
	private var quality:FlxText;
	private var chance:FlxText;
	private var percent:FlxText;
	private var instructions:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		// All you have to do is initiate the RenderLayer!
		
		RenderLayer.init();
		
		// Then you can enable and configure the glitch FX.
		
		RenderLayer.active = true;
		RenderLayer.jpegGlitch = true;
		
		var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLUE, FlxColor.CYAN]);
		
		title = new FlxText(0, 4, FlxG.width, "This is an example of applying glitch FX to HaxeFlixel games.");
		title.alignment = "center";
		
		activeText = new FlxText(0, 20, FlxG.width);
		glitch = new FlxText(0, 30, FlxG.width);
		errors = new FlxText(0, 40, FlxG.width);
		quality = new FlxText(0, 50, FlxG.width);
		chance = new FlxText(0, 60, FlxG.width);
		percent = new FlxText(0, 70, FlxG.width);
		
		instructions = new FlxText(0, 90, FlxG.width);
		instructions.text = "Press J to toggle JPEG compression.\nPress G to toggle JPEG glitching.\nPress up and down to change number of errors.\nPress left and right to change compression quality.\nPress W and S to change glitch chance.\nPress A and D to change glitch position percentage.\nPress R to reset.";
		instructions.alpha = 0.9;
		
		add(gradient);
		add(title);
		add(activeText);
		add(glitch);
		add(errors);
		add(quality);
		add(chance);
		add(percent);
		add(instructions);
	}
	
	override public function update(_):Void
	{
		activeText.text = "JPEG layer active? " + boolToString(RenderLayer.active);
		glitch.text = "Glitching on? " + boolToString(RenderLayer.jpegGlitch);
		errors.text = "Number of glitch errors: " + RenderLayer.jpegErrors;
		quality.text = "JPEG Compression Quality: " + round(RenderLayer.jpegQuality);
		chance.text = "JPEG Glitch Chance: " + round(RenderLayer.jpegGlitchChance) + "%";
		percent.text = "JPEG Glitch Minimum Position: " + round(RenderLayer.jpegGlitchPositionPercent) + "% of screen";
		
		if (FlxG.keys.justPressed.J)
		{
			RenderLayer.active = !RenderLayer.active;
		}
		
		if (FlxG.keys.justPressed.G)
		{
			RenderLayer.jpegGlitch = !RenderLayer.jpegGlitch;
		}
		
		if (FlxG.keys.justPressed.UP)
		{
			RenderLayer.jpegErrors++;
		}
		
		if (FlxG.keys.justPressed.DOWN)
		{
			RenderLayer.jpegErrors--;
		}
		
		if (FlxG.keys.justPressed.LEFT)
		{
			RenderLayer.jpegQuality -= 0.1;
		}
		
		if (FlxG.keys.justPressed.RIGHT)
		{
			RenderLayer.jpegQuality += 0.1;
		}
		
		if (FlxG.keys.justPressed.W)
		{
			RenderLayer.jpegGlitchChance += 10;
		}
		
		if (FlxG.keys.justPressed.S)
		{
			RenderLayer.jpegGlitchChance -= 10;
		}
		
		if (FlxG.keys.justPressed.A)
		{
			RenderLayer.jpegGlitchPositionPercent -= 10;
		}
		
		if (FlxG.keys.justPressed.D)
		{
			RenderLayer.jpegGlitchPositionPercent += 10;
		}
		
		RenderLayer.jpegErrors = intBound(RenderLayer.jpegErrors, 0);
		RenderLayer.jpegQuality = FlxMath.bound(RenderLayer.jpegQuality, 0, 1);
		RenderLayer.jpegGlitchChance = FlxMath.bound(RenderLayer.jpegGlitchChance, 0, 100);
		RenderLayer.jpegGlitchPositionPercent = FlxMath.bound(RenderLayer.jpegGlitchPositionPercent, 0, 100);
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetGame();
		}
		
		super.update(_);
	}
	
	private function boolToString(Value:Bool):String
	{
		return Value ? "Yes" : "No";
	}
	
	private function round(Value:Float):Float
	{
		return FlxMath.roundDecimal(Value, 2);
	}
	
	private function intBound(Value:Int, ?Min:Int, ?Max:Int):Int
	{
		return Std.int(FlxMath.bound(Value, Min, Max));
	}
}