export type ChatMessage = {
  id: string;
  role: "user" | "system";
  text: string;
  createdAt: string;
};

export const seedMessages: ChatMessage[] = [
  {
    id: "m1",
    role: "system",
    text: "Hi — I’m your legal assistant. Ask a legal question and I’ll help you draft next steps (mock UI only).",
    createdAt: "2026-04-14T09:00:00.000Z"
  },
  {
    id: "m2",
    role: "user",
    text: "My landlord won’t return my security deposit. What should I do?",
    createdAt: "2026-04-14T09:01:00.000Z"
  },
  {
    id: "m3",
    role: "system",
    text: "First, check your lease and local timelines. Gather photos, move-out checklist, and written communication. Then send a written demand letter requesting the deposit and itemized deductions by a deadline.",
    createdAt: "2026-04-14T09:02:00.000Z"
  }
];

