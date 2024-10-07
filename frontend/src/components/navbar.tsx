"use client";

import Link from 'next/link'
import { useEffect, useState } from 'react'

export default function Navbar() {
    
    const [visitorCount, setVisitorCount] = useState<number | null>(null);
    const [hasFetched, setHasFetched] = useState(false);

    useEffect(() => {
      const fetchVisitorCount = async () => {
        try {
            const response = await fetch("https://z95hfzvlve.execute-api.us-east-1.amazonaws.com/init/countVisitors");
            const data = await response.json();
            setVisitorCount(data.count)
        } catch (error) {
            console.error('Error Fetching Visitor Count')
        }
    };

    if (!hasFetched) {
      setHasFetched(true);
      fetchVisitorCount();
    }
    }, [hasFetched]);

  return (
    <nav className="mx-auto w-2/3 rounded-full bg-gray-100 shadow-md top-2 fixed left-0 right-0 z-10">
      <div className="mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex-shrink-0 flex items-center">
            <Link href="/" className="text-xl font-bold text-gray-800">
              Sagnik Pal
            </Link>
          </div>
          <div className="inline-flex items-center px-4 py-2 text-sm font-bold text-black">
                {visitorCount != null ? (<span className="text-lg">Visitors: {visitorCount}</span>) : (<span>Fetching...</span>)}
          </div>
        </div>
      </div>
    </nav>
  )
}