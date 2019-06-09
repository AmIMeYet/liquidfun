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

%module b2ParticleGroup

/// forward declarations
struct b2ParticleColor;
class b2Shape;

/// We are going to use b2ParticleFlag as b2ParticleGroupFlag for C++ and Java,
/// so it makes more sense to just expose them as final ints in Java
//%include "enumtypeunsafe.swg"
//%javaconst(1);

// Ignore internal enum flags
%ignore b2_particleGroupWillBeDestroyed;
%ignore b2_particleGroupNeedsUpdateDepth;
%ignore b2_particleGroupInternalMask;

// // Typemaps for getting the raw address of output java.nio.ByteBuffer
// %typemap(jni) (void* inBuf) "jobject"
// %typemap(jtype) (void* inBuf) "java.nio.ByteBuffer"
// %typemap(jstype) (void* inBuf) "java.nio.ByteBuffer"
// %typemap(javain) (void* inBuf) "$javainput"
// %typemap(javaout) (void* inBuf) { return $jnicall; }

// // This extracts the Java ByteBuffer address from C++
// %typemap(in) (void* inBuf) {
//     $1 = jenv->GetDirectBufferAddress($input);
//     if ($1 == NULL) {
//         SWIG_JavaThrowException(
//                 jenv,
//                 SWIG_JavaRuntimeException,
//                 "Unable to get address of java.nio.ByteBuffer. "
//                 "Is the ByteBuffer initialized?");
//     }
// }


%typemap(in) (void* inBuf, int numShapes) {
    /* Get the length of the array */
    int size = RARRAY_LEN($input); 
    int i;
    float* tmp = (float *) malloc(size*sizeof(float));
    /* Get the first element in memory */
    VALUE *ptr = RARRAY_PTR($input); 
    for (i=0; i < size; i++, ptr++) {
      /* Convert Ruby float to C++ float */
      float val;
      int encodeResult = SWIG_AsVal_float(*ptr, &val);
      if (!SWIG_IsOK(encodeResult)) {
        SWIG_exception_fail(SWIG_ArgError(encodeResult), Ruby_Format_TypeError( "", "float32","SetCircleShapesFromVertexList", 2, argv[0] ));
      } 
      tmp[i]= val;
    }
    $1 = static_cast< $1_ltype >(tmp);
    $2 = size;
//     /* Get the length of the array */
//   int size = RARRAY_LEN($input); 
//   int i;
//   $1 = (float **) malloc((size+1)*sizeof(float *));
//   /* Get the first element in memory */
//   VALUE *ptr = RARRAY_PTR($input); 
//   for (i=0; i < size; i++, ptr++) {
//     /* Convert Ruby Object String to char* */
//     float val;
//     int encodeResult = SWIG_AsVal_float(*ptr, &val);
//     if (!SWIG_IsOK(encodeResult)) {
//         SWIG_exception_fail(SWIG_ArgError(encodeResult), Ruby_Format_TypeError( "", "float32","b2Color", 3, argv[2] ));
//     } 
//     $1[i]= static_cast< float32 >(val);
//     // $1[i]= StringValuePtr(*ptr); 
//   }
//   $1[i]=NULL; /* End of list */
}

// This cleans up the float* array created before 
// the function call
%typemap(freearg) float* {
  free((float *) $1);
}

/// b2ParticleGroup class
%nodefaultctor;      // don't create default constructors
%nodefaultdtor;      // don't create default destructors
class b2ParticleGroup {
public:
    const b2ParticleGroup* GetNext() const;
    int32 GetParticleCount() const;
    int32 GetBufferIndex() const;
    int32 GetGroupFlags() const;
};
%clearnodefaultdtor; // Re-enable default destructors
%clearnodefaultctor; // Re-enable default constructors

/// Ignore member variables so SWIG doesn't auto-generate get/setters
%ignore b2ParticleGroupDef::userData;
%ignore b2ParticleGroupDef::shapes;

/// Ignore b2ParticleGroup class in the .h file because it's too complex
/// A simple SWIG interface is provided before this
%ignore b2ParticleGroup;

/// Include original .h file for SWIG
/// The original file is simple enough we will just pull it in
%include "../../../Box2D/Box2D/Particle/b2ParticleGroup.h"

/// Clear the typemaps
%clear (void* inBuf);
