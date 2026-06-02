import Card from "../components/ui/Card";
import Divider from "../components/ui/Divider";
import Badge from "../components/ui/Badge";

export default function SettingsPage() {
  return (
    <div className="flex flex-col gap-4">
      <div>
        <div className="text-lg font-semibold tracking-tight">App settings</div>
        <div className="text-sm text-slate-600">These are UI-only toggles (no persistence).</div>
      </div>

      <Card>
        <div className="flex items-center justify-between gap-3">
          <div>
            <div className="text-sm font-semibold">Notifications</div>
            <div className="mt-1 text-sm text-slate-600">Mock preference.</div>
          </div>
          <Badge>Off</Badge>
        </div>
        <div className="my-4">
          <Divider />
        </div>
        <div className="flex items-center justify-between gap-3">
          <div>
            <div className="text-sm font-semibold">Theme</div>
            <div className="mt-1 text-sm text-slate-600">Light (prototype).</div>
          </div>
          <Badge>Light</Badge>
        </div>
      </Card>
    </div>
  );
}

