# Legal Consultation Platform (Frontend Prototype)

Modern, responsive **frontend-only** prototype for a Legal Consultation Platform.

## Tech

- React + Vite
- Tailwind CSS
- React Router
- React Context (mock auth + incognito flow)

## Flows

- Landing → Incognito (Chat only)
- Landing → Login/Signup → Chat + Lawyers (+ Lawyer Profile)
- Navbar visible after login and in incognito (lawyers link disabled in incognito)

## Run locally

```bash
npm install
npm run dev
```

No backend is implemented. All data is mock data and stored in local component/context state.

