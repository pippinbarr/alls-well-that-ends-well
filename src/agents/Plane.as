package agents
{

	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
		
	import org.flixel.*;
	
	public class Plane extends Agent {
		
		[Embed(source="assets/sprites/PlaneRight.png")]
		private var PlaneRight:Class;
		
		[Embed(source="assets/sprites/PlaneLeft.png")]
		private var PlaneLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a high-tech spy plane";
		public static const NAME_PLURAL:String = "a kamikaze cartel";


		public function Plane():void {

			super();
			
			WIDTH = 80;
			HEIGHT = 45;

		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = true):void {
			
			_sprite = PlaneRight;

			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
									
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = PlaneLeft;
			
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(23 / Globals.RATIO, 6 /Globals.RATIO, new b2Vec2(0,-0.05), 0);
			super.addFixture(boxShape);
									
			boxShape.SetAsOrientedBox(0.1, 0.3, new b2Vec2(-0.8, -0.3), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = PlaneLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(23 / Globals.RATIO, 6 /Globals.RATIO, new b2Vec2(0,-0.05), 0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(0.1, 0.3, new b2Vec2(0.8, -0.3), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}