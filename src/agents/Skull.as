package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Skull extends Agent {
		
		[Embed(source="assets/sprites/SkullRight.png")]
		private var SkullRight:Class;
		
		[Embed(source="assets/sprites/SkullLeft.png")]
		private var SkullLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "poor Yorrick";
		public static const NAME_PLURAL:String = "a skull storm";
		
		
		public function Skull():void {
			
			super();
			
			WIDTH = 60;
			HEIGHT = 71;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = SkullRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = SkullLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var circleShape:b2CircleShape = new b2CircleShape();
			circleShape.SetRadius(28 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(-0.1,-0.2));
			super.addFixture(circleShape);
						
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsOrientedBox(10 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(0.6, 0.6), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = SkullLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var circleShape:b2CircleShape = new b2CircleShape();
			circleShape.SetRadius(28 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(0.1,-0.2));
			super.addFixture(circleShape);
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsOrientedBox(10 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(-0.6, 0.6), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}