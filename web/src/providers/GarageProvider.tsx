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
import { isEnvBrowser } from "../utils/misc";

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

  const [visible, setVisible] = useState(false);

  useNuiEvent<boolean>("setVisible", setVisible);
  // Handle pressing escape/backspace
  useEffect(() => {
    // Only attach listener when we are visible
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Backspace", "Escape"].includes(e.code)) {
        if (!isEnvBrowser()) fetchNui("hideFrame");
        else setVisible(!visible);
      }
    };

    window.addEventListener("keydown", keyHandler);

    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible]);

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
    <GarageContext.Provider value={values}>
      <div className={`${visible ? "visible w-full h-full" : "hidden"}`}>
        {children}
      </div>
    </GarageContext.Provider>
  );
};

export const useGarage = () =>
  useContext<GarageProviderValueTypes>(
    GarageContext as Context<GarageProviderValueTypes>
  );
