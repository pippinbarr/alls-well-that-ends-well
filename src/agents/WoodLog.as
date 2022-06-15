package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class WoodLog extends Agent {
		
		[Embed(source="assets/sprites/LogRight.png")]
		private var LogRight:Class;
		
		[Embed(source="assets/sprites/LogLeft.png")]
		private var LogLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a log";
		public static const NAME_PLURAL:String = "a logjam";
		
		
		public function WoodLog():void {
			
			super();
			
			WIDTH = 70;
			HEIGHT = 35;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = LogRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
			
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = LogLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			shape.SetAsOrientedBox(32 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(0,0.1));
			super.addFixture(shape);
			
			shape.SetAsOrientedBox(3 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(-0.04,-0.4));
			super.addFixture(shape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = LogLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			shape.SetAsOrientedBox(32 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(0,0.1));
			super.addFixture(shape);
			
			shape.SetAsOrientedBox(3 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(0.04,-0.4));
			super.addFixture(shape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}