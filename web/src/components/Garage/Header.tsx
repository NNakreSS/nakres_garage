import { useGarage } from "../../providers/GarageProvider";

const Header = () => {
  const { garageName } = useGarage();
  return (
    <header className="flex justify-center items-center p-2 bg-gradient-to-b from-amber-500/20 to-transparent select-none">
      <span className="font-extrabold text-3xl text-amber-400 drop-shadow-2xl shadow-slate-100">
        {garageName}
      </span>
    </header>
  );
};

export default Header;
