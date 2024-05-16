import BlipTypes from "./BlipTypes";
import Coords from "./Coords";
import GarageTypes from "./GarageTypes";

function Form() {
  return (
    <form action="">
      <hr className="my-2" />
      <div className="space-y-5">
        <GarageTypes />
        <hr className="my-2" />
        <BlipTypes />
        <hr className="my-2" />
        <Coords />
      </div>
    </form>
  );
}

export default Form;
