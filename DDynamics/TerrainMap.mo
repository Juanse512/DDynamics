block TerrainMap "Calculates ground height based on X,Y position"
  // Inputs: We could use connectors, but for simplicity, 
  // we will just use public functions or variables.
  
  function getZ
    input Real x;
    input Real y;
    output Real z;
  algorithm 
    // Example: A 3D wave or a ramp
    // Let's do a sine-wave road (washboard) + a 5m hill
    z := 0.2 * Modelica.Math.sin(2 * Modelica.Constants.pi * x / 5);
  end getZ;

end TerrainMap;
