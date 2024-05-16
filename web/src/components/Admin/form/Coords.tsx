import { Button, Input, Snippet } from "@nextui-org/react";
import CoordsModal from "./CoordsModal";
import { fetchNui } from "../../../utils/fetchNui";
import { useAdmin } from "../../../providers/AdminProvider";
import { useState } from "react";
import copyTextToClipboard from "../../../utils/copToClipBoard";

function Coords() {
  const { setVisible } = useAdmin();
  const [coord, setCoord] = useState<string>("");

  const coordHandler = () => {
    setVisible(false);
    fetchNui("takeCoord", { object: "adder", limit: 1 }).then((coords: any) => {
      setVisible(true);
      if (coords) {
        const coord = JSON.parse(coords)[0];
        const vector4 = `vector4(${coord.x},${coord.y},${coord.z},${coord.w})`;
        setCoord(vector4);
        console.log("This Coords", vector4);
      }
    });
  };

  const copyHandler = () => {
    copyTextToClipboard(coord);
  };

  return (
    <div className="space-y-5 py-2 text-white">
      <div className="grid grid-cols-4 gap-3">
        <Input type="text" variant="bordered" label="Spawn Coord" />
        <Input type="text" variant="bordered" label="Take Coord" />
        <Input type="text" variant="bordered" label="Put Coord" />
        <Input type="text" variant="bordered" label="Preview Coord" />
      </div>
      <div className="flex items-center justify-between">
        <div className="space-x-2">
          <h5 className="text-2xl ml-2 mb-2">Preview Coords</h5>
          <Button variant="faded" color="warning">
            Add
          </Button>
          <CoordsModal />
        </div>
        <div className="flex flex-col gap-2">
          <div className="space-x-2">
            {coord && (
              <Snippet
                symbol="🧭"
                onCopy={copyHandler}
                variant="bordered"
                color="warning"
              >
                {coord}
              </Snippet>
            )}
            <Button variant="faded" color="warning" onClick={coordHandler}>
              Take Coord (vector4)
            </Button>
          </div>
          <Button variant="faded" color="primary" type="submit">
            Save Garage
          </Button>
        </div>
      </div>
    </div>
  );
}

export default Coords;
