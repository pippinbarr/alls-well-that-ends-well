package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class MobyDick extends Agent {
		
		[Embed(source="assets/sprites/MobyDickRight.png")]
		private var MobyDickRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a copy of Herman Melville's Moby Dick";
		public static const NAME_PLURAL:String = "a fleet of Mobys Dick";
		
		
		public function MobyDick():void {
			
			super();
			
			WIDTH = 49;
			HEIGHT = 70;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = MobyDickRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
			
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = MobyDickRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			shape.SetAsBox(22 / Globals.RATIO, 30 / Globals.RATIO);
			super.addFixture(shape);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}