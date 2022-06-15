package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Chair extends Agent {
		
		[Embed(source="assets/sprites/ChairRight.png")]
		private var ChairRight:Class;
		
		[Embed(source="assets/sprites/ChairLeft.png")]
		private var ChairLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a sophisticated dining chair";
		public static const NAME_PLURAL:String = "a dining chair deluge";
		
		
		public function Chair():void {
			
			super();
			
			WIDTH = 60;
			HEIGHT = 106;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = ChairRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = ChairLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(6 / Globals.RATIO, 47 /Globals.RATIO, new b2Vec2(-0.7,-0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 4 / Globals.RATIO, new b2Vec2(0, 0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(6 / Globals.RATIO, 22 /Globals.RATIO, new b2Vec2(0.7,0.7), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = ChairLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(6 / Globals.RATIO, 47 /Globals.RATIO, new b2Vec2(0.7,-0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(20 / Globals.RATIO, 4 / Globals.RATIO, new b2Vec2(0, 0.1), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(6 / Globals.RATIO, 22 /Globals.RATIO, new b2Vec2(-0.7,0.7), 0);
			super.addFixture(boxShape);
		}
		
		override public function update():void {
			super.update();
		}
		
	}
}