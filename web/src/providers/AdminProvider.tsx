import React, { createContext, useContext, useEffect, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
// types
import { fetchNui } from "../utils/fetchNui";
import { isEnvBrowser } from "../utils/misc";

const AdminContext = createContext<any>(null);

export const AdminProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [garageName, setGarageName] = useState<string>("");
  const [garageType, setGarageType] = useState<string>("");
  const [vehicleType, setVehicleType] = useState<string>("");
  const [job, setJob] = useState<string>("");
  const [jobType, setJobType] = useState<string>("");
  const [limit, setLimit] = useState<number | null>(null);
  const [blipShow, setBlipShow] = useState<boolean>(true);
  const [blip, setBlip] = useState<any>({ icon: 0, color: 0 });
  const [previewCoords, setPreviewCoords] = useState<string[] | null>(null);
  const [spawnCoord, setSpawnCoord] = useState<string | null>(null);
  const [takeCoord, setTakeCoord] = useState<string | null>(null);
  const [putCoord, setPutCoord] = useState<string | null>(null);
  const [prevCoord, setPrevCoord] = useState<string | null>(null);

  const [visible, setVisible] = useState(false);

  useNuiEvent<any>("adminMenu", setVisible);
  // Handle pressing escape/backspace
  useEffect(() => {
    // Only attach listener when we are visible
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) {
        if (!isEnvBrowser()) fetchNui("hideFrame");
        else setVisible(!visible);
      }
    };

    window.addEventListener("keydown", keyHandler);

    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible]);

  useNuiEvent<any>("toggleAdminUi", (d: any) => {
    setGarageName(d?.garage ?? "");
    setVisible(d.display);
    fetchNui("previewSelectedVehicle", d.vehicles[0]);
  });

  const values: any = {
    garageName,
    setGarageName,
    garageType,
    setGarageType,
    vehicleType,
    setVehicleType,
    job,
    setJob,
    limit,
    setLimit,
    setJobType,
    jobType,
    blipShow,
    setBlipShow,
    previewCoords,
    setPreviewCoords,
    blip,
    setBlip,
    takeCoord,
    setTakeCoord,
    putCoord,
    setPutCoord,
    prevCoord,
    setPrevCoord,
    spawnCoord,
    setSpawnCoord,
    visible,
    setVisible,
  };

  return (
    <AdminContext.Provider value={values}>
      <div className={`${visible ? "visible w-full h-full" : "hidden"}`}>
        {children}
      </div>
    </AdminContext.Provider>
  );
};

export const useAdmin = () => useContext<any>(AdminContext);
