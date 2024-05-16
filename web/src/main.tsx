import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";
// ui kit
import { NextUIProvider } from "@nextui-org/react";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <NextUIProvider>
    <App />
  </NextUIProvider>
);
