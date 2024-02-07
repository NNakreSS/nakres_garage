import { Button, Progress } from "@nextui-org/react";

const Vehicle = () => {
  const vehicleInfo = {
    motor: 70,
    hız: 65,
    fren: 50,
    hızlanma: 40,
    tutuş: 80,
  };

  return (
    <div className="grid grid-rows-1 grid-cols-[75%_25%]">
      <div id="move-preview"></div>
      <div className="grid grid-cols-1 grid-rows-[80%_10%] gap-5 px-3">
        <div>
          <div className="bg-zinc-900 w-full h-full rounded-md grid grid-cols-1 grid-rows-5 p-10 gap-5 shadow-2xl shadow-black place-content-center place-items-center">
            {Object.entries(vehicleInfo).map(([key, value]) => (
              <Progress
                key={key}
                size="sm"
                radius="sm"
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
        </div>
        <Button className="bg-zinc-800 hover:bg-black text-white  outline-none ring-2 ring-black font-bold text-xl shadow-lg shadow-black/90 h-2/3">
          Spawn
        </Button>
      </div>
    </div>
  );
};

export default Vehicle;
