package agents
{
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Briefcase extends Agent {
		
		[Embed(source="assets/sprites/BriefcaseRight.png")]
		private var BriefcaseRight:Class;
				
		// NAMING VARIABLES
		public static const NAME_SINGULAR:String = "a briefcase full of top-secret documents";
		public static const NAME_PLURAL:String = "a briefcase blitz";
		
		
		public function Briefcase():void {
			
			super();
			
			WIDTH = 70;
			HEIGHT = 56;
			
		}
		
		public override function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			_sprite = BriefcaseRight;
			super.setupAsAvatar(X,Y,world,dead);
			
			setupFixtures();
			
			super.setMass();
			
		}
		
		public override function setupAsMissile(X:Number, Y:Number):void {
			
			_sprite = BriefcaseRight;
			super.setupAsMissile(X,Y);
			
		}
		
		public override function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			
			setupAsAvatar(X,Y,world);
			
		}
		
		private function setupFixtures():void {
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			
			boxShape.SetAsOrientedBox(33 / Globals.RATIO, 20 /Globals.RATIO, new b2Vec2(0,0.1),0);
			super.addFixture(boxShape);
			
			boxShape.SetAsOrientedBox(8 / Globals.RATIO, 5 / Globals.RATIO, new b2Vec2(-0.1, -0.7), 0);
			super.addFixture(boxShape);
			
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}
}