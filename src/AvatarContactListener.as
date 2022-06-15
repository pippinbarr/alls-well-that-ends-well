package
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2Body;
	
	public class AvatarContactListener extends b2ContactListener
	{
		public function AvatarContactListener() {
			
			trace(this+" initalized");
			
		}
		
		override public function BeginContact(contact:b2Contact):void {
			
//			var fix:b2Fixture = contact.GetFixtureA();
//			var body:b2Body = fix.GetBody();

			if (contact.GetFixtureA().GetBody().GetUserData().avatar) {
				contact.GetFixtureA().GetBody().GetUserData().contact = true;
			}
			else {
				contact.GetFixtureB().GetBody().GetUserData().contact = true;
			}
		}
	}
}