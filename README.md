# Cloth Simulation
This is a simulation implementing a cloth simulation. The project was first implemented using Matlab and then using Processing. 

## Requirements

The following additional toolboxes are required to run the program in Matlab:

| Name                                    | 
| --------------------------------------- | 
| Navigation Toolbox                      | 
| Database Toolbox                        |


## Matlab

The core of the cloth model is a system of spring dampers. The model is built upon a structured lattice that consist of particles with a finite mass that are connected to each other by spring-dampers. The spring-damper generates a force on each particle based on its position and velocity. 

### Numerical methods

The simulation of the movement of the particles is based upon numerical methods. First the Euler method is used for both the position and the velocity according to: 

```
x(t+1) = x(t) + hx'(t)
x'(t+1) = x'(t) + hx''(t)
```

The acceleration is based on Newton's second law of motion with the force calculated as the sum of all forces acting on each particle.

Since the Euler method for the cloth simulation requires a very small timestep to stay stable, the Verlet method is implemented as an alternate simulation method according to: 
```
x(t+1) = 2x(t) - x(t-1) + h*h*x''(t)
x'(t+1) = 1/(2h)(x(t) - x(t-1)
```
This approach is an advantage since the position doesn't require the velocity to be calculated and it is also a more stable solution for the cloth simulation. This is the approach used for implementing the simulation in OpenGL. 

## Sources and attribution

The 2D plot of the spring-damper system is built upon the approach of Auralius Manurung's [Matlab Project of a Deformable Object](https://www.mathworks.com/matlabcentral/fileexchange/52931-deformable-object-with-interconnected-mass-spring-damper) that uses the nodes system from the navigation toolbox in Matlab to represent the masses in the lattice. 

