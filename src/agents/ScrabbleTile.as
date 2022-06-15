package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class ScrabbleTile extends Agent {
		
		[Embed(source="assets/sprites/ScrabbleTileRight.png")]
		private var ScrabbleTileRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a 'Z' scrabble tile worth 10 points";
		public static const NAME_PLURAL:String = "a scrabble tile stampede";
		
		
		public function ScrabbleTile():void {
			
			super();
			
			WIDTH = 60;
			HEIGHT = 64;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = ScrabbleTileRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = ScrabbleTileRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(25 / Globals.RATIO, 25 /Globals.RATIO);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}