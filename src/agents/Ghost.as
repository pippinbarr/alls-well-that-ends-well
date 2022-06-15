package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Ghost extends Agent {
		
		[Embed(source="assets/sprites/GhostRight.png")]
		private var GhostRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "the ghostship Blinky";
		public static const NAME_PLURAL:String = "a ghastly ghostly army";
		
		
		public function Ghost():void {
			
			super();
			
			WIDTH = 53;
			HEIGHT = 80;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = GhostRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = GhostRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(22 / Globals.RATIO, 27 /Globals.RATIO, new b2Vec2(0, 0.3), 0);
			super.addFixture(boxShape);
			
			var circleShape:b2CircleShape = new b2CircleShape();
			circleShape.SetRadius(20 / Globals.RATIO);
			circleShape.SetLocalPosition(new b2Vec2(0, -0.6));
			super.addFixture(circleShape);
			
//			boxShape.SetAsOrientedBox(30 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(0, 0.3), 0);
//			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}