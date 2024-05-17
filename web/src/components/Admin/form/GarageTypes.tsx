import { Input, Select, SelectItem } from "@nextui-org/react";
import { InputProps } from "../../../types/types";
import { useAdmin } from "../../../providers/AdminProvider";

const garageTypes = ["public", "job", "gang", "depot"];
const vehicleTypes = ["car", "air", "sea", "rig"];

export default function GarageTypes({ register, errors }: InputProps) {
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

  const isInvalid = (id: string) => (errors[id] ? true : false);

  return (
    <div className="grid grid-cols-3 gap-3 w-full py-2">
      <Input
        {...register("garageName", { required: true })}
        isInvalid={isInvalid("garageName")}
        errorMessage={isInvalid("garageName") && "Bir isim girmelisiniz"}
        type="text"
        variant="bordered"
        label="Garage Name"
        className="text-white"
        defaultValue={garageName}
        onChange={(e) => setGarageName(e.target.value)}
      />
      <Select
        {...register("garageType", { required: true })}
        isRequired
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
        {...register("vehicleType", { required: true })}
        isRequired
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
        {...register("jobName", { required: garageType == "job" })}
        isInvalid={isInvalid("jobName")}
        errorMessage={isInvalid("jobName") && "Bir meslek girin"}
        type="text"
        variant="bordered"
        label="Job Name"
        className={`text-white ${garageType != "job" && "opacity-50"}`}
        disabled={garageType != "job"}
        defaultValue={job}
        onChange={(e) => setJob(e.target.value)}
      />
      <Input
        {...register("jobType", { required: garageType == "job" })}
        isInvalid={isInvalid("jobType")}
        errorMessage={isInvalid("jobType") && "Bir meslek rütbesi"}
        type="text"
        variant="bordered"
        label="Job Type"
        className={`text-white ${garageType != "job" && "opacity-50"}`}
        disabled={garageType != "job"}
        defaultValue={job}
        onChange={(e) => setJobType(e.target.value)}
      />
      <Input
        {...register("limit", { min: 0 })}
        min={0}
        type="number"
        variant="bordered"
        label="Limit"
        className="text-white"
        onChange={(e) => setLimit(e.target.value)}
      />
    </div>
  );
}
