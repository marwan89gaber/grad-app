import { Link, NavLink, useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import Button from "../ui/Button";
import { cn } from "../../lib/cn";

function IconChat(props: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={cn("h-5 w-5", props.className)} fill="none" stroke="currentColor">
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M7 8h10M7 12h6m-8 9 3-3h11a4 4 0 0 0 4-4V7a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v10a4 4 0 0 0 4 4z" />
    </svg>
  );
}

function IconUsers(props: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={cn("h-5 w-5", props.className)} fill="none" stroke="currentColor">
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2M21 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z" />
    </svg>
  );
}

function IconSettings(props: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={cn("h-5 w-5", props.className)} fill="none" stroke="currentColor">
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" />
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M19.4 15a7.97 7.97 0 0 0 .1-1 7.97 7.97 0 0 0-.1-1l2.1-1.6-2-3.4-2.6 1a8.3 8.3 0 0 0-1.7-1L13 2h-4l-.6 2.6a8.3 8.3 0 0 0-1.7 1l-2.6-1-2 3.4L4.2 11a7.97 7.97 0 0 0-.1 1 7.97 7.97 0 0 0 .1 1L2.1 14.6l2 3.4 2.6-1a8.3 8.3 0 0 0 1.7 1L9 22h4l.6-2.6a8.3 8.3 0 0 0 1.7-1l2.6 1 2-3.4-2.1-1.6z" />
    </svg>
  );
}

function IconHistory(props: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={cn("h-5 w-5", props.className)} fill="none" stroke="currentColor">
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M3 12a9 9 0 1 0 3-6.7M3 3v6h6" />
      <path strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" d="M12 7v5l3 3" />
    </svg>
  );
}

const navItemClass = ({ isActive }: { isActive: boolean }) =>
  cn(
    "flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition-colors",
    isActive ? "bg-slate-900 text-white" : "text-slate-700 hover:bg-slate-100"
  );

export default function AppNavbar() {
  const auth = useAuth();
  const navigate = useNavigate();

  const canAccessLawyers = auth.session.isAuthenticated;
  const showAppNav = auth.session.isAuthenticated || auth.session.isIncognito;

  if (!showAppNav) return null;

  return (
    <header className="sticky top-0 z-10 border-b border-slate-200 bg-white/80 backdrop-blur">
      <div className="mx-auto flex w-full max-w-5xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
        <Link to="/app/chat" className="flex items-center gap-2">
          <div className="grid h-9 w-9 place-items-center rounded-xl bg-slate-900 text-white shadow-soft">
            <span className="text-sm font-semibold">LC</span>
          </div>
          <div className="hidden sm:block">
            <div className="text-sm font-semibold leading-4">Legal Consult</div>
            <div className="text-xs text-slate-500">Frontend prototype</div>
          </div>
        </Link>

        <nav className="hidden items-center gap-1 sm:flex">
          <NavLink to="/app/chat" className={navItemClass}>
            <IconChat />
            Chat
          </NavLink>
          <NavLink to="/app/history" className={navItemClass}>
            <IconHistory />
            History
          </NavLink>
          {canAccessLawyers ? (
            <NavLink to="/app/lawyers" className={navItemClass}>
              <IconUsers />
              Lawyers
            </NavLink>
          ) : (
            <div className="flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium text-slate-400" title="Login/Signup required to access lawyers">
              <IconUsers />
              Lawyers
            </div>
          )}
          <NavLink to="/app/settings" className={navItemClass}>
            <IconSettings />
            Settings
          </NavLink>
        </nav>

        <div className="flex items-center gap-2">
          {auth.session.isAuthenticated ? (
            <>
              <Button variant="secondary" size="sm" onClick={() => navigate("/app/profile")}>
                Profile
              </Button>
              <Button variant="ghost" size="sm" onClick={() => auth.logout()}>
                Logout
              </Button>
            </>
          ) : (
            <Button variant="secondary" size="sm" onClick={() => navigate("/")}>
              Exit incognito
            </Button>
          )}
        </div>
      </div>

      <nav className="fixed bottom-0 left-0 right-0 z-10 border-t border-slate-200 bg-white sm:hidden">
        <div className="mx-auto grid max-w-5xl grid-cols-4 gap-1 px-2 py-2">
          <NavLink to="/app/chat" className={navItemClass}>
            <IconChat />
            <span className="text-xs">Chat</span>
          </NavLink>
          <NavLink to="/app/history" className={navItemClass}>
            <IconHistory />
            <span className="text-xs">History</span>
          </NavLink>
          {canAccessLawyers ? (
            <NavLink to="/app/lawyers" className={navItemClass}>
              <IconUsers />
              <span className="text-xs">Lawyers</span>
            </NavLink>
          ) : (
            <Link
              to="/app/chat"
              className={cn("flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium text-slate-400")}
              title="Login/Signup required to access lawyers"
            >
              <IconUsers />
              <span className="text-xs">Lawyers</span>
            </Link>
          )}
          <NavLink to="/app/settings" className={navItemClass}>
            <IconSettings />
            <span className="text-xs">Settings</span>
          </NavLink>
        </div>
      </nav>
    </header>
  );
}

