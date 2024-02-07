import { Button, Card, CardBody, CardFooter } from "@nextui-org/react";
import React from "react";

type VehicleType = {
  name: string;
};

type VehiclesProps = {
  vehicles: VehicleType[];
};

const Vehicles: React.FC<VehiclesProps> = ({ vehicles }) => {
  return (
    <div className="grid grid-rows-1 h-full w-full grid-flow-col place-content-start gap-5 p-2 overflow-hidden">
      {vehicles.map((vehicle, index) => (
        <Card
          shadow="sm"
          key={index}
          isPressable
          onPress={() => console.log("item pressed")}
          className="h-full w-48"
        >
          <CardBody className="w-full h-3/4 flex justify-center items-center box-border p-3">
            <img
              className="w-full h-full object-contain p-2 shadow-md shadow-black rounded-lg"
              src={`https://docs.fivem.net/vehicles/${vehicle.name}.webp`}
            />
          </CardBody>
          <CardFooter className="text-small justify-between h-1/4">
            <b>{vehicle.name.toUpperCase()}</b>
            <p className="text-default-500 pr-2">27asd34</p>
          </CardFooter>
        </Card>
      ))}
    </div>
  );
};

const GarageVehicles: React.FC = () => {
  const vehicles: VehicleType[] = [
    { name: "zentorno" },
    { name: "drafter" },
    { name: "sentinel" },
    { name: "sentinel3" },
    { name: "akuma" },
    { name: "alpha" },
    { name: "ardent" },
    { name: "autarch" },
    { name: "baller" },
    { name: "baller" },
  ];

  return (
    <div className="h-full grid grid-rows-1 grid-cols-[5%_90%_5%] place-content-center place-items-center">
      <Button isIconOnly className="bg-zinc-900" aria-label="Like">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="currentColor"
          className="w-6 h-6"
        >
          <path
            fillRule="evenodd"
            d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25Zm-4.28 9.22a.75.75 0 0 0 0 1.06l3 3a.75.75 0 1 0 1.06-1.06l-1.72-1.72h5.69a.75.75 0 0 0 0-1.5h-5.69l1.72-1.72a.75.75 0 0 0-1.06-1.06l-3 3Z"
            clipRule="evenodd"
          />
        </svg>
      </Button>
      <Vehicles vehicles={vehicles} />
      <Button isIconOnly className="bg-zinc-900" aria-label="Like">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="currentColor"
          className="w-6 h-6"
        >
          <path
            fillRule="evenodd"
            d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25Zm4.28 10.28a.75.75 0 0 0 0-1.06l-3-3a.75.75 0 1 0-1.06 1.06l1.72 1.72H8.25a.75.75 0 0 0 0 1.5h5.69l-1.72 1.72a.75.75 0 1 0 1.06 1.06l3-3Z"
            clipRule="evenodd"
          />
        </svg>
      </Button>
    </div>
  );
};

export default GarageVehicles;
