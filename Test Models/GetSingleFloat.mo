model GetSingleFloat
  "Get float vector from package (all values casted to double before assigning it to Modelica Real array)"
  extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
  extends
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager(nu=0);
  import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
  import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  parameter Integer n = 1 "Vector size";
  parameter ByteOrder byteOrder = ByteOrder.LE;
  discrete Modelica.Blocks.Interfaces.RealOutput y[n](each start=0, each fixed=true)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real dummy(start=0, fixed=true);
equation

  //when initial() then
  //  pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
  //end when;

  when pkgIn.trigger then
    (y,dummy) =
       Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getRealFromFloat(
        pkgIn.pkg,
        n,
        pkgIn.dummy,
        byteOrder);
    //pkgOut.dummy = fill(dummy,nu);
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{30, 40}, {110, -40}}, lineColor = {0, 0, 255}, fillPattern = FillPattern.Solid, fillColor = {0, 0, 255}, textString = "R"), Text(extent = {{-100, -50}, {100, -90}}, textString = "%n * float"), Bitmap(extent = {{-20, -20}, {46, 19}}, fileName = "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Float2RealArrow.png")}),
  uses(Modelica_DeviceDrivers(version = "2.1.1")));
end GetSingleFloat;
