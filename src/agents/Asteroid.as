package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Asteroid extends Agent {
		
		[Embed(source="assets/sprites/AsteroidRight.png")]
		private var AsteroidRight:Class;
		
		[Embed(source="assets/sprites/AsteroidLeft.png")]
		private var AsteroidLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "the good ship Asteroid";
		public static const NAME_PLURAL:String = "an asteroid field";
		
		
		public function Asteroid():void {
			
			super();
			
			WIDTH = 55;
			HEIGHT = 60;
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = AsteroidLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = AsteroidRight;
			
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		private function setupFixtures():void {
			
			var shape:b2CircleShape = new b2CircleShape();
			
			shape.SetRadius(20/Globals.RATIO);
			
			shape.SetLocalPosition(new b2Vec2(-0.3,-0.3));
			super.addFixture(shape);
			
			shape.SetLocalPosition(new b2Vec2(-0.25,0.2));
			super.addFixture(shape);
			
			shape.SetLocalPosition(new b2Vec2(0.25,-0.25));
			super.addFixture(shape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = AsteroidLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
	
		private function setupMissileFixtures():void {
			
			var shape:b2CircleShape = new b2CircleShape();
			
			shape.SetRadius(20/Globals.RATIO);
			
			shape.SetLocalPosition(new b2Vec2(0.3,-0.3));
			super.addFixture(shape);
			
			shape.SetLocalPosition(new b2Vec2(0.25,0.2));
			super.addFixture(shape);
			
			shape.SetLocalPosition(new b2Vec2(-0.25,-0.25));
			super.addFixture(shape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}