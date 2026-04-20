
[Chat de Gemini](https://www.google.com/search?client=firefox-b-d&sca_esv=ba24c2d2484ecd3d&sxsrf=AE3TifNBo0v-dA8NkTRZXjs__mwvH5mAIw%3A1756323116741&q=external+physics+engine+in+unity&spell=1&sa=X&ved=2ahUKEwjOkOG83auPAxXODrkGHaAqFlQQ0NsOegQINxAA&biw=1920&bih=947&udm=50&fbs=AIIjpHxU7SXXniUZfeShr2fp4giZ1Y6MJ25_tmWITc7uy4KIeoJTKjrFjVxydQWqI2NcOha3O1YqG67F0QIhAOFN_ob1yXos5K_Qo9Tq-0cVPzex8akBC0YDCZ6Kdb3tXvKc6RFFaJZ5G23Reu3aSyxvn2qD41n-47oj-b-f0NcRPP5lz0IcnVzj2DIj_DMpoDz5XbfZAMcEl5-58jjbkgCC_7e4L5AEDQ&aep=10&ntc=1&mtid=U12vaMzBLLPc5OUPiLvAmAk&mstk=AUtExfCZ3Vueqr-brCTGdna8LrWiVs3eVByWh18NrrcU64i8YrWU4XFk5WR7qLMjmzrZc1V4WdJ97TUd74yVDTu13dqMPB46h1w_us5PuO_sS_gJji5HOwTNODcxGj7EU0Kp1w4U4JVZ01osVRrXNYEU9N4ZscrWlccb3eB7hrVxvuql91DdoM_uUok9e3lZbcVQYkX8cul2AqZJpG1dJTMnW454y6sha1dwnC1D2aoEMtnjPg1ot2ZilMDueLQeccI3Z1MFhGq_X8wEiOJ8W6F0415XRG421JmQO9mZJJrRr9eyD4Jyies53_xGqUP5ggLuay7nCTaaEVn0BQ&csuir=1)
# Motor gráfico
Una idea es usar un motor gráfico para representar los valores que me va a devolver Modellica, puntos clave para definir si vale la pena son: 
- Facilidad de recibir telemetría externa
- Facilidad de dar feedback de vuelta a Modellica
- Modelos/entornos ya definidos para ahorrar trabajo

Parece que el método más sencillo para hacer esto es crear un plugin en el motor que funcione como interfaz y después pasar información por algún IPC de un lado a otro. Otro punto a tener en cuenta es que los motores hacen polling de las físicas cada x tiempo determinado, entonces hay que sincronizar ambos motores.
## Unity
Primer motor que se me ocurrió, tiene de ventaja la cantidad de assets ya existentes y la extensa documentación disponible. 
- [Simulation of Mobile Robots with Unity and ROS](https://www.diva-portal.org/smash/get/diva2:1334348/FULLTEXT01.pdf): Tiene una implementación de un motor de físicas externo en Unity. [[Notas paper Simulation of Mobile Robots with Unity and ROS |Notas]]
- [Native plugins en Unity, para compilar librerias](https://docs.unity3d.com/Manual/plug-ins-native.html): Con esto se puede crear una librería escrita en C/C++, la idea es implementar los sockets o el IPC a elegir acá, y despues llamar a esa función desde Unity.

## Unreal Engine
Ventajas contra unity:
- Todo codeado en C++
- Motor preparado para cargas mas pesadas (?)
Sin embargo no encuentro una fuente clara que explique como integrar un motor en tiempo real, todo lo que ví es compilar a una librería.
Sin embargo, si de alguna forma se pueden actualizar valores de forma pasiva, la librería solamente puede funcionar como listener de Modellica.
- [Physics timestep en Unreal](https://forums.unrealengine.com/t/using-a-fixed-physics-timestep-in-unreal-engine-free-the-physics-approach/67537): Con esto se puede hacer polling cada x tiempo para las físicas.
- [Blueprint function libraries](https://dev.epicgames.com/documentation/en-us/unreal-engine/blueprint-function-libraries?application_version=4.27): Implementación de librerías de C++ en Unreal.
# Visualizador existente
Otra idea es utilizar un visualizador comercial, esto facilitaría mucho las cosas, pero hay que tener en cuenta las licencias disponibles.
## rFpro
https://rfpro.com/
Solución óptima, visualizador usado en la industria.
## VI-GRADE
https://www.vi-grade.com/en/products/vi-carrealtime/
Creo que ofrecen tanto visualizador como motor de físicas, no se si necesitamos algo asi.