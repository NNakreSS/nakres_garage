import { AdminProvider } from "../../providers/AdminProvider";
import Form from "./form";

function Admin() {
  return (
    <AdminProvider>
      <div className="w-full h-full flex items-center justify-center">
        <div className="w-2/3 bg-black p-5 rounded-lg">
          <h2 className="text-white text-4xl">Create Garage</h2>
          <Form />
        </div>
      </div>
    </AdminProvider>
  );
}

export default Admin;
