import { Navigate, Route, Routes } from "react-router-dom";
import LandingPage from "./pages/LandingPage";
import LoginPage from "./pages/LoginPage";
import SignupPage from "./pages/SignupPage";
import AppLayout from "./layouts/AppLayout";
import ChatPage from "./pages/ChatPage";
import LawyersPage from "./pages/LawyersPage";
import LawyerProfilePage from "./pages/LawyerProfilePage";
import SettingsPage from "./pages/SettingsPage";
import ConversationHistoryPage from "./pages/ConversationHistoryPage";
import ProfilePage from "./pages/ProfilePage";
import RequireMode from "./routes/RequireMode";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/signup" element={<SignupPage />} />

      <Route path="/app" element={<AppLayout />}>
        <Route index element={<Navigate to="/app/chat" replace />} />
        <Route path="chat" element={<RequireMode mode="incognitoOrAuthed"><ChatPage /></RequireMode>} />
        <Route path="history" element={<RequireMode mode="incognitoOrAuthed"><ConversationHistoryPage /></RequireMode>} />
        <Route path="settings" element={<RequireMode mode="incognitoOrAuthed"><SettingsPage /></RequireMode>} />
        <Route path="profile" element={<RequireMode mode="authed"><ProfilePage /></RequireMode>} />
        <Route path="lawyers" element={<RequireMode mode="authed"><LawyersPage /></RequireMode>} />
        <Route path="lawyers/:lawyerId" element={<RequireMode mode="authed"><LawyerProfilePage /></RequireMode>} />
      </Route>

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

