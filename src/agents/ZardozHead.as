package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class ZardozHead extends Agent {
		
		[Embed(source="assets/sprites/ZardozHeadRight.png")]
		private var ZardozHeadRight:Class;
		
		[Embed(source="assets/sprites/ZardozHeadLeft.png")]
		private var ZardozHeadLeft:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "the giant head from the movie Zardoz";
		public static const NAME_PLURAL:String = "an army of giant heads from the movie Zardoz";

		
		public function ZardozHead():void {
			
			super();
			
			WIDTH = 75;
			HEIGHT = 100;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = ZardozHeadRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = ZardozHeadLeft;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(20 / Globals.RATIO, 44 /Globals.RATIO);
			super.addFixture(boxShape);
						
			boxShape.SetAsOrientedBox(30 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(0, 0.3), 0);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			_sprite = ZardozHeadLeft;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupMissileFixtures();
			
			super.setMass();
		}
		
		private function setupMissileFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(20 / Globals.RATIO, 44 /Globals.RATIO);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(30 / Globals.RATIO, 15 / Globals.RATIO, new b2Vec2(0, 0.3), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}