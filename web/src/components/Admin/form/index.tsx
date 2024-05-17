import BlipTypes from "./BlipTypes";
import Coords from "./Coords";
import GarageTypes from "./GarageTypes";
import { useForm, SubmitHandler } from "react-hook-form";

function Form() {
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<any>();

  const onSubmit: SubmitHandler<any> = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <hr className="my-2" />
      <div className="space-y-5">
        <GarageTypes register={register} errors={errors} />
        <hr className="my-2" />
        <BlipTypes register={register} errors={errors} />
        <hr className="my-2" />
        <Coords register={register} errors={errors} />
      </div>
    </form>
  );
}

export default Form;
