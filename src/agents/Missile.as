package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Missile extends Agent {
		
		[Embed(source="assets/sprites/MissileRight.png")]
		private var MissileRight:Class;
		
		[Embed(source="assets/sprites/MissileLeft.png")]
		private var MissileLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a air-to-air missile";
		public static const NAME_PLURAL:String = "a salvo of missiles";
		
		
		public function Missile():void {
			
			super();
			
			WIDTH = 70;
			HEIGHT = 16;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = MissileRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = MissileLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(30 / Globals.RATIO, 4 /Globals.RATIO, new b2Vec2(-0.1,-0.05), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = MissileLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(30 / Globals.RATIO, 4 /Globals.RATIO, new b2Vec2(0.1,-0.05), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}