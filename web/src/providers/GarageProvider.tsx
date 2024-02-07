import React, { Context, createContext, useContext, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
// types
import { GarageProviderValueTypes, vehicleType } from "../types/types";

const GarageContext = createContext<GarageProviderValueTypes | null>(null);

export const GarageProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [selectedVehicle, selectVehicle] = useState<vehicleType | null>(null);
  const [garageVehicles, setGarageVehicles] = useState<vehicleType[]>([]);

  useNuiEvent<any>("toggleGarageUi", (d: any) => {
    setGarageVehicles(d.vehicles);
  });

  const values: GarageProviderValueTypes = {
    selectedVehicle,
    selectVehicle,
    setGarageVehicles,
    garageVehicles,
  };

  return (
    <GarageContext.Provider value={values}>{children}</GarageContext.Provider>
  );
};

export const useGarage = () =>
  useContext<GarageProviderValueTypes>(
    GarageContext as Context<GarageProviderValueTypes>
  );
