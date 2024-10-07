import { GitHubIcon, LinkedInIcon} from "@/components/icons";

export const RESUME_DATA = {
  name: "Sagnik Pal",
  initials: "SP",
  location: "India",
  locationLink: "https://www.google.com/maps/place/India",
  about:
    "A student with a passion in cloud computing, kubernetes, backend engineering curious about quantum computing applications.",
  summary:
    "As an upcoming engineer, I specialize in the applications of cloud in building distributable software. I excel in logic as well have an avid interest as a backend engineer, and also like to fiddle with computer networks, quantum applications, os.",
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
        "Orchestrated comprehensive security audits targeting client-side vulnerabilities (XSS, CSRF) and server-side threats which were then identified and mitigated.",
    },
  ],
  skills: [
    "Linux",
    "Golang",
    "Python",
    "Flask",
    "ARM Assembly",
    "Docker",
    "Kubernetes",
    "Terraform",    
    "Amazon Web Services",
    "Quantum Computing",
  ],
  certifications: [
    {
      title: "AWS Cloud Certified Practitioner (AWS-CCP)",
      description: "A beginner level AWS cloud certification",
      link: "xyz.com",
      issued: "October 2024"
    }
  ],
  projects: [
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
  ],
  blogs: [
    {
      title: "AWS Blog",
      description: "A beginner level AWS cloud blog",
      link: {
        label: "medium.com",
        href: "https://medium.com/@palsagnik2102"
      },
      topics: [
        "AWS",
        "Serverless",
        "Terraform",
        "Cloud"
      ]
    }
  ],
} as const;
