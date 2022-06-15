package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Gulag extends Agent {
		
		[Embed(source="assets/sprites/GulagRight.png")]
		private var GulagRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a very serious book";
		public static const NAME_PLURAL:String = "an angry book club's hurled tomes";
		
		
		public function Gulag():void {
			
			super();
						
			WIDTH = 59;
			HEIGHT = 80;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = GulagRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = GulagRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(24 / Globals.RATIO, 36 /Globals.RATIO);
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