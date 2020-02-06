# Cloth-Simulation
This is a simulation implementing a cloth simulation. The project was first implemented using Matlab and then with compute shaders in OpenGL and GLSL. 

## Matlab

> Note that this code requires the navigation and database toolbox for handling of nodes

The core of the cloth model is a system of spring dampers. The model is built upon a structured lattice that consist of particles with a finite mass that are connected to each other by spring-dampers. The spring-damper generates a force on each particle based on its position and velocity. 

### Numerical methods

The simulation of the movement of the particles is based upon numerical methods. First the Euler method is used for both the position and the velocity according to: 

```
x(t+1) = x(t) + hx'(t)
x'(t+1) = x'(t) + hx''(t)
```

The acceleration is based on Newton's second law of motion with the force calculated as the sum of all forces acting on each particle.



## Sources and attribution

The 2D plot of the spring-damper system is built and developed with the help of Auralius Manurung's [Matlab Project of a Deformable Object](https://www.mathworks.com/matlabcentral/fileexchange/52931-deformable-object-with-interconnected-mass-spring-damper).

