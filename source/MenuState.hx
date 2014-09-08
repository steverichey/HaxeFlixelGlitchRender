package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
	
	override public function create():Void
	{
		super.create();
		
		// All you have to do is create a new RenderLayer!
		
		new RenderLayer();
		
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
		
		add(title);
		add(activeText);
		add(glitch);
		add(errors);
		add(quality);
		add(chance);
		add(percent);
	}
	
	override public function update(_):Void
	{
		activeText.text = "Glitch layer active? " + boolToString(RenderLayer.active);
		glitch.text = "Glitching on? " + boolToString(RenderLayer.jpegGlitch);
		
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
}