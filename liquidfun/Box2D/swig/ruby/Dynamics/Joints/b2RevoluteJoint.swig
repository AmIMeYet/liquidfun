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

%module b2RevoluteJoint



// %feature("notabstract") b2RevoluteJointDef;

// class b2RevoluteJointDef {
// public:
//     b2RevoluteJointDef();
// 	void Initialize(b2Body* bodyA, b2Body* bodyB, const b2Vec2& anchor);
// };

	// b2RevoluteJointDef()
	// {
	// 	type = e_revoluteJoint;
	// 	localAnchorA.Set(0.0f, 0.0f);
	// 	localAnchorB.Set(0.0f, 0.0f);
	// 	referenceAngle = 0.0f;
	// 	lowerAngle = 0.0f;
	// 	upperAngle = 0.0f;
	// 	maxMotorTorque = 0.0f;
	// 	motorSpeed = 0.0f;
	// 	enableLimit = false;
	// 	enableMotor = false;
	// }

	// /// Initialize the bodies, anchors, and reference angle using a world
	// /// anchor point.
	// void Initialize(b2Body* bodyA, b2Body* bodyB, const b2Vec2& anchor);


%nodefaultctor b2RevoluteJoint;      // don't create default constructors
%nodefaultdtor b2RevoluteJoint;      // don't create default destructors


%rename (init) b2RevoluteJointDef::Initialize;

// Not needed?
// %newobject b2RevoluteJoint::GetReactionForce;

%markfunc b2RevoluteJoint "mark_b2RevoluteJoint";
%header %{
    static void mark_b2RevoluteJoint(void* ptr) {
        b2RevoluteJoint* joint = (b2RevoluteJoint*) ptr;
        // Ignoring Joint variables that will already be tracked by world:
        //   m_bodyA, m_bodyB, m_next, m_prev
        // Ignoring internal MotorJoint variables:
        //   m_impulse -> not actualy shared

        const b2Vec2* m_localAnchorA = &(joint->GetLocalAnchorA());
        if (m_localAnchorA != NULL) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_localAnchorA);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
        const b2Vec2* m_localAnchorB = &joint->GetLocalAnchorB();
        if (m_localAnchorB != NULL) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_localAnchorB);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
    }
%}

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Dynamics/Joints/b2RevoluteJoint.h"

// %extend b2RevoluteJointDef {
//     b2RevoluteJointDef(b2Body* bA, b2Body* bB, const b2Vec2& anchor)
// 	{
// 		type = e_revoluteJoint;
// 		localAnchorA.Set(0.0f, 0.0f);
// 		localAnchorB.Set(0.0f, 0.0f);
// 		referenceAngle = 0.0f;
// 		lowerAngle = 0.0f;
// 		upperAngle = 0.0f;
// 		maxMotorTorque = 0.0f;
// 		motorSpeed = 0.0f;
// 		enableLimit = false;
// 		enableMotor = false;
// 	}
// }
