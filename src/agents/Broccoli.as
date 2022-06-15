package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Broccoli extends Agent {
		
		[Embed(source="assets/sprites/BroccoliRight.png")]
		private var BroccoliRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a floret of broccoli";
		public static const NAME_PLURAL:String = "the flying forest of brocolli";
		
		
		public function Broccoli():void {
			
			super();
			
			WIDTH = 60;
			HEIGHT = 66;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = BroccoliRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = BroccoliRight;
			super.setupAsMissile(X,Y);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			setupAsAvatar(X,Y,world);
		}
		
		private function setupFixtures():void {
			
			var circleShape:b2CircleShape = new b2CircleShape();
			var boxShape:b2PolygonShape = new b2PolygonShape();
			

			circleShape.SetRadius(26 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(0,-0.2));
			super.addFixture(circleShape);
			
			boxShape.SetAsOrientedBox(6 / Globals.RATIO, 20 / Globals.RATIO, new b2Vec2(0, 0.4), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}