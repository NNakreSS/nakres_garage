import React from "react";
// components
import Header from "./Header";
import Vehicle from "./Vehicle";
import GarageVehicles from "./GarageVehicles";

const Garage: React.FC = () => {
  return (
    <div className="grid grid-cols-1 grid-rows-[10%_70%_20%] w-full h-full shadow-inner-effect">
      <Header />
      <Vehicle />
      <GarageVehicles />
    </div>
  );
};

export default Garage;
