package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Car extends Agent {
		
		[Embed(source="assets/sprites/CarRight.png")]
		private var CarRight:Class;
		
		[Embed(source="assets/sprites/CarLeft.png")]
		private var CarLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a 1982 Ford Fairlane";
		public static const NAME_PLURAL:String = "a Ford Fairlane fusilade";
		
		
		public function Car():void {
			
			super();
			
			WIDTH = 120;
			HEIGHT = 37;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = CarRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = CarLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(56 / Globals.RATIO, 6 /Globals.RATIO, new b2Vec2(0,0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(18 / Globals.RATIO, 7 / Globals.RATIO, new b2Vec2(-0.3, -0.3), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(5 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(-1.1, 0.3), 0);
			super.addFixture(boxShape);

			boxShape.SetAsOrientedBox(5 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(1.2, 0.4), 0);
			super.addFixture(boxShape);

		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = CarLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(56 / Globals.RATIO, 6 /Globals.RATIO, new b2Vec2(0,0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(18 / Globals.RATIO, 7 / Globals.RATIO, new b2Vec2(0.3, -0.3), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(5 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(1.1, 0.3), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(5 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(-1.2, 0.4), 0);
			super.addFixture(boxShape);
		}
		
		
		
		override public function update():void {
			super.update();
		}
		
	}
}