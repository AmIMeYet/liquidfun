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

%module b2MotorJoint

%nodefaultctor b2MotorJoint;      // don't create default constructors
%nodefaultdtor b2MotorJoint;      // don't create default destructors

%rename (init) b2MotorJointDef::Initialize;

// Not needed?
// %newobject b2MotorJoint::GetReactionForce;

%markfunc b2MotorJoint "mark_b2MotorJoint";
%header %{
    static void mark_b2MotorJoint(void* ptr) {
        b2MotorJoint* joint = (b2MotorJoint*) ptr;
        // Ignoring Joint variables that will already be tracked by world:
        //   m_bodyA, m_bodyB, m_next, m_prev
        // Ignoring internal MotorJoint variables:
        //   m_rA, m_rB, m_localCenterA, m_localCenterB, m_linearError
        //   m_linearImpulse -> not actualy shared

        const b2Vec2* m_linearOffset = &(joint->GetLinearOffset());
        if (m_linearOffset != 0) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_linearOffset);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
    }
%}

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Dynamics/Joints/b2MotorJoint.h"