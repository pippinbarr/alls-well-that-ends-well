package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Minifig extends Agent {
		
		[Embed(source="assets/sprites/MinifigRight.png")]
		private var MinifigRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a LEGO minifig";
		public static const NAME_PLURAL:String = "a marauding minifig platoon";
		
		
		public function Minifig():void {
			
			super();
			
			WIDTH = 49;
			HEIGHT = 80;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = MinifigRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = MinifigRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(8 / Globals.RATIO, 37 /Globals.RATIO, new b2Vec2(-0.02,0.0), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(13 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(0.0, 0.7), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(22 / Globals.RATIO, 3 / Globals.RATIO, new b2Vec2(0.0, 0.3), 0);
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