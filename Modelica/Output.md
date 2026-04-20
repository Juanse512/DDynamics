Como primer prueba se utilizo la librería `Modelica_DeviceDrivers` para configurar un servidor TCP y mandar información de la posición por un socket, el ejemplo se puede encontrar en SocketTest.
- Un punto a tener en cuenta es que hay que compilar con la flag `-lws2_32` para que no tire errores de linkeo.
- Se tiene que modificar tanto el intervalo de la simulación como el intervalo del SocketSend para que se envie información de forma fluida.
