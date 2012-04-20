
#import "GameContactListener.h"

GameContactListener::GameContactListener() : _contacts()
{
}

GameContactListener::~GameContactListener()
{
}

void GameContactListener::BeginContact(b2Contact* contact)
{
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    GameContact myContact = {
        contact->GetFixtureA()->GetBody(),
        contact->GetFixtureB()->GetBody(),
        contact->GetFixtureA(),
        contact->GetFixtureB(),
        YES
    };
    _contacts.push_back(myContact);
}

void GameContactListener::EndContact(b2Contact* contact)
{
    GameContact myContact = {
        contact->GetFixtureA()->GetBody(),
        contact->GetFixtureB()->GetBody(),
        contact->GetFixtureA(),
        contact->GetFixtureB(),
        NO
    };
    _contacts.push_back(myContact);
}

//
//void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
//{
//}
//
//void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
//{
//}
