import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import Card from "../components/ui/Card";
import Input from "../components/ui/Input";
import Badge from "../components/ui/Badge";
import { cn } from "../lib/cn";
import { apiRequest } from "../lib/api";

type ApiLawyer = {
  id: string;
  city: string;
  specialization: string;
  rating: number;
  availability: boolean;
  user: { id: string; name: string; email: string; profilePicture?: string | null };
};

function Stars(props: { rating: number }) {
  const full = Math.round(props.rating);
  return (
    <div className="flex items-center gap-1">
      {Array.from({ length: 5 }).map((_, i) => (
        <span key={i} className={cn("text-sm", i < full ? "text-amber-500" : "text-slate-300")}>
          ★
        </span>
      ))}
      <span className="ml-1 text-xs font-medium text-slate-600">{props.rating.toFixed(1)}</span>
    </div>
  );
}

function LawyerCard(props: { lawyer: ApiLawyer }) {
  const { lawyer } = props;
  return (
    <Link to={`/app/lawyers/${lawyer.id}`} className="block">
      <Card className="transition-transform hover:-translate-y-0.5">
        <div className="flex items-start justify-between gap-3">
          <div>
            <div className="text-sm font-semibold">{lawyer.user.name}</div>
            <div className="mt-1 text-sm text-slate-600">{lawyer.specialization}</div>
            <div className="mt-3 flex flex-wrap items-center gap-2">
              <Badge>{lawyer.city}</Badge>
              <Badge>{lawyer.specialization}</Badge>
            </div>
          </div>
          <div className="flex flex-col items-end gap-2">
            <Stars rating={lawyer.rating} />
            <Badge className={lawyer.availability ? "bg-emerald-100 text-emerald-800" : "bg-slate-200 text-slate-700"}>
              {lawyer.availability ? "Available" : "Unavailable"}
            </Badge>
          </div>
        </div>
      </Card>
    </Link>
  );
}

export default function LawyersPage() {
  const [query, setQuery] = useState("");
  const [city, setCity] = useState("");
  const [lawyers, setLawyers] = useState<ApiLawyer[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const run = async () => {
      setLoading(true);
      setError(null);
      try {
        const params = new URLSearchParams();
        if (query.trim()) params.set("specialization", query.trim());
        if (city.trim()) params.set("city", city.trim());
        const data = await apiRequest<{ data: ApiLawyer[] }>(
          `/lawyers${params.toString() ? `?${params.toString()}` : ""}`
        );
        setLawyers(data.data || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to load lawyers");
      } finally {
        setLoading(false);
      }
    };
    void run();
  }, [query, city]);

  const filtered = useMemo(() => {
    return lawyers.filter((l) => {
      return true;
    });
  }, [lawyers]);

  return (
    <div className="flex flex-col gap-4">
      <div>
        <div className="text-lg font-semibold tracking-tight">Lawyers</div>
        <div className="text-sm text-slate-600">Search by specialization and city from backend.</div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2">
        <div>
          <label className="sr-only" htmlFor="lawyer-search">
            Search specialization
          </label>
          <Input
            id="lawyer-search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search by specialization"
          />
        </div>
        <div>
          <label className="sr-only" htmlFor="lawyer-city">
            Filter city
          </label>
          <Input id="lawyer-city" value={city} onChange={(e) => setCity(e.target.value)} placeholder="Filter by city" />
        </div>
      </div>

      <div className="grid gap-3">
        {loading ? <Card><div className="text-sm text-slate-600">Loading lawyers...</div></Card> : null}
        {error ? <Card><div className="text-sm text-rose-700">{error}</div></Card> : null}
        {filtered.length === 0 ? (
          <Card>
            <div className="text-sm font-medium">No matches</div>
            <div className="mt-1 text-sm text-slate-600">Try a different name or filter.</div>
          </Card>
        ) : (
          filtered.map((l) => <LawyerCard key={l.id} lawyer={l} />)
        )}
      </div>
    </div>
  );
}

