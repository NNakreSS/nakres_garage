import ReactDOM from "react-dom/client";
import { VisibilityProvider } from "./providers/VisibilityProvider";
import App from "./App";
import "./index.css";
// ui kit
import { NextUIProvider } from "@nextui-org/react";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <VisibilityProvider>
    <NextUIProvider>
      <App />
    </NextUIProvider>
  </VisibilityProvider>
);
