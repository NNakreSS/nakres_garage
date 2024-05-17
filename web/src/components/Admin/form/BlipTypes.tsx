import { Checkbox, Input } from "@nextui-org/react";
import { useAdmin } from "../../../providers/AdminProvider";
import { InputProps } from "../../../types/types";

function BlipTypes({ errors, register }: InputProps) {
  const { blipShow, setBlipShow } = useAdmin();
  const isInvalid = (id: string) => (errors[id] ? true : false);

  return (
    <div className="flex gap-3 w-full py-2">
      <Checkbox
        {...register("blipShow")}
        defaultSelected={blipShow}
        onChange={(e) => setBlipShow(e.target.checked)}
      >
        Blip
      </Checkbox>
      <Input
        {...register("blipName", { required: blipShow })}
        isInvalid={isInvalid("blipName")}
        errorMessage={isInvalid("blipName") && "Blip ismi belirtmelisin"}
        type="text"
        variant="bordered"
        label="Blip name"
        className={`text-white ${!blipShow && "opacity-50"}`}
        disabled={!blipShow}
      />
      <Input
        {...register("blipIcon", { required: blipShow })}
        isInvalid={isInvalid("blipIcon")}
        errorMessage={isInvalid("blipIcon") && "Blip iconu belirtmelisin"}
        type="number"
        variant="bordered"
        label="Blip"
        min={0}
        max={883}
        className={`text-white ${!blipShow && "opacity-50"}`}
        disabled={!blipShow}
      />
      <Input
        {...register("blipColor", { required: blipShow })}
        isInvalid={isInvalid("blipColor")}
        errorMessage={isInvalid("blipColor") && "Blip rengi belirtmelisin"}
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
