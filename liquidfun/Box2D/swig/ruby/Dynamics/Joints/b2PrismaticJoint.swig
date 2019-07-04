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

%module b2PrismaticJoint

%nodefaultctor b2PrismaticJoint;      // don't create default constructors
%nodefaultdtor b2PrismaticJoint;      // don't create default destructors

%rename (init) b2PrismaticJointDef::Initialize;

// Not needed?
// %newobject b2PrismaticJoint::GetReactionForce;

%markfunc b2PrismaticJoint "mark_b2PrismaticJoint";
%header %{
    static void mark_b2PrismaticJoint(void* ptr) {
        b2PrismaticJoint* joint = (b2PrismaticJoint*) ptr;
        // Ignoring Joint variables that will already be tracked by world:
        //   m_bodyA, m_bodyB, m_next, m_prev
        // Ignoring internal MotorJoint variables:
        //   m_localYAxisA, m_impulse, m_limitState -> not actualy shared

        const b2Vec2* m_localAnchorA = &(joint->GetLocalAnchorA());
        if (m_localAnchorA != 0) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_localAnchorA);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
        const b2Vec2* m_localAnchorB = &(joint->GetLocalAnchorB());
        if (m_localAnchorB != 0) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_localAnchorB);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
        // Local (X) axis A
        const b2Vec2* m_localXAxisA = &(joint->GetLocalAxisA());
        if (m_localXAxisA != 0) {
            VALUE object = SWIG_RubyInstanceFor((b2Vec2*) m_localXAxisA);
            if (object != Qnil) {
                rb_gc_mark(object);
            }
        }
    }
%}

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Dynamics/Joints/b2PrismaticJoint.h"