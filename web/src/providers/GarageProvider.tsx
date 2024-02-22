import React, {
  Context,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
// types
import {
  GarageProviderValueTypes,
  localeType,
  vehicleType,
} from "../types/types";
import { fetchNui } from "../utils/fetchNui";

const GarageContext = createContext<GarageProviderValueTypes | null>(null);

export const GarageProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [selectedVehicle, selectVehicle] = useState<vehicleType | null>(null);
  const [garageVehicles, setGarageVehicles] = useState<vehicleType[]>([]);
  const [locale, setLocale] = useState<localeType | null>(null);
  const [depotGarage, setDepotGarage] = useState<boolean>(false);
  const [garageName, setGarageName] = useState<string>("Garage");
  const [garageLimit, setGarageLimit] = useState<number | false>(false);

  useNuiEvent<any>("toggleGarageUi", (d: any) => {
    setGarageVehicles(d.vehicles);
    setLocale(d.locale);
    setDepotGarage(d.depotGarage);
    setGarageName(d.garageName);
    setGarageLimit(d.garageLimit);
    selectVehicle(d.vehicles[0]);
    fetchNui("previewSelectedVehicle", d.vehicles[0]);
  });

  const values: GarageProviderValueTypes = {
    selectedVehicle,
    selectVehicle,
    setGarageVehicles,
    garageVehicles,
    locale,
    depotGarage,
    garageName,
    garageLimit,
  };

  return (
    <GarageContext.Provider value={values}>{children}</GarageContext.Provider>
  );
};

export const useGarage = () =>
  useContext<GarageProviderValueTypes>(
    GarageContext as Context<GarageProviderValueTypes>
  );
