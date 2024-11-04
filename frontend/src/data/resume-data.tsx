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
        url: "https://www.linkedin.com/in/sagnik-pal-iitism/",
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
    "Networking",
  ],
  certifications: [
    {
      title: "AWS Cloud Certified Practitioner (AWS-CCP)",
      description: "A beginner level AWS cloud certification",
      link: "https://www.credly.com/badges/30c120a8-b0a2-40bf-90c4-766fc20d86cb",
      issued: "November 2024"
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
        "The AWS Version of Cloud Resume Challenge. A NextJS resume hosted by AWS Services like S3, Cloudfront, Lambda, API Gateway and DynamoDB. All the infrastructure was spun up using terraform using the principle of IaC.",
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
    {
      title: "Networking In Go",
      techStack: [
        "Networking Services",
        "Golang",
        "TCP",
        "HTTP",
        "Cryptography"

      ],
      description:
        "A project containing of different networking tools written in Golang such as scanners, proxies, load balancers and many more",
      link: {
        label: "github.com",
        href: "https://github.com/palSagnik/networking-go",
      },
    },
    {
      title: "Hermes",
      techStack: [
        "Golang",
        "Docker",
        "PostgreSQL",
      ],
      description:
        "A user authentication, signin and verification backend template for golang websites.",
      link: {
        label: "github.com",
        href: "https://github.com/palSagnik/hermes",
      },
    },
  ],
  blogs: [
    {
      title: "AWS Project Blog",
      description: "A semi-technical blog on the challenge where I describe how I dealt with various challenges of the project.",
      link: {
        label: "hashnode.com",
        href: "https://dev-journal-sagnik.hashnode.dev/how-i-completed-the-cloud-resume-challenge-a-personal-journey"
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
