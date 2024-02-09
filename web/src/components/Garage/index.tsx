import React from "react";
// components
import Header from "./Header";
import Vehicle from "./Vehicle";
import GarageVehicles from "./GarageVehicles";
import { GarageProvider } from "../../providers/GarageProvider";

const Garage: React.FC = () => {
  return (
    <GarageProvider>
      <div className="grid grid-cols-1 grid-rows-[10%_65%_25%] w-full h-full shadow-inner-effect bg-gradient-to-t from-amber-500/30 via-transparent to-transparent">
        <Header />
        <Vehicle />
        <GarageVehicles />
      </div>
    </GarageProvider>
  );
};

export default Garage;
