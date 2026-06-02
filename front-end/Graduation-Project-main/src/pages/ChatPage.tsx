import { FormEvent, useEffect, useMemo, useRef, useState } from "react";
import Card from "../components/ui/Card";
import Button from "../components/ui/Button";
import { cn } from "../lib/cn";
import { useAuth } from "../context/AuthContext";
import { apiRequest } from "../lib/api";

type Message = {
  id: string;
  role: "user" | "assistant" | "system";
  content: string;
  createdAt: string;
};

function formatTime(iso: string) {
  const d = new Date(iso);
  return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
}

function MessageBubble(props: { msg: Message }) {
  const isUser = props.msg.role === "user";
  return (
    <div className={cn("flex w-full", isUser ? "justify-end" : "justify-start")}>
      <div
        className={cn(
          "max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-6 shadow-soft ring-1",
          isUser ? "bg-slate-900 text-white ring-slate-900" : "bg-white text-slate-900 ring-slate-100"
        )}
      >
        <div className="whitespace-pre-wrap">{props.msg.content}</div>
        <div className={cn("mt-2 text-[11px] opacity-80", isUser ? "text-slate-200" : "text-slate-500")}>
          {formatTime(props.msg.createdAt)}
        </div>
      </div>
    </div>
  );
}

export default function ChatPage() {
  const auth = useAuth();
  const [messages, setMessages] = useState<Message[]>([]);
  const [draft, setDraft] = useState("");
  const [uploadName, setUploadName] = useState<string | null>(null);
  const [chatId, setChatId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [sending, setSending] = useState(false);
  const listRef = useRef<HTMLDivElement | null>(null);

  const accessNote = useMemo(() => {
    if (auth.session.isIncognito) {
      return "Incognito mode: Login/Signup required to access lawyers.";
    }
    return null;
  }, [auth.session.isIncognito]);

  useEffect(() => {
    const loadLatestChat = async () => {
      if (!auth.session.isAuthenticated) {
        setMessages([]);
        return;
      }
      try {
        const chats = await apiRequest<Array<{ id: string }>>("/chats", {}, auth.session.user.token);
        if (chats.length === 0) return;
        const latestId = chats[0].id;
        setChatId(latestId);
        const chat = await apiRequest<{ messages: Message[] }>(
          `/chats/${latestId}`,
          {},
          auth.session.user.token
        );
        setMessages(chat.messages || []);
        scrollToBottom();
      } catch {
        // keep page usable even if chat list fetch fails
      }
    };
    void loadLatestChat();
  }, [auth.session]);

  function scrollToBottom() {
    requestAnimationFrame(() => listRef.current?.scrollTo({ top: listRef.current.scrollHeight, behavior: "smooth" }));
  }

  async function onSend(e: FormEvent) {
    e.preventDefault();
    const text = draft.trim();
    if (!text) return;
    if (!auth.session.isAuthenticated) {
      setError("Login is required to send messages.");
      return;
    }

    setError(null);
    setSending(true);
    try {
      const response = await apiRequest<{ chat: { id: string; messages: Message[] } }>(
        "/chats/message",
        {
          method: "POST",
          body: JSON.stringify({ chatId: chatId || undefined, message: text }),
        },
        auth.session.user.token
      );
      setChatId(response.chat.id);
      setMessages(response.chat.messages || []);
      setDraft("");
      setUploadName(null);
      scrollToBottom();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to send message");
    } finally {
      setSending(false);
    }
  }

  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-start justify-between gap-3">
        <div>
          <div className="text-lg font-semibold tracking-tight">Chat</div>
          <div className="text-sm text-slate-600">Ask a legal question and get a live AI response.</div>
          {accessNote ? (
            <div className="mt-2 inline-flex rounded-xl bg-amber-50 px-3 py-2 text-xs font-medium text-amber-900 ring-1 ring-amber-200">
              {accessNote}
            </div>
          ) : null}
          {error ? (
            <div className="mt-2 inline-flex rounded-xl bg-rose-50 px-3 py-2 text-xs font-medium text-rose-800 ring-1 ring-rose-200">
              {error}
            </div>
          ) : null}
        </div>
        <div className="hidden sm:flex">
          <Button variant="secondary" onClick={scrollToBottom}>
            Jump to latest
          </Button>
        </div>
      </div>

      <Card className="flex h-[60dvh] flex-col p-0 sm:h-[68dvh]">
        <div
          ref={listRef}
          className="flex-1 space-y-3 overflow-auto px-4 py-4"
          onLoad={scrollToBottom}
        >
          {messages.map((m) => (
            <MessageBubble key={m.id} msg={m} />
          ))}
        </div>

        <form onSubmit={onSend} className="border-t border-slate-200 p-3">
          <div className="flex flex-col gap-2">
            {uploadName ? (
              <div className="flex items-center justify-between rounded-xl bg-slate-50 px-3 py-2 text-xs text-slate-700 ring-1 ring-slate-200">
                <span>Attached: {uploadName}</span>
                <button
                  type="button"
                  className="text-slate-900 underline-offset-2 hover:underline"
                  onClick={() => setUploadName(null)}
                >
                  Remove
                </button>
              </div>
            ) : null}

            <div className="flex items-end gap-2">
              <label className="sr-only" htmlFor="legal-query">
                Enter legal query
              </label>
              <textarea
                id="legal-query"
                value={draft}
                onChange={(e) => setDraft(e.target.value)}
                placeholder="Enter legal query"
                rows={1}
                className="min-h-11 flex-1 resize-none rounded-xl bg-white px-4 py-3 text-sm leading-5 ring-1 ring-slate-200 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-slate-900"
              />

              <label className="inline-flex h-11 cursor-pointer items-center justify-center rounded-xl bg-white px-3 text-sm font-medium text-slate-900 ring-1 ring-slate-200 transition-colors hover:bg-slate-50">
                <input
                  type="file"
                  className="hidden"
                  onChange={(e) => {
                    const f = e.target.files?.[0];
                    setUploadName(f ? f.name : null);
                  }}
                />
                Upload
              </label>

              <Button type="submit" disabled={!draft.trim() || sending}>
                {sending ? "Sending..." : "Send"}
              </Button>
            </div>
          </div>
        </form>
      </Card>
    </div>
  );
}

