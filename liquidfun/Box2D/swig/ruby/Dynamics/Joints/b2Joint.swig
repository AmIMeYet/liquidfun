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

%module b2Joint

/// We are going to use b2ParticleFlag as bitfields for C++ and Java, so it
/// makes more sense to just expose them as final ints in Java
//%include "enums.swg"
//%javaconst(1);

/// b2JointDef class
// Ignore userData
%ignore b2JointDef::userData;

/// b2Joint class
/// C++ implementation does not have default public ctors and dtors. Don't
/// allow them as SWIG will add them otherwise and cause compile errors.
%nodefaultctor b2Joint;      // don't create default constructors
%nodefaultdtor b2Joint;      // don't create default destructors

// // Suppress warnings for overloaded functions, because SWIG will pick the
// // non-const version automatically, which is what we want anyway.
// // We could suppress the warning in all of b2Joint, but it's clearer this way.
// %warnfilter(516) b2Joint::GetFixtureList;
// %warnfilter(516) b2Joint::GetJointList;
// %warnfilter(516) b2Joint::GetContactList;
// %warnfilter(516) b2Joint::GetNext;
// %warnfilter(516) b2Joint::GetWorld;

// // Ignore userData
%ignore b2Joint::m_userData;
%ignore b2Joint::GetUserData;
%ignore b2Joint::SetUserData;

%rename (JOINT_UNKNOWN) e_unknownJoint;
%rename (JOINT_REVOLUTE) e_revoluteJoint;
%rename (JOINT_PRISMATIC) e_prismaticJoint;
%rename (JOINT_DISTANCE) e_distanceJoint;
%rename (JOINT_PULLEY) e_pulleyJoint;
%rename (JOINT_MOUSE) e_mouseJoint;
%rename (JOINT_GEAR) e_gearJoint;
%rename (JOINT_WHEEL) e_wheelJoint;
%rename (JOINT_WELD) e_weldJoint;
%rename (JOINT_FRICTION) e_frictionJoint;
%rename (JOINT_ROPE) e_ropeJoint;
%rename (JOINT_MOTOR) e_motorJoint;
%rename (LIMIT_INACTIVE) e_inactiveLimit;
%rename (LIMIT_LOWER) e_atLowerLimit;
%rename (LIMIT_UPPER) e_atUpperLimit;
%rename (LIMIT_EQUAL) e_equalLimits;

// %newmethod b2Joint::CreateFixture;

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Dynamics/Joints/b2Joint.h"
