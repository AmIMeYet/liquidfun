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

// /// Global variables for Typemaps
// // We use byte[] for DebugDraw because then we don't have to have a specific-
// // sized buffer initialized on the Java side. We can allocate these dynamically.
// %{
//     static VALUE sDebugDrawPosByteArray = NULL;
//     static int sDebugDrawPosArraySize = 0;
//     static VALUE sDebugDrawColorByteArray = NULL;
//     static int sDebugDrawColorArraySize = 0;
// %}

/// Director Typemaps for b2Vec2*
// %typemap(jni) (const b2Vec2*) "jobject";
// %typemap(jstype) (const b2Vec2*) "byte[]"
// %typemap(jtype) (const b2Vec2*) "byte[]"
// %typemap(javain) (const b2Vec2*) "$javainput"
// %typemap(javaout) (const b2Vec2*) "$jnicall"
// %typemap(javadirectorin) (const b2Vec2*) "$jniinput"
// %typemap(javadirectorout) (const b2Vec2*) "$jnicall"

// %{
//     int b2Draw_SetUpDebugDrawArray(JNIEnv* jenv,
//                                    jbyteArray* byteArray,
//                                    int currSize,
//                                    int newSize) {
//         if (currSize != newSize) {
// 	        jenv->DeleteGlobalRef(*byteArray);
// 	        jbyteArray tempArray = jenv->NewByteArray(newSize);
// 	        (*byteArray) = (jbyteArray)jenv->NewGlobalRef(tempArray);
// 	        return newSize;
//         }
//         return currSize;
//     }
// %}


// VALUE obj0 = Qnil ;
// VALUE obj1 = Qnil ;
// VALUE obj2 = Qnil ;
// VALUE SWIGUNUSED result;

// obj0 = SWIG_NewPointerObj(SWIG_as_voidptr(vertices), SWIGTYPE_p_b2Vec2,  0 );
// obj1 = SWIG_From_int(static_cast< int >(vertexCount));
// obj2 = SWIG_NewPointerObj(SWIG_as_voidptr(&color), SWIGTYPE_p_b2Color,  0 );
// result = rb_funcall(swig_get_self(), rb_intern("draw_solid_polygon"), 3,obj0,obj1,obj2);


/* THIS WORKS!

void SwigDirector_B2Draw::DrawSolidPolygon(b2Vec2 const *vertices, int32 vertexCount, b2Color const &color) {
  VALUE obj0 = Qnil ;
  VALUE SWIGUNUSED result;
  
  {
    // VALUE ary = rb_ary_new2(vertexCount);
    // for(int i = 0; i < vertexCount; ++i) {
    //     rb_ary_push(ary, SWIG_NewPointerObj(SWIG_as_voidptr(&(vertices[i])), SWIGTYPE_p_b2Vec2, 0));
    // }
    // obj0 = ary;
    obj0 = rb_ary_new2(vertexCount);
    VALUE vertex;
    for(int i = 0; i < vertexCount; ++i) {
      vertex = rb_ary_new2(2);
      // PyTuple_SetItem(vertex, 0, SWIG_From_double((float32)vertices[i].x));
      // PyTuple_SetItem(vertex, 1, SWIG_From_double((float32)vertices[i].y));
      rb_ary_push(vertex, SWIG_From_double((float32)vertices[i].x));
      rb_ary_push(vertex, SWIG_From_double((float32)vertices[i].y));
      
      rb_ary_push(obj0, vertex);
    }
    // obj0 = ary;
  }
  // obj1 = SWIG_NewPointerObj(SWIG_as_voidptr(&color), SWIGTYPE_p_b2Color,  0 );
  result = rb_funcall(swig_get_self(), rb_intern("draw_solid_polygon"), 1,obj0);
}
*/

// 2 copies of these so we can hard code the count variable in them.
// Not the best solution but director typemaps does not support multi-arguments
// matching yet, it seems. It always throws a warning and will not be converted
// correctly.
// Injected into DrawPolygon() and DrawSolidPolygon()
// %newobject DrawSolidPolygon;
// %feature("del","0") *::DrawSolidPolygon;
// %feature("new","0") *::DrawSolidPolygon;
%typemap(directorin) (const b2Vec2* vertices, int32 vertexCount) {
    // VALUE ary = rb_ary_new2(vertexCount);
    // for(int i = 0; i < vertexCount; ++i) {
    //     rb_ary_push(ary, SWIG_NewPointerObj(SWIG_as_voidptr(&(vertices[i])), $descriptor(b2Vec2 *), 0));
    // }
    // $input = ary;
    $input = rb_ary_new2(vertexCount);
    VALUE vertex;
    for(int i = 0; i < vertexCount; ++i) {
        // vertex = rb_ary_new2(2);
        // rb_ary_push(vertex, SWIG_From_double((float32)vertices[i].x));
        // rb_ary_push(vertex, SWIG_From_double((float32)vertices[i].y));
        vertex = SWIG_NewPointerObj(SWIG_as_voidptr(&(vertices[i])), $1_descriptor, 0);

        rb_ary_push($input, vertex);
    }
    // $input = ary;
}

// %rename(DrawSolidPolygon) MyDrawSolidPolygon;
// %{
//     void MyDrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color) {
//         DrawSolidPolygon(ary, const b2Color& color)
//     }
// %}

// Injected into DrawParticles().
%typemap(directorin) (const b2Vec2* centers) {
    VALUE ary = rb_ary_new2(count);
    for(int i = 0; i < count; i++) {
        rb_ary_push(ary, SWIG_NewPointerObj(SWIG_as_voidptr(&centers[i]), $descriptor(b2Vec2 *), 0));
    }
    $input = ary;
}
// %typemap(directorin, descriptor="[B") (const b2Vec2* centers) {
//     int size = sizeof(b2Vec2) * count;
//     sDebugDrawPosArraySize =
//             b2Draw_SetUpDebugDrawArray(
//                 jenv,
//                 &sDebugDrawPosByteArray,
//                 sDebugDrawPosArraySize,
//                 size);
//     // jenv->SetByteArrayRegion(sDebugDrawPosByteArray, 0, size, (jbyte *)$1);
//     $input = sDebugDrawPosByteArray;
// }

/// Director Typemaps for b2ParticleColor*
%apply (const b2Vec2*) {const b2ParticleColor*}

// // Injected into DrawParticles().
%typemap(directorin) (const b2ParticleColor*) {
    if ($1 != NULL) {
        VALUE ary = rb_ary_new2(count);
        for(int i = 0; i < count; i++) {
            rb_ary_push(ary, SWIG_NewPointerObj(SWIG_as_voidptr(&$1[i]), $descriptor(b2ParticleColor *), 0));
        }
        $input = ary;
    }
    else {
        $input = Qnil;
    }
}
// %typemap(directorin, descriptor="[B") (const b2ParticleColor*) {
//     if ($1 != NULL) {
//         int size = sizeof(b2ParticleColor) * count;
//         sDebugDrawColorArraySize =
//                 b2Draw_SetUpDebugDrawArray(
//                     jenv,
//                     &sDebugDrawColorByteArray,
//                     sDebugDrawColorArraySize,
//                     size);
//         // jenv->SetByteArrayRegion(sDebugDrawColorByteArray, 0, size, (jbyte *)$1);
//         $input = sDebugDrawColorByteArray;
//     } else {
//         $input = NULL;
//     }
// }

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Common/b2Draw.h"

/// Disable all the Typemaps so they don't get generated for other files
%clear (const b2Vec2*);
%clear (const b2Vec2* vertices);
%clear (const b2Vec2* centers);
%clear (const b2ParticleColor*);
