export type vehicleType = {
  model: number;
  name: string;
  depotPrice: number;
  displayName: string;
  traction: number;
  topSpeed: number;
  bodyPercent: number;
  acceleration: number;
  brakes: number;
  fuelPercent: number;
  plate: string;
  enginePercent: number;
};

export type GarageProviderValueTypes = {
  garageVehicles: vehicleType[];
  setGarageVehicles: (vehicles: vehicleType[]) => void;
  selectedVehicle: vehicleType | null;
  selectVehicle: (vehicle: vehicleType | null) => void;
  locale: localeType | null;
  depotGarage: boolean;
  garageName: string;
  garageLimit: number | false;
};

export type GarageDataType = {
  vehicles: vehicleType[];
  garageName: string;
  garageLimit: number | false;
  depotGarage: boolean;
};

export type localeType = {
  limit: string;
  total: string;
  spawn: string;
  model: string;
  garage: string;
  impounds: string;
  admin: {
    header: string;
    info: string;
    garageName: string;
    garageType: string;
    vehicleType: string;
    garageLimit: string;
    job: string;
    jobType: string;
    npcCoord: string;
    spawnCoord: string;
    enterCoord: string;
    previewCoord: string;
    blip: string;
    submit: string;
    unlimited: string;
  };
};
