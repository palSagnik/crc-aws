import { GitHubIcon, LinkedInIcon} from "@/components/icons";

export const RESUME_DATA = {
  name: "Sagnik Pal",
  initials: "SP",
  location: "India",
  locationLink: "https://www.google.com/maps/place/India",
  about:
    "Detail-oriented Full Stack Engineer dedicated to building high-quality products.",
  summary:
    "As a Full Stack Engineer, I specialize in taking products from concept to launch. I excel in leading teams and creating environments where individuals perform at their best. Currently, I work mostly with TypeScript, React, Node.js, and GraphQL. I have over 8 years of experience working remotely with companies worldwide.",
  contact: {
    email: "palsagnik2102@gmail.com",
    tel: "+91-6364558467",
    social: [
      {
        name: "GitHub",
        url: "https://github.com/palSagnik",
        icon: GitHubIcon,
      },
      {
        name: "LinkedIn",
        url: "https://www.linkedin.com/in/sagnik-pal-0152b8256/",
        icon: LinkedInIcon,
      },
    ],
  },
  education: [
    {
      school: "Indian Institute of Technology, Dhanbad",
      degree: "Bachelor Of Technology in Electronics and Communication Engineering",
      start: "2022",
      end: "2026",
    },
  ],
  work: [
    {
      company: "Abhaya Secure",
      link: "https://www.abhayasecure.com/",
      badges: ["Remote"],
      title: "Site and Security Engineer Intern",
      start: "Dec 2023",
      end: "Feb 2024",
      description:
        "Implemented new features, led a squad, improved code delivery process, and initiated migration from Emotion to Tailwind CSS. Technologies: React, TypeScript, GraphQL",
    },
  ],
  skills: [
    "Golang",
    "Python",
    "Flask",
    "Docker",
    "Kubernetes",
    "Terraform",    
    "Amazon Web Services",
    "Quantum Computing",
  ],
  certifications: [
    {
      title: "AWS Cloud Certified Practitioner",
      description: "A beginner level AWS cloud certification",
      link: {
        label: "AWC CCP",
        href: "xyz.com"
      },
      issued: "October 2024"
    }
  ],
  projects: [
    {
      title: "Decentralised Storage",
      techStack: [
        "Backend Development",
        "Golang",
        "Docker",
        "Encrypted Storage"
      ],
      description:
        "A secure decentralised storage backend solution written in Go",
      link: {
        label: "github.com",
        href: "https://github.com/palSagnik/Distributed-File-Storage",
      },
    },
    {
      title: "Cloud AWS Challenge",
      techStack: [
        "Full Stack Development",
        "Python",
        "Terraform",
        "AWS",
        "CI/CD Pipeline",
        "Cloud Computing"
      ],
      description:
        "A secure decentralised storage backend solution written in Go",
      link: {
        label: "github.com",
        href: "https://github.com/palSagnik/crc-aws",
      },
    },
  ],
} as const;
