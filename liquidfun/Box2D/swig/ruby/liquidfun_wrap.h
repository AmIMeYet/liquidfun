/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.1
 *
 * This file is not intended to be easily readable and contains a number of
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG
 * interface file instead.
 * ----------------------------------------------------------------------------- */

#ifndef SWIG_Liquidfun_WRAP_H_
#define SWIG_Liquidfun_WRAP_H_

namespace Swig {
  class Director;
}


class SwigDirector_B2Draw : public b2Draw, public Swig::Director {

public:
    SwigDirector_B2Draw(VALUE self);
    virtual ~SwigDirector_B2Draw();
    virtual void DrawPolygon(b2Vec2 const *vertices, int32 vertexCount, b2Color const &color);
    virtual void DrawSolidPolygon(b2Vec2 const *vertices, int32 vertexCount, b2Color const &color);
    virtual void DrawCircle(b2Vec2 const &center, float32 radius, b2Color const &color);
    virtual void DrawSolidCircle(b2Vec2 const &center, float32 radius, b2Vec2 const &axis, b2Color const &color);
    virtual void DrawParticles(b2Vec2 const *centers, float32 radius, b2ParticleColor const *colors, int32 count);
    virtual void DrawSegment(b2Vec2 const &p1, b2Vec2 const &p2, b2Color const &color);
    virtual void DrawTransform(b2Transform const &xf);
};


class SwigDirector_B2QueryCallback : public b2QueryCallback, public Swig::Director {

public:
    SwigDirector_B2QueryCallback(VALUE self);
    virtual ~SwigDirector_B2QueryCallback();
    virtual bool ReportFixture(b2Fixture *fixture);
    virtual bool ReportParticle(b2ParticleSystem const *particleSystem, int32 index);
};


#endif