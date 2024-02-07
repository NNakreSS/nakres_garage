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
  selectVehicle: (vehicle: vehicleType) => void;
};

export type GarageDataType = {
  vehicles: vehicleType[];
  garageName: string;
  garageLimit: number | false;
  depotGarage: boolean;
};
