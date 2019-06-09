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

%module(directors="1") b2Draw

%feature("director") b2Draw;

/// Rename the enums as SWIG doesn't allow multiple rename rules except with
/// a script that can slow SWIG down quite a bit
%rename (SHAPE_BIT) e_shapeBit;
%rename (JOINT_BIT) e_jointBit;
%rename (AABB_BIT) e_aabbBit;
%rename (PAIR_BIT) e_pairBit;
%rename (CENTER_OF_MASS_BIT) e_centerOfMassBit;
%rename (PARTICLE_BIT) e_particleBit;

// Include (..., int32 vertexCount) to hide it from ruby
%typemap(directorin) (const b2Vec2* vertices, int32 vertexCount) {
    $input = rb_ary_new2(vertexCount);
    VALUE vertex;
    for(int i = 0; i < vertexCount; ++i) {
        vertex = SWIG_NewPointerObj(SWIG_as_voidptr(&(vertices[i])), $1_descriptor, 0);
        rb_ary_push($input, vertex);
    }
}

// Injected into DrawParticles().
// Also takes (..., int32 count) but we can only use it once, so use it for (b2ParticleColor* colors, ...)
%typemap(directorin) (const b2Vec2* centers) {
    $input = rb_ary_new2(count);
    VALUE vertex;
    for(int i = 0; i < count; i++) {
        vertex = SWIG_NewPointerObj(SWIG_as_voidptr(&centers[i]), $1_descriptor, 0);
        rb_ary_push($input, vertex);
    }
}

/// Director Typemaps for b2ParticleColor*
%apply (const b2Vec2*) { const b2ParticleColor* }

// // Injected into DrawParticles().
// Include (..., int32 count) to hide it from ruby
%typemap(directorin) (const b2ParticleColor* colors, int32 count) {
    if ($1 != NULL) {
        $input = rb_ary_new2(count);
        VALUE vertex;
        for(int i = 0; i < count; i++) {
            vertex = SWIG_NewPointerObj(SWIG_as_voidptr(&$1[i]), $1_descriptor, 0);
            rb_ary_push($input, vertex);
        }
    }
    else {
        $input = Qnil;
    }
}

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Common/b2Draw.h"

/// Disable all the Typemaps so they don't get generated for other files
%clear (const b2Vec2*);
%clear (const b2Vec2* vertices);
%clear (const b2Vec2* centers);
%clear (const b2ParticleColor*);
