package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class XWing extends Agent {
		
		[Embed(source="assets/sprites/XWingRight.png")]
		private var XWingRight:Class;
		
		[Embed(source="assets/sprites/XWingLeft.png")]
		private var XWingLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "an X-wing starfighter";
		public static const NAME_PLURAL:String = "a coordinated X-Wing attack";
		
		
		public function XWing():void {
			
			super();
			
			WIDTH = 120;
			HEIGHT = 45;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = XWingRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = XWingLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(35 / Globals.RATIO, 18 /Globals.RATIO, new b2Vec2(-0.7, 0), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(0.2, -0.06), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 2 / Globals.RATIO, new b2Vec2(1.1, -0.1), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = XWingLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(35 / Globals.RATIO, 18 /Globals.RATIO, new b2Vec2(0.7, 0), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(-0.2, -0.06), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 2 / Globals.RATIO, new b2Vec2(-1.1, -0.1), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}