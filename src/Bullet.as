package
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	import agents.Agent;
	
	public class Bullet extends Agent
	{
						
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "BULLET";
		public static const NAME_PLURAL:String = "HAIL OF BULLETS";
				
		public function Bullet() {
			super();
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = Assets.BULLET_SPRITE;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {

			WIDTH = 20;
			HEIGHT = 10;

			_sprite = Assets.BULLET_SPRITE;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
						
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(0.1,0.2);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
		public override function destroy():void {		
			super.destroy();
		}
	}
}