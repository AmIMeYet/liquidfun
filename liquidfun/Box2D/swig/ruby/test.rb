require_relative './liquidfun'

require 'pry'

class Object
    def mt
        self.methods - Object.new.methods
    end
end

WINDOW_HEIGHT = 480
WINDOW_WIDTH = 640
SCALE = 10.0
HEIGHT = WINDOW_HEIGHT / SCALE
WIDTH = WINDOW_WIDTH / SCALE

# Construct a world object, which will hold and simulate the rigid bodies.
world = Liquidfun::B2World.new(0, 10.0)

# Define the ground body.
groundBodyDef = Liquidfun::B2BodyDef.new
groundBodyDef.position.set(WIDTH/2, HEIGHT-(1*SCALE))
# Call the body factory which allocates memory for the ground body
# from a pool and creates the ground box shape (also from a pool).
# The body is also added to the world.
groundBody = world.create_body(groundBodyDef)
# Define the ground box shape.
groundBox = Liquidfun::B2PolygonShape.new
# The extents are the half-widths of the box.
groundBox.set_as_box(WIDTH/2, 2)
# Add the ground fixture to the ground body.
groundBody.create_fixture(groundBox, 0.0)

# Define the dynamic body. We set its position and call the body factory.
bodyDef = Liquidfun::B2BodyDef.new
bodyDef.type = Liquidfun::B2_DYNAMIC_BODY;
bodyDef.position.set(WIDTH/2, HEIGHT-(4 * SCALE));
# bodyDef.angularVelocity = 0.5
body = world.create_body(bodyDef)
# Define another box shape for our dynamic body.
dynamicBox = Liquidfun::B2PolygonShape.new
dynamicBox.set_as_box(1, 1)
# Define the dynamic body fixture.
fixtureDef = Liquidfun::B2FixtureDef.new
fixtureDef.shape = dynamicBox
# Set the box density to be non-zero, so it will be dynamic.
fixtureDef.density = 1.0
# Override the default friction.
fixtureDef.friction = 0.3
# Add the shape to the body.
body.create_fixture(fixtureDef)

# Define a second body
bodyDef.position.set(WIDTH/2 + (1 * SCALE), HEIGHT-(4 * SCALE));
body2 = world.create_body(bodyDef)
# Add the shape to the body.
body2.create_fixture(fixtureDef)

## Joints
jointDef = Liquidfun::B2RevoluteJointDef.new#(body, body2, body.get_world_center)
jointDef.motorSpeed = 6.0
jointDef.enableMotor = true
# jointDef.maxForce = 1000.0
jointDef.maxMotorTorque = 1000.0
jointDef.init(body, body2, body.get_world_center)
joint = world.create_joint(jointDef)

# jointDef = Liquidfun::B2MotorJointDef.new#(body, body2, body.get_world_center)
# jointDef.init(body, body2)
# jointDef.maxForce = 1000.0
# jointDef.maxTorque = 1000.0
# joint = world.create_joint(jointDef)


## Liquifun Particle Module

particleSystemDef = Liquidfun::B2ParticleSystemDef.new
particleSystemDef.radius = 0.5
particleSystem = world.create_particle_system(particleSystemDef)

particleDef = Liquidfun::B2ParticleDef.new
# particleDef.flags = b2_elasticParticle
particleDef.set_color(0, 0, 255, 255)#.color = Liquidfun::B2ParticleColor.new(0, 0, 255, 255) # RGBA

10.times do |i|
    particleDef.position = Liquidfun::B2Vec2.new(i, 0)
    tempIndex = particleSystem.create_particle(particleDef)
    puts tempIndex
end

##

# Prepare for simulation. Typically we use a time step of 1/60 of a
# second (60Hz) and 10 iterations. This provides a high quality simulation
# in most game scenarios.
TIME_STEP = 1.0 / 60.0
VELOCITY_ITERATIONS = 6
POSITION_ITERATIONS = 2
PARTICLE_ITERATIONS = 1

# class RbDraw < Liquidfun::B2Draw
#     def initialize
#         super
#     end

    # # Draw a closed polygon provided in CCW order.
    # def draw_polygon(vertices, vertexCount, color)
    #     puts "draw_polygon"
    # end

	# # Draw a solid closed polygon provided in CCW order.
    # def draw_solid_polygon(vertices, vertexCount, color)
    #     puts "draw_solid_polygon"
    #     puts vertices
    #     binding.pry
    # end

	# # Draw a circle.
    # def draw_circle(center, radius, color)
    #     puts "draw_circle"
    # end

	# # Draw a solid circle.
    # def draw_colid_circle(center, radius, axis, color)
    #     puts "draw_colid_circle"
    # end

	# # Draw a particle array
    # def draw_particles(centers, radius, colors, count)
    #     puts "draw_particles"
    # end

	# # Draw a line segment.
    # def draw_segment(p1, p2, color)
    #     puts "draw_segment"
    # end

	# # Draw a transform. Choose your own length scale.
	# # @param xf a transform.
    # def draw_transform(xf)
    #     puts "draw_transform"
    # end
# end

# # This is our little game loop.
# 60.times do |i|
#     # Instruct the world to perform a single step of simulation.
#     # It is generally best to keep the time step and iterations fixed.
#     world.step(timeStep, velocityIterations, positionIterations, particleIterations)

#     # Now print the position and angle of the body.
#     position = body.get_position
#     angle = body.get_angle

#     printf("%4.2f %4.2f %4.2f\n", position.x, position.y, angle);
# end

# rdDraw = RdDraw.new
# rdDraw.set_flags(Liquidfun::B2Draw::SHAPE_BIT)
# world.set_debug_draw(rdDraw)

# world.draw_debug_data

require 'gosu'

# class TestVec
#     attr_reader :x, :y
#     def initialize(x, y)
#         @x = x
#         @y = y
#     end
# end

# class Array; def x; self[0]; end; def y; self[1]; end; end

# See https://gist.github.com/jlnr/661266
class CircleImage
  attr_reader :columns, :rows
  
  def initialize(radius)
    @columns = @rows = radius * 2

    clear, solid = 0x00.chr, 0xff.chr

    lower_half = (0...radius).map do |y|
      x = Math.sqrt(radius ** 2 - y ** 2).round
      right_half = "#{solid * x}#{clear * (radius - x)}"
      right_half.reverse + right_half
    end.join
    alpha_channel = lower_half.reverse + lower_half
    # Expand alpha bytes into RGBA color values.
    @blob = alpha_channel.gsub(/./) { |alpha| solid * 3 + alpha }
  end
  
  def to_blob
    @blob
  end
end

class GosuDraw < Liquidfun::B2Draw
    def initialize(width, height, scale)
        super()
        # @width, @height, @scale = width, height, scale
        @width, @height, @scale = width, height, scale
        @particle_images = {}
    end

    # Draw a closed polygon provided in CCW order.
    def draw_polygon(vertices, color)
        c = Gosu::Color.new(255, 255.0 * color.r, 255.0 * color.g, 255.0 * color.b)
        vertices.each_with_index do |p2, i|
            p1 = vertices[i-1]
            Gosu.draw_line(@scale * p1.x, @scale * p1.y, c, @scale * p2.x, @scale * p2.y, c)
        end
    end

	# Draw a solid closed polygon provided in CCW order.
    def draw_solid_polygon(vertices, color)
        c = Gosu::Color.new(255, 255.0 * color.r, 255.0 * color.g, 255.0 * color.b)
        vertices.each_with_index do |p2, i|
            p1 = vertices[i-1]
            Gosu.draw_line(@scale * p1.x, @scale * p1.y, c, @scale * p2.x, @scale * p2.y, c)
        end
    end
    # def draw_solid_polygon(vertexCount, color)
    #     puts "draw_solid_polygon"
    #     # puts vertices
    #     # binding.pry
    #     c = Gosu::Color.new(255, color.r * 255, color.g * 255, color.b * 255)

    #     vertices = [TestVec.new(10, 10), TestVec.new(20, 20), TestVec.new(30, 30), TestVec.new(40, 40)]

    #     vertices.each_cons(2) do |p1, p2|
    #         Gosu.draw_line(100 + p1.x * 10, 100 + p1.y * 10, c, 100 + p2.x * 10, 100 + p2.y * 10, c)
    #     end
    # end

    # def draw_solid_polygon(vertices)
    #     puts "draw_solid_polygon"
    #     # puts vertices
    #     # binding.pry
    #     c = Gosu::Color::WHITE

    #     vertices.each_cons(2) do |p1, p2|
    #         Gosu.draw_line(100 + p1.x * 10, 100 + p1.y * 10, c, 100 + p2.x * 10, 100 + p2.y * 10, c)
    #     end
    # end

	# # Draw a circle.
    # def draw_circle(center, radius, color)
    #     puts "draw_circle"
    # end

	# # Draw a solid circle.
    # def draw_colid_circle(center, radius, axis, color)
    #     puts "draw_colid_circle"
    # end

    def particle_image(radius)
        @particle_images[radius] ||= Gosu::Image.new(CircleImage.new(radius))
    end

	# Draw a particle array
    def draw_particles(centers, radius, colors)
        centers.each_with_index do |p, i|
            color = colors[i]
            c = Gosu::Color.new(255, color.r, color.g, color.b)

            particle_image(@scale * radius).draw_rot(@scale * p.x, @scale * p.y, 1, 0, 0.5, 0.5, 1, 1, c)
            # Gosu.draw_quad(
            #     @scale * p.x, @scale * (p.y-radius), c,
            #     @scale * (p.x + radius), @scale * p.y, c,
            #     @scale * p.x, @scale * (p.y+radius), c,
            #     @scale * (p.x - radius), @scale * p.y, c)
        end
    end

	# Draw a line segment.
    def draw_segment(p1, p2, color)
        c = Gosu::Color.new(255, 255.0 * color.r, 255.0 * color.g, 255.0 * color.b)
        Gosu.draw_line(@scale * p1.x, @scale *p1.y, c, @scale * p2.x, @scale * p2.y, c)
    end

	# Draw a transform. Choose your own length scale.
	# @param xf a transform.
    def draw_transform(xf)
        axis_scale = 0.8

        p1_x = xf.get_position_x
        p1_y = xf.get_position_y

        p2_x = p1_x + (axis_scale * xf.get_rotation_cos)
        p2_y = p1_y + (axis_scale * xf.get_rotation_sin)
        Gosu.draw_line(@scale * p1_x, @scale * p1_y, Gosu::Color::RED, @scale * p2_x, @scale * p2_y, Gosu::Color::RED)
    end
end

class LiquidfunTest < Gosu::Window
    def initialize(world, body, particle_system)
        super WINDOW_WIDTH, WINDOW_HEIGHT
        self.caption = "Liquidfun testing visualization"
        @world = world
        @body = body
        @particle_system = particle_system

        gosuDraw = GosuDraw.new(WIDTH, HEIGHT, SCALE)
        gosuDraw.set_flags(Liquidfun::B2Draw::SHAPE_BIT | Liquidfun::B2Draw::PARTICLE_BIT | Liquidfun::B2Draw::CENTER_OF_MASS_BIT | Liquidfun::B2Draw::JOINT_BIT)
        @world.set_debug_draw(gosuDraw)
    end

    def update
        @world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS, PARTICLE_ITERATIONS)

        particleDef = Liquidfun::B2ParticleDef.new
        # particleDef.flags = b2_elasticParticle
        particleDef.set_color(rand(256), rand(256), rand(256), 255)#.color = Liquidfun::B2ParticleColor.new(0, 0, 255, 255) # RGBA

        5.times do |i|
            particleDef.position = Liquidfun::B2Vec2.new((WIDTH / 2) - (5/2*2) + (i * 2), 0)
            tempIndex = @particle_system.create_particle(particleDef)
            # puts tempIndex
        end

        printf("Particle count: %20d. FPS: %5d\n", @particle_system.get_particle_count, Gosu.fps)

        # Now print the position and angle of the body.
        # position = @body.get_position
        # angle = @body.get_angle

        # printf("%4.2f %4.2f %4.2f\n", position.x, position.y, angle);
    end

    def needs_cursor?
        true
    end

    def draw
        @world.draw_debug_data
        GC.start 
    end
end

LiquidfunTest.new(world, body, particleSystem).show


# gosuDraw = GosuDraw.new
# gosuDraw.set_flags(Liquidfun::B2Draw::SHAPE_BIT)
# world.set_debug_draw(gosuDraw)

# def update(world, body)
#     world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS, PARTICLE_ITERATIONS)

#     # Now print the position and angle of the body.
#     position = body.get_position
#     angle = body.get_angle

#     printf("%4.2f %4.2f %4.2f\n", position.x, position.y, angle)
# end
# def draw(world)
#     world.draw_debug_data
#     GC.start
# end

# while true
#     update(world, body)
#     draw(world)
# end



# When the world destructor is called, all bodies and joints are freed. This can
# create orphaned pointers, so be careful about your world management.

# binding.pry