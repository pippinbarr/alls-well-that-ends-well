package {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;
	
	public class Text
	{
		[Embed(source="assets/fonts/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		public static const COMMODORE_FONT:Class;

		[Embed(systemFont='Helvetica', fontName='Helvetica', mimeType='application/x-font', embedAsCFF="false")]
		public static var Impact:Class;
		
		private const DIRECTIONS:Array = new Array(
			", but your mission has been compromised. You must make it across the mountains",
			", but the enemy has spotted you. You must use your extreme reflexes to cross the mountains",
			", but you have been identified by enemy forces and now must make it home"
		);
		
		private const MISSILE_INTROS:Array = new Array(
			" while avoiding ",
			" while navigating through ",
			" by dodging through "
		);
		
		private const ENCOURAGEMENTS:Array = new Array(
			"Good luck.",
			"May God protect you.",
			"Over and out."
		);
		
		private const RESULTS:Array = new Array(
			"ALL'S WELL\nTHAT\nENDS WELL"
		);
		
		private var _text:TextField;
		private var _format:TextFormat = new TextFormat("Helvetica",24,0xFFFFFF,null,null,null,null,null,"center",null,null);
		private var _title:TextField;
		private var _titleFormat:TextFormat = new TextFormat("Helvetica",100,0x000000,true,null,null,null,null,"center",null,null);
		private var _pressSpace:TextField;
		private var _getFocus:TextField;
		
		private var _avatarName:String;
		private var _missileName:String;
		
		private var _bg:Sprite;
		
		private var _timer:FlxTimer;
		
		public function Text(avatarName:String,missileName:String) {
			_avatarName = avatarName;
			_missileName = missileName;
			_bg = new Sprite();
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(0,0,FlxG.width,FlxG.height);
			_bg.graphics.endFill();	
			_timer = new FlxTimer();
		}
		
		public function showInstructions():void {
			
			FlxG.stage.addChild(_bg);
			
			_text = makeTextField(200,100,FlxG.width - 400,FlxG.height,"",_format);
			
			_text.appendText(
				"ATTENTION: Player\n\n" +
				"You are the brave pilot of " +
				_avatarName +
				randomDirection() +
				randomMissileIntro() +
				_missileName + ".\n\n" +
				randomEncouragement());
			
			FlxG.stage.addChild(_text);
			
		}
		
		public function hideInstructions():void {
			
			FlxG.stage.removeChild(_bg);
			FlxG.stage.removeChild(_text);
			FlxG.stage.focus = null;
			
		}
		
		public function showGetFocus():void {
			FlxG.stage.addChild(_bg);
			_getFocus = makeTextField(200,FlxG.height/2 - 80,FlxG.width - 400,FlxG.height,"WASD OR ARROW KEYS TO MOVE\n\nCLICK TO START",_format);
			FlxG.stage.addChild(_getFocus);
		}
		
		public function hideGetFocus():void {
			FlxG.stage.removeChild(_bg);
			FlxG.stage.removeChild(_getFocus);
	
		}
		
		public function showPressSpace(t:FlxTimer):void {
			if (_pressSpace == null) {
				_pressSpace = makeTextField(0,FlxG.height - 50,FlxG.width,50,"PRESS SPACE TO CONTINUE",_format);
			}
			FlxG.stage.addChild(_pressSpace);
		}
		
		public function hidePressSpace():void {
			FlxG.stage.removeChild(_pressSpace);
		}
		
		public function pressSpaceVisible():Boolean {
			return (_pressSpace != null && FlxG.stage.contains(_pressSpace));
		}
		
		public function showResult(t:FlxTimer):void {
			_text.y = 20;
			_title = makeTextField(0,20,FlxG.width,FlxG.height,"",_titleFormat);
			_title.text = randomResult();
			FlxG.stage.addChild(_title);
			_timer.start(1,1,showPressSpace);
		}
		
		private function randomDirection():String {
			return (DIRECTIONS[Math.floor(Math.random() * DIRECTIONS.length)]);
		}
		
		private function randomMissileIntro():String {
			return (MISSILE_INTROS[Math.floor(Math.random() * MISSILE_INTROS.length)]);
		}
		
		private function randomEncouragement():String {
			return (ENCOURAGEMENTS[Math.floor(Math.random() * ENCOURAGEMENTS.length)]);
		}
		
		private function randomResult():String {
			return (RESULTS[Math.floor(Math.random() * RESULTS.length)]);
		}
		
		public static function makeTextField(x:uint, y:uint, w:uint, h:uint, s:String,tf:TextFormat):TextField {
			
			var textField:TextField = new TextField();
			textField.x = x * Globals.ZOOM;
			textField.y = y * Globals.ZOOM;
			textField.width = w * Globals.ZOOM;
			textField.height = h * Globals.ZOOM;
			textField.defaultTextFormat = tf;
			textField.text = s;
			textField.wordWrap = true;
			textField.selectable = false;
			textField.embedFonts = true;
			
			return textField;
		}
		
		public function destroy():void {
			if (_bg && FlxG.stage.contains(_bg)) FlxG.stage.removeChild(_bg);
			if (_text && FlxG.stage.contains(_text)) FlxG.stage.removeChild(_text);
			if (_title && FlxG.stage.contains(_title)) FlxG.stage.removeChild(_title);
			if (_pressSpace && FlxG.stage.contains(_pressSpace)) FlxG.stage.removeChild(_pressSpace);
		}
		
	}
}