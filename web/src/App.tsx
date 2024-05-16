import React from "react";
import { debugData } from "./utils/debugData";
// components
import Garage from "./components/Garage";
import Admin from "./components/Admin";
import TakeCoord from "./components/TakeCoord";

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: "adminMenu",
    data: true,
  },
]);

const App: React.FC = () => {
  return (
    <div className="w-screen h-screen dark text-background">
      <Garage />
      <Admin />
      <TakeCoord />
    </div>
  );
};

export default App;
