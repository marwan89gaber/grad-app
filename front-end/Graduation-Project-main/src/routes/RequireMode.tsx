import { ReactNode } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

type Mode = "authed" | "incognitoOrAuthed";

export default function RequireMode(props: { mode: Mode; children: ReactNode }) {
  const { mode, children } = props;
  const auth = useAuth();
  const location = useLocation();

  if (mode === "authed") {
    if (!auth.session.isAuthenticated) {
      return <Navigate to="/" replace state={{ from: location.pathname }} />;
    }
  }

  if (mode === "incognitoOrAuthed") {
    if (!auth.session.isAuthenticated && !auth.session.isIncognito) {
      return <Navigate to="/" replace state={{ from: location.pathname }} />;
    }
  }

  return <>{children}</>;
}

