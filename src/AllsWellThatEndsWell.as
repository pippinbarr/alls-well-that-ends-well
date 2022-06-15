package
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.system.fscommand;
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	[SWF(width = "800", height = "600", backgroundColor = "#FFFFFF")]
	//[Frame(factoryClass="TrolleyProblemPreloader")]
	
	public class AllsWellThatEndsWell extends FlxGame
	{
		public function AllsWellThatEndsWell() {			
			super(800,600,GameState,Globals.ZOOM);

			this.useSoundHotKeys = false;
			FlxG.volume = 1.0;
			FlxG.debug = false; //Globals.DEBUG_MODE;
			FlxG.visualDebug = false; //Globals.DEBUG_HITBOXES;
			FlxG.mouse.hide();
			flash.ui.Mouse.hide();
			
			/////////////////////////////////
			
			
			FlxG.stage.showDefaultContextMenu = false;
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL;
			FlxG.stage.fullScreenSourceRect = new Rectangle(0,0,800,600);
			
			FlxG.stage.align = StageAlign.TOP;
			
			fscommand("trapallkeys","true");
		}		
	}
}