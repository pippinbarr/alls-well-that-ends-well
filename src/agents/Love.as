package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Love extends Agent {
		
		[Embed(source="assets/sprites/LoveRight.png")]
		private var LoveRight:Class;
		
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "the word 'love'";
		public static const NAME_PLURAL:String = "a surge of love";
		
		
		public function Love():void {
			
			super();
			
			WIDTH = 107;
			HEIGHT = 40;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = LoveRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = LoveRight;
			super.setupAsMissile(X,Y);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsBox(50 / Globals.RATIO, 12 /Globals.RATIO);
			super.addFixture(boxShape);
		
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}