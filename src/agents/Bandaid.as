package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Bandaid extends Agent {
		
		[Embed(source="assets/sprites/BandaidRight.png")]
		private var BandaidRight:Class;
				
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "the USS Bandaid";
		public static const NAME_PLURAL:String = "a bandaid barrage";
		
		
		public function Bandaid():void {
			
			super();
			
			WIDTH = 100;
			HEIGHT = 27;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = BandaidRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = BandaidRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(45 / Globals.RATIO, 9 /Globals.RATIO);
			super.addFixture(boxShape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			_sprite = BandaidRight;
			
			super.setupAsDeadMissile(X,Y,world);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}