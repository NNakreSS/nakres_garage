import React, { Context, createContext, useContext, useState } from "react";

type vehicle = {
  name: string;
  id: number;
};

interface GarageProviderValue {
  garageVehicles: vehicle[];
  setGarageVehicles: (vehicles: vehicle[]) => void;
  selectedVehicle: vehicle | null;
  selectVehicle: (vehicle: vehicle) => void;
}

const GarageContext = createContext<GarageProviderValue | null>(null);

export const GarageProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const vehicles: vehicle[] = [
    { name: "zentorno", id: 1 },
    { name: "drafter", id: 2 },
    { name: "drafter", id: 3 },
    { name: "drafter", id: 4 },
    { name: "drafter", id: 5 },
    { name: "drafter", id: 6 },
    { name: "sentinel", id: 7 },
    { name: "sentinel3", id: 8 },
    { name: "sentinel3", id: 23 },
    { name: "sentinel3", id: 24234 },
    { name: "sentinel3", id: 4332 },
    { name: "akuma", id: 112 },
    { name: "akuma", id: 145 },
    { name: "akuma", id: 1662 },
    { name: "alpha", id: 99776 },
    { name: "alpha", id: 457454536 },
    { name: "ardent", id: 34563451 },
    { name: "ardent", id: 24564562 },
    { name: "ardent", id: 23423525 },
    { name: "autarch", id: 456223562 },
    { name: "autarch", id: 23534535235 },
    { name: "autarch", id: 345345 },
    { name: "autarch", id: 34534534532 },
    { name: "autarch", id: 233342627 },
    { name: "autarch", id: 1231728 },
    { name: "autarch", id: 1231251689 },
    { name: "autarch", id: 1231567439 },
    { name: "autarch", id: 2342772 },
    { name: "baller", id: 36899034 },
    { name: "baller", id: 92834234 },
    { name: "baller", id: 234234 },
    { name: "baller", id: 14124156 },
    { name: "baller", id: 123162859 },
    { name: "baller", id: 6516513 },
    { name: "baller", id: 5498498495 },
    { name: "baller", id: 212154514 },
  ];

  const [selectedVehicle, selectVehicle] = useState<vehicle | null>(null);
  const [garageVehicles, setGarageVehicles] = useState<vehicle[]>(vehicles);

  const values: GarageProviderValue = {
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
  useContext<GarageProviderValue>(
    GarageContext as Context<GarageProviderValue>
  );
