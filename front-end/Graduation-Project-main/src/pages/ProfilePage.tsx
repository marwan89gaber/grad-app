import { useEffect, useState } from "react";
import Card from "../components/ui/Card";
import Divider from "../components/ui/Divider";
import { useAuth } from "../context/AuthContext";
import { apiRequest } from "../lib/api";

type Profile = {
  id: string;
  email: string;
  name: string;
  role: "USER" | "LAWYER";
  profilePicture?: string | null;
  createdAt: string;
  updatedAt: string;
};

export default function ProfilePage() {
  const auth = useAuth();
  const [profile, setProfile] = useState<Profile | null>(null);

  useEffect(() => {
    const run = async () => {
      if (!auth.session.isAuthenticated) return;
      try {
        const data = await apiRequest<Profile>("/auth/profile", {}, auth.session.user.token);
        setProfile(data);
      } catch {
        setProfile(null);
      }
    };
    void run();
  }, [auth.session]);

  if (!auth.session.isAuthenticated) return null;
  const user = profile || auth.session.user;

  return (
    <div className="flex flex-col gap-4">
      <div>
        <div className="text-lg font-semibold tracking-tight">Profile</div>
        <div className="text-sm text-slate-600">Live profile loaded from backend.</div>
      </div>

      <Card>
        <div className="flex items-start gap-4">
          <div className="grid h-14 w-14 place-items-center rounded-2xl bg-slate-900 text-white shadow-soft">
            <span className="text-base font-semibold">{user.name.split(" ").map((p) => p[0]).slice(0, 2).join("")}</span>
          </div>
          <div className="flex-1">
            <div className="text-sm font-semibold">{user.name}</div>
            <div className="mt-1 text-sm text-slate-600">{user.email}</div>
          </div>
        </div>

        <div className="my-4">
          <Divider />
        </div>

        <div className="grid gap-3 text-sm text-slate-700 sm:grid-cols-2">
          <div>
            <div className="text-xs font-medium text-slate-600">Plan</div>
            <div className="mt-1">{user.role}</div>
          </div>
          <div>
            <div className="text-xs font-medium text-slate-600">Member since</div>
            <div className="mt-1">{profile ? new Date(profile.createdAt).toLocaleDateString() : "N/A"}</div>
          </div>
        </div>
      </Card>
    </div>
  );
}

