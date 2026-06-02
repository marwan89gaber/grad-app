import { HTMLAttributes } from "react";
import { cn } from "../../lib/cn";

export default function Card({ className, ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("rounded-2xl bg-white p-4 shadow-soft ring-1 ring-slate-100", className)} {...props} />;
}

