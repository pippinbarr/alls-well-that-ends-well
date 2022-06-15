package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Fork extends Agent {
		
		[Embed(source="assets/sprites/ForkRight.png")]
		private var ForkRight:Class;
		
		[Embed(source="assets/sprites/ForkLeft.png")]
		private var ForkLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a fork";
		public static const NAME_PLURAL:String = "a fork free-for-all";
		
		
		public function Fork():void {
			
			super();
			
			WIDTH = 120;
			HEIGHT = 28;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = ForkRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = ForkLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(54 / Globals.RATIO, 3 /Globals.RATIO, new b2Vec2(0,0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(12 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(1.5, 0.0), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = ForkLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(54 / Globals.RATIO, 3 /Globals.RATIO, new b2Vec2(0,0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(12 / Globals.RATIO, 12 / Globals.RATIO, new b2Vec2(-1.5, 0.0), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}