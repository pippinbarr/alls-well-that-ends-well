package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Pear extends Agent {
		
		[Embed(source="assets/sprites/PearRight.png")]
		private var PearRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a delicious pear";
		public static const NAME_PLURAL:String = "a pelting of pears";
		
		
		public function Pear():void {
			
			super();
			
			WIDTH = 48;
			HEIGHT = 80;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = PearRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = PearRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var circleShape:b2CircleShape = new b2CircleShape();
			circleShape.SetRadius(22 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(0,0.5));
			super.addFixture(circleShape);
			
			circleShape.SetRadius(10 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(-0.15,-0.6));
			super.addFixture(circleShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}