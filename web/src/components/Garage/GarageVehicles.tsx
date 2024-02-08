import React, { useEffect, useRef, useState } from "react";
// UI kits
import { Button, Card, CardBody, CardFooter } from "@nextui-org/react";
import classNames from "classnames";
// context
import { useGarage } from "../../providers/GarageProvider";
// utils
import { fetchNui } from "../../utils/fetchNui";

type scrollRefType = {
  scrollRef: React.RefObject<HTMLDivElement>;
};

const Vehicles: React.FC<scrollRefType> = ({ scrollRef }) => {
  const { selectedVehicle, selectVehicle, garageVehicles } = useGarage();

  useEffect(() => {
    if (selectedVehicle) fetchNui("previewSelectedVehicle", selectedVehicle);
  }, [selectedVehicle?.plate]);

  return (
    <div
      ref={scrollRef}
      className="grid grid-rows-1 h-full w-full grid-flow-col place-content-start gap-5 p-[10px] overflow-x-hidden"
    >
      {garageVehicles.map((vehicle, index) => (
        <Card
          shadow="sm"
          key={index}
          isPressable
          onPress={() => selectVehicle(vehicle)}
          className={classNames(
            "h-full w-48 hover:scale-110 border border-black bg-zinc-900/80",
            {
              "border-amber-500": vehicle.plate === selectedVehicle?.plate,
            }
          )}
        >
          <CardBody className="w-full h-3/4 flex justify-center items-center box-border p-3">
            <img
              className={classNames(
                "w-full h-full object-contain p-2 shadow-md shadow-black rounded-lg",
                {
                  "bg-gradient-to-t from-amber-500/20 to-transparent via-transparent":
                    vehicle.plate === selectedVehicle?.plate,
                }
              )}
              src={`https://docs.fivem.net/vehicles/${vehicle.name}.webp`}
            />
          </CardBody>
          <CardFooter
            className={classNames("text-small justify-between h-1/4", {
              "text-amber-400": vehicle.plate === selectedVehicle?.plate,
            })}
          >
            <b>{vehicle.displayName.toUpperCase()}</b>
            <p className="text-default-500 pr-2">{vehicle.plate}</p>
          </CardFooter>
        </Card>
      ))}
    </div>
  );
};

const GarageVehicles: React.FC = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const [isScrolling, setIsScrolling] = useState<boolean>(false);

  const handleScroll = (direction: "left" | "right") => {
    const container = containerRef?.current;
    if (!isScrolling && container) {
      setIsScrolling(true);
      const scrollAmount = container.clientWidth * 0.75;
      const scrollLeft =
        direction === "left"
          ? container.scrollLeft - scrollAmount
          : container.scrollLeft + scrollAmount;

      container.scrollTo({
        left: scrollLeft,
        behavior: "smooth",
      });
      setTimeout(() => {
        setIsScrolling(false);
      }, 500);
    }
  };

  return (
    <div className="h-full grid grid-rows-1 grid-cols-[5%_90%_5%] place-content-center place-items-center select-none">
      <Button
        onClick={() => handleScroll("left")}
        isIconOnly
        className="bg-zinc-900 text-amber-400 shadow-lg shadow-black"
        aria-label="Like"
      >
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
      <Vehicles scrollRef={containerRef} />
      <Button
        onClick={() => handleScroll("right")}
        isIconOnly
        className="bg-zinc-900 text-amber-400 shadow-lg shadow-black"
        aria-label="Like"
      >
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
