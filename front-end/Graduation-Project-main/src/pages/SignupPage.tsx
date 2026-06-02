import { FormEvent, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Button from "../components/ui/Button";
import Card from "../components/ui/Card";
import Input from "../components/ui/Input";
import { useAuth } from "../context/AuthContext";

export default function SignupPage() {
  const auth = useAuth();
  const navigate = useNavigate();
  const [name, setName] = useState("Ava Johnson");
  const [email, setEmail] = useState("ava@example.com");
  const [password, setPassword] = useState("password");
  const [role, setRole] = useState<"USER" | "LAWYER">("USER");
  const [error, setError] = useState<string | null>(null);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    try {
      await auth.signup(name, email, password, role);
      navigate("/app/chat");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Signup failed");
    }
  }

  return (
    <div className="min-h-dvh bg-slate-50">
      <div className="mx-auto flex w-full max-w-md flex-col gap-6 px-4 py-10">
        <Link to="/" className="text-sm font-medium text-slate-700 hover:text-slate-900">
          ← Back to landing
        </Link>

        <Card className="p-6">
          <div className="mb-6">
            <div className="text-xl font-semibold tracking-tight">Create your account</div>
            <div className="mt-1 text-sm text-slate-600">Sign up to access chat and lawyers.</div>
          </div>

          <form className="flex flex-col gap-4" onSubmit={onSubmit}>
            {error ? <div className="rounded-xl bg-rose-50 px-3 py-2 text-sm text-rose-800">{error}</div> : null}
            <div className="flex flex-col gap-2">
              <label className="text-xs font-medium text-slate-700">Full name</label>
              <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Your name" />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-xs font-medium text-slate-700">Email</label>
              <Input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@example.com" />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-xs font-medium text-slate-700">Password</label>
              <Input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Create a password"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-xs font-medium text-slate-700">Role</label>
              <select
                value={role}
                onChange={(e) => setRole(e.target.value as "USER" | "LAWYER")}
                className="h-11 rounded-xl bg-white px-4 text-sm ring-1 ring-slate-200 focus:outline-none focus:ring-2 focus:ring-slate-900"
              >
                <option value="USER">USER</option>
                <option value="LAWYER">LAWYER</option>
              </select>
            </div>

            <Button type="submit" className="w-full" disabled={auth.isLoading}>
              {auth.isLoading ? "Creating account..." : "Sign up"}
            </Button>

            <div className="text-center text-xs text-slate-600">
              Already have an account?{" "}
              <Link to="/login" className="font-medium text-slate-900 hover:underline">
                Log in
              </Link>
            </div>
          </form>
        </Card>
      </div>
    </div>
  );
}

