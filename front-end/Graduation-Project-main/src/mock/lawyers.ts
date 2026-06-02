export type ConsultationType = "Family" | "Property" | "Corporate" | "Criminal" | "Immigration";

export type Lawyer = {
  id: string;
  name: string;
  description: string;
  rating: number;
  pricePerConsultation: number;
  consultationTypes: ConsultationType[];
  address: string;
  phone: string;
  workingHours: string;
  availableSlots: string[];
  experience: string[];
  profileImage: string | null;
};

export const lawyers: Lawyer[] = [
  {
    id: "l_001",
    name: "Sophia Patel",
    description: "Family law specialist focused on custody, divorce mediation, and support agreements.",
    rating: 4.8,
    pricePerConsultation: 120,
    consultationTypes: ["Family"],
    address: "120 Maple Ave, Suite 200, Springfield",
    phone: "(555) 010-2020",
    workingHours: "Mon–Fri, 9:00–17:00",
    availableSlots: ["Today 4:30 PM", "Tomorrow 10:00 AM", "Fri 2:00 PM"],
    experience: [
      "10+ years family law practice",
      "Mediated 300+ custody agreements",
      "Community legal clinic volunteer"
    ],
    profileImage: null
  },
  {
    id: "l_002",
    name: "Ethan Brooks",
    description: "Property & tenancy disputes, contracts, and small claims guidance.",
    rating: 4.6,
    pricePerConsultation: 90,
    consultationTypes: ["Property"],
    address: "44 River St, Floor 3, Springfield",
    phone: "(555) 010-4040",
    workingHours: "Mon–Thu, 10:00–18:00",
    availableSlots: ["Tomorrow 1:00 PM", "Thu 11:30 AM", "Mon 9:30 AM"],
    experience: ["Former housing authority counsel", "Drafted 200+ lease agreements", "Tenant advocacy speaker"],
    profileImage: null
  },
  {
    id: "l_003",
    name: "Nina Alvarez",
    description: "Corporate counsel for startups: incorporation, compliance, and contract review.",
    rating: 4.9,
    pricePerConsultation: 180,
    consultationTypes: ["Corporate"],
    address: "88 Market Blvd, Suite 500, Springfield",
    phone: "(555) 010-9090",
    workingHours: "Mon–Fri, 8:30–16:30",
    availableSlots: ["Wed 3:00 PM", "Thu 9:00 AM", "Fri 11:00 AM"],
    experience: ["Advised 50+ early-stage startups", "M&A diligence support", "SaaS contracts specialist"],
    profileImage: null
  },
  {
    id: "l_004",
    name: "Marcus Chen",
    description: "Criminal defense consultations with a focus on pre-trial strategy and rights education.",
    rating: 4.7,
    pricePerConsultation: 150,
    consultationTypes: ["Criminal"],
    address: "9 Oak St, Springfield",
    phone: "(555) 010-3333",
    workingHours: "Tue–Sat, 11:00–19:00",
    availableSlots: ["Sat 12:00 PM", "Tue 5:00 PM", "Thu 6:30 PM"],
    experience: ["Public defender background", "Trial advocacy instructor", "Bail hearings specialist"],
    profileImage: null
  },
  {
    id: "l_005",
    name: "Priya Nair",
    description: "Immigration consultations: work permits, family petitions, and documentation prep.",
    rating: 4.5,
    pricePerConsultation: 110,
    consultationTypes: ["Immigration"],
    address: "210 Cedar Rd, Springfield",
    phone: "(555) 010-7878",
    workingHours: "Mon–Fri, 9:30–17:30",
    availableSlots: ["Today 5:15 PM", "Wed 2:00 PM", "Fri 9:45 AM"],
    experience: ["Document review and filing support", "Multilingual consultations", "Community outreach programs"],
    profileImage: null
  }
];

