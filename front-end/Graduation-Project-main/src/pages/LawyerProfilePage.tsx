import { useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import Card from "../components/ui/Card";
import Button from "../components/ui/Button";
import Badge from "../components/ui/Badge";
import Divider from "../components/ui/Divider";
import { apiRequest } from "../lib/api";

type ApiLawyerDetails = {
  id: string;
  city: string;
  specialization: string;
  rating: number;
  availability: boolean;
  user: {
    id: string;
    name: string;
    email: string;
    profilePicture?: string | null;
  };
};

export default function LawyerProfilePage() {
  const { lawyerId } = useParams();
  const navigate = useNavigate();
  const [lawyer, setLawyer] = useState<ApiLawyerDetails | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const run = async () => {
      if (!lawyerId) return;
      setLoading(true);
      try {
        const data = await apiRequest<ApiLawyerDetails>(`/lawyers/${lawyerId}`);
        setLawyer(data);
      } catch {
        setLawyer(null);
      } finally {
        setLoading(false);
      }
    };
    void run();
  }, [lawyerId]);

  if (loading) {
    return (
      <Card>
        <div className="text-sm text-slate-600">Loading lawyer details...</div>
      </Card>
    );
  }

  if (!lawyer) {
    return (
      <Card>
        <div className="text-sm font-semibold">Lawyer not found</div>
        <div className="mt-2 text-sm text-slate-600">Return to the lawyers list.</div>
        <div className="mt-4">
          <Button variant="secondary" onClick={() => navigate("/app/lawyers")}>
            Back to lawyers
          </Button>
        </div>
      </Card>
    );
  }

  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-start justify-between gap-3">
        <div>
          <Link to="/app/lawyers" className="text-sm font-medium text-slate-700 hover:text-slate-900">
            ← Back to lawyers
          </Link>
          <div className="mt-2 text-xl font-semibold tracking-tight">{lawyer.user.name}</div>
          <div className="mt-1 text-sm text-slate-600">{lawyer.specialization}</div>
          <div className="mt-3 flex flex-wrap gap-2">
            <Badge>{lawyer.city}</Badge>
            <Badge>{lawyer.specialization}</Badge>
            <Badge className={lawyer.availability ? "bg-emerald-100 text-emerald-800" : "bg-slate-200 text-slate-700"}>
              {lawyer.availability ? "Available" : "Unavailable"}
            </Badge>
          </div>
        </div>

        <div className="hidden sm:block">
          <div className="grid h-20 w-20 place-items-center rounded-2xl bg-slate-900 text-white shadow-soft">
            <span className="text-lg font-semibold">{lawyer.user.name.split(" ").map((p) => p[0]).slice(0, 2).join("")}</span>
          </div>
        </div>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Card className="sm:col-span-2">
          <div className="text-sm font-semibold">Contact info</div>
          <Divider />
          <div className="mt-3 grid gap-3 text-sm">
            <div className="grid gap-3 sm:grid-cols-2">
              <div>
                <div className="text-xs font-medium text-slate-600">Email</div>
                <div className="mt-1">{lawyer.user.email}</div>
              </div>
              <div>
                <div className="text-xs font-medium text-slate-600">City</div>
                <div className="mt-1">{lawyer.city}</div>
              </div>
            </div>
          </div>
        </Card>

        <Card>
          <div className="text-sm font-semibold">Booking availability</div>
          <Divider />
          <div className="mt-4">
            <Button className="w-full" disabled>
              Book consultation
            </Button>
            <div className="mt-3 text-xs text-slate-600">
              Booking from this page is disabled because the current backend does not expose public lawyer slot listing.
            </div>
          </div>
        </Card>
      </div>

      <Card>
        <div className="text-sm font-semibold">Lawyer details</div>
        <Divider />
        <ul className="mt-3 list-disc space-y-2 pl-5 text-sm text-slate-700">
          <li>Specialization: {lawyer.specialization}</li>
          <li>City: {lawyer.city}</li>
          <li>Rating: {lawyer.rating.toFixed(1)} / 5</li>
        </ul>
      </Card>
    </div>
  );
}

