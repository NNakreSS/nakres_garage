import { Checkbox, Input } from "@nextui-org/react";
import { useAdmin } from "../../../providers/AdminProvider";

function BlipTypes() {
  const { blipShow, setBlipShow } = useAdmin();
  console.log(blipShow);
  return (
    <div className="flex gap-3 w-full py-2">
      <Checkbox
        defaultSelected={blipShow}
        onChange={(e) => setBlipShow(e.target.checked)}
      >
        Blip
      </Checkbox>
      <Input
        type="text"
        variant="bordered"
        label="Blip name"
        className={`text-white ${!blipShow && "opacity-50"}`}
        disabled={!blipShow}
      />
      <Input
        type="number"
        variant="bordered"
        label="Blip"
        min={0}
        max={883}
        className={`text-white ${!blipShow && "opacity-50"}`}
        disabled={!blipShow}
      />
      <Input
        type="number"
        variant="bordered"
        label="Blip Color"
        min={0}
        max={85}
        className={`text-white ${!blipShow && "opacity-50"}`}
        disabled={!blipShow}
      />
    </div>
  );
}

export default BlipTypes;
