import { memo, useEffect, useRef } from "react";
// ui
import { Button, Progress } from "@nextui-org/react";
// context
import { useGarage } from "../../providers/GarageProvider";
// utils
import { fetchNui } from "../../utils/fetchNui";
// icons
import { GiTireTracks } from "react-icons/gi";
import { SiCarthrottle } from "react-icons/si";
import { MdTireRepair } from "react-icons/md";
import { PiEngineFill } from "react-icons/pi";
import { IoSpeedometer } from "react-icons/io5";

const Vehicle = () => {
  const { selectedVehicle, locale, garageLimit, garageVehicles } = useGarage();

  console.log(garageLimit);

  const moveContainer = useRef<HTMLDivElement>(null);
  const isClickMoveContainer = useRef<boolean>(false);

  useEffect(() => {
    const handleMouseMove = (event: MouseEvent) => {
      if (isClickMoveContainer.current) {
        const movementMouse = event.movementX;
        const rotate = movementMouse * 0.1;
        fetchNui("setPreviewVehicleHeading", rotate);
      }
    };

    const handleMouseDown = () => {
      isClickMoveContainer.current = true;
    };

    const handleMouseUp = () => {
      isClickMoveContainer.current = false;
    };

    const handleMouseLeave = () => {
      isClickMoveContainer.current = false;
    };

    const container = moveContainer.current;
    if (container) {
      container.addEventListener("mousedown", handleMouseDown);
      container.addEventListener("mouseup", handleMouseUp);
      container.addEventListener("mouseleave", handleMouseLeave);
      container.addEventListener("mousemove", handleMouseMove);
      return () => {
        container.removeEventListener("mouseleave", handleMouseLeave);
        container.removeEventListener("mousedown", handleMouseDown);
        container.removeEventListener("mouseup", handleMouseUp);
        container.removeEventListener("mousemove", handleMouseMove);
      };
    }
  }, []);

  const stats = {
    accelaration: selectedVehicle?.acceleration,
    traction: selectedVehicle?.traction,
    brakes: selectedVehicle?.brakes,
    enginePercent: selectedVehicle?.enginePercent,
    topSpeed: selectedVehicle?.topSpeed,
  };

  const iconsClass = "tracking-wider text-amber-500 text-2xl";
  const icons: Record<string, JSX.Element> = {
    accelaration: <SiCarthrottle className={iconsClass} />,
    traction: <MdTireRepair className={iconsClass} />,
    brakes: <GiTireTracks className={iconsClass} />,
    enginePercent: <PiEngineFill className={iconsClass} />,
    topSpeed: <IoSpeedometer className={iconsClass} />,
  };

  return (
    <div className="grid grid-rows-1 grid-cols-[80%_20%]">
      <div
        id="move-preview"
        className="cursor-col-resize relative"
        ref={moveContainer}
      >
        {garageLimit && (
          <div className="font-mono absolute left-10 bottom-10 select-none grid grid-cols-1 grid-rows-2 border-l-4 border-amber-400 gap-1 p-1 pl-3 rounded-sm bg-gradient-to-r from-amber-400/20 via-amber-400/5 to-transparent">
            <span className="text-5xl text-amber-400 font-extrabold">
              {locale?.limit}
            </span>
            <div className="text-4xl text-white font-bold">
              <span className="text-red-500">{garageLimit}</span> /{" "}
              <span className="text-green-500">{garageVehicles.length}</span>
            </div>
          </div>
        )}
      </div>
      <div className="grid grid-cols-1 grid-rows-[80%_10%] gap-5 px-3 select-none">
        <div className="bg-zinc-900/95 w-full h-full rounded-md grid grid-cols-1 grid-rows-6 p-5 gap-2 shadow-lg shadow-black place-content-center place-items-center">
          <div className="grid grid-cols-1 h-3/4 grid-rows-2 w-full border-l-3 border-amber-400 p-1 pl-5  bg-gradient-to-r from-amber-400/20 to-transparent">
            <span
              id="vehicleName"
              className="text-amber-400 font-extrabold flex items-center "
            >
              {selectedVehicle?.displayName.toLocaleUpperCase()}
            </span>
            <span
              id="vehiclePlate"
              className="text-start  text-foreground/60 flex items-center font-semibold text-sm"
            >
              {selectedVehicle?.plate}
            </span>
          </div>
          {Object.entries(stats).map(([key, value]) => (
            <Progress
              key={key}
              size="md"
              radius="sm"
              classNames={{
                base: "max-w-xl",
                track: "drop-shadow-md border border-default",
                indicator: "bg-gradient-to-r from-red-500 to-amber-500",
                value: "text-foreground/60",
              }}
              label={icons[key]}
              value={value}
              showValueLabel={true}
            />
          ))}
        </div>
        <Button
          onClick={() => fetchNui("spawnSelectedVehicle", selectedVehicle)}
          className="bg-zinc-900  text-amber-400  outline-none font-bold text-lg shadow-lg shadow-black/90 h-2/3"
        >
          {locale?.spawn}
        </Button>
      </div>
    </div>
  );
};

export default memo(Vehicle);
