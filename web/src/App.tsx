import React from "react";
import { debugData } from "./utils/debugData";
// components
import Garage from "./components/Garage";

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

const App: React.FC = () => {
  return (
    <div className="w-screen h-screen dark text-background">
      <Garage />
    </div>
  );
};

export default App;
