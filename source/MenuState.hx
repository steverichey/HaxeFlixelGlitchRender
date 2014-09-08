package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;

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
		
		title = new FlxText(0, 4, FlxG.width, "This is an example of applying glitch FX to HaxeFlixel games.");
		title.alignment = "center";
		
		activeText = new FlxText(0, 20, FlxG.width);
		glitch = new FlxText(0, 30, FlxG.width);
		errors = new FlxText(0, 40, FlxG.width);
		quality = new FlxText(0, 50, FlxG.width);
		chance = new FlxText(0, 60, FlxG.width);
		percent = new FlxText(0, 70, FlxG.width);
		
		instructions = new FlxText(0, 90, FlxG.width);
		instructions.text = "Press A to toggle JPEG compression.\nPress G to toggle JPEG glitching.\nPress up and down to change number of errors.\nPress left and right to change compression quality.\nPress [ and ] to change glitch chance.\nPress < and > to change glitch position percentage.";
		instructions.alpha = 0.9;
		
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
		activeText.text = "Glitch layer active? " + boolToString(RenderLayer.active);
		glitch.text = "Glitching on? " + boolToString(RenderLayer.jpegGlitch);
		errors.text = "Number of glitch errors: " + RenderLayer.jpegErrors;
		quality.text = "JPEG Compression Quality: " + RenderLayer.jpegQuality;
		chance.text = "JPEG Glitch Chance: " + round(RenderLayer.jpegGlitchChance) + "%";
		percent.text = "JPEG Glitch Minimum Position: " + round(RenderLayer.jpegGlitchPositionPercent) + "% of screen";
		
		if (FlxG.keys.justPressed.A)
		{
			RenderLayer.active = !RenderLayer.active;
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
}