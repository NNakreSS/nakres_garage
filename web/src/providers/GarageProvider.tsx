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

  // useEffect(() => {
  //   const fakeData = {
  //     locale: {
  //       garage: "Garage",
  //       spawn: "Spawn",
  //       model: "Model",
  //       limit: "LIMIT",
  //       admin: {
  //         vehicleType: "Vehicle type",
  //         garageType: "Garage Type",
  //         info: "If the garage type is selected as a job, you must specify the job and job grade (job type); if the preview coord is left blank, it will be used as the default spawn coord preview coord",
  //         garageName: "Garage Label",
  //         enterCoord: "Garage coordinates",
  //         unlimited: "Unlimited",
  //         blip: "Blip",
  //         submit: "Save",
  //         spawnCoord: "Spawn coordinates",
  //         npcCoord: "Npc coordinates",
  //         header: "Create Garage",
  //         previewCoord: "Preview coordinates",
  //         jobType: "Rank",
  //         job: "Job",
  //         garageLimit: "Garage limit",
  //       },
  //       impounds: "Impounds",
  //       total: "TOTAL",
  //     },
  //     garageLimit: 10,
  //     garageName: "Motel Parking",
  //     vehicles: [
  //       {
  //         plate: "7CJ428JQ",
  //         brakes: 64,
  //         acceleration: 50,
  //         topSpeed: 66,
  //         traction: 67,
  //         model: 108773431,
  //         depotPrice: 0,
  //         enginePercent: 100,
  //         name: "coquette",
  //         displayName: "Invetero Coquette",
  //         bodyPercent: 100,
  //         fuelPercent: 96,
  //       },
  //     ],
  //     depotGarage: false,
  //   };

  //   fetchNui("sa", "as", fakeData).then((d) => {
  //     setGarageVehicles(d.vehicles);
  //     setLocale(d.locale);
  //     setDepotGarage(d.depotGarage);
  //     setGarageName(d.garageName);
  //     setGarageLimit(d.garageLimit);
  //     selectVehicle(d.vehicles[0]);
  //     fetchNui("previewSelectedVehicle", d.vehicles[0]);
  //   });
  // }, []);

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
