import { useEffect, useState } from "react";
import Card from "../components/ui/Card";
import Badge from "../components/ui/Badge";
import { useAuth } from "../context/AuthContext";
import { apiRequest } from "../lib/api";

type ChatSummary = {
  id: string;
  title: string;
  updatedAt: string;
};

export default function ConversationHistoryPage() {
  const auth = useAuth();
  const [chats, setChats] = useState<ChatSummary[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const run = async () => {
      if (!auth.session.isAuthenticated) return;
      setLoading(true);
      setError(null);
      try {
        const data = await apiRequest<ChatSummary[]>("/chats", {}, auth.session.user.token);
        setChats(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to load conversation history");
      } finally {
        setLoading(false);
      }
    };
    void run();
  }, [auth.session]);

  return (
    <div className="flex flex-col gap-4">
      <div>
        <div className="text-lg font-semibold tracking-tight">Conversation history</div>
        <div className="text-sm text-slate-600">Your saved chats from backend.</div>
      </div>

      <div className="grid gap-3">
        {loading ? <Card><div className="text-sm text-slate-600">Loading conversations...</div></Card> : null}
        {error ? <Card><div className="text-sm text-rose-700">{error}</div></Card> : null}
        {!loading && chats.length === 0 ? (
          <Card>
            <div className="text-sm text-slate-600">No conversation history yet.</div>
          </Card>
        ) : null}
        {chats.map((c) => (
          <Card key={c.id} className="flex items-center justify-between gap-3">
            <div>
              <div className="text-sm font-semibold">{c.title}</div>
              <div className="mt-1 text-xs text-slate-600">Last updated: {new Date(c.updatedAt).toLocaleString()}</div>
            </div>
            <Badge>Live</Badge>
          </Card>
        ))}
      </div>
    </div>
  );
}

