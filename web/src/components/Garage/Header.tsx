import { memo } from "react";
import { useGarage } from "../../providers/GarageProvider";

const Header = () => {
  const { garageName } = useGarage();
  return (
    <header className="flex justify-center items-center p-2 bg-gradient-to-b from-amber-600/20 to-transparent select-none">
      <span className="font-extrabold text-6xl text-amber-400 drop-shadow-[0_0_15px]">
        {garageName}
      </span>
    </header>
  );
};

export default memo(Header);
