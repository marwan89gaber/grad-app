import { Outlet } from "react-router-dom";
import AppNavbar from "../components/nav/AppNavbar";

export default function AppLayout() {
  return (
    <div className="min-h-dvh bg-slate-50">
      <AppNavbar />
      <main className="mx-auto w-full max-w-5xl px-4 pb-24 pt-4 sm:px-6">{<Outlet />}</main>
    </div>
  );
}

