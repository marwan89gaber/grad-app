import React, { createContext, useContext, useMemo, useState } from "react";
import { apiRequest } from "../lib/api";

type Session =
  | { isAuthenticated: false; isIncognito: false; user: null }
  | { isAuthenticated: false; isIncognito: true; user: null }
  | {
      isAuthenticated: true;
      isIncognito: false;
      user: { id: string; name: string; email: string; role: "USER" | "LAWYER"; token: string };
    };

type AuthContextValue = {
  session: Session;
  isLoading: boolean;
  startIncognito: () => void;
  login: (email: string, password: string) => Promise<void>;
  signup: (name: string, email: string, password: string, role: "USER" | "LAWYER") => Promise<void>;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider(props: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session>(() => {
    const raw = localStorage.getItem("auth_user");
    if (!raw) return { isAuthenticated: false, isIncognito: false, user: null };
    try {
      const parsed = JSON.parse(raw) as {
        id: string;
        name: string;
        email: string;
        role: "USER" | "LAWYER";
        token: string;
      };
      return { isAuthenticated: true, isIncognito: false, user: parsed };
    } catch {
      return { isAuthenticated: false, isIncognito: false, user: null };
    }
  });
  const [isLoading, setIsLoading] = useState(false);

  const value = useMemo<AuthContextValue>(() => {
    return {
      session,
      isLoading,
      startIncognito: () => setSession({ isAuthenticated: false, isIncognito: true, user: null }),
      login: async (email: string, password: string) => {
        setIsLoading(true);
        try {
          const data = await apiRequest<{
            id: string;
            name: string;
            email: string;
            role: "USER" | "LAWYER";
            token: string;
          }>("/auth/login", {
            method: "POST",
            body: JSON.stringify({ email, password }),
          });
          const user = { id: data.id, name: data.name, email: data.email, role: data.role, token: data.token };
          localStorage.setItem("auth_user", JSON.stringify(user));
          setSession({ isAuthenticated: true, isIncognito: false, user });
        } finally {
          setIsLoading(false);
        }
      },
      signup: async (name: string, email: string, password: string, role: "USER" | "LAWYER") => {
        setIsLoading(true);
        try {
          const data = await apiRequest<{
            id: string;
            name: string;
            email: string;
            role: "USER" | "LAWYER";
            token: string;
          }>("/auth/signup", {
            method: "POST",
            body: JSON.stringify({ name, email, password, role }),
          });
          const user = { id: data.id, name: data.name, email: data.email, role: data.role, token: data.token };
          localStorage.setItem("auth_user", JSON.stringify(user));
          setSession({ isAuthenticated: true, isIncognito: false, user });
        } finally {
          setIsLoading(false);
        }
      },
      logout: () => {
        localStorage.removeItem("auth_user");
        setSession({ isAuthenticated: false, isIncognito: false, user: null });
      },
    };
  }, [session, isLoading]);

  return <AuthContext.Provider value={value}>{props.children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

