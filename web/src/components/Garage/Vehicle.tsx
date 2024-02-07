import { Button, Progress } from "@nextui-org/react";
import { useGarage } from "../../providers/GarageProvider";

const Vehicle = () => {
  const { selectedVehicle } = useGarage();

  return (
    <div className="grid grid-rows-1 grid-cols-[75%_25%]">
      <div id="move-preview"></div>
      <div className="grid grid-cols-1 grid-rows-[80%_10%] gap-5 px-3 select-none">
        <div className="bg-zinc-900/95 w-full h-full rounded-md grid grid-cols-1 grid-rows-6 p-10 gap-2 shadow-lg shadow-black place-content-center place-items-center">
          <div className="grid grid-cols-1 grid-rows-2 w-full h-full gap-1 border-l-3 border-amber-400 p-2 bg-gradient-to-r from-amber-400/20 to-transparent">
            <span
              id="vehicleName"
              className="text-amber-400 font-bold flex items-center text-lg"
            >
              {selectedVehicle?.displayName.toLocaleUpperCase()}
            </span>
            <span
              id="vehiclePlate"
              className="text-start  text-gray-400 flex items-center text-sm"
            >
              {selectedVehicle?.plate}
            </span>
          </div>
          {[
            selectedVehicle?.acceleration,
            selectedVehicle?.traction,
            selectedVehicle?.brakes,
            selectedVehicle?.enginePercent,
            selectedVehicle?.topSpeed,
          ].map((value, key) => (
            <Progress
              key={key}
              size="md"
              radius="md"
              classNames={{
                base: "max-w-md",
                track: "drop-shadow-md border border-default",
                indicator: "bg-gradient-to-r from-pink-500 to-yellow-500",
                label: "tracking-wider font-medium text-default-600",
                value: "text-foreground/60",
              }}
              label={key}
              value={value}
              showValueLabel={true}
            />
          ))}
        </div>
        <Button className="bg-zinc-950  text-amber-400  outline-none ring-2 ring-black font-bold text-lg shadow-lg shadow-black/90 h-2/3">
          Spawn
        </Button>
      </div>
    </div>
  );
};

export default Vehicle;
