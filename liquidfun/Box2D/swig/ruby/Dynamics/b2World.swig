/*
 * Copyright (c) 2014 Google, Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

%module b2World

/// Forward declarations
class b2Body;

%newobject b2World::b2World;
%newobject b2World::CreateBody;
%newobject b2World::CreateParticleSystem;

%markfunc b2World "mark_b2World";

%header %{
    static void mark_b2World(void* ptr) {
        b2World* world = (b2World*) ptr;
        /* Loop over each object and tell the garbage collector  that we are holding a reference to them. */ 
        // int count = world->GetBodyCount();
        b2Body* bodyList = world->GetBodyList();
        for (b2Body* b = bodyList; b; b = b->GetNext())
        {
            VALUE object = SWIG_RubyInstanceFor(b);
            if (object != Qnil) {
                rb_gc_mark(object);
            } 
        }

        b2Draw* debugDraw = world->GetDebugDraw();
        if (debugDraw != NULL) {
            VALUE object = SWIG_RubyInstanceFor(debugDraw);
            if (object != Qnil) {
                rb_gc_mark(object);
            } 
        }
        // for(int i = 0; i < count; ++i) {
        //     Body* animal = world->get_animal(i);
        //     VALUE object = SWIG_RubyInstanceFor(animal);
        //     if (object != Qnil) {
        //         rb_gc_mark(object);
        //     } 
        // }
    }
%}

/// b2World class
class b2World {
public:
    b2World(float32 gravityX, float32 gravityY);
    ~b2World();

    // %apply SWIGTYPE *DISOWN {b2Draw* debugDraw};
    void SetDebugDraw(b2Draw* debugDraw);
    // %clear b2Draw* debugDraw;

    b2Body* CreateBody(const b2BodyDef* def);
    
    void DestroyBody(b2Body* body);

    void Step(
        float32 timeStep,
        int32 velocityIterations,
        int32 positionIterations,
        int32 particleIterations);
    void DrawDebugData();

    int32 GetBodyCount() const;

    b2ParticleSystem* CreateParticleSystem(const b2ParticleSystemDef* def);

    void SetGravity(float32 gravityX, float32 gravityY);
};
