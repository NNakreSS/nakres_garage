import { Input, Select, SelectItem } from "@nextui-org/react";
import { useAdmin } from "../../../providers/AdminProvider";

const garageTypes = ["public", "job", "gang", "depot"];
const vehicleTypes = ["car", "air", "sea", "rig"];

export default function GarageTypes() {
  const {
    garageName,
    setGarageName,
    garageType,
    setGarageType,
    setVehicleType,
    vehicleType,
    setJob,
    job,
    setLimit,
    setJobType,
  } = useAdmin();

  return (
    <div className="grid grid-cols-3 gap-3 w-full py-2">
      <Input
        type="text"
        variant="bordered"
        label="Garage Name"
        className="text-white"
        defaultValue={garageName}
        onChange={(e) => setGarageName(e.target.value)}
      />
      <Select
        label="Garage Type"
        placeholder="Select an type"
        labelPlacement="inside"
        className="text-white"
        defaultSelectedKeys={garageType}
        onChange={(e) => setGarageType(e.target.value)}
      >
        {garageTypes.map((_type) => (
          <SelectItem key={_type} value={_type}>
            {_type}
          </SelectItem>
        ))}
      </Select>
      <Select
        label="Vehicle Type"
        placeholder="Select an type"
        labelPlacement="inside"
        className="text-white"
        defaultSelectedKeys={vehicleType}
        onChange={(e) => setVehicleType(e.target.value)}
      >
        {vehicleTypes.map((_type) => (
          <SelectItem key={_type} value={_type}>
            {_type}
          </SelectItem>
        ))}
      </Select>
      <Input
        type="text"
        variant="bordered"
        label="Job Name"
        className={`text-white ${garageType != "job" && "opacity-50"}`}
        disabled={garageType != "job"}
        defaultValue={job}
        onChange={(e) => setJob(e.target.value)}
      />
      <Input
        type="text"
        variant="bordered"
        label="Job Type"
        className={`text-white ${garageType != "job" && "opacity-50"}`}
        disabled={garageType != "job"}
        defaultValue={job}
        onChange={(e) => setJobType(e.target.value)}
      />
      <Input
        type="number"
        variant="bordered"
        label="Limit"
        className="text-white"
        onChange={(e) => setLimit(e.target.value)}
      />
    </div>
  );
}
