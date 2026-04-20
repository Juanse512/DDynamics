
## Librerías de dinámica completas:

- [Free vehicle dynamics library](https://openmodelica.org/forum/default-topic/2668-free-vehicle-dynamics-library.html): Parece ser una versión muy antigua que no funciona bien con OpenModellica.
- [VehicleInterfaces](https://github.com/modelica/VehicleInterfaces): Entiendo que esto es una interfaz a seguir cuando se implemente la librería.
- [VehicleDynamicsLibrary](https://ep.liu.se/ecp/063/045/ecp11063045.pdf): Propietaria, [Link a página](https://modelon.com/library/vehicle-dynamics-library/).
- [Modeling Road Vehicle Dynamics with Modelica](https://www.sae.org/publications/technical-papers/content/2002-01-1219/): Este paper es 3 días mas jóven que yo, encima es pago.
- [A Vehicle Dynamics Model for Driving Simulators](https://odr.chalmers.se/server/api/core/bitstreams/989a1db0-1820-4c71-a607-4b3dfdea9e62/content): Esta tesis se acerca un poco a lo que estabamos viendo, tiene sus años, es de 2012, además no encuentro la librería disponible para descargar.
- [A basic vehicle dynamics model for driving simulators](https://www.inderscienceonline.com/doi/epdf/10.1504/IJVSMT.2013.057530): Este paper capaz se acerca todavía más siendo que es un modelo más simple, es de 2013 y usa de referencia el paper anterior, sin embargo es pago y no tengo acceso.
- [Real-time Simulation of Detailed Automotive Models](https://modelica.org/events/Conference2003/papers/h38_Elmqvist_realtime.pdf): Otro paper que es antiguo pero hace más o menos lo que estoy buscando, esta compilado en Dymola.
- [DEVELOPMENT OF A COMPUTATIONAL VEHICLE DYNAMICS MODEL FOR A RACING CAR](https://repositorio.uniandes.edu.co/server/api/core/bitstreams/f7687be7-c142-482d-a4ab-4e2a4b6d1dca/content): Este es de 2020, tiene bastante que ver con lo que quiero hacer yo, pero no tiene la parte de visualizador.
## Tire Model

 Si conseguimos tomar el modelo de neumáticos de otro lado me ahorraría muchisimo trabajo.
 - [Modularised Tyre Modelling in Modelica](https://modelica.org/events/Conference2002/papers/p34_Andreasson.pdf)
- [An Interface to the FTire Tire Model](https://2011.international.conference.modelica.org/proceedings/pages/papers/13_2_ID111_a_fv.pdf):  Tiene una sección integrandolo a la librería VDL de Modelon que es la propietaria.
- [Real-time models for wheels and tyres in an object-oriented modelling framework](https://www.tandfonline.com/doi/abs/10.1080/00423110802687596)
## Driveline 

- [Development of an Integrated Control of Front Steering and Torque Vectoring Differential Gear System Using Modelica](https://ep.liu.se/ecp/132/001/ecp1713217.pdf): Paper desarrollando un diferencial en Modelica por un ingeniero de Toyota.
- [MODELING AND REALTIME SIMULATION OF AN AUTOMATIC GEARBOX USING MODELICA](https://modelica.org/papers/ess97gearbox.pdf):
- [Driveline Modelling using MathModelica](https://www.fs.isy.liu.se/Publications/MSc/01_EX_3114_PN.pdf): Modelado del driveline de un vehículo.
- [AlternativeVehicles Library](https://scispace.com/pdf/the-modelica-library-alternativevehicles-for-vehicle-system-4988yn1yjl.pdf): Librería que permite simular motores híbridos y eléctricos, principalmente orientados al calculo de la eficiencia. Usa la interfaz VehicleInterfaces.
