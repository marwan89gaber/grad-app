import { useNavigate } from "react-router-dom";
import Button from "../components/ui/Button";
import Card from "../components/ui/Card";
import { useAuth } from "../context/AuthContext";

export default function LandingPage() {
  const navigate = useNavigate();
  const auth = useAuth();

  return (
    <div className="min-h-dvh bg-slate-50">
      <div className="mx-auto flex w-full max-w-5xl flex-col gap-10 px-4 py-10 sm:px-6 sm:py-14">
        <header className="flex flex-col gap-3">
          <div className="inline-flex w-fit items-center gap-2 rounded-full bg-white px-4 py-2 text-xs font-medium text-slate-700 ring-1 ring-slate-200">
             frontend prototype 
          </div>
          <h1 className="text-pretty text-3xl font-semibold tracking-tight text-slate-900 sm:text-4xl">
            Legal Consultation Platform
          </h1>
          <p className="max-w-2xl text-pretty text-sm leading-6 text-slate-600 sm:text-base">
            Chat with a legal assistant and browse lawyers with the live backend API.
          </p>
        </header>

        <section className="grid gap-4 sm:grid-cols-3">
          <Card className="flex flex-col gap-3">
            <div className="text-sm font-semibold">Incognito</div>
            <div className="text-sm text-slate-600">
              Access the chat only. <span className="font-medium">Login/Signup required to access lawyers.</span>
            </div>
            <div className="mt-2">
              <Button
                onClick={() => {
                  auth.startIncognito();
                  navigate("/app/chat");
                }}
                className="w-full"
              >
                Continue incognito
              </Button>
            </div>
          </Card>

          <Card className="flex flex-col gap-3">
            <div className="text-sm font-semibold">Log in</div>
            <div className="text-sm text-slate-600">Unlock chat + lawyers, profile, and bookings.</div>
            <div className="mt-2">
              <Button variant="secondary" onClick={() => navigate("/login")} className="w-full">
                Go to login
              </Button>
            </div>
          </Card>

          <Card className="flex flex-col gap-3">
            <div className="text-sm font-semibold">Sign up</div>
            <div className="text-sm text-slate-600">Create an account to access the full app.</div>
            <div className="mt-2">
              <Button variant="secondary" onClick={() => navigate("/signup")} className="w-full">
                Create account
              </Button>
            </div>
          </Card>
        </section>

        <footer className="text-xs text-slate-500">Tip: Backend must run on http://localhost:4000.</footer>
      </div>
    </div>
  );
}

